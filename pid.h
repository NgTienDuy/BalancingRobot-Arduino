#ifndef PID_H
#define PID_H
typedef struct
{
    int  Kp_x10, Ki_x10, Kd_x10;   /* he so * 10 */
    int  setpoint_cdeg;
    long integral;                 /* tong error (cdeg), co anti-windup */
    int  prev_meas;
    int  dfilt;                    /* dao ham da loc */
    long i_limit;
    int  out_limit;
    unsigned char init;
} PID_Controller;

void PID_Init(PID_Controller *p, int kp_x10, int ki_x10, int kd_x10,
              long i_limit, int out_limit, int setpoint_cdeg);
int  PID_Compute(PID_Controller *p, int meas_cdeg);
void PID_Reset(PID_Controller *p);
#endif
