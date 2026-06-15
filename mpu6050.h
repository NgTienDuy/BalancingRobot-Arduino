#ifndef MPU6050_H
#define MPU6050_H

#include <stdint.h>

#define MPU6050_I2C_ADDR 0x68
#define MPU6050_RA_ACCEL_XOUT_H 0x3B
#define MPU6050_RA_PWR_MGMT_1   0x6B
#define MPU6050_RA_CONFIG       0x1A
#define MPU6050_RA_GYRO_CONFIG  0x1B
#define MPU6050_RA_ACCEL_CONFIG 0x1C

typedef struct
{
    int16_t accel_x;
    int16_t accel_y;
    int16_t accel_z;
    int16_t gyro_x;
    int16_t gyro_y;
    int16_t gyro_z;
    float   angle_acc;
    float   angle_gyro;
    float   angle_filtered;
} MPU6050_Data;

void MPU6050_Init(void);
void MPU6050_Read_Raw(MPU6050_Data* data, float dt);

#endif
