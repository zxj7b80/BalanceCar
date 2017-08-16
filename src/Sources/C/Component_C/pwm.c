#include<pwm.h>
#include<gpio.h>    

extern int periph_clk_khz;
uint32 FTM_MOD0=0;
uint32 FTM_MOD1=0;
uint32 FTM_MOD2=0;
 

/***************************************************************
*��������uint8 FTM_PWM_Init(uint8 FTMx,uint32 freq)
*���ܣ�  ���ض���FTMx��ʼ��Ϊpwm�������������Ƶ��
*��ڲ�����(1)FTMx : 0
                     1
                     2
           
          (2)fre  :  Hz
*���ڲ�������
*˵������
***************************************************************/
uint8 FTM_PWM_Init(uint8 FTMx,uint32 freq)
{
  uint32 bus_clk_hz;
  uint32 mod;
  uint8  ps=0;
  bus_clk_hz = periph_clk_khz*1000;
    
  if(freq>bus_clk_hz) return 0;
  
  if((mod=bus_clk_hz/(freq*128)) < 0xFFFFu)
  {
    ps = 7;
    if(FTMx==0)
    {
      FTM_MOD0= mod;
    }
    else if(FTMx==1)
    {
      FTM_MOD1=mod;
    }
    else if(FTMx==2)
    {
      FTM_MOD2=mod;  
    }
    else
      return 0;
    if((mod=bus_clk_hz/(freq*64)) < 0xFFFFu)
    {
      ps = 6;   
      if(FTMx==0)
      {
        FTM_MOD0= mod;
      }
      else if(FTMx==1)
      {
        FTM_MOD1=mod;
      }
      else if(FTMx==2)
      {
        FTM_MOD2=mod;  
      }
    else
      return 0;
      if((mod=bus_clk_hz/(freq*32)) < 0xFFFFu)
      {
        ps = 5; 
        if(FTMx==0)
        {
          FTM_MOD0= mod;
        }
        else if(FTMx==1)
        {
          FTM_MOD1=mod;
        }
        else if(FTMx==2)
        {
          FTM_MOD2=mod;  
        }
        else
          return 0;
        if((mod=bus_clk_hz/(freq*16)) < 0xFFFFu)
        {
          ps = 4;  
          if(FTMx==0)
          {
            FTM_MOD0= mod;
          }
          else if(FTMx==1)
          {
            FTM_MOD1=mod;
          }
          else if(FTMx==2)
          {
            FTM_MOD2=mod;  
          }
          else
            return 0;
          if((mod=bus_clk_hz/(freq*8)) < 0xFFFFu)
          {
            ps = 3;
            if(FTMx==0)
            {
              FTM_MOD0= mod;
            }
            else if(FTMx==1)
            {
              FTM_MOD1=mod;
            }
            else if(FTMx==2)
            {
              FTM_MOD2=mod;  
            }
            else
              return 0;
            if((mod=bus_clk_hz/(freq*4)) < 0xFFFFu)
            {
              ps = 2;
              if(FTMx==0)
              {
                FTM_MOD0= mod;
              }
              else if(FTMx==1)
              {
                FTM_MOD1=mod;
              }
              else if(FTMx==2)
              {
                FTM_MOD2=mod;  
              }
              else
                return 0;
              if((mod=bus_clk_hz/(freq*2)) < 0xFFFFu)
              {
                ps = 1;
                if(FTMx==0)
                {
                  FTM_MOD0= mod;
                }
                else if(FTMx==1)
                {
                  FTM_MOD1=mod;
                }
                else if(FTMx==2)
                {
                  FTM_MOD2=mod;  
                }
                else
                  return 0;
                if((mod=bus_clk_hz/(freq*1)) < 0xFFFFu)
                {
                  ps = 0;
                  if(FTMx==0)
                  {
                    FTM_MOD0= mod;
                  }
                  else if(FTMx==1)
                  {
                    FTM_MOD1=mod;
                  }
                  else if(FTMx==2)
                  {
                    FTM_MOD2=mod;  
                  }
                  else
                    return 0;
                }
              }
            }
          }
        }  
      }
    }
  }
  else
  {
    return 0;
  }
  
  if(FTMx==0)
    {
      // ʹ��FTMʱ��ģ��
      SIM_SCGC6 |= SIM_SCGC6_FTM0_MASK;
  
      // ����FTM���ƼĴ���
      // �����ж�, �Ӽ���ģʽ, ʱ��Դ:System clock��Bus Clk��, ��Ƶϵ��:8
      // ����SysClk = 50MHz, SC_PS=3, FTM Clk = 50MHz/2^3 = 6.25MHz
      FTM0_SC = FTM_SC_CLKS(1)|FTM_SC_PS(ps);
  
      // ����PWM���ڼ�ռ�ձ�
      // PWM���� = (MOD-CNTIN+1)*FTMʱ������ :
      // ����FTM������ʼֵ
      FTM0_CNT = 0;
      FTM0_CNTIN = 0;
      
      // ����FTM����MODֵ
      FTM0_MOD = FTM_MOD0;
    }
  else if(FTMx==1)
    {
      // ʹ��FTMʱ��ģ��
      SIM_SCGC6 |= SIM_SCGC6_FTM1_MASK;
  
      // ����FTM���ƼĴ���
      // �����ж�, �Ӽ���ģʽ, ʱ��Դ:System clock��Bus Clk��, ��Ƶϵ��:8
      // ����SysClk = 50MHz, SC_PS=3, FTM Clk = 50MHz/2^3 = 6.25MHz
      FTM1_SC = FTM_SC_CLKS(1)|FTM_SC_PS(ps);
  
      // ����PWM���ڼ�ռ�ձ�
      // PWM���� = (MOD-CNTIN+1)*FTMʱ������ :
      // ����FTM������ʼֵ
      FTM1_CNT = 0;
      FTM1_CNTIN = 0;
      
      // ����FTM����MODֵ
      FTM1_MOD = FTM_MOD1;
    } 
  else if(FTMx==2)
    {
      // ʹ��FTMʱ��ģ��
      SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;
  
      // ����FTM���ƼĴ���
      // �����ж�, �Ӽ���ģʽ, ʱ��Դ:System clock��Bus Clk��, ��Ƶϵ��:8
      // ����SysClk = 50MHz, SC_PS=3, FTM Clk = 50MHz/2^3 = 6.25MHz
      FTM2_SC = FTM_SC_CLKS(1)|FTM_SC_PS(ps);
  
      // ����PWM���ڼ�ռ�ձ�
      // PWM���� = (MOD-CNTIN+1)*FTMʱ������ :
      // ����FTM������ʼֵ
      FTM2_CNT = 0;
      FTM2_CNTIN = 0;
      
      // ����FTM����MODֵ
      FTM2_MOD = FTM_MOD2;
    }  
  else
    return 0;

  return 1;
}


