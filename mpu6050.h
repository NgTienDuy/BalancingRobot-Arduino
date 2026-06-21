#ifndef MPU6050_H
#define MPU6050_H
#include <stdint.h>

#define MPU6050_RA_SMPLRT_DIV    0x19
#define MPU6050_RA_CONFIG        0x1A
#define MPU6050_RA_GYRO_CONFIG   0x1B
#define MPU6050_RA_ACCEL_CONFIG  0x1C
#define MPU6050_RA_ACCEL_XOUT_H  0x3B
#define MPU6050_RA_PWR_MGMT_1    0x6B
#define MPU6050_RA_WHO_AM_I      0x75

typedef struct
{
    int16_t ax, ay, az, gx, gy, gz;
    int     acc_cdeg;     /* goc tu accel (centi-degree)            */
    int     gyro_dcdeg;   /* delta goc tu gyro moi tick (cdeg)      */
} MPU6050_Data;

unsigned char MPU6050_Init(void);
unsigned char MPU6050_WhoAmI(void);
void          MPU6050_CalibrateGyro(void);
unsigned char MPU6050_Read(MPU6050_Data *d);  /* 1=ok, 0=loi I2C */
#endif
