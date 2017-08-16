#include "includes.h"
/*
ANGLE_CONTROL_P   ANGLE_CONTROL_D   SPEED_CONTROL_P   SPEED_CONTROL_I   CAR_SPEED_SET   DIR_CONTROL_P   DIR_CONTROL_D
0.19              0.006             0.03              0.00003           10              0.012           0.001
0.163             0.006             0.044             0.00003           20              0.017           0.007
0.169             0.0065            0.049             0.00004           25              0.028           0.0018
*/
//----------
#define GRAVITY_OFFSET                      gravity
#define GYROSCOPE_OFFSET                    gyro   
#define GYROSCOPE_OFFSET_DIRECTION          gyro_direction
#define GRAVITY_ANGLE_RATIO                 0.1227
#define GYROSCOPE_ANGLE_RATIO               0.3
#define GRAVITY_ADJUST_TIME_CONSTANT        0.35                                                        
#define GYROSCOPE_ANGLE_SIGMA_FREQUENCY     200
#define CAR_ANGLE_SET                       0
#define CAR_ANGLE_SPEED_SET                 0 
#define ANGLE_CONTROL_P                     0.163//0.171//0.167最好//0.30是上限
#define ANGLE_CONTROL_D                     0.006//0.007是上限
#define ANGLE_CONTROL_OUT_MAX	            MOTOR_OUT_MAX *10
#define ANGLE_CONTROL_OUT_MIN		    MOTOR_OUT_MIN *10

//------------
#define SPEED_CONTROL_PERIOD                100
#define CAR_SPEED_CONSTANT                  0.02
#define SPEED_CONTROL_P                     0.044//0.053//0.049对应0.167//0.044
#define SPEED_CONTROL_I                     0.00003//0.00003//0.1漂移很明显
#define SPEED_CONTROL_OUT_MAX		    MOTOR_OUT_MAX *10
#define SPEED_CONTROL_OUT_MIN		    MOTOR_OUT_MIN *10
#define CAR_SPEED_SET                       20
#define CAR_SPEED_STEP                      5//每100毫秒增加的速度

//-----------
#define SI_SetVal()                         gpio_init (PORTE , 0, 1, 1)
#define SI_ClrVal()                         gpio_init (PORTE , 0, 1, 0)
#define CLK_SetVal()                        gpio_init (PORTE , 1, 1, 1)
#define CLK_ClrVal()                        gpio_init (PORTE , 1, 1, 0)
#define SI_SetVal_1()                       gpio_init (PORTC , 11, 1, 1)
#define SI_ClrVal_1()                       gpio_init (PORTC , 11, 1, 0)
#define CLK_SetVal_1()                      gpio_init (PORTC , 10, 1, 1)
#define CLK_ClrVal_1()                      gpio_init (PORTC , 10, 1, 0)
#define DIR_DEFAULT_MIN                     50
#define DIRECTION_CONTROL_PERIOD            10
#define DIR_CONTROL_P                       0.017//0.019
#define DIR_CONTROL_D                       0.0007//0.00095//0.0008//0.0007
#define DIR_DEV                             dev
#define GATE                                30
#define DIRECTION_CONTROL_DEADVALUE         0
#define DIRECTION_CONTROL_OUT_MAX	    MOTOR_OUT_MAX
#define DIRECTION_CONTROL_OUT_MIN	    MOTOR_OUT_MIN

//------------
#define MOTOR_OUT_DEAD_VAL                  0
#define MOTOR_LEFT_SPEED_POSITIVE	    (g_fLeftMotorOut > 0)
#define MOTOR_RIGHT_SPEED_POSITIVE	    (g_fRightMotorOut > 0)
#define MOTOR_OUT_MAX                       1.0
#define MOTOR_OUT_MIN                      -1.0
//------------------------------------------------------------------------------
int16   g_nInputVoltage[5]={0};
int32	g_lnInputVoltageSigma[5]={0};    	   
#define VOLTAGE_GRAVITY                     g_nInputVoltage[0]
#define VOLTAGE_GYRO                        g_nInputVoltage[1]
#define VOLTAGE_LEFT                        g_nInputVoltage[2]
#define VOLTAGE_RIGHT                       g_nInputVoltage[3]		
#define DIR_CONTROL_D_VALUE                 g_nInputVoltage[4]
#define key_1                               (((GPIO_PDIR_REG(PTA_BASE_PTR))>>(19))&1)
//------------------------------------------------------------------------------

