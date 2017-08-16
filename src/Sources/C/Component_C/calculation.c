
#include "includes.h"

/************************************************************************
*                             蓝宙电子工作室
*
*  函数名称：CCD_init
*  功能说明：CCD初始化
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/
void CCD_init(void)
{
  gpio_init (PORTE , 0, 1,1);
  gpio_init (PORTE , 1, 1,1);
  hw_adc_init(1) ;
  
}

/*************************************************************************
*                           蓝宙电子工作室
*
*  函数名称：StartIntegration
*  功能说明：CCD启动程序
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/
void StartIntegration(void) 
{

    unsigned char i;

    SI_SetVal();            /* SI  = 1 */
    SamplingDelay();
    CLK_SetVal();           /* CLK = 1 */
    SamplingDelay();
    SI_ClrVal();            /* SI  = 0 */
    SamplingDelay();
    CLK_ClrVal();           /* CLK = 0 */

    for(i=0; i<127; i++) 
    {
        SamplingDelay();
        SamplingDelay();
        CLK_SetVal();       /* CLK = 1 */
        SamplingDelay();
        SamplingDelay();
        CLK_ClrVal();       /* CLK = 0 */
    }
    SamplingDelay();
    SamplingDelay();
    CLK_SetVal();           /* CLK = 1 */
    SamplingDelay();
    SamplingDelay();
    CLK_ClrVal();           /* CLK = 0 */
}



void ImageCapture(unsigned char * ImageData)        //*ImageData =  ad_once(ADC1, AD6a, ADC_8bit);
{

    unsigned char i;
    extern uint8 AtemP ;

    SI_SetVal();            /* SI  = 1 */
    SamplingDelay();
    CLK_SetVal();           /* CLK = 1 */
    SamplingDelay();
    SI_ClrVal();            /* SI  = 0 */
    SamplingDelay();

   
//Delay 10us for sample the first pixel
    for(i = 0; i < 50; i++) 
    {
      SamplingDelay() ;  //200ns
    }


//Sampling Pixel 1
    *ImageData =  hw_ad_once(1, 6, 8);
    ImageData ++ ;
    CLK_ClrVal();           /* CLK = 0 */

    for(i=0; i<127; i++) 
    {
        SamplingDelay();
        SamplingDelay();
        CLK_SetVal();       /* CLK = 1 */
        SamplingDelay();
        SamplingDelay();
        //Sampling Pixel 2~128

       *ImageData =  hw_ad_once(1, 6, 8);
        ImageData ++ ;
        CLK_ClrVal();       /* CLK = 0 */
    }
    SamplingDelay();
    SamplingDelay();
    CLK_SetVal();           /* CLK = 1 */
    SamplingDelay();
    SamplingDelay();
    CLK_ClrVal();           /* CLK = 0 */
}

/*************************************************************************
*                           蓝宙电子工作室
*
*  函数名称：CalculateIntegrationTime
*  功能说明：计算曝光时间
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/
extern uint8 Pixel[128];

uint8 PixelAverageValue;/* 128个像素点的平均AD值 */

uint8 PixelAverageVoltage;/* 128个像素点的平均电压值的10倍 */


int16 TargetPixelAverageVoltage = 30;/* 设定目标平均电压值，实际电压的10倍 */

int16 PixelAverageVoltageError = 0;/* 设定目标平均电压值与实际值的偏差，实际电压的10倍 */

int16 TargetPixelAverageVoltageAllowError = 2;/* 设定目标平均电压值允许的偏差，实际电压的10倍 */

uint8 IntegrationTime = 10;/* 曝光时间，单位ms */


void CalculateIntegrationTime(void) 
{

    PixelAverageValue = PixelAverage(128,Pixel);/* 计算128个像素点的平均AD值 */
    
   
    PixelAverageVoltage = (unsigned char)((int)PixelAverageValue * 25 / 128); /* 计算128个像素点的平均电压值,实际值的10倍 */

    PixelAverageVoltageError = TargetPixelAverageVoltage - PixelAverageVoltage;
    if(PixelAverageVoltageError < -TargetPixelAverageVoltageAllowError)
        IntegrationTime--;//曝光时间看什么
    if(PixelAverageVoltageError > TargetPixelAverageVoltageAllowError)
        IntegrationTime++;
    if(IntegrationTime <= 1)
        IntegrationTime = 1;
    if(IntegrationTime >= 20)
        IntegrationTime = 20;
}

/*************************************************************************
*                           蓝宙电子工作室
*
*  函数名称：PixelAverage
*  功能说明：求数组的均值程序
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/

uint8 PixelAverage(uint8 len, uint8 *data) 
{
  unsigned char i;
  unsigned int sum = 0;
  for(i = 0; i<len; i++) 
  {
    sum = sum + *data++;
  }
  return ((unsigned char)(sum/len));
}
/*************************************************************************
*                           蓝宙电子工作室
*
*  函数名称：SendHex
*  功能说明：采集发送程序
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/
void SendHex(unsigned char hex) 
{
  unsigned char temp;
  temp = hex >> 4;
  if(temp < 10) 
  {
   uart_send1(UART0,temp + '0');
  } 
  else 
  {
   uart_send1(UART0,temp - 10 + 'A');
  }
  temp = hex & 0x0F;
  if(temp < 10) 
  {
   uart_send1(UART0,temp + '0');
  } 
  else 
  {
  uart_send1(UART0,temp - 10 + 'A');
  }
}
/*************************************************************************
*                           蓝宙电子工作室
*
*  函数名称：SendImageData
*  功能说明：
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/
void SendImageData(unsigned char * ImageData) 
{

    unsigned char i;
    unsigned char crc = 0;

    /* Send Data */
    
    uart_send1(UART0,'*');
    uart_send1(UART0,'L');
    uart_send1(UART0,'D');

    SendHex(0);
    SendHex(0);
    SendHex(0);
    SendHex(0);
    
    for(i=0; i<128; i++) 
    {
      SendHex(*ImageData++);
    }

    SendHex(crc);
    uart_send1(UART0,'#');
}
/*************************************************************************
*                           蓝宙电子工作室
*
*  函数名称：SamplingDelay
*  功能说明：CCD延时程序 200ns
*  参数说明：
*  函数返回：无
*  修改时间：2012-10-20
*  备    注：
*************************************************************************/
 void SamplingDelay(void)
{
   volatile uint8 i ;
   for(i=0;i<1;i++) 
   {
    asm("nop");
    asm("nop");
   }
   
}
