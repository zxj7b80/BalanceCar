//-------------------------------------------------------------------------*
//文件名: includes.h                                                       *
//说  明: 总头文件,本文件包含:                                             *
//        主函数(main)文件中用到的头文件、外部函数声明及有关常量命名       *
//-------------------------------------------------------------------------*
#ifndef INCLUDE_H_
#define INCLUDE_H_

	//1 头文件
        #include "sysinit.h"
        #include "stdlib.h"
        #include "math.h"
	//1.1通用头文件
	#include "common.h"            //通用函数头文件
                
	//1.2包含面向硬件对象头文件(即构件模块)       
	#include  "light.h"                  //小灯构件头文件
	#include  "uart.h"                   //串口构件头文件
        #include  "adc.h" 
        #include  "pwm.h"
        #include  "decoder.h"
        #include  "pit.h"
        #include  "gpio.h"
        #include  "i2c.h"
        #include  "delay.h"
        #include  "control.h"
        #include  "LQ12864.h"
	//2 宏定义
      //  #define MOTOR_OUT_MAX   1.0
      //  #define MOTOR_OUT_MIN	-1.0

#endif
