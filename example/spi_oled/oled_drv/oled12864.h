#ifndef __OLED_H
#define __OLED_H

#define OLED_MODE 0
#define SIZE 8
#define XLevelL		0x00
#define XLevelH		0x10
#define Max_Column	128
#define Max_Row		64
#define	Brightness	0xFF
#define X_WIDTH 	128
#define Y_WIDTH 	64

#define u8 unsigned char
#define u32 unsigned int

#include <stdint.h>
#include "../../include/gpio.h"

//-----------------OLED IIC端口定义----------------

#define OLED_DC_Set() GPIO_REG(GPIO_DATA) |= 0x8000;  // GPIO15输出高
#define OLED_DC_Clr() GPIO_REG(GPIO_DATA) &= ~0x8000;  // GPIO15输出低

#define OLED_RES_Set() GPIO_REG(GPIO_DATA) |= 0x4000;  // GPIO14输出高
#define OLED_RES_Clr() GPIO_REG(GPIO_DATA) &= ~0x4000;  // GPIO14输出低

#define OLED_CMD  0	//写命令
#define OLED_DATA 1	//写数据


//OLED控制用函数
void OLED_WR_Byte(unsigned dat,unsigned cmd);
void OLED_DisplayOn(void);
void OLED_DisplayOff(void);
void OLED_Init(void);
void OLED_Clear(void);
void OLED_DrawPoint(u8 x,u8 y,u8 t);
void OLED_Fill(u8 x1,u8 y1,u8 x2,u8 y2,u8 dot);
void OLED_ShowChar(u8 x,u8 y,u8 chr,u8 Char_Size);
void OLED_ShowNum(u8 x,u8 y,u32 num,u8 len,u8 size);
void OLED_ShowString(u8 x,u8 y, u8 *p,u8 Char_Size);
void OLED_SetPos(unsigned char x, unsigned char y);

void OLED_DrawBMP(unsigned char x0, unsigned char y0,unsigned char x1, unsigned char y1,unsigned char BMP[]);
void Delay_50ms(unsigned int Del_50ms);
void Delay_1ms(unsigned int Del_1ms);
void OLED_FillPicture(unsigned char fill_Data);
void Picture();

// 快速绘制图像
void OLED_DrawBMPFast(const unsigned char BMP[]);

// 显示地面
void OLED_DrawGround();

// 绘制云朵
void OLED_DrawCloud();

// 绘制小恐龙
void OLED_DrawDino();

// 绘制仙人掌障碍物
void OLED_DrawCactus();

// 绘制跳跃小恐龙
int OLED_DrawDinoJump(char reset);

// 绘制随机出现的仙人掌障碍物
int OLED_DrawCactusRandom(unsigned char ver, unsigned char reset);

// 绘制重启
void OLED_DrawRestart();
// 绘制封面
void OLED_DrawCover();
#endif




