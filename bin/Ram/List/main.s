///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      05/May/2013  16:53:28 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  C:\Users\hp\Desktop\balance car\src\Sources\C\main.c    /
//    Command line =  "C:\Users\hp\Desktop\balance car\src\Sources\C\main.c"  /
//                    -D IAR -D TWR_K60N512 -lCN                              /
//                    "C:\Users\hp\Desktop\balance car\bin\Ram\List\" -lB     /
//                    "C:\Users\hp\Desktop\balance car\bin\Ram\List\" -o      /
//                    "C:\Users\hp\Desktop\balance car\bin\Ram\Obj\"          /
//                    --no_cse --no_unroll --no_inline --no_code_motion       /
//                    --no_tbaa --no_clustering --no_scheduling --debug       /
//                    --endian=little --cpu=Cortex-M4 -e --fpu=None           /
//                    --dlib_config F:\iar\arm\INC\c\DLib_Config_Normal.h -I  /
//                    "C:\Users\hp\Desktop\balance car\src\Sources\H\" -I     /
//                    "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\H\Component_H\" -I                      /
//                    "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\H\Frame_H\" -Ol --use_c++_inline        /
//    List file    =  C:\Users\hp\Desktop\balance car\bin\Ram\List\main.s     /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME main

        #define SHT_PROGBITS 0x1

        EXTERN FTM_PWM_ChangeDuty
        EXTERN FTM_PWM_Init
        EXTERN FTM_QUAD_init
        EXTERN Motor_init
        EXTERN __aeabi_cfcmple
        EXTERN __aeabi_cfrcmple
        EXTERN delay
        EXTERN enable_pit_interrupt
        EXTERN enableuartreint
        EXTERN g_fCarAngle
        EXTERN gravity
        EXTERN gyro
        EXTERN hw_ad_ave
        EXTERN hw_adc_init
        EXTERN hw_pit_init
        EXTERN periph_clk_khz
        EXTERN uart_init
        EXTERN uart_send1
        EXTERN uart_sendnumber

        PUBLIC g_OverSlopeCnt
        PUBLIC main
        PUBLIC system_init

// C:\Users\hp\Desktop\balance car\src\Sources\C\main.c
//    1 //头文件
//    2 #include "includes.h"
//    3 void system_init();
//    4 void delay();
//    5 extern int gravity,gyro;
//    6 //全局变量声明
//    7 extern int periph_clk_khz;
//    8 extern float g_fCarAngle;

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//    9 uint8 g_OverSlopeCnt=0;
g_OverSlopeCnt:
        DS8 1
//   10 //主函数

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   11 void main()
//   12 {
main:
        PUSH     {R7,LR}
//   13   system_init();
        BL       system_init
//   14 
//   15 /*  GetInputVoltageAverage(10000);
//   16    gravity= g_nInputVoltage[0];
//   17    gyro=g_nInputVoltage[1];
//   18    gyro_direction=g_nInputVoltage[4];
//   19 //   dir_left_offset= g_nInputVoltage[2];
//   20  //  dir_right_offset= g_nInputVoltage[3];*/
//   21   delay( 3000 );
        MOVW     R0,#+3000
        BL       delay
