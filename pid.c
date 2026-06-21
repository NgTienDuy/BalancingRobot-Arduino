/*============================================================================
  pid.c  -  PID SO NGUYEN.
  Goc theo centi-degree, dt=0.01s da gop vao cac he so chia:
    P: Kp*error_deg      = Kp_x10 * error_cdeg / 1000
    I: Ki*integral_deg_s = Ki_x10 * sum_err   / 100000   (anti-windup)
    D: Kd*d(deg)/dt      = -Kd_x10 * d_meas   / 10       (deriv-on-measurement, da loc)
============================================================================*/
#include "pid.h"

void PID_Init(PID_Controller *p, int kp_x10, int ki_x10, int kd_x10,
              long i_limit, int out_limit, int setpoint_cdeg)
{
    p->Kp_x10 = kp_x10; p->Ki_x10 = ki_x10; p->Kd_x10 = kd_x10;
    p->setpoint_cdeg = setpoint_cdeg;
    p->integral = 0;
    p->prev_meas = 0;
    p->dfilt = 0;
    p->i_limit = i_limit;
    p->out_limit = out_limit;
    p->init = 0;
}

void PID_Reset(PID_Controller *p)
{
    p->integral = 0;
    p->dfilt = 0;
    p->init = 0;
}

int PID_Compute(PID_Controller *p, int meas_cdeg)
{
    int  error = p->setpoint_cdeg - meas_cdeg;
    int  dmeas;
    long pout, iout, dout, out;

    p->integral += error;
    if (p->integral >  p->i_limit) p->integral =  p->i_limit;
    if (p->integral < -p->i_limit) p->integral = -p->i_limit;

    if (!p->init) { p->prev_meas = meas_cdeg; p->init = 1; }
    dmeas = meas_cdeg - p->prev_meas;
    p->prev_meas = meas_cdeg;
    p->dfilt = (p->dfilt * 3 + dmeas) / 4;          /* low-pass don gian */

    pout =  (long)p->Kp_x10 * error      / 1000L;
    iout =  (long)p->Ki_x10 * p->integral / 100000L;
    dout = -(long)p->Kd_x10 * p->dfilt   / 10L;

    out = pout + iout + dout;
    if (out >  p->out_limit) out =  p->out_limit;
    if (out < -p->out_limit) out = -p->out_limit;
    return (int)out;
}
