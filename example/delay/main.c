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
    int cnt = 0;
    TIMER0_REG(TIMER0_VALUE) = 500000;  // 10ms period
    TIMER0_REG(TIMER0_CTRL) = 0x07;     // enable interrupt and start timer

    GPIO_REG(GPIO_CTRL) |= 0x2;  // gpio0输入模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 2;  // gpio1输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 4;  // gpio2输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 6;  // gpio3输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 8;  // gpio4输出模式

    while (1) {
        // 1000ms
        if (count == 100) {
            count = 0;
            if((GPIO_REG(GPIO_DATA) & 0x1))
        {
            cnt++;
        }
        else
        {
            cnt--;
        }
        if(cnt>3)
        {
            cnt=0;
        }
        if(cnt<0)
        {
            cnt=3;
        }
        GPIO_REG(GPIO_DATA) &= ~0x1f;  // 拉低全部LED_IO(1~4)
        GPIO_REG(GPIO_DATA) |= (0x02 << cnt);
        }
    }
    return 0;
}

void timer0_irq_handler()
{
    TIMER0_REG(TIMER0_CTRL) |= (1 << 2) | (1 << 0);  // clear int pending and start timer

    count++;
}
