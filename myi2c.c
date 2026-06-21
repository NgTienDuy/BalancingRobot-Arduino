/*============================================================================
  myi2c.c  -  TWI phan cung co TIMEOUT (khong treo cung) + phuc hoi bus.
============================================================================*/
#include <mega328p.h>
#include <delay.h>
#include "config.h"
#include "myi2c.h"

#define TWI_TWBR_VAL    72
#define TW_MT_SLA_ACK   0x18
#define TW_MR_SLA_ACK   0x40
#define TW_MT_DATA_ACK  0x28
#define TWI_TIMEOUT     20000U

static unsigned char g_fault = 0;

unsigned char myi2c_fault(void)     { return g_fault; }
void          myi2c_clear_fault(void){ g_fault = 0; }

static void twi_wait(void)
{
    unsigned int t = 0;
    while (!(TWCR & (1 << TWINT)))
        if (++t > TWI_TIMEOUT) { g_fault = 1; return; }
}

void myi2c_init(void)
{
    TWSR = 0x00;
    TWBR = TWI_TWBR_VAL;
    TWCR = (1 << TWEN);
    g_fault = 0;
}

unsigned char myi2c_start(unsigned char addr)
{
    unsigned char st;
    if (g_fault) return 0;
    TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
    twi_wait(); if (g_fault) return 0;
    TWDR = addr;
    TWCR = (1 << TWINT) | (1 << TWEN);
    twi_wait(); if (g_fault) return 0;
    st = TWSR & 0xF8;
    return (st == TW_MT_SLA_ACK || st == TW_MR_SLA_ACK) ? 1 : 0;
}

void myi2c_stop(void)
{
    unsigned int t = 0;
    TWCR = (1 << TWINT) | (1 << TWSTO) | (1 << TWEN);
    while (TWCR & (1 << TWSTO))
        if (++t > TWI_TIMEOUT) { g_fault = 1; return; }
}

unsigned char myi2c_write(unsigned char data)
{
    if (g_fault) return 0;
    TWDR = data;
    TWCR = (1 << TWINT) | (1 << TWEN);
    twi_wait(); if (g_fault) return 0;
    return ((TWSR & 0xF8) == TW_MT_DATA_ACK) ? 1 : 0;
}

unsigned char myi2c_read_ack(void)
{
    if (g_fault) return 0xFF;
    TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWEA);
    twi_wait();
    return TWDR;
}

unsigned char myi2c_read_nack(void)
{
    if (g_fault) return 0xFF;
    TWCR = (1 << TWINT) | (1 << TWEN);
    twi_wait();
    return TWDR;
}

/* Phuc hoi bus ket: tat TWI, danh 9 xung SCL bang GPIO, tao STOP, bat lai TWI.
   SDA = PC4, SCL = PC5 */
void myi2c_recover(void)
{
    unsigned char i;

    TWCR = 0;                      /* tra chan ve GPIO */
    DDRC  &= ~(1 << 4);            /* SDA = input (tha) */
    PORTC &= ~(1 << 4);
    DDRC  |=  (1 << 5);            /* SCL = output */

    for (i = 0; i < 9; i++)
    {
        PORTC |=  (1 << 5); delay_us(5);
        PORTC &= ~(1 << 5); delay_us(5);
    }

    DDRC  |=  (1 << 4); PORTC &= ~(1 << 4);    /* SDA low  */
    PORTC |=  (1 << 5); delay_us(5);           /* SCL high */
    DDRC  &= ~(1 << 4); delay_us(5);           /* SDA tha len -> STOP */

    myi2c_init();
}
