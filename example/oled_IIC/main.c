#include <stdint.h>
#include <stdlib.h>

#include "../include/timer.h"
#include "../include/gpio.h"
#include "../include/utils.h"
#include "../include/uart.h"
#include "../include/xprintf.h"
#include "./oled_drv/oled12864.h"

void gpio_init()
{
    GPIO_REG(GPIO_CTRL) |= 0x2;  // gpio0输入模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 30;  // gpio15输出模式
    GPIO_REG(GPIO_CTRL) |= 0x1 << 28;  // gpio14输出模式
}
void delay(unsigned int ms)
{
    int i,j;
    for(i=0;i<ms;i++)
    for(j=0;j<1000;j++);
}

int main()
{
    unsigned char key_num = 0;
    unsigned char cactus_category = 0;
    unsigned char cactus_length = 8;
    unsigned int score = 0;
    unsigned int highest_score = 0;
    int height = 0;
    int cactus_pos = 128;
    unsigned char cur_speed = 30;
    char failed = 0;
    char reset = 0;
    gpio_init();
    uart_init();
    xprintf("\rinitiliazed OK!\r\n");
    OLED_Init();
    OLED_DrawCover();
    delay(100);
    while (!(GPIO_REG(GPIO_DATA) & 0x1));
    delay(100);
    OLED_Clear();
    xprintf("\r\nDinosaur game initiliazed OK!\r\n");
    while (1)
    {
        if (failed == 1)
        {
            OLED_DrawRestart();

            key_num = (GPIO_REG(GPIO_DATA) & 0x1)+1;
            if (key_num == 2)
            {
                if (score > highest_score) highest_score = score;
                score = 0;
                failed = 0;
                height = 0;
                reset = 1;
                OLED_DrawDinoJump(reset);
                OLED_DrawCactusRandom(cactus_category, reset);
                OLED_Clear();
            }
            continue;
        }


        score ++;
        if (height <= 0) key_num = (GPIO_REG(GPIO_DATA) & 0x1)+1;

        OLED_DrawGround();
        OLED_DrawCloud();

        if (height>0 || key_num == 1) height = OLED_DrawDinoJump(reset);
        else OLED_DrawDino();

        cactus_pos = OLED_DrawCactusRandom(cactus_category, reset);
        if(cactus_category == 0) cactus_length = 8;
        else if(cactus_category == 1) cactus_length = 16;
        else cactus_length = 24;

        if (cactus_pos + cactus_length < 0)
        {
          cactus_category = rand()%4;
            OLED_DrawCactusRandom(cactus_category, 1);
        }

        if ((height < 16) && ( (cactus_pos>=16 && cactus_pos <=32) || (cactus_pos + cactus_length>=16 && cactus_pos + cactus_length <=32)))
        {
            failed = 1;
        }

        OLED_ShowString(35, 0, "HI:", 12);
        OLED_ShowNum(58, 0, highest_score, 5, 12);
        OLED_ShowNum(98, 0, score, 5, 12);

        reset = 0;

        cur_speed = score/50;
        if (cur_speed > 29) cur_speed = 29;
        delay(30 - cur_speed);
        key_num = 0;
    }
}