//-----------
int16 left_l=0;
int16 right_l=0;
int16 dev=0;
int16 gravity,gyro,gyro_direction;
float g_fGravityAngle=0;
float g_fGyroscopeAngleSpeed =0;
float g_fCarAngle=0;
float g_fGyroscopeAngleIntergral =0;
float g_fAngleControlOut=0;

//-----------
float g_fCarSpeed=0;
float g_fCarSpeedstart=0;
int16 g_nLeftMotorPulse=0;
int16 g_nRightMotorPulse=0;
float g_fSpeedControlIntegral=0;
float g_fSpeedControlOutOld =0;
float g_fSpeedControlOutNew =0;
float g_fSpeedControlOut =0;
uint8 g_nSpeedControlPeriod =0;

//-----------
float g_fDirectionControlOutOld=0;
float g_fDirectionControlOutNew =0;
float g_fDirectionControlOut=0;
int16 g_nDirectionControlPeriod=0;
int16 left=0;
int16 right=0;
int16 left_c,right_c;
int16 left_OFFSET,right_OFFSET;
//------------
float g_fLeftMotorOut=0;
float g_fRightMotorOut=0;
int16 g_nLeftMotorPulseSigma =0;
int16 g_nRightMotorPulseSigma=0;
extern int16 OutData[4] = { 0 };//虚拟示波器输出
extern uint8 a,b;
extern int16 speedflag;
//----------------------------------------------------------------------------------------------------
void get_ad()
{
   VOLTAGE_GRAVITY = hw_ad_ave(0,8,12,20);                 //均值滤波得加速度电压信号(PTB0)
   VOLTAGE_GYRO = hw_ad_ave(0,9,12,20);                    //--------得平衡陀螺仪电压信号(PTB1)
   DIR_CONTROL_D_VALUE = hw_ad_ave(0,12,12,20);            //---------得转向陀螺仪电压信号(PTB2)
}

void GetSamplezhi()
{
    g_lnInputVoltageSigma[0]+= hw_ad_ave(0,8,12,20);   
    g_lnInputVoltageSigma[1]+= hw_ad_ave(0,9,12,20);
    g_lnInputVoltageSigma[2]+= hw_ad_ave(0,12,12,20);
}
void GetOFFSET()
{
    gravity=g_lnInputVoltageSigma[0]/1000;
    gyro =g_lnInputVoltageSigma[1]/1000;
    gyro_direction= g_lnInputVoltageSigma[2]/1000;  
}

void GetInputVoltageAverage(int j)
{
	int i;
        for(i = 0; i < 5; i ++) 
	{
		g_nInputVoltage[i] = (int)(g_lnInputVoltageSigma[i] /j);
		g_lnInputVoltageSigma[i] = 0;
	}
}

void AngleCalculate(void)
{
      float Value;
      g_fGravityAngle=(VOLTAGE_GRAVITY-GRAVITY_OFFSET) * GRAVITY_ANGLE_RATIO ;           
      g_fGyroscopeAngleSpeed=(VOLTAGE_GYRO-GYROSCOPE_OFFSET) * GYROSCOPE_ANGLE_RATIO;
      
      g_fCarAngle=g_fGyroscopeAngleIntergral;      
   
      Value=(g_fGravityAngle-g_fCarAngle)/GRAVITY_ADJUST_TIME_CONSTANT;
      
      g_fGyroscopeAngleIntergral+=(g_fGyroscopeAngleSpeed+Value)/GYROSCOPE_ANGLE_SIGMA_FREQUENCY;   
}

