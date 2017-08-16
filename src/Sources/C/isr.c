//-------------------------------------------------------------------------*
// 文件名: isr.c                                                           *
// 说  明: 中断处理例程                                                    *
//---------------苏州大学飞思卡尔嵌入式系统实验室2011年--------------------*

#include "includes.h"
uint8        g_n1MSEventCount =0;
static uint8 TimerCnt20ms = 0;
uint8        g_nSpeedControlCount =0;
uint8        g_nDirectionControlCount =0;
uint8        Pixel[128]={0};
uint8        Pixel_1[128]={0};
uint8        TIME1flag_20ms=0;
int16 speedflag=0;
extern uint8 g_nSpeedControlPeriod;
extern uint8 g_nDirectionControlPeriod;
extern uint8 IntegrationTime;
extern uint8 IntegrationTime_Right;
extern uint8 integration_piont;
extern uint8 integration_piont_Right;

void pit0_isr(void)                    //定时器1ms中断函数
{  
         DisableInterrupts;            //关总中断
                                             
         integration_piont = 20 - IntegrationTime; 
         if(integration_piont >= 2)   //曝光点小于2不进行再曝光                 
         {      
            if(integration_piont == TimerCnt20ms) 
              StartIntegration();               
         }
      
         integration_piont_Right = 20 - IntegrationTime_Right;
         if(integration_piont_Right >= 2)//曝光点小于2不进行再曝光                 
         {      
            if(integration_piont_Right == TimerCnt20ms)
              StartIntegrationRight();              
         }
         
         TimerCnt20ms++;
         if(TimerCnt20ms>=20)
         {   
            TimerCnt20ms=0;
            ImageCapture(Pixel);
            CalculateIntegrationTime();            
            ImageCapture_1(Pixel_1);
            CalculateIntegrationTimeRight();            
            TIME1flag_20ms = 1;
         }
         //--------------------------------------------------------------------------
         g_nSpeedControlPeriod ++;
         SpeedControlOutput();          
         g_nDirectionControlPeriod ++;
         DirectionControlOutput();
         
         g_n1MSEventCount ++;
         switch(g_n1MSEventCount)
         {
         case 1:
              get_ad();
	      AngleCalculate(); 
              break;
         case 2:
              AngleControl();
              MotorOutput();//---1
              break;
         case 3:
              g_nSpeedControlCount ++;
  	      if(g_nSpeedControlCount >= 20)
  	      {
                 speedflag++;
  	         SpeedControl();
  		 g_nSpeedControlCount = 0;
  		 g_nSpeedControlPeriod = 0; 			
  	      }
              //MotorOutput();//---2
              break;
         case 4:
              g_nDirectionControlCount ++;
     	      if(g_nDirectionControlCount >=2)
	      {
	         DirectionControl();
	  	 g_nDirectionControlCount = 0;
	  	 g_nDirectionControlPeriod = 0;
	      }
              //MotorOutput();//---3
              break;
         case 5:
              g_n1MSEventCount = 0;                  
              GetMotorPulse();
              break;        
         }
         
/*         
           if(g_n1MSEventCount >=5)
  	 {                                          
           g_n1MSEventCount = 0;                  
           GetMotorPulse();
  	 }

  	 else if(g_n1MSEventCount == 1) 
  	 {                                        
             get_ad();
	     AngleCalculate();   
  	 }
        
  	 else if(g_n1MSEventCount == 2) 
  	 {    
             AngleControl();
             MotorOutput();                       		
  	 }

 	 else if(g_n1MSEventCount == 3)
  	 {                                      
  	     g_nSpeedControlCount ++;
  	     if(g_nSpeedControlCount >= 20)
  	     {
  	         SpeedControl();
  		 g_nSpeedControlCount = 0;
  		 g_nSpeedControlPeriod = 0;  			
  	     }
  	 } 

         else if(g_n1MSEventCount == 4)
  	 {    
             g_nDirectionControlCount ++;
     	     if(g_nDirectionControlCount >=2)
	     {
	         DirectionControl();
	  	 g_nDirectionControlCount = 0;
	  	 g_nDirectionControlPeriod = 0;
	     }
    	 }
*/        
         PIT_TFLG(0)|=PIT_TFLG_TIF_MASK;          //清中断标志位
         enable_pit_interrupt(0);
         EnableInterrupts;                        //开总中断
}
