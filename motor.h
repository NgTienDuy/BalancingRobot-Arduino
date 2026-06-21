#ifndef MOTOR_H
#define MOTOR_H
void Motor_Init(void);
void Motor_SetDuty(int left, int right);   /* -799..+799 */
void Motor_SetDeadband(int l, int r);      /* chinh nguong khoi dong song */
void Motor_Stop(void);
#endif
