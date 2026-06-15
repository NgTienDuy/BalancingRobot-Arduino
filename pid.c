#include "pid.h"

void PID_Init(PID_Controller* pid, float Kp, float Ki, float Kd,
              float integral_limit, float output_limit, float setpoint)
{
    pid->Kp = Kp;
    pid->Ki = Ki;
    pid->Kd = Kd;
    pid->Integral = 0.0f;
    pid->Derivative = 0.0f;
    pid->Error = 0.0f;
    pid->Last_Error = 0.0f;
    pid->Setpoint = setpoint;
    pid->Integral_Limit = integral_limit;
    pid->Output_Limit = output_limit;
    pid->Output = 0.0f;
}

float PID_Compute(PID_Controller* pid, float current_angle, float dt)
{
    pid->Error = pid->Setpoint - current_angle;
    pid->Integral += pid->Error * dt;

    if (pid->Integral > pid->Integral_Limit) pid->Integral = pid->Integral_Limit;
    if (pid->Integral < -pid->Integral_Limit) pid->Integral = -pid->Integral_Limit;

    pid->Derivative = (pid->Error - pid->Last_Error) / dt;
    pid->Output = pid->Kp * pid->Error + pid->Ki * pid->Integral + pid->Kd * pid->Derivative;

    if (pid->Output > pid->Output_Limit) pid->Output = pid->Output_Limit;
    if (pid->Output < -pid->Output_Limit) pid->Output = -pid->Output_Limit;

    pid->Last_Error = pid->Error;
    return pid->Output;
}
