/*============================================================================
  myi2c.h  -  Hardware TWI driver (ten khac thu vien i2c.h cua CVAVR).
              Co timeout + phuc hoi bus de chong ket I2C do nhieu motor.
============================================================================*/
#ifndef MYI2C_H
#define MYI2C_H

void          myi2c_init(void);
unsigned char myi2c_start(unsigned char addr);
void          myi2c_stop(void);
unsigned char myi2c_write(unsigned char data);
unsigned char myi2c_read_ack(void);
unsigned char myi2c_read_nack(void);

void          myi2c_recover(void);       /* danh 9 xung SCL giai phong bus ket */
unsigned char myi2c_fault(void);         /* 1 neu lan giao tiep vua roi loi    */
void          myi2c_clear_fault(void);

#endif