/***************************************************************
*��������uint8 FTM_PWM_Open(uint8 FTMx,uint8 channel, uint32 duty)
*���ܣ�  ��PWMͨ��������ռ�ձ�
*��ڲ�����(1)FTMx : 0
                     1
                     2
           
          (2)channel  ͨ���� 

          (3)duty     ռ�ձ�
*���ڲ�������
*˵������
***************************************************************/
uint8 FTM_PWM_Open(uint8 FTMx,uint8 channel, uint32 duty)
{
  uint32 cv;
  volatile uint32 mod;
  
  if(duty>10000) return 0;
  //ռ�ձ� = (CnV-CNTIN)/(MOD-CNTIN+1)
  if(FTMx==0)
  {
    mod = FTM_MOD0;
  }
  else if(FTMx==1)
  {
    mod==FTM_MOD1;
  }
  else if(FTMx==2)
  {
    mod==FTM_MOD2;
  }
  else
    return 0;
  
  cv = (duty*(mod-0+1)+0)/10000;
  
  if(FTMx==0)
  {
    //ѡ�񲢿���ͨ��
    switch(channel)
      {
        case 0:
        case 1:
        case 2:
          SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
          PORT_PCR_REG(PORTA_BASE_PTR, channel+3) = PORT_PCR_MUX(3);
          break;
        case 3:
          SIM_SCGC5 |= SIM_SCGC5_PORTC_MASK;
          PORT_PCR_REG(PORTC_BASE_PTR, channel+1) = PORT_PCR_MUX(4);
          break;
        case 4:
        case 5:
        case 6:
        case 7:
          SIM_SCGC5 |= SIM_SCGC5_PORTD_MASK;
          PORT_PCR_REG(PORTD_BASE_PTR, channel) = PORT_PCR_MUX(4);
          break;
        default:
          return 0;
      }  
  
    // ����FTMͨ�����ƼĴ��� 
    // ͨ��ģʽ MSB:MSA-1X, ͨ����Եѡ�� ELSB:ELSA-10
    FTM_CnSC_REG(FTM0_BASE_PTR, channel) = FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
    // ����FTMͨ��ֵ
    FTM_CnV_REG(FTM0_BASE_PTR, channel) = cv;
  } 
  
  if(FTMx==1)
  {
    //ѡ�񲢿���ͨ��
    switch(channel)
      {
        case 0:
              SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
              PORT_PCR_REG(PORTB_BASE_PTR, channel) = PORT_PCR_MUX(3);
               //SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
               //PORTB_PCR0= PORT_PCR_MUX(0x3)| PORT_PCR_DSE_MASK;
               break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        default:
          return 0;
      }  
  
    // ����FTMͨ�����ƼĴ��� 
    // ͨ��ģʽ MSB:MSA-1X, ͨ����Եѡ�� ELSB:ELSA-10
    FTM_CnSC_REG(FTM1_BASE_PTR, channel) = FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
    // ����FTMͨ��ֵ
    FTM_CnV_REG(FTM1_BASE_PTR, channel) = cv;
  } 
  
  if(FTMx==2)
  {
    //ѡ�񲢿���ͨ��
    switch(channel)
      {
        case 0:
          break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        default:
          return 0;
      }  
  
    // ����FTMͨ�����ƼĴ��� 
    // ͨ��ģʽ MSB:MSA-1X, ͨ����Եѡ�� ELSB:ELSA-10
    FTM_CnSC_REG(FTM2_BASE_PTR, channel) = FTM_CnSC_MSB_MASK|FTM_CnSC_ELSB_MASK;
    // ����FTMͨ��ֵ
    FTM_CnV_REG(FTM2_BASE_PTR, channel) = cv;
  } 
  return 1;
}


