///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      03/May/2013  23:26:21 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  C:\Users\hp\Desktop\balance                             /
//                    car\src\Sources\C\Component_C\pit.c                     /
//    Command line =  "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\C\Component_C\pit.c" -D IAR -D          /
//                    TWR_K60N512 -lCN "C:\Users\hp\Desktop\balance           /
//                    car\bin\Ram\List\" -lB "C:\Users\hp\Desktop\balance     /
//                    car\bin\Ram\List\" -o "C:\Users\hp\Desktop\balance      /
//                    car\bin\Ram\Obj\" --no_cse --no_unroll --no_inline      /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    F:\iar\arm\INC\c\DLib_Config_Normal.h -I                /
//                    "C:\Users\hp\Desktop\balance car\src\Sources\H\" -I     /
//                    "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\H\Component_H\" -I                      /
//                    "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\H\Frame_H\" -Ol --use_c++_inline        /
//    List file    =  C:\Users\hp\Desktop\balance car\bin\Ram\List\pit.s      /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME pit

        #define SHT_PROGBITS 0x1

        EXTERN disable_irq
        EXTERN enable_irq

        PUBLIC disable_pit_interrupt
        PUBLIC enable_pit_interrupt
        PUBLIC hw_pit_init

// C:\Users\hp\Desktop\balance car\src\Sources\C\Component_C\pit.c
//    1 #include"pit.h"
//    2 
//    3 //==========================================================================
//    4 //函数名:     void hw_pit_init(uint8 pitno,uint32 timeout)
//    5 //功能:       配置pit定时器
//    6 //入口参数:   pitno:  表示pit通道号。
//    7 //                            0
//    8 //                            1
//    9 //                            2
//   10 //                            3
//   11 //            timeout:表示定时溢出开始递减的值
//   12 //            定时时间计算公式   定时=(timeout+1)/bus_clk
//   13 //出口参数:   无
//   14 //说明:       无       
//   15 //==========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   16 void hw_pit_init(uint8 pitno,uint32 timeout)
//   17     {
//   18       SIM_SCGC6|=SIM_SCGC6_PIT_MASK;              //使能PIT时钟
hw_pit_init:
        LDR.N    R2,??DataTable2  ;; 0x4004803c
        LDR      R2,[R2, #+0]
        ORRS     R2,R2,#0x800000
        LDR.N    R3,??DataTable2  ;; 0x4004803c
        STR      R2,[R3, #+0]
//   19       PIT_MCR&=~(PIT_MCR_MDIS_MASK);              //调试模式下禁止
        LDR.N    R2,??DataTable2_1  ;; 0x40037000
        LDR      R2,[R2, #+0]
        BICS     R2,R2,#0x2
        LDR.N    R3,??DataTable2_1  ;; 0x40037000
        STR      R2,[R3, #+0]
//   20       PIT_MCR|=PIT_MCR_FRZ_MASK;                  //使能PIT模块时钟
        LDR.N    R2,??DataTable2_1  ;; 0x40037000
        LDR      R2,[R2, #+0]
        ORRS     R2,R2,#0x1
        LDR.N    R3,??DataTable2_1  ;; 0x40037000
        STR      R2,[R3, #+0]
//   21       PIT_LDVAL(pitno)=timeout;                   //设置周期  1ms中断
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LSLS     R2,R0,#+4
        LDR.N    R3,??DataTable2_2  ;; 0x40037100
        STR      R1,[R2, R3]
//   22       PIT_TCTRL(pitno)|=PIT_TCTRL_TEN_MASK;       //使能pit模块运行
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable2_2  ;; 0x40037100
        ADDS     R1,R1,R0, LSL #+4
        LDR      R1,[R1, #+8]
        ORRS     R1,R1,#0x1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R2,??DataTable2_2  ;; 0x40037100
        ADDS     R2,R2,R0, LSL #+4
        STR      R1,[R2, #+8]
//   23       PIT_TCTRL(pitno)&=~(PIT_TCTRL_TIE_MASK);    //关pit中断
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable2_2  ;; 0x40037100
        ADDS     R1,R1,R0, LSL #+4
        LDR      R1,[R1, #+8]
        BICS     R1,R1,#0x2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R2,??DataTable2_2  ;; 0x40037100
        ADDS     R0,R2,R0, LSL #+4
        STR      R1,[R0, #+8]
//   24     }
        BX       LR               ;; return
//   25 
//   26 //==========================================================================
//   27 //函数名:    void enable_pit_interrupt(uint8 pitno)  
//   28 //功能:      开接收引脚的IRQ中断
//   29 //入口参数:  pitno: 表示pit通道号 
//   30 //                           0
//   31 //                           1
//   32 //                           2
//   33 //                           3
//   34 //出口参数:  无
//   35 //说明:      无                                                                                                     
//   36 //==========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   37     void enable_pit_interrupt(uint8 pitno)
//   38     {
enable_pit_interrupt:
        PUSH     {R7,LR}
//   39       PIT_TCTRL(pitno)|=(PIT_TCTRL_TIE_MASK); //开pit中断
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable2_2  ;; 0x40037100
        ADDS     R1,R1,R0, LSL #+4
        LDR      R1,[R1, #+8]
        ORRS     R1,R1,#0x2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R2,??DataTable2_2  ;; 0x40037100
        ADDS     R2,R2,R0, LSL #+4
        STR      R1,[R2, #+8]
//   40       switch(pitno)
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??enable_pit_interrupt_0
        CMP      R0,#+2
        BEQ.N    ??enable_pit_interrupt_1
        BCC.N    ??enable_pit_interrupt_2
        CMP      R0,#+3
        BEQ.N    ??enable_pit_interrupt_3
        B.N      ??enable_pit_interrupt_4
//   41       {
//   42       case 0:
//   43         enable_irq(68);			      //开接收引脚的IRQ中断
??enable_pit_interrupt_0:
        MOVS     R0,#+68
        BL       enable_irq
//   44         break;
        B.N      ??enable_pit_interrupt_4
//   45       case 1:
//   46         enable_irq(69);			      //开接收引脚的IRQ中断
??enable_pit_interrupt_2:
        MOVS     R0,#+69
        BL       enable_irq
//   47         break;
        B.N      ??enable_pit_interrupt_4
//   48       case 2:
//   49         enable_irq(70);			      //开接收引脚的IRQ中断
??enable_pit_interrupt_1:
        MOVS     R0,#+70
        BL       enable_irq
//   50         break;
        B.N      ??enable_pit_interrupt_4
//   51       case 3:
//   52         enable_irq(71);			      //开接收引脚的IRQ中断
??enable_pit_interrupt_3:
        MOVS     R0,#+71
        BL       enable_irq
//   53         break;
//   54       }
//   55     }
??enable_pit_interrupt_4:
        POP      {R0,PC}          ;; return
//   56 
//   57 //==========================================================================
//   58 //函数名:   void disable_pit_interrupt(uint8 pitno)
//   59 //功能:     开接收引脚的IRQ中断 
//   60 //入口参数: pitno: 表示pit通道号 
//   61 //                           0
//   62 //                           1
//   63 //                           2
//   64 //                           3
//   65 //出口参数: 无  
//   66 //说明:     无                                                                                                    
//   67 //==========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   68     void disable_pit_interrupt(uint8 pitno)
//   69     {
disable_pit_interrupt:
        PUSH     {R7,LR}
//   70       PIT_TCTRL(pitno)&=~(PIT_TCTRL_TIE_MASK);//关pit中断
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable2_2  ;; 0x40037100
        ADDS     R1,R1,R0, LSL #+4
        LDR      R1,[R1, #+8]
        BICS     R1,R1,#0x2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R2,??DataTable2_2  ;; 0x40037100
        ADDS     R2,R2,R0, LSL #+4
        STR      R1,[R2, #+8]
//   71       switch(pitno)
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??disable_pit_interrupt_0
        CMP      R0,#+2
        BEQ.N    ??disable_pit_interrupt_1
        BCC.N    ??disable_pit_interrupt_2
        CMP      R0,#+3
        BEQ.N    ??disable_pit_interrupt_3
        B.N      ??disable_pit_interrupt_4
//   72       {
//   73       case 0:
//   74         disable_irq(68);	              //关接收引脚的IRQ中断
??disable_pit_interrupt_0:
        MOVS     R0,#+68
        BL       disable_irq
//   75         break;
        B.N      ??disable_pit_interrupt_4
//   76       case 1:
//   77         disable_irq(69);		      //关接收引脚的IRQ中断
??disable_pit_interrupt_2:
        MOVS     R0,#+69
        BL       disable_irq
//   78         break;
        B.N      ??disable_pit_interrupt_4
//   79       case 2:
//   80         disable_irq(70);		      //关接收引脚的IRQ中断
??disable_pit_interrupt_1:
        MOVS     R0,#+70
        BL       disable_irq
//   81         break;
        B.N      ??disable_pit_interrupt_4
//   82       case 3:
//   83         disable_irq(71);		      //关接收引脚的IRQ中断
??disable_pit_interrupt_3:
        MOVS     R0,#+71
        BL       disable_irq
//   84         break;
//   85       }
//   86     }
??disable_pit_interrupt_4:
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2:
        DC32     0x4004803c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_1:
        DC32     0x40037000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_2:
        DC32     0x40037100

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
// 258 bytes in section .text
// 
// 258 bytes of CODE memory
//
//Errors: none
//Warnings: none