void AngleControl(void) 
{
        float fValue;

	fValue = (CAR_ANGLE_SET - g_fCarAngle) * ANGLE_CONTROL_P +(CAR_ANGLE_SPEED_SET - g_fGyroscopeAngleSpeed) * ANGLE_CONTROL_D;
        /*
        if(fValue > ANGLE_CONTROL_OUT_MAX)			
          fValue = ANGLE_CONTROL_OUT_MAX;
        else if(fValue < ANGLE_CONTROL_OUT_MIN)
          fValue = ANGLE_CONTROL_OUT_MIN;
        */
	g_fAngleControlOut = fValue;
}
//-----------------------速度控制-------------------------------------------------------
void GetMotorPulse()
{
  uint32  nLeftPulse,nRightPulse; 
  nLeftPulse=FTM1_CNT;
  nRightPulse=FTM2_CNT;
  g_nLeftMotorPulse = -(int32)nLeftPulse;       //注意编码器的安装
  g_nRightMotorPulse = (int32)nRightPulse;
  if(!MOTOR_LEFT_SPEED_POSITIVE)		g_nLeftMotorPulse = -g_nLeftMotorPulse;
  g_nLeftMotorPulseSigma +=g_nLeftMotorPulse;
  if(!MOTOR_RIGHT_SPEED_POSITIVE)		g_nRightMotorPulse = -g_nRightMotorPulse;
  g_nRightMotorPulseSigma +=g_nRightMotorPulse;	
  FTM1_CNT=0; 
  FTM2_CNT=0; 
}
//-------------目前速度控制不明显，尚无处理方案--------------
void SpeedControl(void)
{
	float fP,fI, fDelta;
        
	g_fCarSpeed = (g_nLeftMotorPulseSigma + g_nRightMotorPulseSigma)/2;//合理吗？有没有更准确的方法？
	g_nLeftMotorPulseSigma = g_nRightMotorPulseSigma = 0;
	g_fCarSpeed *= CAR_SPEED_CONSTANT;

        if(g_fCarSpeedstart<CAR_SPEED_SET)
        {
	   g_fCarSpeedstart+=CAR_SPEED_STEP;
        } 
        if(g_fCarSpeedstart>CAR_SPEED_SET)
        {
	   g_fCarSpeedstart-=CAR_SPEED_STEP;           
        } 
        
        if(speedflag<30) //speedflag的递加应该设在中断中
        {
          fDelta = g_fCarSpeedstart - g_fCarSpeed;
        }
        else	
        {
          fDelta = CAR_SPEED_SET - g_fCarSpeed;
        }
        
        fDelta = g_fCarSpeedstart - g_fCarSpeed;
	fP = fDelta * SPEED_CONTROL_P;
	fI = fDelta * SPEED_CONTROL_I;
	g_fSpeedControlIntegral += fI;		
	if(g_fSpeedControlIntegral > SPEED_CONTROL_OUT_MAX)	
		g_fSpeedControlIntegral = SPEED_CONTROL_OUT_MAX;
	if(g_fSpeedControlIntegral < SPEED_CONTROL_OUT_MIN)  	
		g_fSpeedControlIntegral = SPEED_CONTROL_OUT_MIN;
	
	g_fSpeedControlOutOld = g_fSpeedControlOutNew;

	g_fSpeedControlOutNew = fP + g_fSpeedControlIntegral;
}

void SpeedControlOutput(void) 
{
	float fValue3;
	fValue3 = g_fSpeedControlOutNew - g_fSpeedControlOutOld;
	g_fSpeedControlOut = fValue3 * (g_nSpeedControlPeriod + 1) / SPEED_CONTROL_PERIOD + g_fSpeedControlOutOld;	
}


//-------------------------------------方向控制-------------------------------
void CCD_init(void)
{
  gpio_init (PORTE , 0, 1, 1);
  gpio_init (PORTE , 1, 1, 1);
  gpio_init (PORTC , 10, 1, 1);
  gpio_init (PORTC , 11, 1, 1);
  hw_adc_init(1);
}

void button_init()
{
   SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;    //打开PORTD端口的时钟
   PORTA_PCR19=(0|PORT_PCR_MUX(1));
   gpio_init (PORTA,19, 0,0);
}

void ADC0_stop(void)
{
    hw_adc_convertstop(0,8);
    hw_adc_convertstop(0,9);
    hw_adc_convertstop(0,12);
}

void ADC0_start(void)
{
    hw_adc_convertstart(0,8,12);
    hw_adc_convertstart(0,9,12);
    hw_adc_convertstart(0,12,12);
}


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

