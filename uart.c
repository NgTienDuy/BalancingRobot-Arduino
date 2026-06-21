/*============================================================================
  uart.c  -  UART register-level cho ATmega328P (USART0)
============================================================================*/
#include <mega328p.h>
#include "config.h"
#include "uart.h"

void uart_init(void)
{
    UBRR0H = (unsigned char)(UART_UBRR >> 8);
    UBRR0L = (unsigned char)(UART_UBRR);
    UCSR0A = 0x00;                                  /* U2X0 = 0 */
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);           /* bat RX + TX */
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);         /* 8 data, 1 stop, no parity */
}

void uart_tx(char c)
{
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = c;
}

void uart_puts(char *s)
{
    while (*s) uart_tx(*s++);
}

void uart_put_int(long v)
{
    char buf[12];
    unsigned char i = 0;
    unsigned long u;

    if (v < 0) { uart_tx('-'); u = (unsigned long)(-v); }
    else         u = (unsigned long)v;

    if (u == 0) { uart_tx('0'); return; }

    while (u) { buf[i++] = (char)('0' + (u % 10)); u /= 10; }
    while (i)   uart_tx(buf[--i]);
}

unsigned char uart_available(void)
{
    return (UCSR0A & (1 << RXC0)) ? 1 : 0;
}

char uart_get(void)
{
    while (!(UCSR0A & (1 << RXC0)));
    return UDR0;
}
