#include <stdint.h>

#include "../include/timer.h"
#include "../include/gpio.h"
#include "../include/utils.h"

void delay()
{
    int i,j;
    for(i=0;i<600;i++)
    for(j=0;j<1000;j++);
}

int main()
{
    int cnt = 0;
    int i,j;
    GPIO_REG(GPIO_CTRL) |= 0x2;  // gpio0输入模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 2;  // gpio1输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 4;  // gpio2输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 6;  // gpio3输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 8;  // gpio4输出模式
    while (1) {
        for(;(cnt<4)&&(GPIO_REG(GPIO_DATA) & 0x1);cnt++)
        {
            if(cnt == 3)
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x2;  // GPIO1输出高
            }
            else if(cnt == 2)
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x4;  // GPIO2输出高
            }
            else if(cnt == 1)
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x8;  // GPIO3输出高
            }
            else
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x10;  // GPIO4输出高
            }
            delay();
        }
        for(;cnt<4&&(~(GPIO_REG(GPIO_DATA) & 0x1));cnt++)
        {
            if(cnt == 0)
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x10; // GPIO4输出高
            }
            else if(cnt == 1)
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x2;  // GPIO1输出高
            }
            else if(cnt == 2)
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x4;  // GPIO2输出高
            }
            else
            {
                GPIO_REG(GPIO_DATA) &= 0x1;  // 拉低除GPIO0以外的IO
                GPIO_REG(GPIO_DATA) |= 0x8;  // GPIO3输出高
            }
            delay();
        }
        if(cnt>=4)
        {
            cnt=0;
        }
    }
}