void StartIntegrationRight(void) 
{
    unsigned char i;

    //SI_SetVal();            /* SI  = 1 */
    SI_SetVal_1();      
    SamplingDelay();
    //CLK_SetVal();           /* CLK = 1 */
    CLK_SetVal_1();  
    SamplingDelay();
    //SI_ClrVal();            /* SI  = 0 */
    SI_ClrVal_1(); 
    SamplingDelay();
    //CLK_ClrVal();           /* CLK = 0 */
    CLK_ClrVal_1(); 

    for(i=0; i<127; i++) 
    {
        SamplingDelay();
        SamplingDelay();
        //CLK_SetVal();       /* CLK = 1 */
        CLK_SetVal_1();  
        SamplingDelay();
        SamplingDelay();
        //CLK_ClrVal();       /* CLK = 0 */
        CLK_ClrVal_1();  
    }
    SamplingDelay();
    SamplingDelay();
    //CLK_SetVal();           /* CLK = 1 */
    CLK_SetVal_1();  
    SamplingDelay();
    SamplingDelay();
    //CLK_ClrVal();           /* CLK = 0 */
    CLK_ClrVal_1();   
}



void ImageCapture(uint8 * ImageData)       
{
    unsigned char i;
    extern uint8 AtemP;

    SI_SetVal();            /* SI  = 1 */
    SamplingDelay();
    CLK_SetVal();           /* CLK = 1 */  
    SamplingDelay();
    SI_ClrVal();            /* SI  = 0 */
    SamplingDelay();
   
//Delay 10us for sample the first pixel
    for(i = 0; i < 50; i++) 
    {
      SamplingDelay();  //200ns
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
        *ImageData = hw_ad_once(1, 6, 8);
        ImageData ++;
        CLK_ClrVal();       /* CLK = 0 */
    }
    SamplingDelay();
    SamplingDelay();
    CLK_SetVal();           /* CLK = 1 */
    SamplingDelay();
    SamplingDelay();
    CLK_ClrVal();           /* CLK = 0 */
}

void ImageCapture_1(uint8 * ImageData_1)         
{
    unsigned char i;
    extern uint8 AtemP;

    //SI_SetVal();            /* SI  = 1 */
    SI_SetVal_1();
    SamplingDelay();
    //CLK_SetVal();           /* CLK = 1 */
    CLK_SetVal_1();    
    SamplingDelay();
    //SI_ClrVal();            /* SI  = 0 */
    SI_ClrVal_1(); 
    SamplingDelay();

   
//Delay 10us for sample the first pixel
    for(i = 0; i < 50; i++) 
    {
      SamplingDelay();  //200ns
    }


//Sampling Pixel 1
    //*ImageData =  hw_ad_once(1, 6, 8);
    //ImageData ++ ;
    *ImageData_1= hw_ad_once(1, 7, 8);              
    ImageData_1 ++;
    //CLK_ClrVal();           /* CLK = 0 */
    CLK_ClrVal_1(); 

    for(i=0; i<127; i++) 
    {
        SamplingDelay();
        SamplingDelay();
        //CLK_SetVal();       /* CLK = 1 */
        CLK_SetVal_1(); 
        SamplingDelay();
        SamplingDelay();
        //Sampling Pixel 2~128

        //*ImageData = hw_ad_once(1, 6, 8);
        //ImageData ++;
        *ImageData_1= hw_ad_once(1, 7, 8);  
        ImageData_1++;

        //CLK_ClrVal();       /* CLK = 0 */
        CLK_ClrVal_1(); 
    }
    SamplingDelay();
    SamplingDelay();
    //CLK_SetVal();           /* CLK = 1 */
    CLK_SetVal_1();    
    SamplingDelay();
    SamplingDelay();
    //CLK_ClrVal();           /* CLK = 0 */
    CLK_ClrVal_1(); 
}

extern uint8 Pixel[128];
extern uint8 Pixel_1[128];
uint8  PixelAverageValue=0;                                       /* 128个像素点的平均AD值 */
uint8  PixelAverageVoltage=0;                                     /* 128个像素点的平均电压值的10倍 */
uint8  PixelAverageValue_Right=0;
uint8  PixelAverageVoltage_Right=0;
int16  TargetPixelAverageVoltage = 30;                          /* 设定目标平均电压值，实际电压的10倍 */
int16  PixelAverageVoltageError = 0;                            /* 设定目标平均电压值与实际值的偏差，实际电压的10倍 */
int16  TargetPixelAverageVoltageAllowError = 2;                 /* 设定目标平均电压值允许的偏差，实际电压的10倍 */
uint8  IntegrationTime = 10;                                    /* 曝光时间，单位ms */
uint8  IntegrationTime_Right = 10;                              // 曝光时间，单位ms

