/*============================================================================
  i2c.c  -  TWI phan cung (dung TWBR/TWCR/TWSR/TWDR - dung yeu cau de bai)
  SCL = 100 kHz @16MHz : TWBR = (F_CPU/SCL - 16)/2 = (160-16)/2 = 72, presc=1
============================================================================*/
#include <mega328p.h>
#include "config.h"
#include "i2c.h"

#define TWI_TWBR_VAL  72

/* Status codes (TWSR & 0xF8) */
#define TW_MT_SLA_ACK   0x18
#define TW_MR_SLA_ACK   0x40
#define TW_MT_DATA_ACK  0x28

static void twi_wait(void)
{
    while (!(TWCR & (1 << TWINT)));
}

void i2c_init(void)
{
    TWSR = 0x00;            /* prescaler = 1 */
    TWBR = TWI_TWBR_VAL;
    TWCR = (1 << TWEN);
}

unsigned char i2c_start(unsigned char addr)
{
    unsigned char st;

    TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);   /* START */
    twi_wait();

    TWDR = addr;                                        /* SLA + R/W */
    TWCR = (1 << TWINT) | (1 << TWEN);
    twi_wait();

    st = TWSR & 0xF8;
    return (st == TW_MT_SLA_ACK || st == TW_MR_SLA_ACK) ? 1 : 0;
}

void i2c_stop(void)
{
    TWCR = (1 << TWINT) | (1 << TWSTO) | (1 << TWEN);
    while (TWCR & (1 << TWSTO));
}

unsigned char i2c_write(unsigned char data)
{
    TWDR = data;
    TWCR = (1 << TWINT) | (1 << TWEN);
    twi_wait();
    return ((TWSR & 0xF8) == TW_MT_DATA_ACK) ? 1 : 0;
}

unsigned char i2c_read_ack(void)
{
    TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWEA);
    twi_wait();
    return TWDR;
}

unsigned char i2c_read_nack(void)
{
    TWCR = (1 << TWINT) | (1 << TWEN);
    twi_wait();
    return TWDR;
}
