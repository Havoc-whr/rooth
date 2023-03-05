//////////////////////////////////////////////////////////////////////////////////
//  文 件 名   : oled12864.c
//  版 本 号   : v2.0
//  作    者   : hejunlin
//  生成日期   : 2022-06-28
//  最近修改   :
//  功能描述   : 0.96寸OLED 接口演示例程
//              说明:
//              ----------------------------------------------------------------
//              GND   电源地
//              VCC   接5V或3.3v电源
//              SCL   接PB3（SCL）
//              SDA   接PB4（SDA）
//              ----------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////?

#include "oled12864.h"
#include "stdlib.h"
#include "oledfont.h"
#include "../../include/spi.h"
//#include "delay.h"
//OLED的显存
//存放格式如下.
//[0]0 1 2 3 ... 127
//[1]0 1 2 3 ... 127
//[2]0 1 2 3 ... 127
//[3]0 1 2 3 ... 127
//[4]0 1 2 3 ... 127
//[5]0 1 2 3 ... 127
//[6]0 1 2 3 ... 127
//[7]0 1 2 3 ... 127

void OLED_WR_Byte(unsigned dat,unsigned cmd)
{
	if(cmd)
	{
		spi_write_byte(dat);
	}
	else
	{
		OLED_DC_Clr();//写命令
		spi_write_byte(dat);
		OLED_DC_Set();//写数据
	}


}


/********************************************
// OLED_FillPicture
********************************************/
void OLED_FillPicture(unsigned char fill_Data)
{
	unsigned char m,n;
	for(m=0;m<8;m++)
	{
		OLED_WR_Byte(0xb0+m,0);		//page0-page1
		OLED_WR_Byte(0x00,0);		//low column start address
		OLED_WR_Byte(0x10,0);		//high column start address
		for(n=0;n<128;n++)
			{
				OLED_WR_Byte(fill_Data,1);
			}
	}
}


/***********************Delay****************************************/
void Delay_50ms(unsigned int Del_50ms)
{
	int i,j;
   for(i=0;i<Del_50ms;i++)
   for(j=0;j<133000;j++);
}

void Delay_1ms(unsigned int Del_1ms)
{
	int i,j;
   for(i=0;i<Del_1ms;i++)
   for(j=0;j<2660;j++);
}

//坐标设置

void OLED_SetPos(unsigned char x, unsigned char y)
{ 	OLED_WR_Byte(0xb0+y,OLED_CMD);
	OLED_WR_Byte(((x&0xf0)>>4)|0x10,OLED_CMD);
	OLED_WR_Byte((x&0x0f),OLED_CMD);
}
//开启OLED显示
void OLED_DisplayOn(void)
{
	OLED_WR_Byte(0X8D,OLED_CMD);  //SET DCDC命令
	OLED_WR_Byte(0X14,OLED_CMD);  //DCDC ON
	OLED_WR_Byte(0XAF,OLED_CMD);  //DISPLAY ON
}
//关闭OLED显示
void OLED_DisplayOff(void)
{
	OLED_WR_Byte(0X8D,OLED_CMD);  //SET DCDC命令
	OLED_WR_Byte(0X10,OLED_CMD);  //DCDC OFF
	OLED_WR_Byte(0XAE,OLED_CMD);  //DISPLAY OFF
}
//清屏函数,清完屏,整个屏幕是黑色的!和没点亮一样!!!
void OLED_Clear(void)
{
	u8 i,n;
	for(i=0;i<8;i++)
	{
		OLED_WR_Byte (0xb0+i,OLED_CMD);    //设置页地址（0~7）
		OLED_WR_Byte (0x00,OLED_CMD);      //设置显示位置—列低地址
		OLED_WR_Byte (0x10,OLED_CMD);      //设置显示位置—列高地址
		for(n=0;n<128;n++)OLED_WR_Byte(0,OLED_DATA);
	} //更新显示
}
void OLED_On(void)
{
	u8 i,n;
	for(i=0;i<8;i++)
	{
		OLED_WR_Byte (0xb0+i,OLED_CMD);    //设置页地址（0~7）
		OLED_WR_Byte (0x00,OLED_CMD);      //设置显示位置—列低地址
		OLED_WR_Byte (0x10,OLED_CMD);      //设置显示位置—列高地址
		for(n=0;n<128;n++)OLED_WR_Byte(1,OLED_DATA);
	} //更新显示
}
//在指定位置显示一个字符,包括部分字符
//x:0~127
//y:0~63
//mode:0,反白显示;1,正常显示
//size:选择字体 16/12
void OLED_ShowChar(u8 x,u8 y,u8 chr,u8 Char_Size)
{
	unsigned char c=0,i=0;
		c=chr-' ';//得到偏移后的值
		if(x>Max_Column-1){x=0;y=y+2;}
		if(Char_Size ==16)
			{
			OLED_SetPos(x,y);
			for(i=0;i<8;i++)
			OLED_WR_Byte(F8X16[c*16+i],OLED_DATA);
			OLED_SetPos(x,y+1);
			for(i=0;i<8;i++)
			OLED_WR_Byte(F8X16[c*16+i+8],OLED_DATA);
			}
			else {
				OLED_SetPos(x,y);
				for(i=0;i<6;i++)
				OLED_WR_Byte(F6x8[c][i],OLED_DATA);

			}
}
//m^n函数
u32 oled_pow(u8 m,u8 n)
{
	u32 result=1;
	while(n--)result*=m;
	return result;
}
//显示2个数字
//x,y :起点坐标
//len :数字的位数
//size:字体大小
//mode:模式	0,填充模式;1,叠加模式
//num:数值(0~4294967295);
void OLED_ShowNum(u8 x,u8 y,u32 num,u8 len,u8 size2)
{
	u8 t,temp;
	u8 enshow=0;
	for(t=0;t<len;t++)
	{
		temp=(num/oled_pow(10,len-t-1))%10;
		if(enshow==0&&t<(len-1))
		{
			if(temp==0)
			{
//				OLED_ShowChar(x+(size2/2)*t,y,' ',size2);
				OLED_ShowChar(x+(size2/2)*t,y,'0',size2);
				continue;
			}else enshow=1;

		}
	 	OLED_ShowChar(x+(size2/2)*t,y,temp+'0',size2);
	}
}
//显示一个字符号串
void OLED_ShowString(u8 x,u8 y,u8 *chr,u8 Char_Size)
{
	unsigned char j=0;
	while (chr[j]!='\0')
	{		OLED_ShowChar(x,y,chr[j],Char_Size);
			x+=8;
		if(x>120){x=0;y+=2;}
			j++;
	}
}