void CalculateIntegrationTime(void) 
{
    PixelAverageValue = PixelAverage(128,Pixel);/* 计算128个像素点的平均AD值 */
    
    PixelAverageVoltage = (uint8)((int)PixelAverageValue * 25 / 128);/* 计算128个像素点的平均电压值,实际值的10倍 */

    PixelAverageVoltageError = TargetPixelAverageVoltage - PixelAverageVoltage;
    if(PixelAverageVoltageError < -TargetPixelAverageVoltageAllowError)
      IntegrationTime--;                                 
    if(PixelAverageVoltageError > TargetPixelAverageVoltageAllowError)
      IntegrationTime++;
    if(IntegrationTime <= 1)
      IntegrationTime = 1;
    if(IntegrationTime >= 20)
      IntegrationTime = 20;
}

void CalculateIntegrationTimeRight(void) 
{
    PixelAverageValue_Right = PixelAverage(128,Pixel_1);/* 计算128个像素点的平均AD值 */
    
    PixelAverageVoltage_Right = (uint8)((int)PixelAverageValue_Right * 25 / 128);/* 计算128个像素点的平均电压值,实际值的10倍 */

    PixelAverageVoltageError = TargetPixelAverageVoltage - PixelAverageVoltage_Right;
    if(PixelAverageVoltageError < -TargetPixelAverageVoltageAllowError)
      IntegrationTime_Right--;                                 
    if(PixelAverageVoltageError > TargetPixelAverageVoltageAllowError)
      IntegrationTime_Right++;
    if(IntegrationTime_Right <= 1)
      IntegrationTime_Right = 1;
    if(IntegrationTime_Right >= 20)
      IntegrationTime_Right = 20;
}


uint8 PixelAverage(uint8 len, uint8 *data) 
{
  uint8 i;
  uint16 sum = 0;
  for(i = 0; i<len; i++) 
  {
     sum = sum + *data++;
  }
  return ((uint8)(sum/len));
}

void get_left()
{
    int16 i;
    left=255;
    for(i=127;i>2;i--)
    {
       if((Pixel[i]-Pixel[i-3])>GATE)
       { 
         left=i-3;
         break;
       }
    }
    left_c=left_OFFSET-left;   
}

void get_right()
{
   int16 i;
   right=255;   
   for(i=0;i<125;i++) 
   { 
      if((Pixel_1[i]-Pixel_1[i+3])>GATE)
      {
        right=i+3;
        break;
      }
   }
   right_c=right_OFFSET-right;
}

void getCCD()
{
    ImageCapture(Pixel);    
    CalculateIntegrationTime();
    ImageCapture_1(Pixel_1);
    CalculateIntegrationTimeRight();

    get_left();
    get_right();
    left_l+=left;
    right_l+=right;
}

void BlackManange() 
{  
  //两边都没丢失
  if((left!=255)&&(right!=255)) DIR_DEV =(left_c+right_c)/2; 
  //右边沿丢失    /*右边可能丢掉右边的线，但检测到左边的线，则右边所得数值极偏小*/
  if((left!=255)&&(right==255)) DIR_DEV =left_c; 
  //左边沿丢失    /*左边可能丢掉左边的线，但检测到右边的线，则左边所得数值极偏大*/
  if((left==255)&&(right!=255)) DIR_DEV =right_c;
  //左右都丢失
  if((left==255)&&(right==255)) DIR_DEV=DIR_DEV*2/3;
}

void LCD_show()
{
    LCD_P8x16_number(10,0,left_OFFSET);
    LCD_P8x16_number(70,0,right_OFFSET);
    LCD_P8x16_number(10,2,left);
    LCD_P8x16_number(70,2,right);
    delay_ms(50);       
    //LCD_CLS();   
}

//----------------------------给CCDView发送图像----------------------------------------------------------------//
void SendImageData(uint8 * ImageData)
{
    unsigned char i;
    unsigned char crc = 0;
    /* Send Data */    
    uart_send1(UART3,'*');
    uart_send1(UART3,'L');
    uart_send1(UART3,'D');
    
    SendHex(0);
    SendHex(0);
    SendHex(0);
    SendHex(0);    
    
    for(i=0; i<128; i++) 
    {
        SendHex(*ImageData ++);
    }

    SendHex(crc);
    uart_send1(UART3,'#');
}