/***************************************************************
*��������uint8 FTM_PWM_ChangeDuty(uint8 FTMx,uint8 channel, uint32 duty)
*���ܣ�  ��PWMͨ��������ռ�ձ�
*��ڲ�����(1)FTMx : 0
                     1
                     2
           
          (2)channel  ͨ���� 

          (3)duty     ռ�ձ�
*���ڲ�������
*˵������
***************************************************************/
uint8 FTM_PWM_ChangeDuty(uint8 FTMx,uint8 channel, uint32 duty)
{
  uint32 cv;
  volatile uint32 mod;
  
  if(duty>10000) return 0;
  //ռ�ձ� = (CnV-CNTIN)/(MOD-CNTIN+1)
  if(FTMx==0)
  {
    mod =FTM_MOD0;
  }
  else if(FTMx==1)
  {
    mod==FTM_MOD1;
  }
  else if(FTMx==2)
  {
    mod==FTM_MOD2;
  }
  else
    return 0;
  
  cv = (duty*(mod-0+1)+0)/10000;
  
  if(FTMx==0)
  {
    switch(channel)// ����FTMͨ��ֵ
    {  
      case 0:
         FTM_CnV_REG(FTM0_BASE_PTR, 0) = cv;
         break;
      case 1:
         FTM_CnV_REG(FTM0_BASE_PTR, 1) = cv;
         break;
      default:
      return 0;
    }
  }
  else if(FTMx==1)
  {
    // ����FTMͨ��ֵ
    FTM_CnV_REG(FTM1_BASE_PTR, channel) = cv;
  }
  else if(FTMx==2)
  {
    // ����FTMͨ��ֵ
    FTM_CnV_REG(FTM2_BASE_PTR, channel) = cv;
  }
  else
    return 0;
  return 1;
}

