/*============================================================================
  uart.h  -  USART0 register-level, 8N1. Khong dung printf float (tiet kiem RAM/flash)
============================================================================*/
#ifndef UART_H
#define UART_H

void          uart_init(void);
void          uart_tx(char c);
void          uart_puts(char *s);
void          uart_put_int(long v);     /* in so nguyen co dau */
unsigned char uart_available(void);     /* 1 neu co byte den   */
char          uart_get(void);           /* doc 1 byte (blocking)*/

#endif