void SendHex(unsigned char hex) 
{
  unsigned char temp;
  temp = hex >> 4;
  if(temp < 10) 
  {
   uart_send1(UART3,temp + '0');
  } 
  else 
  {
   uart_send1(UART3,temp - 10 + 'A');
  }
  temp = hex & 0x0F;
  if(temp < 10) 
  {
   uart_send1(UART3,temp + '0');
  } 
  else 
  {
  uart_send1(UART3,temp - 10 + 'A');
  }
}

void SamplingDelay(void)//CCD延时程序 200ns
{
   volatile uint8 i ;
   for(i=0;i<1;i++) 
   {
    asm("nop");
    asm("nop");
   }
}
//----------------------------------------------------------------------------------------------------------//
void DirectionControl(void)
 {
	float  fValue, fDValue;
	
	g_fDirectionControlOutOld = g_fDirectionControlOutNew;
        
	fValue=DIR_DEV;
        
        fValue = fValue * DIR_CONTROL_P;
	fDValue = (DIR_CONTROL_D_VALUE - GYROSCOPE_OFFSET_DIRECTION) * DIR_CONTROL_D;
        
	fValue+=fDValue;
	/*  
	if(fValue > 0) fValue += DIRECTION_CONTROL_DEADVALUE;
        if(fValue < 0) fValue -= DIRECTION_CONTROL_DEADVALUE;
	*/	
	if(fValue > DIRECTION_CONTROL_OUT_MAX) fValue = DIRECTION_CONTROL_OUT_MAX;
	if(fValue < DIRECTION_CONTROL_OUT_MIN) fValue = DIRECTION_CONTROL_OUT_MIN;
	g_fDirectionControlOutNew = fValue;
}
    
void DirectionControlOutput(void) 
{
	float fValue;
	fValue = g_fDirectionControlOutNew - g_fDirectionControlOutOld;
	g_fDirectionControlOut = fValue * (g_nDirectionControlPeriod + 1) / DIRECTION_CONTROL_PERIOD + g_fDirectionControlOutOld;
}



//----------------------电机控制--------------------------------------------------
void MotorOutput(void)
{
	float fLeft, fRight;

	fLeft  = g_fAngleControlOut - g_fSpeedControlOut - g_fDirectionControlOut;
	fRight = g_fAngleControlOut - g_fSpeedControlOut + g_fDirectionControlOut;
	
	if(fLeft > MOTOR_OUT_MAX)		fLeft = MOTOR_OUT_MAX;
	if(fLeft < MOTOR_OUT_MIN)		fLeft = MOTOR_OUT_MIN;
	if(fRight > MOTOR_OUT_MAX)		fRight = MOTOR_OUT_MAX;
	if(fRight < MOTOR_OUT_MIN)		fRight = MOTOR_OUT_MIN;
		
	g_fLeftMotorOut = fLeft;
	g_fRightMotorOut = fRight;
	MotorSpeedOut();
}

void MotorSpeedOut(void)
{
	float fLeftVal, fRightVal;
	
	fLeftVal = g_fLeftMotorOut;
	fRightVal = g_fRightMotorOut;
        /*
	if(fLeftVal > 0) 			fLeftVal += MOTOR_OUT_DEAD_VAL;
	else if(fLeftVal < 0) 		fLeftVal -= MOTOR_OUT_DEAD_VAL;
	
	if(fRightVal > 0)			fRightVal += MOTOR_OUT_DEAD_VAL;
	else if(fRightVal < 0)		fRightVal -= MOTOR_OUT_DEAD_VAL;
	*/	
	if(fLeftVal > MOTOR_OUT_MAX)	fLeftVal = MOTOR_OUT_MAX;
	if(fLeftVal < MOTOR_OUT_MIN)	fLeftVal = MOTOR_OUT_MIN;
	if(fRightVal > MOTOR_OUT_MAX)	fRightVal = MOTOR_OUT_MAX;
	if(fRightVal < MOTOR_OUT_MIN)	fRightVal = MOTOR_OUT_MIN;
			
	SetMotorVoltage(fLeftVal, fRightVal);
}

