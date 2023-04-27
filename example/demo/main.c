#include <stdint.h>

#include "../include/timer.h"
#include "../include/gpio.h"
#include "../include/utils.h"

void delay(unsigned int ms)
{
    int i,j;
    for(i=0;i<ms;i++)
    for(j=0;j<2660;j++);
}

int main()
{
    int cnt = 0;
    GPIO_REG(GPIO_CTRL) |= 0x2;  // gpio0输入模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 2;  // gpio1输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 4;  // gpio2输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 6;  // gpio3输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 8;  // gpio4输出模式
    while (1) 
    {
        if(!(GPIO_REG(GPIO_DATA) & 0x1))
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
        delay(1000);
    }
}
