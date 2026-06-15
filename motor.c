#include <mega328p.h>
#include "motor.h"

static unsigned int Motor_PwmValue(int speed)
{
    if (speed < 0)
        speed = -speed;
    if (speed > 255)
        speed = 255;
    return (unsigned int)speed;
}

static void Set_Left_Speed(int speed)
{
    unsigned int duty = Motor_PwmValue(speed);

    if (speed >= 0)
    {
        PORTD.2 = 1;
        PORTD.3 = 0;
    }
    else
    {
        PORTD.2 = 0;
        PORTD.3 = 1;
    }

    OCR1AL = (unsigned char)duty;
    OCR1AH = (unsigned char)(duty >> 8);
}

static void Set_Right_Speed(int speed)
{
    unsigned int duty = Motor_PwmValue(speed);

    if (speed >= 0)
    {
        PORTD.4 = 1;
        PORTD.5 = 0;
    }
    else
    {
        PORTD.4 = 0;
        PORTD.5 = 1;
    }

    OCR1BL = (unsigned char)duty;
    OCR1BH = (unsigned char)(duty >> 8);
}

void Motor_Init(void)
{
    DDRD.2 = 1;
    DDRD.3 = 1;
    DDRD.4 = 1;
    DDRD.5 = 1;
    DDRB.1 = 1;
    DDRB.2 = 1;

    TCCR1A = (1 << COM1A1) | (1 << COM1B1) | (1 << WGM10);
    TCCR1B = (1 << CS10) | (1 << WGM12);
    OCR1AL = 0;
    OCR1AH = 0;
    OCR1BL = 0;
    OCR1BH = 0;
}

void Motor_Control(int speed_left, int speed_right)
{
    if (speed_left > 255) speed_left = 255;
    if (speed_left < -255) speed_left = -255;
    if (speed_right > 255) speed_right = 255;
    if (speed_right < -255) speed_right = -255;

    Set_Left_Speed(speed_left);
    Set_Right_Speed(speed_right);
}