//   22   gravity =hw_ad_ave(0,8,12,100); //ADC0 通道8 100 次(PTB0)
        MOVS     R3,#+100
        MOVS     R2,#+12
        MOVS     R1,#+8
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.N    R1,??DataTable1
        STR      R0,[R1, #+0]
//   23   gyro =hw_ad_ave(0,9,12,100); //ADC0 通道9 100 次(PTB1)
        MOVS     R3,#+100
        MOVS     R2,#+12
        MOVS     R1,#+9
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.N    R1,??DataTable1_1
        STR      R0,[R1, #+0]
//   24   
//   25   uart_sendnumber(UART3 ,  gravity );           //PTC16接串口模块的uart3_RX
        LDR.N    R0,??DataTable1
        LDR      R1,[R0, #+0]
        LDR.N    R0,??DataTable1_2  ;; 0x4006d000
        BL       uart_sendnumber
//   26                                                 // PTC17接串口模块的uart3_TX  
//   27   uart_sendnumber(UART3 , gyro );  
        LDR.N    R0,??DataTable1_1
        LDR      R1,[R0, #+0]
        LDR.N    R0,??DataTable1_2  ;; 0x4006d000
        BL       uart_sendnumber
//   28   
//   29   uart_send1 (UART3, '\r');
        MOVS     R1,#+13
        LDR.N    R0,??DataTable1_2  ;; 0x4006d000
        BL       uart_send1
//   30   uart_send1 (UART3, '\n');
        MOVS     R1,#+10
        LDR.N    R0,??DataTable1_2  ;; 0x4006d000
        BL       uart_send1
        B.N      ??main_0
//   31   for(;;)                            //等待1ms中断
//   32   {
//   33     //倾倒停机
//   34       if(g_fCarAngle>=40/*前倾*/ ||g_fCarAngle<=-50/*后倾*/)
//   35       {
//   36         if(g_OverSlopeCnt>3)
//   37         {
//   38          // g_switch=0; //关闭定时
//   39           FTM_PWM_ChangeDuty( 0,0 , 0);      //通道0 PTC1 左
//   40           FTM_PWM_ChangeDuty( 0,1 , 0);      //通道1 PTC2 右
//   41         }
//   42         else
//   43         {
//   44           g_OverSlopeCnt++;
//   45         }
//   46       }
//   47       else
//   48       {
//   49         g_OverSlopeCnt=0;
??main_1:
        LDR.N    R0,??DataTable1_3
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   50       }
??main_0:
        LDR.N    R0,??DataTable1_4
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable1_5  ;; 0x42200000
        BL       __aeabi_cfrcmple
        BLS.N    ??main_2
        LDR.N    R0,??DataTable1_4
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable1_6  ;; 0xc247ffff
        BL       __aeabi_cfcmple
        BCS.N    ??main_1
??main_2:
        LDR.N    R0,??DataTable1_3
        LDRB     R0,[R0, #+0]
        CMP      R0,#+4
        BCC.N    ??main_3
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       FTM_PWM_ChangeDuty
        MOVS     R2,#+0
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       FTM_PWM_ChangeDuty
        B.N      ??main_0
??main_3:
        LDR.N    R0,??DataTable1_3
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable1_3
        STRB     R0,[R1, #+0]
        B.N      ??main_0
//   51         //key_scan(); //键盘扫描函数
//   52       //===========================================================
//   53   }
//   54   
//   55 }

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   56 void system_init()
//   57 {
system_init:
        PUSH     {R7,LR}
//   58   DisableInterrupts;                          //关闭总中断
        CPSID i         
//   59   
//   60  // gpio_init (GPIO_MemMapPtr port, int index, int dir,int data);
//   61   
//   62   uart_init (UART3,periph_clk_khz,9600);      //串口初始化
        MOV      R2,#+9600
        LDR.N    R0,??DataTable1_7
        LDR      R1,[R0, #+0]
        LDR.N    R0,??DataTable1_2  ;; 0x4006d000
        BL       uart_init
//   63   
//   64   FTM_PWM_Init(0,10000);                      //pwm频率为10kHz
        MOVW     R1,#+10000
        MOVS     R0,#+0
        BL       FTM_PWM_Init
//   65  //  FTM_PWM_Open(0,2,4000);
//   66   Motor_init();                               //电机初始化 
        BL       Motor_init
//   67   
//   68   hw_adc_init(0);                             //ADC0初始化
        MOVS     R0,#+0
        BL       hw_adc_init
//   69   
//   70  // hw_i2c_init(I2C1);                        //i2c初始化
//   71   enableuartreint(UART3,UART0irq);	      //开串口3接收中断
        MOVS     R1,#+45
        LDR.N    R0,??DataTable1_2  ;; 0x4006d000
        BL       enableuartreint
//   72  
//   73   hw_pit_init(0,10000);                       //配置pit定时器,1ms中断
        MOVW     R1,#+10000
        MOVS     R0,#+0
        BL       hw_pit_init
//   74   
//   75   enable_pit_interrupt(0);                    //开pit中断0通道
        MOVS     R0,#+0
        BL       enable_pit_interrupt
//   76   
//   77   FTM_QUAD_init();                            //正交解码测速初始化
        BL       FTM_QUAD_init
//   78   
//   79   EnableInterrupts;                           //开启总中断
        CPSIE i         
//   80   
//   81 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1:
        DC32     gravity

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_1:
        DC32     gyro

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_2:
        DC32     0x4006d000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_3:
        DC32     g_OverSlopeCnt

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_4:
        DC32     g_fCarAngle

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_5:
        DC32     0x42200000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_6:
        DC32     0xc247ffff

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_7:
        DC32     periph_clk_khz

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//   82 
//   83 
//   84 
//   85 
//   86 
//   87 
//   88 
//   89 
//   90 
//   91 
//   92 
//   93 
//   94 
//   95                             
//   96                                           
//   97 
//   98 
//   99 
//  100 
//  101 
//  102 
//  103 
//  104 
//  105 
//  106 
//  107 
//  108 
//  109 
// 
//   1 byte  in section .bss
// 258 bytes in section .text
// 
// 258 bytes of CODE memory
//   1 byte  of DATA memory
//
//Errors: none
//Warnings: none
