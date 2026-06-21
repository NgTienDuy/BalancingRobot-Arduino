/*============================================================================
  Self_Balancing_Rover.c  -  main (fixed-point, robust I2C)
  ATmega328P @16MHz - CodeVisionAVR.  Loop 100Hz (Timer2 CTC).

  Telemetry CSV moi tick: "<ms>,<goc_cdeg>,<output>"  (cdeg = do*100)
  Live-tune (Enter de gui):
    P 150=Kp15.0  I 5=Ki0.5  D 8=Kd0.8  S -15=setpoint -1.5do  ?=in he so
    L 560=deadband TRAI  R 580=deadband PHAI
    T 600=chay thu CA HAI o duty 600 (ke banh len, do nguong) ; T 0=tat
============================================================================*/
#include <mega328p.h>
#include <delay.h>
#include "config.h"
#include "uart.h"
#include "myi2c.h"
#include "mpu6050.h"
#include "filter.h"
#include "motor.h"
#include "pid.h"

volatile unsigned char g_tick = 0;

MPU6050_Data   imu;
CompFilter     filt;
PID_Controller pid;

int  g_dead_l = MOTOR_L_DEADBAND;
int  g_dead_r = MOTOR_R_DEADBAND;
int  g_test   = 0;        /* !=0: chay thu duty co dinh, bo qua PID */
long g_ms     = 0;

#define LED_ON()   (PORTB |=  (1 << 5))
#define LED_OFF()  (PORTB &= ~(1 << 5))
#define LED_TGL()  (PORTB ^=  (1 << 5))

static void timer2_init_100hz(void)
{
    TCCR2A = (1 << WGM21);
    TCCR2B = (1 << CS22) | (1 << CS21) | (1 << CS20);
    OCR2A  = 155;
    TIMSK2 = (1 << OCIE2A);
}

static void tx_gains(void)   /* in: #Kp,Ki,Kd,Sp,DL,DR */
{
    uart_tx('#');
    uart_put_int(pid.Kp_x10);        uart_tx(',');
    uart_put_int(pid.Ki_x10);        uart_tx(',');
    uart_put_int(pid.Kd_x10);        uart_tx(',');
    uart_put_int(pid.setpoint_cdeg); uart_tx(',');
    uart_put_int(g_dead_l);          uart_tx(',');
    uart_put_int(g_dead_r);
    uart_tx('\r'); uart_tx('\n');
}

static void tx_csv(long ms, int a, int out)
{
    uart_put_int(ms);        uart_tx(',');
    uart_put_int((long)a);   uart_tx(',');
    uart_put_int((long)out);
    uart_tx('\r'); uart_tx('\n');
}

static void apply_cmd(char cmd, long val)
{
    switch (cmd)
    {
        case 'P': case 'p': pid.Kp_x10 = (int)val; break;
        case 'I': case 'i': pid.Ki_x10 = (int)val; break;
        case 'D': case 'd': pid.Kd_x10 = (int)val; break;
        case 'S': case 's': pid.setpoint_cdeg = (int)(val * 10); break;
        case 'L': case 'l': g_dead_l = (int)val; Motor_SetDeadband(g_dead_l, g_dead_r); break;
        case 'R': case 'r': g_dead_r = (int)val; Motor_SetDeadband(g_dead_l, g_dead_r); break;
        case 'T': case 't': g_test = (int)val; break;
        case '?': tx_gains(); break;
        default: break;
    }
}

static void poll_uart_tuning(void)
{
    static char          line[16];
    static unsigned char idx = 0;
    char c;

    while (uart_available())
    {
        c = uart_get();
        if (c == '\r') continue;
        if (c == '\n')
        {
            line[idx] = 0;
            if (idx >= 1)
            {
                long          val = 0;
                unsigned char i   = 1;
                unsigned char neg = 0;
                while (line[i] == ' ') i++;
                if (line[i] == '-') { neg = 1; i++; }
                while (line[i] >= '0' && line[i] <= '9')
                    { val = val * 10 + (line[i] - '0'); i++; }
                if (neg) val = -val;
                apply_cmd(line[0], val);
            }
            idx = 0;
        }
        else if (idx < sizeof(line) - 1)
        {
            line[idx++] = c;
        }
    }
}

void main(void)
{
    int           angle     = 0;
    int           out;
    unsigned char fallen    = 0;
    unsigned char tel       = 0;
    unsigned char read_fail = 0;

    DDRB |= (1 << 5);
    uart_init();
    Motor_Init();
    Motor_SetDeadband(g_dead_l, g_dead_r);
    Motor_Stop();

    uart_puts("\r\nB\r\n");

    if (MPU6050_Init())
    {
        uart_puts("ID="); uart_put_int((long)MPU6050_WhoAmI()); uart_puts("\r\n");
    }
    else
    {
        uart_puts("EF\r\n");
        while (1) { LED_TGL(); delay_ms(120); }
    }

    uart_puts("CAL\r\n");
    LED_ON();
    MPU6050_CalibrateGyro();
    LED_OFF();

    Filter_Init(&filt);
    PID_Init(&pid, PID_KP_X10, PID_KI_X10, PID_KD_X10,
             PID_I_ACC_LIMIT, PID_OUT_LIMIT, PID_SETPOINT_CDEG);

    timer2_init_100hz();
    #asm("sei")

    uart_puts("RUN\r\n");

#if DEBUG_SENSOR_CHECK
    while (1)
    {
        if (g_tick)
        {
            g_tick = 0;
            MPU6050_Read(&imu);
            uart_put_int(imu.ax); uart_tx(',');
            uart_put_int(imu.ay); uart_tx(',');
            uart_put_int(imu.az); uart_tx(',');
            uart_put_int(imu.gx); uart_tx(',');
            uart_put_int(imu.gy); uart_tx(',');
            uart_put_int(imu.gz); uart_tx(',');
            uart_put_int(imu.acc_cdeg);
            uart_tx('\r'); uart_tx('\n');
            LED_TGL();
        }
    }
#else
    while (1)
    {
        poll_uart_tuning();

        if (g_tick)
        {
            g_tick = 0;
            out = 0;

            if (MPU6050_Read(&imu))
            {
                read_fail = 0;
                angle = Filter_Update(&filt, imu.acc_cdeg, imu.gyro_dcdeg);

                if (g_test != 0)
                {
                    out = g_test;
                    Motor_SetDuty(g_test, g_test);     /* chay thu, bo qua PID */
                }
                else if (angle > FALL_CDEG || angle < -FALL_CDEG)
                {
                    if (!fallen) { Motor_Stop(); PID_Reset(&pid); fallen = 1; }
                    LED_ON();
                }
                else
                {
                    fallen = 0;
                    out = OUTPUT_SIGN * PID_Compute(&pid, angle);
                    Motor_SetDuty(out, out);
                }
            }
            else
            {
                if (++read_fail >= 5)
                {
                    Motor_Stop();
                    PID_Reset(&pid);
                    myi2c_recover();
                    MPU6050_Init();
                    read_fail = 0;
                }
            }

            g_ms += 10;
            if (++tel >= TELEM_EVERY)
            {
                tel = 0;
                LED_TGL();
                tx_csv(g_ms, angle, out);
            }
        }
    }
#endif
}

interrupt [TIM2_COMPA] void timer2_compa_isr(void)
{
    g_tick = 1;
}
