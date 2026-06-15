#include <mega328p.h>
#include <stdint.h>
#include <math.h>
#include "mpu6050.h"

// ============================================================
// Manual bit-bang I2C for ATmega328P (SCL=PORTC.5, SDA=PORTC.4)
// ============================================================
#define I2C_DDR   DDRC
#define I2C_PORT  PORTC
#define I2C_PIN   PINC
#define I2C_SCL   5
#define I2C_SDA   4

#define SCL_HIGH() (I2C_DDR &= ~(1 << I2C_SCL))   // release -> pull-up high
#define SCL_LOW()  (I2C_DDR |= (1 << I2C_SCL))    // drive low
#define SDA_HIGH() (I2C_DDR &= ~(1 << I2C_SDA))
#define SDA_LOW()  (I2C_DDR |= (1 << I2C_SDA))
#define SDA_IN()   (I2C_PIN & (1 << I2C_SDA))

static void i2c_delay(void)
{
    // ~5 us at 8 MHz (rough tuning for 100 kHz I2C)
    unsigned char i;
    for (i = 0; i < 3; i++) {
        #asm("nop");
    }
}

static void i2c_init(void)
{
    SDA_HIGH();
    SCL_HIGH();
}

static unsigned char i2c_start(void)
{
    SDA_HIGH();
    SCL_HIGH();
    i2c_delay();
    SDA_LOW();
    i2c_delay();
    SCL_LOW();
    i2c_delay();
    return 1; // success
}

static void i2c_stop(void)
{
    SDA_LOW();
    SCL_HIGH();
    i2c_delay();
    SDA_HIGH();
    i2c_delay();
}

static unsigned char i2c_write(unsigned char data)
{
    unsigned char i;
    for (i = 0; i < 8; i++)
    {
        if (data & 0x80)
            SDA_HIGH();
        else
            SDA_LOW();
        data <<= 1;
        i2c_delay();
        SCL_HIGH();
        i2c_delay();
        SCL_LOW();
        i2c_delay();
    }
    // Release SDA for ACK, read ACK bit
    SDA_HIGH();
    i2c_delay();
    SCL_HIGH();
    i2c_delay();
    {
        unsigned char ack = SDA_IN() == 0;
        SCL_LOW();
        i2c_delay();
        return ack;
    }
}

static unsigned char i2c_read(unsigned char ack)
{
    unsigned char i, data = 0;
    SDA_HIGH();
    for (i = 0; i < 8; i++)
    {
        data <<= 1;
        SCL_HIGH();
        i2c_delay();
        if (SDA_IN())
            data |= 1;
        SCL_LOW();
        i2c_delay();
    }
    // Send ACK/NACK
    if (ack)
        SDA_LOW();
    else
        SDA_HIGH();
    i2c_delay();
    SCL_HIGH();
    i2c_delay();
    SCL_LOW();
    i2c_delay();
    SDA_HIGH();
    return data;
}

// ============================================================
// MPU6050 functions
// ============================================================

static float g_alpha = 0.96f;

void MPU6050_Init(void)
{
    i2c_init();
    i2c_start();
    i2c_stop();

    // Wake up sensor
    i2c_start();
    i2c_write(MPU6050_I2C_ADDR << 1);
    i2c_write(MPU6050_RA_PWR_MGMT_1);
    i2c_write(0x00);
    i2c_stop();

    // DLPF off
    i2c_start();
    i2c_write(MPU6050_I2C_ADDR << 1);
    i2c_write(MPU6050_RA_CONFIG);
    i2c_write(0x00);
    i2c_stop();

    // Gyro config: +/-250 deg/s
    i2c_start();
    i2c_write(MPU6050_I2C_ADDR << 1);
    i2c_write(MPU6050_RA_GYRO_CONFIG);
    i2c_write(0x00);
    i2c_stop();

    // Accel config: +/-2g
    i2c_start();
    i2c_write(MPU6050_I2C_ADDR << 1);
    i2c_write(MPU6050_RA_ACCEL_CONFIG);
    i2c_write(0x00);
    i2c_stop();
}

void MPU6050_Read_Raw(MPU6050_Data* data, float dt)
{
    unsigned char buf[14];
    int16_t ax, ay, az, gx, gy, gz;

    i2c_start();
    i2c_write(MPU6050_I2C_ADDR << 1);
    i2c_write(MPU6050_RA_ACCEL_XOUT_H);
    i2c_start();
    i2c_write((MPU6050_I2C_ADDR << 1) | 1);

    buf[0] = i2c_read(1);
    buf[1] = i2c_read(1);
    buf[2] = i2c_read(1);
    buf[3] = i2c_read(1);
    buf[4] = i2c_read(1);
    buf[5] = i2c_read(1);
    buf[6] = i2c_read(1);
    buf[7] = i2c_read(1);
    buf[8] = i2c_read(1);
    buf[9] = i2c_read(1);
    buf[10] = i2c_read(1);
    buf[11] = i2c_read(1);
    buf[12] = i2c_read(1);
    buf[13] = i2c_read(0);

    i2c_stop();

    ax = (int16_t)((buf[0] << 8) | buf[1]);
    ay = (int16_t)((buf[2] << 8) | buf[3]);
    az = (int16_t)((buf[4] << 8) | buf[5]);
    gx = (int16_t)((buf[8] << 8) | buf[9]);
    gy = (int16_t)((buf[10] << 8) | buf[11]);
    gz = (int16_t)((buf[12] << 8) | buf[13]);

    data->accel_x = ax;
    data->accel_y = ay;
    data->accel_z = az;
    data->gyro_x = gx;
    data->gyro_y = gy;
    data->gyro_z = gz;

    // Convert raw sensor data to physical units.
    // Accel range: +/-2g  => 16384 LSB/g
    // Gyro range: +/-250 deg/s => 131 LSB/(deg/s)
    data->angle_acc = atan2((float)ay, (float)az) * 57.29578f;
    data->angle_gyro = (float)gy / 131.0f;

    if (data->angle_filtered == 0.0f)
    {
        data->angle_filtered = data->angle_acc;
    }

    // Complementary filter: fuse gyro integration with accelerometer angle.
    // dt must be fixed by a timer interrupt (recommended 5 ms to 10 ms).
    data->angle_filtered = g_alpha * (data->angle_filtered + data->angle_gyro * dt) +
                           (1.0f - g_alpha) * data->angle_acc;
}