/***************************************************************
*��������void Motor_init(void)   
*���ܣ�  ֱ�����PWM�������ų�ʼ��
*��ڲ�������
*���ڲ�������
*˵������
***************************************************************/
void Motor_init(void)    //ֱ�����
    {      	   
      DIR_B;                     //�ҵ��B10  ��ת
      DIL_B;                     //����B9  ��ת
      
      /* Turn on all port clocks */
      SIM_SCGC5 |= SIM_SCGC5_PORTC_MASK;
      
      PORTC_PCR1= PORT_PCR_MUX(0x4)| PORT_PCR_DSE_MASK; // FTM is alt3 function for this pin 
      PORTC_PCR2= PORT_PCR_MUX(0x4)| PORT_PCR_DSE_MASK; // FTM is alt3 function for this pin
      
      SIM_SCGC6|=SIM_SCGC6_FTM0_MASK;         //ʹ��FTM0ʱ��      
      
      //change MSnB = 1  
      FTM0_C0SC |= FTM_CnSC_ELSB_MASK;
      FTM0_C0SC &= ~FTM_CnSC_ELSA_MASK;
      FTM0_C0SC |= FTM_CnSC_MSB_MASK;    
      
      FTM0_C1SC |= FTM_CnSC_ELSB_MASK;
      FTM0_C1SC &= ~FTM_CnSC_ELSA_MASK;
      FTM0_C1SC |= FTM_CnSC_MSB_MASK;   
      
      
      FTM0_SC = 0x29; //not enable the interrupt mask    0010 1001
      //FTM1_SC=0X1F;       //BIT5  0 FTM counter operates in up counting mode.
                            //1 FTM counter operates in up-down counting mode.      
      //BIT43 FTM1_SC|=FTM1_SC_CLKS_MASK;
                            //00 No clock selected (This in effect disables the FTM counter.)
                            //01 System clock
                            //10 Fixed frequency clock
                            //11 External clock
      //BIT210 FTM1_SC|=FTM1_SC_PS_MASK; 
                            //100M          MOD=2000;    
                            //000 Divide by 1---12KHZ     
                            //001 Divide by 2--- 6KHZ
                            //010 Divide by 4--- 3K
                            //011 Divide by 8--- 1.5K
                            //100 Divide by 16---750
                            //101 Divide by 32---375
                            //110 Divide by 64---187.5HZ
                            //111 Divide by 128--93.75hz             
      
      FTM0_MODE |= FTM_MODE_WPDIS_MASK;      
       //BIT1   Initialize the Channels Output
      //FTMEN is bit 0, need to set to zero so DECAPEN can be set to 0
      FTM0_MODE &= ~1;
       //BIT0   FTM Enable
       //0 Only the TPM-compatible registers (first set of registers) can be used without any restriction. Do not use the FTM-specific registers.
       //1 All registers including the FTM-specific registers (second set of registers) are available for use with no restrictions.
      
      FTM0_OUTMASK=0XFC;   //0 Channel output is not masked. It continues to operate normally.
                           //1 Channel output is masked. It is forced to its inactive state.
      
      FTM0_COMBINE=0;      //Function for Linked Channels (FTMx_COMBINE)
      FTM0_OUTINIT=0;
      FTM0_EXTTRIG=0;      //FTM aExternl Trigger (FTMx_EXTTRIG)
      FTM0_POL=0;          //Channels Polarity (FTMx_POL)
                           //0 The channel polarity is active high.
                           //1 The channel polarity is active low.     
      //Set Edge Aligned PWM
      FTM0_QDCTRL &=~FTM_QDCTRL_QUADEN_MASK;
      //QUADEN is Bit 1, Set Quadrature Decoder Mode (QUADEN) Enable to 0,   (disabled)
      //FTM0_SC = 0x16; //Center Aligned PWM Select = 0, sets FTM Counter to operate in up counting mode,
      //it is field 5 of FTMx_SC (status control) - also setting the pre-scale bits here
      
      FTM0_INVCTRL=0;      //��ת����
      FTM0_SWOCTRL=0;      //����������F TM Software Output Control (FTMx_SWOCTRL)
      FTM0_PWMLOAD=0;      //FTM PWM Load
                           //BIT9: 0 Loading updated values is disabled.
                           //1 Loading updated values is enabled.
      FTM0_CNTIN=0;        //Counter Initial Value      
      FTM0_MOD=1250;       //Modulo value,The EPWM period is determined by (MOD - CNTIN + 0x0001) 
                           //PMWƵ��=ϵͳƵ��/4/(2^FTM1_SC_PS)/FTM1_MOD   10000=180000000/4/2/2250   
      FTM0_C0V=0;       //���� the pulse width(duty cycle) is determined by (CnV - CNTIN).  �ߵ�ƽ��ʱ��
      FTM0_C1V=0;       //���� the pulse width(duty cycle) is determined by (CnV - CNTIN).  �ߵ�ƽ��ʱ��
      FTM0_CNT=0;          //ֻ�е�16λ����,�Ĵ����ĳ�ֵ
}