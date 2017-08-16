#include"pit.h"

//==========================================================================
//函数名:     void hw_pit_init(uint8 pitno,uint32 timeout)
//功能:       配置pit定时器
//入口参数:   pitno:  表示pit通道号。
//                            0
//                            1
//                            2
//                            3
//            timeout:表示定时溢出开始递减的值
//            定时时间计算公式   定时=(timeout+1)/bus_clk
//出口参数:   无
//说明:       无       
//==========================================================================
void hw_pit_init(uint8 pitno,uint32 timeout)
    {
      SIM_SCGC6|=SIM_SCGC6_PIT_MASK;              //使能PIT时钟
      PIT_MCR&=~(PIT_MCR_MDIS_MASK);              //调试模式下禁止
      PIT_MCR|=PIT_MCR_FRZ_MASK;                  //使能PIT模块时钟
      PIT_LDVAL(pitno)=timeout;                   //设置周期  1ms中断
      PIT_TCTRL(pitno)|=PIT_TCTRL_TEN_MASK;       //使能pit模块运行
      PIT_TCTRL(pitno)&=~(PIT_TCTRL_TIE_MASK);    //关pit中断
    }

//==========================================================================
//函数名:    void enable_pit_interrupt(uint8 pitno)  
//功能:      开接收引脚的IRQ中断
//入口参数:  pitno: 表示pit通道号 
//                           0
//                           1
//                           2
//                           3
//出口参数:  无
//说明:      无                                                                                                     
//==========================================================================
    void enable_pit_interrupt(uint8 pitno)
    {
      PIT_TCTRL(pitno)|=(PIT_TCTRL_TIE_MASK); //开pit中断
      switch(pitno)
      {
      case 0:
        enable_irq(68);			      //开接收引脚的IRQ中断
        break;
      case 1:
        enable_irq(69);			      //开接收引脚的IRQ中断
        break;
      case 2:
        enable_irq(70);			      //开接收引脚的IRQ中断
        break;
      case 3:
        enable_irq(71);			      //开接收引脚的IRQ中断
        break;
      }
    }

//==========================================================================
//函数名:   void disable_pit_interrupt(uint8 pitno)
//功能:     关接收引脚的IRQ中断 
//入口参数: pitno: 表示pit通道号 
//                           0
//                           1
//                           2
//                           3
//出口参数: 无  
//说明:     无                                                                                                    
//==========================================================================
    void disable_pit_interrupt(uint8 pitno)
    {
      PIT_TCTRL(pitno)&=~(PIT_TCTRL_TIE_MASK);//关pit中断
      switch(pitno)
      {
      case 0:
        disable_irq(68);	              //关接收引脚的IRQ中断
        break;
      case 1:
        disable_irq(69);		      //关接收引脚的IRQ中断
        break;
      case 2:
        disable_irq(70);		      //关接收引脚的IRQ中断
        break;
      case 3:
        disable_irq(71);		      //关接收引脚的IRQ中断
        break;
      }
    }