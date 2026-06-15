#include <mega328p.h>
#include <stdint.h>
#include <math.h>
#include "mpu6050.h"
#include "motor.h"
#include "pid.h"

// Project skeleton for Self-Balancing Rover on ATmega328P + CodeVisionAVR
// This file is intentionally lightweight and ready for further tuning.

#define SAMPLE_DT 0.010f

volatile unsigned char g_flag_compute = 0;
PID_Controller g_pid;

void Init_System(void)
{
    // Configure Timer0 for a fixed 10 ms sampling tick.
    TCCR0B = (1 << CS02) | (1 << CS00);   // prescaler 1024
    TCNT0 = 0;
    TIMSK0 = (1 << TOIE0);

    // Enable global interrupts
    #asm("sei")

    // Initialize modules
    MPU6050_Init();
    Motor_Init();

    // Default PID parameters (start values only - tune on real hardware)
    // These are safe initial values for a small rover platform.
    PID_Init(&g_pid, 18.0f, 0.0f, 4.0f, 0.0f, 255.0f, 255.0f);
    g_pid.Setpoint = 0.0f;
}

void main(void)
{
    MPU6050_Data imu;
    float pitch = 0.0f;
    int output = 0;

    Init_System();

    while (1)
    {
        if (g_flag_compute)
        {
            g_flag_compute = 0;

            MPU6050_Read_Raw(&imu, SAMPLE_DT);

            // Simple complementary-filter style estimate
            // (The actual angle filter is implemented in mpu6050.c for reuse)
            pitch = imu.angle_filtered;

            output = (int)PID_Compute(&g_pid, pitch, SAMPLE_DT);
            Motor_Control(output, output);
        }
    }
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    static unsigned char counter = 0;

    TCNT0 = 0;
    counter++;

    if (counter >= 1)
    {
        counter = 0;
        g_flag_compute = 1;
    }
}
