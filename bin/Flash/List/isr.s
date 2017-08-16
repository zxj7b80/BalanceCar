///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      30/Sep/2013  20:34:14 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  D:\balance car（9.28高速但出赛道）\src\Sources\C\isr.c  /
//    Command line =  "D:\balance car（9.28高速但出赛道）\src\Sources\C\isr.c /
//                    " -D IAR -D TWR_K60N512 -lCN "D:\balance                /
//                    car（9.28高速但出赛道）\bin\Flash\List\" -lB            /
//                    "D:\balance car（9.28高速但出赛道）\bin\Flash\List\"    /
//                    -o "D:\balance car（9.28高速但出赛道）\bin\Flash\Obj\"  /
//                    --no_cse --no_unroll --no_inline --no_code_motion       /
//                    --no_tbaa --no_clustering --no_scheduling --debug       /
//                    --endian=little --cpu=Cortex-M4 -e --fpu=None           /
//                    --dlib_config E:\IAREW6.3\arm\INC\c\DLib_Config_Normal. /
//                    h -I "D:\balance car（9.28高速但出赛道）\src\Sources\H\ /
//                    " -I "D:\balance car（9.28高速但出赛道）\src\Sources\H\ /
//                    Component_H\" -I "D:\balance                            /
//                    car（9.28高速但出赛道）\src\Sources\H\Frame_H\" -Ol     /
//                    --use_c++_inline                                        /
//    List file    =  D:\balance car（9.28高速但出赛道）\bin\Flash\List\isr.s /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME isr

        #define SHT_PROGBITS 0x1

        EXTERN AngleCalculate
        EXTERN AngleControl
        EXTERN CalculateIntegrationTime
        EXTERN CalculateIntegrationTimeRight
        EXTERN DirectionControl
        EXTERN DirectionControlOutput
        EXTERN GetMotorPulse
        EXTERN ImageCapture
        EXTERN ImageCapture_1
        EXTERN IntegrationTime
        EXTERN IntegrationTime_Right
        EXTERN MotorOutput
        EXTERN SpeedControl
        EXTERN SpeedControlOutput
        EXTERN StartIntegration
        EXTERN StartIntegrationRight
        EXTERN enable_pit_interrupt
        EXTERN g_nDirectionControlPeriod
        EXTERN g_nSpeedControlPeriod
        EXTERN get_ad
        EXTERN integration_piont
        EXTERN integration_piont_Right

        PUBLIC Pixel
        PUBLIC Pixel_1
        PUBLIC TIME1flag_20ms
        PUBLIC g_n1MSEventCount
        PUBLIC g_nDirectionControlCount
        PUBLIC g_nSpeedControlCount
        PUBLIC pit0_isr
        PUBLIC speedflag

// D:\balance car（9.28高速但出赛道）\src\Sources\C\isr.c
//    1 //-------------------------------------------------------------------------*
//    2 // 文件名: isr.c                                                           *
//    3 // 说  明: 中断处理例程                                                    *
//    4 //---------------苏州大学飞思卡尔嵌入式系统实验室2011年--------------------*
//    5 
//    6 #include "includes.h"

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//    7 uint8        g_n1MSEventCount =0;
g_n1MSEventCount:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//    8 static uint8 TimerCnt20ms = 0;
TimerCnt20ms:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//    9 uint8        g_nSpeedControlCount =0;
g_nSpeedControlCount:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   10 uint8        g_nDirectionControlCount =0;
g_nDirectionControlCount:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   11 uint8        Pixel[128]={0};
Pixel:
        DS8 128

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   12 uint8        Pixel_1[128]={0};
Pixel_1:
        DS8 128

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   13 uint8        TIME1flag_20ms=0;
TIME1flag_20ms:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   14 int16 speedflag=0;
speedflag:
        DS8 2
//   15 extern uint8 g_nSpeedControlPeriod;
//   16 extern uint8 g_nDirectionControlPeriod;
//   17 extern uint8 IntegrationTime;
//   18 extern uint8 IntegrationTime_Right;
//   19 extern uint8 integration_piont;
//   20 extern uint8 integration_piont_Right;
//   21 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   22 void pit0_isr(void)                    //定时器1ms中断函数
//   23 {  
pit0_isr:
        PUSH     {R7,LR}
//   24          DisableInterrupts;            //关总中断
        CPSID i         
