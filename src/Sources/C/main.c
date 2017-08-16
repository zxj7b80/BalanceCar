//ͷ�ļ�
#include "includes.h"

//ȫ�ֱ�������
extern int   periph_clk_khz;

extern int16 left_l;
extern int16 right_l;
extern int16 left_OFFSET;
extern int16 right_OFFSET;
extern uint8 IntegrationTime;
extern uint8 IntegrationTime_Right;
uint8        integration_piont;
uint8        integration_piont_Right;
extern uint8 Pixel[128];
extern uint8 Pixel_1[128];
extern uint8 TIME1flag_20ms;
extern int16 gravity;
uint8        a=0;
uint8        b=0;

void  system_init();
void  button_init();
//������
void main()
{
   vuint8  i,j;
   uint8   *pixel_pt;
 //  uint8   send_data_cnt = 0;
   pixel_pt = Pixel;
   for(j=0; j<128+10; j++) 
   {
      *pixel_pt++ = 0;
   }   
   pixel_pt = Pixel_1;
   for(j=0; j<128+10; j++) 
   {
      *pixel_pt++ = 0;
   }
   
   system_init();
   /*  
   serial_choose();
   uart_send1(UART3 ,  gravity );        //PTC16�Ӵ���ģ���uart3_RX��PTC17�Ӵ���ģ���uart3_TX                                         
   uart_send1(UART3 , gyro );  
   */ 
   while(1)                              //�ȴ�1ms�ж�
   {
     if(TIME1flag_20ms == 1)
     {
        TIME1flag_20ms = 0; 
        get_left();
        get_right();
        BlackManange();        
        LCD_show();
        
/*        if(++send_data_cnt >= 5)        //ÿ100ms��CCDview�������� 
        {  
           send_data_cnt =0;
           SendImageData(Pixel);
           //SendImageData(Pixel_1);
        }
*/        
     }      
   }
}

void system_init()
{
    uint16 i,j;
 
    DisableInterrupts;                          //�ر����ж�
    
    uart_init(UART3,periph_clk_khz,115200);     //���ڳ�ʼ��
    Motor_init();                               //�����ʼ��   pwmƵ��Ϊ10kHz
    FTM_QUAD_init();                            //����������ٳ�ʼ��
    CCD_init();
    LCD_Init();                                 //OLEDҺ����ʼ��
    hw_adc_init(0);                             //ADC0��ʼ�� ֱ��������Ϣ�ɼ�
    button_init();
        
    for(;;)
    {              
      for(j=0;j<25;j++)
      {
         for(i=0;i<20;i++)
         {
            //delay_ms(2);
            delay_ms(1);             
            integration_piont = 20 - IntegrationTime;            
            if(integration_piont >= 2)//�ع��С��2���������ع�                
            {      
              if(integration_piont == i)           
              StartIntegration();                
            }
            
            integration_piont_Right = 20 - IntegrationTime_Right;
            if(integration_piont_Right >= 2)//�ع��С��2���������ع�                
            {      
              if(integration_piont_Right == i)
              StartIntegrationRight();         
            }
         }
         getCCD();
      }   
      left_OFFSET=(int16)(left_l/25);//������left��right����Ϊ255������ͨ����Ϊ����
      right_OFFSET=(int16)(right_l/25);
      LCD_P8x16_number(10,0,left_OFFSET);
      LCD_P8x16_number(70,0,right_OFFSET);
      left_l=0;
      right_l=0;
      
      KeyScan();
      if(a!=0)break;      
    }
   for(;;)
    {
     // delay_ms(1000);
    for(i=0;i<1000;i++)
    {
       GetSamplezhi();                          //������ѹֵ
    }
      GetOFFSET();
      LCD_P8x16_number(70,4,(int16)(gravity*0.15));
      Clear();
      KeyScan_1();
      if(b!=0)break;    
    }
    hw_pit_init(0,60000);                       //����pit��ʱ��0,1ms�ж�(60000)
    enable_pit_interrupt(0);                    //��pit�ж�0ͨ��
    EnableInterrupts;                           //�������ж�
}