/***********功能描述：显示显示BMP图片128×64起始点坐标(x,y),x的范围0～127，y为页的范围0～7*****************/
void OLED_DrawBMP(unsigned char x0, unsigned char y0,unsigned char x1, unsigned char y1,unsigned char BMP[])
{
 unsigned int j=0;
 unsigned char x,y;

  if(y1%8==0) y=y1/8;
  else y=y1/8+1;
	for(y=y0;y<y1;y++)
	{
		OLED_SetPos(x0,y);
		for(x=x0;x<x1;x++)
	    {
	    	OLED_WR_Byte(BMP[j++],OLED_DATA);
	    }
	}
}


// 快速绘制图像
void OLED_DrawBMPFast(const unsigned char BMP[])
{
	unsigned int j = 0;
	unsigned char x, y;

	for (y = 0; y < 8; y++)
	{
		OLED_SetPos(0, y);
		spi_write_byte(0x78);
		spi_write_byte(0x40);
		for (x = 0; x < 128; x++)
		{
			spi_write_byte(BMP[j++]);
		}
	}
}

void oled_drawbmp_block_clear(int bx, int by, int clear_size)
{
	unsigned int i;
	OLED_SetPos(bx, by);
	spi_write_byte(0x78);
	spi_write_byte(0x40);

	for (i = 0; i < clear_size; i++)
	{
		if (bx + i>128) break;
		spi_write_byte(0x0);
	}
}

void OLED_DrawGround()
{
	static unsigned int pos = 0;
	unsigned char speed = 5;
	unsigned int ground_length = sizeof(GROUND);
	unsigned char x;

	OLED_SetPos(0, 7);

	spi_write_byte(0x78);
	spi_write_byte(0x40);
	for (x = 0; x < 128; x++)
	{
		spi_write_byte(GROUND[(x+pos)%ground_length]);
	}

	pos = pos + speed;
	//if(pos>ground_length) pos=0;
}


// 绘制云朵
void OLED_DrawCloud()
{
	static int pos = 128;
	static char height=0;
	char speed = 3;
	unsigned int i=0;
	int x;
	int start_x = 0;
	int length = sizeof(CLOUD);
	unsigned char byte;

	//if (pos + length <= -speed) pos = 128;

	if (pos + length <= -speed)
	{
		pos = 128;
		height = rand()%3;
	}
	if(pos < 0)
	{
		start_x = -pos;
		OLED_SetPos(0, 1+height);
	}
	else
	{
		OLED_SetPos(pos, 1+height);
	}

	spi_write_byte(0x78);
	spi_write_byte(0x40);
	for (x = start_x; x < length + speed; x++)
	{
		if (pos + x > 127) break;
		if (x < length) byte = CLOUD[x];
		else byte = 0x0;

		spi_write_byte(byte);
	}

	pos = pos - speed;
}