//   25                                              
//   26          integration_piont = 20 - IntegrationTime; 
        LDR.N    R0,??pit0_isr_0
        LDRB     R0,[R0, #+0]
        RSBS     R0,R0,#+20
        LDR.N    R1,??pit0_isr_0+0x4
        STRB     R0,[R1, #+0]
//   27          if(integration_piont >= 2)   //曝光点小于2不进行再曝光                 
        LDR.N    R0,??pit0_isr_0+0x4
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCC.N    ??pit0_isr_1
//   28          {      
//   29             if(integration_piont == TimerCnt20ms) 
        LDR.N    R0,??pit0_isr_0+0x4
        LDRB     R0,[R0, #+0]
        LDR.N    R1,??pit0_isr_0+0x8
        LDRB     R1,[R1, #+0]
        CMP      R0,R1
        BNE.N    ??pit0_isr_1
//   30               StartIntegration();               
        BL       StartIntegration
//   31          }
//   32       
//   33          integration_piont_Right = 20 - IntegrationTime_Right;
??pit0_isr_1:
        LDR.N    R0,??pit0_isr_0+0xC
        LDRB     R0,[R0, #+0]
        RSBS     R0,R0,#+20
        LDR.N    R1,??pit0_isr_0+0x10
        STRB     R0,[R1, #+0]
//   34          if(integration_piont_Right >= 2)//曝光点小于2不进行再曝光                 
        LDR.N    R0,??pit0_isr_0+0x10
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCC.N    ??pit0_isr_2
//   35          {      
//   36             if(integration_piont_Right == TimerCnt20ms)
        LDR.N    R0,??pit0_isr_0+0x10
        LDRB     R0,[R0, #+0]
        LDR.N    R1,??pit0_isr_0+0x8
        LDRB     R1,[R1, #+0]
        CMP      R0,R1
        BNE.N    ??pit0_isr_2
//   37               StartIntegrationRight();              
        BL       StartIntegrationRight
//   38          }
//   39          
//   40          TimerCnt20ms++;
??pit0_isr_2:
        LDR.N    R0,??pit0_isr_0+0x8
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x8
        STRB     R0,[R1, #+0]
//   41          if(TimerCnt20ms>=20)
        LDR.N    R0,??pit0_isr_0+0x8
        LDRB     R0,[R0, #+0]
        CMP      R0,#+20
        BCC.N    ??pit0_isr_3
//   42          {   
//   43             TimerCnt20ms=0;
        LDR.N    R0,??pit0_isr_0+0x8
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   44             ImageCapture(Pixel);
        LDR.N    R0,??pit0_isr_0+0x14
        BL       ImageCapture
//   45             CalculateIntegrationTime();            
        BL       CalculateIntegrationTime
//   46             ImageCapture_1(Pixel_1);
        LDR.N    R0,??pit0_isr_0+0x18
        BL       ImageCapture_1
//   47             CalculateIntegrationTimeRight();            
        BL       CalculateIntegrationTimeRight
//   48             TIME1flag_20ms = 1;
        LDR.N    R0,??pit0_isr_0+0x1C
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//   49          }
//   50          //--------------------------------------------------------------------------
//   51          g_nSpeedControlPeriod ++;
??pit0_isr_3:
        LDR.N    R0,??pit0_isr_0+0x20
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x20
        STRB     R0,[R1, #+0]
//   52          SpeedControlOutput();          
        BL       SpeedControlOutput
//   53          g_nDirectionControlPeriod ++;
        LDR.N    R0,??pit0_isr_0+0x24
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x24
        STRB     R0,[R1, #+0]
//   54          DirectionControlOutput();
        BL       DirectionControlOutput
//   55          
//   56          g_n1MSEventCount ++;
        LDR.N    R0,??pit0_isr_0+0x28
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x28
        STRB     R0,[R1, #+0]
//   57          switch(g_n1MSEventCount)
        LDR.N    R0,??pit0_isr_0+0x28
        LDRB     R0,[R0, #+0]
        CMP      R0,#+1
        BEQ.N    ??pit0_isr_4
        BCC.N    ??pit0_isr_5
        CMP      R0,#+3
        BEQ.N    ??pit0_isr_6
        BCC.N    ??pit0_isr_7
        CMP      R0,#+5
        BEQ.N    ??pit0_isr_8
        BCC.N    ??pit0_isr_9
        B.N      ??pit0_isr_5
//   58          {
//   59          case 1:
//   60               get_ad();
??pit0_isr_4:
        BL       get_ad
//   61 	      AngleCalculate(); 
        BL       AngleCalculate
//   62               break;
        B.N      ??pit0_isr_5
//   63          case 2:
//   64               AngleControl();
??pit0_isr_7:
        BL       AngleControl
//   65               MotorOutput();//---1
        BL       MotorOutput
//   66               break;
        B.N      ??pit0_isr_5
//   67          case 3:
//   68               g_nSpeedControlCount ++;
??pit0_isr_6:
        LDR.N    R0,??pit0_isr_0+0x2C
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x2C
        STRB     R0,[R1, #+0]
//   69   	      if(g_nSpeedControlCount >= 20)
        LDR.N    R0,??pit0_isr_0+0x2C
        LDRB     R0,[R0, #+0]
        CMP      R0,#+20
        BCC.N    ??pit0_isr_10
//   70   	      {
//   71                  speedflag++;
        LDR.N    R0,??pit0_isr_0+0x30
        LDRH     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x30
        STRH     R0,[R1, #+0]
//   72   	         SpeedControl();
        BL       SpeedControl
//   73   		 g_nSpeedControlCount = 0;
        LDR.N    R0,??pit0_isr_0+0x2C
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   74   		 g_nSpeedControlPeriod = 0; 			
        LDR.N    R0,??pit0_isr_0+0x20
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   75   	      }
//   76               //MotorOutput();//---2
//   77               break;
??pit0_isr_10:
        B.N      ??pit0_isr_5
//   78          case 4:
//   79               g_nDirectionControlCount ++;
??pit0_isr_9:
        LDR.N    R0,??pit0_isr_0+0x34
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??pit0_isr_0+0x34
        STRB     R0,[R1, #+0]
//   80      	      if(g_nDirectionControlCount >=2)
        LDR.N    R0,??pit0_isr_0+0x34
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCC.N    ??pit0_isr_11
//   81 	      {
//   82 	         DirectionControl();
        BL       DirectionControl
//   83 	  	 g_nDirectionControlCount = 0;
        LDR.N    R0,??pit0_isr_0+0x34
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   84 	  	 g_nDirectionControlPeriod = 0;
        LDR.N    R0,??pit0_isr_0+0x24
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   85 	      }
//   86               //MotorOutput();//---3
//   87               break;
??pit0_isr_11:
        B.N      ??pit0_isr_5
//   88          case 5:
//   89               g_n1MSEventCount = 0;                  
??pit0_isr_8:
        LDR.N    R0,??pit0_isr_0+0x28
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   90               GetMotorPulse();
        BL       GetMotorPulse
//   91               break;        
//   92          }
//   93          
//   94 /*         
//   95            if(g_n1MSEventCount >=5)
//   96   	 {                                          
//   97            g_n1MSEventCount = 0;                  
//   98            GetMotorPulse();
//   99   	 }
//  100 
//  101   	 else if(g_n1MSEventCount == 1) 
//  102   	 {                                        
//  103              get_ad();
//  104 	     AngleCalculate();   
//  105   	 }
//  106         
//  107   	 else if(g_n1MSEventCount == 2) 
//  108   	 {    
//  109              AngleControl();
//  110              MotorOutput();                       		
//  111   	 }
//  112 
//  113  	 else if(g_n1MSEventCount == 3)
//  114   	 {                                      
//  115   	     g_nSpeedControlCount ++;
//  116   	     if(g_nSpeedControlCount >= 20)
//  117   	     {
//  118   	         SpeedControl();
//  119   		 g_nSpeedControlCount = 0;
//  120   		 g_nSpeedControlPeriod = 0;  			
//  121   	     }
//  122   	 } 
//  123 
//  124          else if(g_n1MSEventCount == 4)
//  125   	 {    
//  126              g_nDirectionControlCount ++;
//  127      	     if(g_nDirectionControlCount >=2)
//  128 	     {
//  129 	         DirectionControl();
//  130 	  	 g_nDirectionControlCount = 0;
//  131 	  	 g_nDirectionControlPeriod = 0;
//  132 	     }
//  133     	 }
//  134 */        
//  135          PIT_TFLG(0)|=PIT_TFLG_TIF_MASK;          //清中断标志位
??pit0_isr_5:
        LDR.N    R0,??pit0_isr_0+0x38  ;; 0x4003710c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??pit0_isr_0+0x38  ;; 0x4003710c
        STR      R0,[R1, #+0]
//  136          enable_pit_interrupt(0);
        MOVS     R0,#+0
        BL       enable_pit_interrupt
//  137          EnableInterrupts;                        //开总中断
        CPSIE i         
//  138 }
        POP      {R0,PC}          ;; return
        Nop      
        DATA
??pit0_isr_0:
        DC32     IntegrationTime
        DC32     integration_piont
        DC32     TimerCnt20ms
        DC32     IntegrationTime_Right
        DC32     integration_piont_Right
        DC32     Pixel
        DC32     Pixel_1
        DC32     TIME1flag_20ms
        DC32     g_nSpeedControlPeriod
        DC32     g_nDirectionControlPeriod
        DC32     g_n1MSEventCount
        DC32     g_nSpeedControlCount
        DC32     speedflag
        DC32     g_nDirectionControlCount
        DC32     0x4003710c

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
// 
// 263 bytes in section .bss
// 384 bytes in section .text
// 
// 384 bytes of CODE memory
// 263 bytes of DATA memory
//
//Errors: none
//Warnings: none
