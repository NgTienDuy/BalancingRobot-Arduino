/*============================================================================
  mpu6050.c  -  Doc cam bien qua TWI. Tinh goc bang SO NGUYEN (khong atan2).
============================================================================*/
#include <mega328p.h>
#include <stdint.h>
#include <delay.h>
#include "config.h"
#include "myi2c.h"
#include "mpu6050.h"

static int gyro_bias = 0;
static unsigned char who_id = 0;

static void mpu_write_reg(unsigned char reg, unsigned char val)
{
    myi2c_start(MPU6050_ADDR_W);
    myi2c_write(reg);
    myi2c_write(val);
    myi2c_stop();
}
static unsigned char mpu_read_reg(unsigned char reg)
{
    unsigned char v;
    myi2c_start(MPU6050_ADDR_W);
    myi2c_write(reg);
    myi2c_start(MPU6050_ADDR_R);
    v = myi2c_read_nack();
    myi2c_stop();
    return v;
}

unsigned char MPU6050_WhoAmI(void) { return who_id; }

unsigned char MPU6050_Init(void)
{
    unsigned char tries;

    myi2c_init();
    delay_ms(100);

    for (tries = 0; tries < 3; tries++)
    {
        myi2c_clear_fault();
        mpu_write_reg(MPU6050_RA_PWR_MGMT_1,  0x00);
        delay_ms(10);
        mpu_write_reg(MPU6050_RA_SMPLRT_DIV,  0x09);
        mpu_write_reg(MPU6050_RA_CONFIG,      0x03);
        mpu_write_reg(MPU6050_RA_GYRO_CONFIG, 0x00);
        mpu_write_reg(MPU6050_RA_ACCEL_CONFIG,0x00);
        delay_ms(10);

        myi2c_clear_fault();
        who_id = mpu_read_reg(MPU6050_RA_WHO_AM_I);
        if (!myi2c_fault() && who_id != 0x00 && who_id != 0xFF)
            return 1;

        myi2c_recover();          /* bus co the ket -> giai phong roi thu lai */
        delay_ms(50);
    }
    return 0;
}

unsigned char MPU6050_Read(MPU6050_Data *d)
{
    unsigned char b[14];
    unsigned char i;
    int16_t tilt_acc, gyro_axis;
    long den, a;

    myi2c_clear_fault();
    myi2c_start(MPU6050_ADDR_W);
    myi2c_write(MPU6050_RA_ACCEL_XOUT_H);
    myi2c_start(MPU6050_ADDR_R);
    for (i = 0; i < 13; i++) b[i] = myi2c_read_ack();
    b[13] = myi2c_read_nack();
    myi2c_stop();

    if (myi2c_fault()) return 0;          /* doc that bai -> bao loi */

    d->ax = (int16_t)((b[0]  << 8) | b[1]);
    d->ay = (int16_t)((b[2]  << 8) | b[3]);
    d->az = (int16_t)((b[4]  << 8) | b[5]);
    d->gx = (int16_t)((b[8]  << 8) | b[9]);
    d->gy = (int16_t)((b[10] << 8) | b[11]);
    d->gz = (int16_t)((b[12] << 8) | b[13]);

#if TILT_USES_X_ACCEL
    tilt_acc  = d->ax;  gyro_axis = d->gy;
#else
    tilt_acc  = d->ay;  gyro_axis = d->gx;
#endif

    /* goc accel (cdeg) ~ (tilt_acc / az_up) * 5730 */
    den = (long)ACC_Z_SIGN * (long)d->az;          /* thanh phan huong len, ~+16384 */
    if (den < 2000L)                               /* gan nam ngang -> coi nhu nga */
        a = (tilt_acc >= 0) ? 9000L : -9000L;
    else
    {
        a = ((long)tilt_acc * ACC_CDEG_K) / den;
        if (a >  9000L) a =  9000L;
        if (a < -9000L) a = -9000L;
    }
    d->acc_cdeg = (int)(ACC_ANGLE_SIGN * a);

    /* gyro delta moi tick (cdeg) = (gy - bias)/131 */
    d->gyro_dcdeg = (int)(GYRO_RATE_SIGN *
                          ((long)(gyro_axis - gyro_bias) / GYRO_LSB_PER_DPS));
    return 1;
}

void MPU6050_CalibrateGyro(void)
{
    unsigned int n;
    long sum = 0;
    MPU6050_Data d;

    gyro_bias = 0;
    for (n = 0; n < 1000; n++)
    {
        MPU6050_Read(&d);
#if TILT_USES_X_ACCEL
        sum += d.gy;
#else
        sum += d.gx;
#endif
        delay_ms(2);
    }
    gyro_bias = (int)(sum / 1000L);
}