// 绘制小恐龙
void OLED_DrawDino()
{
	static unsigned char dino_dir = 0;
	unsigned int j=0;
	unsigned char x, y;
	unsigned char byte;

	dino_dir++;
	dino_dir = dino_dir%2;
	for(y=0; y<2; y++)
	{
		OLED_SetPos(16, 6+y);
		spi_write_byte(0x78);
		spi_write_byte(0x40);
		for (x = 0; x < 16; x++)
		{
			j = y*16 + x;
			byte = DINO[dino_dir][j];

			spi_write_byte(byte);
		}
	}
}

// 绘制仙人掌障碍物
void OLED_DrawCactus()
{
	char speed = 5;
	static int pos = 128;
	int start_x = 0;
	int length = sizeof(CACTUS_2)/2;

	unsigned int j=0;
	unsigned char x, y;
	unsigned char byte;

	if (pos + length <= 0)
	{
		oled_drawbmp_block_clear(0, 6, speed);
		pos = 128;
	}

	for(y=0; y<2; y++)
	{
		if(pos < 0)
		{
			start_x = -pos;
			OLED_SetPos(0, 6+y);
		}
		else
		{
			OLED_SetPos(pos, 6+y);
		}

		spi_write_byte(0x78);
		spi_write_byte(0x40);

		for (x = start_x; x < length; x++)
		{
			if (pos + x > 127) break;
			j = y*length + x;
			byte = CACTUS_2[j];
			spi_write_byte(byte);
		}
	}
	oled_drawbmp_block_clear(pos + length, 6, speed); // 清除残影
	pos = pos - speed;
}


// 绘制随机出现的仙人掌障碍物
int OLED_DrawCactusRandom(unsigned char ver, unsigned char reset)
{
	char speed = 5;
	static int pos = 128;
	int start_x = 0;
	int length = 0;

	unsigned int i=0, j=0;
	unsigned char x, y;
	unsigned char byte;
	if (reset == 1)
	{
		pos = 128;
		oled_drawbmp_block_clear(0, 6, speed);
		return 128;
	}
	if (ver == 0) length = 8; //sizeof(CACTUS_1) / 2;
	else if (ver == 1) length = 16; //sizeof(CACTUS_2) / 2;
	else if (ver == 2 || ver == 3) length = 24;

	for(y=0; y<2; y++)
	{
		if(pos < 0)
		{
			start_x = -pos;
			OLED_SetPos(0, 6+y);
		}
		else
		{
			OLED_SetPos(pos, 6+y);
		}

		spi_write_byte(0x78);
		spi_write_byte(0x40);

		for (x = start_x; x < length; x++)
		{
			if (pos + x > 127) break;

			j = y*length + x;
			if (ver == 0) byte = CACTUS_1[j];
			else if (ver == 1) byte = CACTUS_2[j];
			else if(ver == 2) byte = CACTUS_3[j];
			else byte = CACTUS_4[j];

			spi_write_byte(byte);
		}
	}

	oled_drawbmp_block_clear(pos + length, 6, speed);

	pos = pos - speed;
	return pos + speed;
}




// 绘制跳跃小恐龙
int OLED_DrawDinoJump(char reset)
{
	char speed_arr[] = {1, 1, 3, 3, 4, 4, 5, 6, 7};
	static char speed_idx = sizeof(speed_arr)-1;
	static int height = 0;
	static char dir = 0;
	//char speed = 4;

	unsigned int j=0;
	unsigned char x, y;
	char offset = 0;
	unsigned char byte;
	if(reset == 1)
	{
		height = 0;
		dir = 0;
		speed_idx = sizeof(speed_arr)-1;
		return 0;
	}
	if (dir==0)
	{
		height += speed_arr[speed_idx];
		speed_idx --;
		if (speed_idx<0) speed_idx = 0;
	}
	if (dir==1)
	{
		height -= speed_arr[speed_idx];
		speed_idx ++;
		if (speed_idx>sizeof(speed_arr)-1) speed_idx = sizeof(speed_arr)-1;
	}
	if(height >= 31)
	{
		dir = 1;
		height = 31;
	}
	if(height <= 0)
	{
		dir = 0;
		height = 0;
	}
	if(height <= 7) offset = 0;
	else if(height <= 15) offset = 1;
	else if(height <= 23) offset = 2;
	else if(height <= 31) offset = 3;
	else offset = 4;

	for(y=0; y<3; y++) // 4
	{
		OLED_SetPos(16, 5- offset + y);

		spi_write_byte(0x78);
		spi_write_byte(0x40);
		for (x = 0; x < 16; x++) // 32
		{
			j = y*16 + x; // 32
			byte = DINO_JUMP[height%8][j];

			spi_write_byte(byte);
		}
	}
	if (dir == 0) oled_drawbmp_block_clear(16, 8- offset, 16);
	if (dir == 1) oled_drawbmp_block_clear(16, 4- offset, 16);
	return height;
}

