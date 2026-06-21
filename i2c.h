/*============================================================================
  i2c.h  -  Hardware TWI (I2C) driver, register-level, cho ATmega328P
  SDA=PC4, SCL=PC5 (chan TWI phan cung)
============================================================================*/
#ifndef I2C_H
#define I2C_H

void          i2c_init(void);
unsigned char i2c_start(unsigned char addr);  /* addr da gom bit R/W; 1=ACK  */
void          i2c_stop(void);
unsigned char i2c_write(unsigned char data);   /* 1 neu nhan ACK             */
unsigned char i2c_read_ack(void);              /* doc byte, tra ACK          */
unsigned char i2c_read_nack(void);             /* doc byte cuoi, tra NACK    */

#endif
