#include <stdint.h>

#include "../include/gpio.h"
#include "../include/utils.h"


int main()
{
    GPIO_REG(GPIO_CTRL) |= 0x2;       // gpio0输入模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 2;  // gpio1输出模式

    while (1) {
        // 如果GPIO0输入高
        if (GPIO_REG(GPIO_DATA) & 0x1)
            GPIO_REG(GPIO_DATA) |= 0x2;  // GPIO1输出高
        // 如果GPIO0输入低
        else
            GPIO_REG(GPIO_DATA) &= ~0x2; // GPIO1输出低
    }
}