// 绘制重启
void OLED_DrawRestart()
{
	unsigned int j=0;
	unsigned char x, y;
	unsigned char byte;
	//OLED_SetPos(0, 0);
	for (y = 2; y < 5; y++)
	{
		OLED_SetPos(52, y);
		spi_write_byte(0x78);
		spi_write_byte(0x40);
		for (x = 0; x < 24; x++)
		{
			byte = RESTART[j++];
			spi_write_byte(byte);
		}
	}
	OLED_ShowString(10, 3, "GAME", 16);
	OLED_ShowString(86, 3, "OVER", 16);
}
// 绘制封面
void OLED_DrawCover()
{
	OLED_DrawBMPFast(COVER);
}



//初始化SSD1306
void OLED_Init(void)
{
	spi_init();
	OLED_DC_Set();
	
	OLED_RES_Clr();
	Delay_1ms(200);
	OLED_RES_Set();
	
	OLED_WR_Byte(0xAE,OLED_CMD);//--turn off oled panel
	OLED_WR_Byte(0x00,OLED_CMD);//---set low column address
	OLED_WR_Byte(0x10,OLED_CMD);//---set high column address
	OLED_WR_Byte(0x40,OLED_CMD);//--set start line address  Set Mapping RAM Display Start Line (0x00~0x3F)
	OLED_WR_Byte(0x81,OLED_CMD);//--set contrast control register
	OLED_WR_Byte(0xCF,OLED_CMD);// Set SEG Output Current Brightness
	OLED_WR_Byte(0xA1,OLED_CMD);//--Set SEG/Column Mapping     0xa0左右反置 0xa1正常
	OLED_WR_Byte(0xC8,OLED_CMD);//Set COM/Row Scan Direction   0xc0上下反置 0xc8正常
	OLED_WR_Byte(0xA6,OLED_CMD);//--set normal display
	OLED_WR_Byte(0xA8,OLED_CMD);//--set multiplex ratio(1 to 64)
	OLED_WR_Byte(0x3f,OLED_CMD);//--1/64 duty
	OLED_WR_Byte(0xD3,OLED_CMD);//-set display offset	Shift Mapping RAM Counter (0x00~0x3F)
	OLED_WR_Byte(0x00,OLED_CMD);//-not offset
	OLED_WR_Byte(0xd5,OLED_CMD);//--set display clock divide ratio/oscillator frequency
	OLED_WR_Byte(0x80,OLED_CMD);//--set divide ratio, Set Clock as 100 Frames/Sec
	OLED_WR_Byte(0xD9,OLED_CMD);//--set pre-charge period
	OLED_WR_Byte(0xF1,OLED_CMD);//Set Pre-Charge as 15 Clocks & Discharge as 1 Clock
	OLED_WR_Byte(0xDA,OLED_CMD);//--set com pins hardware configuration
	OLED_WR_Byte(0x12,OLED_CMD);
	OLED_WR_Byte(0xDB,OLED_CMD);//--set vcomh
	OLED_WR_Byte(0x40,OLED_CMD);//Set VCOM Deselect Level
	OLED_WR_Byte(0x20,OLED_CMD);//-Set Page Addressing Mode (0x00/0x01/0x02)
	OLED_WR_Byte(0x02,OLED_CMD);//
	OLED_WR_Byte(0x8D,OLED_CMD);//--set Charge Pump enable/disable
	OLED_WR_Byte(0x14,OLED_CMD);//--set(0x10) disable
	OLED_WR_Byte(0xA4,OLED_CMD);// Disable Entire Display On (0xa4/0xa5)
	OLED_WR_Byte(0xA6,OLED_CMD);// Disable Inverse Display On (0xa6/a7) 
	OLED_Clear();
	OLED_WR_Byte(0xAF,OLED_CMD);
}





























