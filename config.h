/*============================================================================
  config.h  -  Cau hinh tap trung. BAN FIXED-POINT (khong float) de vua
               gioi han dung luong cua CodeVision Evaluation.
  ATmega328P @16MHz - CodeVisionAVR
============================================================================*/
#ifndef CONFIG_H
#define CONFIG_H

/* ---- Clock (nho dat Chip Clock = 16MHz trong C Compiler) ---- */
#define F_CPU            16000000UL

/* ---- UART 38400 8N1 ; UBRR = F_CPU/(16*baud)-1 = 25 ---- */
#define UART_BAUD        38400UL
#define UART_UBRR        ((F_CPU/(16UL*UART_BAUD)) - 1UL)

/* ---- Control loop 100 Hz (Timer2 CTC) ---- */
#define LOOP_HZ          100

/* ---- MPU6050/6500 ---- */
#define MPU6050_ADDR     0x68
#define MPU6050_ADDR_W   (MPU6050_ADDR << 1)
#define MPU6050_ADDR_R   ((MPU6050_ADDR << 1) | 1)
#define GYRO_LSB_PER_DPS 131L         /* +/-250dps -> 131 LSB/(deg/s) */

/* ---- Chon truc & dau (tu ket qua test thuc te) ----
   1: goc tu ax, gyro gy ; 0: goc tu ay, gyro gx */
#define TILT_USES_X_ACCEL  1
#define ACC_ANGLE_SIGN     (1)        /* +1 hoac -1 */
#define GYRO_RATE_SIGN     (1)
#define ACC_Z_SIGN         (-1)       /* az AM khi dung -> -1 de goc ~0 luc dung */

/* ---- Goc bang centi-degree (cdeg = do*100) ----
   acc_cdeg ~ (ax/az)*5730  (xap xi tan; chinh xac khi goc nho) */
#define ACC_CDEG_K       5730L

/* ---- Complementary filter: alpha = NUM/DEN ~ 0.98 ---- */
#define COMP_ALPHA_NUM   251
#define COMP_ALPHA_DEN   256

/* ---- PWM/Motor (Timer1 mode14, ICR1=799 -> 20kHz) ---- */
#define PWM_TOP          799
#define MOTOR_MAX_DUTY   PWM_TOP
/* Nguong khoi dong RIENG tung motor (duty 0..799). Dat ~ duty toi thieu de
   banh do bat dau quay. Do bang lenh T/L/R qua UART roi ghi lai vao day.   */
#define MOTOR_L_DEADBAND 540
#define MOTOR_R_DEADBAND 560
#define OUTPUT_SIGN      (1)          /* doi dau dieu khien neu xe day nguoc */
#define MOTOR_L_SCALE    100          /* %% can chinh toc do 2 dong co */
#define MOTOR_R_SCALE    100

/* ---- PID (he so luu dang *10 ; live-tune: "P 150" -> Kp=15.0) ---- */
#define PID_KP_X10         150        /* Kp = 15.0 */
#define PID_KI_X10         0          /* Ki = 0.0  */
#define PID_KD_X10         6          /* Kd = 0.6  */
#define PID_SETPOINT_CDEG  0          /* diem can bang (centi-degree) */
#define PID_I_ACC_LIMIT    2000000L   /* gioi han chong windup (tong error cdeg) */
#define PID_OUT_LIMIT      799

/* ---- Safety: |goc| > FALL_CDEG -> dung motor ---- */
#define FALL_CDEG        4000         /* 40.0 do */

/* ---- Build mode: 1 = stream raw (kiem tra truc), motor TAT ---- */
#define DEBUG_SENSOR_CHECK  0

/* Telemetry: in moi TELEM_EVERY tick (1=10ms/100Hz log, 2=20ms, 5=50ms) */
#define TELEM_EVERY  2

#endif /* CONFIG_H */
