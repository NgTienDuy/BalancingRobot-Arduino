/*============================================================================
  motor.c  -  Timer1 Fast PWM mode14 (ICR1=799 -> 20kHz). Deadband RIENG tung
              motor + anh xa ti le: |out| 0..799 -> deadband..799 (out=0 -> 0).
  Chan: ENA=OC1A=PB1(D9) ENB=OC1B=PB2(D10)
        IN1=PD2(D2) IN2=PD4(D4) -> TRAI ; IN3=PD7(D7) IN4=PB0(D8) -> PHAI
============================================================================*/
#include <mega328p.h>
#include "config.h"
#include "motor.h"

static int dead_l = MOTOR_L_DEADBAND;
static int dead_r = MOTOR_R_DEADBAND;

void Motor_SetDeadband(int l, int r) { dead_l = l; dead_r = r; }

/* |speed| (0..799) -> (dead..799), giu 0 = 0 */
static unsigned int map_duty(int speed, int dead)
{
    long mag;
    if (speed == 0) return 0;
    mag = (speed < 0) ? -(long)speed : (long)speed;
    if (mag > MOTOR_MAX_DUTY) mag = MOTOR_MAX_DUTY;
    mag = dead + mag * (long)(MOTOR_MAX_DUTY - dead) / MOTOR_MAX_DUTY;
    if (mag > MOTOR_MAX_DUTY) mag = MOTOR_MAX_DUTY;
    if (mag < 0) mag = 0;
    return (unsigned int)mag;
}

void Motor_Init(void)
{
    DDRD |= (1 << 2) | (1 << 4) | (1 << 7);
    DDRB |= (1 << 0) | (1 << 1) | (1 << 2);

    TCCR1A = (1 << COM1A1) | (1 << COM1B1) | (1 << WGM11);
    TCCR1B = (1 << WGM13)  | (1 << WGM12)  | (1 << CS10);
    ICR1H = (unsigned char)(PWM_TOP >> 8);
    ICR1L = (unsigned char)(PWM_TOP & 0xFF);
    OCR1AH = 0; OCR1AL = 0;
    OCR1BH = 0; OCR1BL = 0;
}

static void set_left(int speed)
{
    unsigned int duty = map_duty(speed, dead_l);
    if (speed >= 0) { PORTD.2 = 1; PORTD.4 = 0; }
    else            { PORTD.2 = 0; PORTD.4 = 1; }
    OCR1AH = (unsigned char)(duty >> 8);
    OCR1AL = (unsigned char)(duty & 0xFF);
}

static void set_right(int speed)
{
    unsigned int duty = map_duty(speed, dead_r);
    if (speed >= 0) { PORTD.7 = 1; PORTB.0 = 0; }
    else            { PORTD.7 = 0; PORTB.0 = 1; }
    OCR1BH = (unsigned char)(duty >> 8);
    OCR1BL = (unsigned char)(duty & 0xFF);
}

void Motor_SetDuty(int left, int right)
{
    set_left ((int)((long)left  * MOTOR_L_SCALE / 100));
    set_right((int)((long)right * MOTOR_R_SCALE / 100));
}

void Motor_Stop(void)
{
    OCR1AH = 0; OCR1AL = 0;
    OCR1BH = 0; OCR1BL = 0;
    PORTD.2 = 0; PORTD.4 = 0; PORTD.7 = 0; PORTB.0 = 0;
}
