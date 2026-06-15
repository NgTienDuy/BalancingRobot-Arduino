#ifndef PID_H
#define PID_H

typedef struct
{
    float Kp;
    float Ki;
    float Kd;
    float Error;
    float Integral;
    float Derivative;
    float Last_Error;
    float Setpoint;
    float Output;
    float Integral_Limit;
    float Output_Limit;
} PID_Controller;

void PID_Init(PID_Controller* pid, float Kp, float Ki, float Kd,
              float integral_limit, float output_limit, float setpoint);
float PID_Compute(PID_Controller* pid, float current_angle, float dt);

#endif