void SetMotorVoltage(float fLeftVoltage, float fRightVoltage) 
{
                                                // Voltage : > 0 : Move forward
                                                // Voltage : < 0 : Move backward
	int16 nPeriod;
	int16 nOut;
	
	nPeriod =1250;
        //--------------------------------------------------------------------------
	if(fLeftVoltage > 1.0) 			fLeftVoltage = 1.0;
	else if(fLeftVoltage < -1.0) 	fLeftVoltage = -1.0;
	
	if(fRightVoltage > 1.0) 		fRightVoltage = 1.0;
	else if(fRightVoltage < -1.0)	fRightVoltage = -1.0;
        //--------------------------------------------------------------------------
	if(fRightVoltage > 0)                                          //右轮 前
        {
          gpio_init(PORTB,10, 1,1);//DIR_B;
          nOut = (int16)(fRightVoltage * nPeriod);
          FTM0_C1V=nPeriod-nOut;
	}
	else                                                          //右轮 后
	{
          gpio_init(PORTB,10, 1,0);// DIR_F ;
	  fRightVoltage = -fRightVoltage;
          nOut = (int16)(fRightVoltage * nPeriod);
          FTM0_C1V=nOut;
  	}
        //--------------------------------------------------------------------------	                                            	                                              
	if(fLeftVoltage > 0)                                           //左轮 前
	{
          gpio_init(PORTB, 9, 1,1);//DIL_B ;
          nOut = (int16)(fLeftVoltage * nPeriod);
          FTM0_C0V=nPeriod-nOut;
	} 
	else                                                           //左轮 后
	{ 
	  gpio_init(PORTB, 9, 1,0);// DIL_F ;
	  fLeftVoltage = -fLeftVoltage;
	  nOut = (int16)(fLeftVoltage * nPeriod);
          FTM0_C0V=nOut;
  	}                                
} 




/****************************虚拟示波器模块******************************/
void virtual_scope_show(void)
{
      OutData[0]=0;
      OutData[1]=0;
      OutData[2]=0;
      OutData[3]=0;
}

void serial_Txd()//传输的一帧数据，包括如下的内容
{
        uint8 temp[10]={0};
        uint8 i,j;
        //帧头数据
        uart_send1 (UART3, 0xa5);
        uart_send1 (UART3, 0x5a);
	
       //第一条曲线的数据
        for(i=0;i<3;i++)
        {
           temp[i*2]=(int)OutData[i]/10;
           temp[i*2+1]=(int)OutData[i]%10;
        }
       for(j=0;j<6;j++)
       {
          uart_send1 (UART3, temp[j]);
       }
        delay_ms(10);
}


unsigned short CRC_CHECK(unsigned char *Buf, unsigned char CRC_CNT)
{
    unsigned short CRC_Temp;
    unsigned char i,j;
    CRC_Temp = 0xffff;

    for (i=0;i<CRC_CNT; i++)
    {      
        CRC_Temp ^= Buf[i];
        for (j=0;j<8;j++)
        {
            if (CRC_Temp & 0x01)
                CRC_Temp = (CRC_Temp >>1 ) ^ 0xa001;
            else
                CRC_Temp = CRC_Temp >> 1;
        }
    }
    return(CRC_Temp);
}

void OutPut_Data(void)
{
  int temp[4] = {0};
  unsigned int temp1[4] = {0};
  unsigned char databuf[10] = {0};
  unsigned char i;
  unsigned short CRC16 = 0;
  for(i=0;i<4;i++)
  {    
    temp[i]  = (int16)OutData[i];
    temp1[i] = (uint16)temp[i];
  }
   
  for(i=0;i<4;i++) 
  {
    databuf[i*2]   = (int8)(temp1[i]%256);
    databuf[i*2+1] = (int8)(temp1[i]/256);
  }
  
  CRC16 = CRC_CHECK(databuf,8);
  databuf[8] = CRC16%256;
  databuf[9] = CRC16/256;
  
  for(i=0;i<10;i++)
  uart_send1 (UART3,databuf[i]);
}

void KeyScan(void) 
{
  if(key_1==0) 
  {
      delay_ms(10);
      if(key_1==0) 
      {
        a=255;  
        LCD_P8x16_number(10,4,a);    
        while(!key_1);
      }
  }     
}
void KeyScan_1(void) 
{
  if(key_1==0) 
  {
      delay_ms(10);
      if(key_1==0) 
      {
        b=200;  
        LCD_P8x16_number(10,4,b);    
        while(!key_1);
      }
  }     
}
void Clear()
{
    g_lnInputVoltageSigma[0]=0;   
    g_lnInputVoltageSigma[1]=0;
    g_lnInputVoltageSigma[2]=0;
}

