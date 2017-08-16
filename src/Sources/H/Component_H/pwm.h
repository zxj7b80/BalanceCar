#ifndef _PWM_H_
#define _PWM_H_

  //1 头文件
  #include "common.h"

  #include "gpio.h"


  #define DIR_B  gpio_init(PORTB,10, 1,0)    
  #define DIR_F  gpio_init(PORTB,10, 1,1)
  #define DIL_B  gpio_init(PORTB, 9, 1,0)
  #define DIL_F  gpio_init(PORTB, 9, 1,1)
  //2 函数声明
 
    void Motor_init(void);    //直流电机

  //  void duoji_init(void);    //直流电机
    
    uint8 FTM_PWM_Init(uint8 FTMx,uint32 freq);
    
    uint8 FTM_PWM_Open(uint8 FTMx,uint8 channel, uint32 duty);
    
    uint8 FTM_PWM_ChangeDuty(uint8 FTMx,uint8 channel, uint32 duty);
    
#endif