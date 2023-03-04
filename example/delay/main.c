#include <stdint.h>

#include "../include/timer.h"
#include "../include/gpio.h"
#include "../include/utils.h"


static volatile uint32_t count;

void delay_ms(unsigned int ms)
{
}
int main()
{
    count = 0;
    TIMER0_REG(TIMER0_VALUE) = 500000;  // 10ms period
    TIMER0_REG(TIMER0_CTRL) = 0x07;     // enable interrupt and start timer

    GPIO_REG(GPIO_CTRL) |= 0x1 << 2;  // set gpio1 output mode

    while (1) {
        // 1000ms
        if (count == 100) {
            count = 0;
            GPIO_REG(GPIO_DATA) ^= 0x2; // toggle led
        }
    }
    return 0;
}

void timer0_irq_handler()
{
    TIMER0_REG(TIMER0_CTRL) |= (1 << 2) | (1 << 0);  // clear int pending and start timer

    count++;
}
