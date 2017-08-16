#include "common.h"
#include "decoder.h"
/*==============================================================================
功能：FTM1、FTM2模块双路正交脉冲计数
引脚：PTA12、PTA13、PTB18、PTB19
内容：初始化FTM1、FTM2的正交解码功能
参数：无
==============================================================================*/
void FTM_QUAD_init()
{
   /*使能FTM1、FTM2时钟*/
  SIM_SCGC6|=SIM_SCGC6_FTM1_MASK;
  SIM_SCGC3|=SIM_SCGC3_FTM2_MASK;
  /*开启端口时钟*/
  SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
  
  /*选择管脚复用功能*/
  PORTA_PCR12 = PORT_PCR_MUX(7);                          //特定芯片是什么功能
  PORTA_PCR13 = PORT_PCR_MUX(7);

  PORTB_PCR18 = PORT_PCR_MUX(6);
  PORTB_PCR19 = PORT_PCR_MUX(6);
 
  FTM1_CNTIN = 0;                                          //FTM1初始值
  FTM2_CNTIN = 0;
  FTM1_MOD = 65535;                                        //可根据需要设置
  FTM2_MOD = 65535;                                        //结束值
  
  FTM1_MODE |= FTM_MODE_WPDIS_MASK;                        //禁止写保护
  FTM2_MODE |= FTM_MODE_WPDIS_MASK;                        //禁止写保护
 
  FTM1_QDCTRL|=FTM_QDCTRL_QUADMODE_MASK;                   //AB相同时确定方向和计数值  
  FTM2_QDCTRL|=FTM_QDCTRL_QUADMODE_MASK;                   //AB相同时确定方向和计数值  
 // FTM2_QDCTRL &= ~FTM_QDCTRL_QUADMODE_MASK;                //选定编码模式为A相与B相编码模式
  //FTM1_QDCTRL &= ~FTM_QDCTRL_QUADMODE_MASK;                //选定编码模式为A相与B相编码模式
  //FTM1_SC |= FTM_SC_CLKS(3);                               //选择外部时钟
  // FTM1_CONF |=FTM_CONF_BDMMODE(3);                      //可根据需要选择
 // FTM2_SC |= FTM_SC_CLKS(3);
  // FTM2_CONF |=FTM_CONF_BDMMODE(3);
  FTM1_QDCTRL |= FTM_QDCTRL_QUADEN_MASK;                   //使能正交解码模式
  FTM2_QDCTRL |= FTM_QDCTRL_QUADEN_MASK;                   //使能正交解码模式
  
  FTM1_MODE |= FTM_MODE_FTMEN_MASK;                        //FTMEN=1,关闭TPM兼容模式，开启FTM所有功能
  FTM2_MODE |= FTM_MODE_FTMEN_MASK;                        //FTMEN=1,关闭TPM兼容模式，开启FTM所有功能
  
  FTM1_CNT=0; 
  FTM2_CNT=0; 
}



/*************************************************************************
*  函数名称：FTM2_QUAD_DIR_init
*  功能说明：正交解码 方向计数模式初始化函数
*  函数返回：无
*  修改时间：2012-1-26
*  备    注：
             该例程使用 A10 和A11 引脚输入作为旋转编码器的 A相和B 相输入。 
              B路控制计数器方向  高电平时计数器正向计数
              A路计数脉冲
              对B路默认上拉
*************************************************************************/
/*void FTM_QUAD_DIR_init()
{
   
    SIM_SCGC6 |=SIM_SCGC6_FTM1_MASK;                             //使能FTM1时钟
    SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;                           //使能FTM2时钟
    
    SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
    SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
    
    PORT_PCR_REG(PORTA_BASE_PTR, 12) = (0|PORT_PCR_MUX(7)|0x10);     // PTA12
    PORT_PCR_REG(PORTA_BASE_PTR, 13) = (0|PORT_PCR_MUX(7)|0x13);     // PTA13
    PORT_PCR_REG(PORTB_BASE_PTR, 18) = PORT_PCR_MUX(6);              // PTB18
    PORT_PCR_REG(PORTB_BASE_PTR, 19) = PORT_PCR_MUX(6);              // PTB19
      
    FTM_MODE_REG(FTM1_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //写保护禁止
    FTM_QDCTRL_REG(FTM1_BASE_PTR)  &=~FTM_QDCTRL_QUADMODE_MASK;       //AB相同时确定方向和计数值
    FTM_CNTIN_REG(FTM1_BASE_PTR)    = 0;                             //FTM1计数器初始值为0
    FTM_MOD_REG(FTM1_BASE_PTR)      = 0xFFFF;                        //FTM1计数器终值为0
    
    FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //写保护禁止
    FTM_QDCTRL_REG(FTM2_BASE_PTR)  &= ~FTM_QDCTRL_QUADMODE_MASK;     //AB 正交解码模式
    FTM_CNTIN_REG(FTM2_BASE_PTR)    = 0;                             //FTM计数器初始值为0
    FTM_MOD_REG(FTM2_BASE_PTR)      = 0xFFFF;                        //FTM计数器初始值为0
    
    FTM_QDCTRL_REG(FTM1_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //使能FTM1正交解码模式
    FTM_MODE_REG(FTM1_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;           //FTM1EN=1	
    FTM_CNT_REG(FTM1_BASE_PTR)     = 0; 
    
    FTM_QDCTRL_REG(FTM2_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //使能FTM2正交解码模式
    FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;           //FTM2EN=1	
    FTM_CNT_REG(FTM2_BASE_PTR)     = 0; 	
}*/



/*************************************************************************
*  函数名称：FTM2_init
*  功能说明：正交解码 方向计数模式初始化函数
*  函数返回：无
*  修改时间：2012-1-26
*  备    注：CH0~CH3可以使用过滤器，未添加这功能
             该例程使用 A10 和A11 引脚输入作为旋转编码器的 A相和B 相输入。 
*************************************************************************
void FTM_QUAD_init()
{
    SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;                                 //使能FTM2时钟

    SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
    PORT_PCR_REG(PORTB_BASE_PTR, 18) = PORT_PCR_MUX(6);               // PTB18
    PORT_PCR_REG(PORTB_BASE_PTR, 19) = PORT_PCR_MUX(6);               // PTB19
       
    FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //写保护禁止
    FTM_QDCTRL_REG(FTM2_BASE_PTR)  &= ~FTM_QDCTRL_QUADMODE_MASK;     //AB 正交解码模式
    FTM_CNTIN_REG(FTM2_BASE_PTR)    = 0;                             //FTM计数器初始值为0
    FTM_MOD_REG(FTM2_BASE_PTR)      = 0xFFFF;                        //FTM计数器初始值为0
   
    FTM_QDCTRL_REG(FTM2_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //使能FTM2正交解码模式
    FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;                             //FTM2EN=1	
    FTM_CNT_REG(FTM2_BASE_PTR)    = 0; 	
}*/
