///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      30/Sep/2013  20:34:02 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  D:\balance car（9.28高速但出赛道）\src\Sources\C\main.c /
//    Command line =  "D:\balance car（9.28高速但出赛道）\src\Sources\C\main. /
//                    c" -D IAR -D TWR_K60N512 -lCN "D:\balance               /
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
//    List file    =  D:\balance car（9.28高速但出赛道）\bin\Flash\List\main. /
//                    s                                                       /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME main

        #define SHT_PROGBITS 0x1

        EXTERN BlackManange
        EXTERN CCD_init
        EXTERN Clear
        EXTERN FTM_QUAD_init
        EXTERN GetOFFSET
        EXTERN GetSamplezhi
        EXTERN IntegrationTime
        EXTERN IntegrationTime_Right
        EXTERN KeyScan
        EXTERN KeyScan_1
        EXTERN LCD_Init
        EXTERN LCD_P8x16_number
        EXTERN LCD_show
        EXTERN Motor_init
        EXTERN Pixel
        EXTERN Pixel_1
        EXTERN StartIntegration
        EXTERN StartIntegrationRight
        EXTERN TIME1flag_20ms
        EXTERN __aeabi_d2iz
        EXTERN __aeabi_dmul
        EXTERN __aeabi_i2d
        EXTERN button_init
        EXTERN delay_ms
        EXTERN enable_pit_interrupt
        EXTERN getCCD
        EXTERN get_left
        EXTERN get_right
        EXTERN gravity
        EXTERN hw_adc_init
        EXTERN hw_pit_init
        EXTERN left_OFFSET
        EXTERN left_l
        EXTERN periph_clk_khz
        EXTERN right_OFFSET
        EXTERN right_l
        EXTERN uart_init

        PUBLIC a
        PUBLIC `b`
        PUBLIC integration_piont
        PUBLIC integration_piont_Right
        PUBLIC main
        PUBLIC system_init

// D:\balance car（9.28高速但出赛道）\src\Sources\C\main.c
//    1 //头文件
//    2 #include "includes.h"
//    3 
//    4 //全局变量声明
//    5 extern int   periph_clk_khz;
//    6 
//    7 extern int16 left_l;
//    8 extern int16 right_l;
//    9 extern int16 left_OFFSET;
//   10 extern int16 right_OFFSET;
//   11 extern uint8 IntegrationTime;
//   12 extern uint8 IntegrationTime_Right;

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   13 uint8        integration_piont;
integration_piont:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   14 uint8        integration_piont_Right;
integration_piont_Right:
        DS8 1
//   15 extern uint8 Pixel[128];
//   16 extern uint8 Pixel_1[128];
//   17 extern uint8 TIME1flag_20ms;
//   18 extern int16 gravity;

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   19 uint8        a=0;
a:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   20 uint8        b=0;
`b`:
        DS8 1
//   21 
//   22 void  system_init();
//   23 void  button_init();
//   24 //主函数

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   25 void main()
//   26 {
main:
        PUSH     {R7,LR}
//   27    vuint8  i,j;
//   28    uint8   *pixel_pt;
//   29  //  uint8   send_data_cnt = 0;
//   30    pixel_pt = Pixel;
        LDR.N    R0,??DataTable1
//   31    for(j=0; j<128+10; j++) 
        MOVS     R1,#+0
        STRB     R1,[SP, #+0]
        B.N      ??main_0
//   32    {
//   33       *pixel_pt++ = 0;
??main_1:
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
        ADDS     R0,R0,#+1
//   34    }   
        LDRB     R1,[SP, #+0]
        ADDS     R1,R1,#+1
        STRB     R1,[SP, #+0]
??main_0:
        LDRB     R1,[SP, #+0]
        CMP      R1,#+138
        BCC.N    ??main_1
//   35    pixel_pt = Pixel_1;
        LDR.N    R0,??DataTable1_1
//   36    for(j=0; j<128+10; j++) 
        MOVS     R1,#+0
        STRB     R1,[SP, #+0]
        B.N      ??main_2
//   37    {
//   38       *pixel_pt++ = 0;
??main_3:
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
        ADDS     R0,R0,#+1
//   39    }
        LDRB     R1,[SP, #+0]
        ADDS     R1,R1,#+1
        STRB     R1,[SP, #+0]
??main_2:
        LDRB     R1,[SP, #+0]
        CMP      R1,#+138
        BCC.N    ??main_3
//   40    
//   41    system_init();
        BL       system_init
//   42    /*  
//   43    serial_choose();
//   44    uart_send1(UART3 ,  gravity );        //PTC16接串口模块的uart3_RX，PTC17接串口模块的uart3_TX                                         
//   45    uart_send1(UART3 , gyro );  
//   46    */ 
//   47    while(1)                              //等待1ms中断
//   48    {
//   49      if(TIME1flag_20ms == 1)
??main_4:
        LDR.N    R0,??DataTable1_2
        LDRB     R0,[R0, #+0]
        CMP      R0,#+1
        BNE.N    ??main_4
//   50      {
//   51         TIME1flag_20ms = 0; 
        LDR.N    R0,??DataTable1_2
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//   52         get_left();
        BL       get_left
//   53         get_right();
        BL       get_right
//   54         BlackManange();        
        BL       BlackManange
//   55         LCD_show();
        BL       LCD_show
        B.N      ??main_4
//   56         
//   57 /*        if(++send_data_cnt >= 5)        //每100ms给CCDview发送数据 
//   58         {  
//   59            send_data_cnt =0;
//   60            SendImageData(Pixel);
//   61            //SendImageData(Pixel_1);
//   62         }
//   63 */        
//   64      }      
//   65    }
//   66 }
//   67 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   68 void system_init()
//   69 {
system_init:
        PUSH     {R3-R5,LR}
//   70     uint16 i,j;
//   71  
//   72     DisableInterrupts;                          //关闭总中断
        CPSID i         
//   73     
//   74     uart_init(UART3,periph_clk_khz,115200);     //串口初始化
        MOVS     R2,#+115200
        LDR.N    R0,??DataTable1_3
        LDR      R1,[R0, #+0]
        LDR.N    R0,??DataTable1_4  ;; 0x4006d000
        BL       uart_init
//   75     Motor_init();                               //电机初始化   pwm频率为10kHz
        BL       Motor_init
//   76     FTM_QUAD_init();                            //正交解码测速初始化
        BL       FTM_QUAD_init
//   77     CCD_init();
        BL       CCD_init
//   78     LCD_Init();                                 //OLED液晶初始化
        BL       LCD_Init
//   79     hw_adc_init(0);                             //ADC0初始化 直立控制信息采集
        MOVS     R0,#+0
        BL       hw_adc_init
//   80     button_init();
        BL       button_init
//   81         
//   82     for(;;)
//   83     {              
//   84       for(j=0;j<25;j++)
??system_init_0:
        MOVS     R4,#+0
        B.N      ??system_init_1
//   85       {
//   86          for(i=0;i<20;i++)
//   87          {
//   88             //delay_ms(2);
//   89             delay_ms(1);             
??system_init_2:
        MOVS     R0,#+1
        BL       delay_ms
//   90             integration_piont = 20 - IntegrationTime;            
        LDR.N    R0,??DataTable1_5
        LDRB     R0,[R0, #+0]
        RSBS     R0,R0,#+20
        LDR.N    R1,??DataTable1_6
        STRB     R0,[R1, #+0]
//   91             if(integration_piont >= 2)//曝光点小于2不进行再曝光                
        LDR.N    R0,??DataTable1_6
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCC.N    ??system_init_3
//   92             {      
//   93               if(integration_piont == i)           
        LDR.N    R0,??DataTable1_6
        LDRB     R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        UXTH     R5,R5            ;; ZeroExt  R5,R5,#+16,#+16
        CMP      R0,R5
        BNE.N    ??system_init_3
//   94               StartIntegration();                
        BL       StartIntegration
//   95             }
//   96             
//   97             integration_piont_Right = 20 - IntegrationTime_Right;
??system_init_3:
        LDR.N    R0,??DataTable1_7
        LDRB     R0,[R0, #+0]
        RSBS     R0,R0,#+20
        LDR.N    R1,??DataTable1_8
        STRB     R0,[R1, #+0]
//   98             if(integration_piont_Right >= 2)//曝光点小于2不进行再曝光                
        LDR.N    R0,??DataTable1_8
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCC.N    ??system_init_4
//   99             {      
//  100               if(integration_piont_Right == i)
        LDR.N    R0,??DataTable1_8
        LDRB     R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        UXTH     R5,R5            ;; ZeroExt  R5,R5,#+16,#+16
        CMP      R0,R5
        BNE.N    ??system_init_4
//  101               StartIntegrationRight();         
        BL       StartIntegrationRight
//  102             }
//  103          }
??system_init_4:
        ADDS     R5,R5,#+1
??system_init_5:
        UXTH     R5,R5            ;; ZeroExt  R5,R5,#+16,#+16
        CMP      R5,#+20
        BCC.N    ??system_init_2
//  104          getCCD();
        BL       getCCD
        ADDS     R4,R4,#+1
??system_init_1:
        UXTH     R4,R4            ;; ZeroExt  R4,R4,#+16,#+16
        CMP      R4,#+25
        BCS.N    ??system_init_6
        MOVS     R5,#+0
        B.N      ??system_init_5
//  105       }   
//  106       left_OFFSET=(int16)(left_l/25);//不合理，left或right可能为255，但可通过人为修正
??system_init_6:
        LDR.N    R0,??DataTable1_9
        LDRSH    R0,[R0, #+0]
        MOVS     R1,#+25
        SDIV     R0,R0,R1
        LDR.N    R1,??DataTable1_10
        STRH     R0,[R1, #+0]
//  107       right_OFFSET=(int16)(right_l/25);
        LDR.N    R0,??DataTable1_11
        LDRSH    R0,[R0, #+0]
        MOVS     R1,#+25
        SDIV     R0,R0,R1
        LDR.N    R1,??DataTable1_12
        STRH     R0,[R1, #+0]
//  108       LCD_P8x16_number(10,0,left_OFFSET);
        LDR.N    R0,??DataTable1_10
        LDRSH    R2,[R0, #+0]
        MOVS     R1,#+0
        MOVS     R0,#+10
        BL       LCD_P8x16_number
//  109       LCD_P8x16_number(70,0,right_OFFSET);
        LDR.N    R0,??DataTable1_12
        LDRSH    R2,[R0, #+0]
        MOVS     R1,#+0
        MOVS     R0,#+70
        BL       LCD_P8x16_number
//  110       left_l=0;
        LDR.N    R0,??DataTable1_9
        MOVS     R1,#+0
        STRH     R1,[R0, #+0]
//  111       right_l=0;
        LDR.N    R0,??DataTable1_11
        MOVS     R1,#+0
        STRH     R1,[R0, #+0]
//  112       
//  113       KeyScan();
        BL       KeyScan
//  114       if(a!=0)break;      
        LDR.N    R0,??DataTable1_13
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??system_init_0
//  115     }
//  116    for(;;)
//  117     {
//  118      // delay_ms(1000);
//  119     for(i=0;i<1000;i++)
??system_init_7:
        MOVS     R5,#+0
        B.N      ??system_init_8
//  120     {
//  121        GetSamplezhi();                          //采样电压值
??system_init_9:
        BL       GetSamplezhi
//  122     }
        ADDS     R5,R5,#+1
??system_init_8:
        MOV      R0,#+1000
        UXTH     R5,R5            ;; ZeroExt  R5,R5,#+16,#+16
        CMP      R5,R0
        BCC.N    ??system_init_9
//  123       GetOFFSET();
        BL       GetOFFSET
//  124       LCD_P8x16_number(70,4,(int16)(gravity*0.15));
        LDR.N    R0,??DataTable1_14
        LDRSH    R0,[R0, #+0]
        BL       __aeabi_i2d
        MOVS     R2,#+858993459
        LDR.N    R3,??DataTable1_15  ;; 0x3fc33333
        BL       __aeabi_dmul
        BL       __aeabi_d2iz
        MOVS     R2,R0
        SXTH     R2,R2            ;; SignExt  R2,R2,#+16,#+16
        MOVS     R1,#+4
        MOVS     R0,#+70
        BL       LCD_P8x16_number
//  125       Clear();
        BL       Clear
//  126       KeyScan_1();
        BL       KeyScan_1
//  127       if(b!=0)break;    
        LDR.N    R0,??DataTable1_16
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??system_init_7
//  128     }
//  129     hw_pit_init(0,60000);                       //配置pit定时器0,1ms中断(60000)
        MOVW     R1,#+60000
        MOVS     R0,#+0
        BL       hw_pit_init
//  130     enable_pit_interrupt(0);                    //开pit中断0通道
        MOVS     R0,#+0
        BL       enable_pit_interrupt
//  131     EnableInterrupts;                           //开启总中断
        CPSIE i         
//  132 }
        POP      {R0,R4,R5,PC}    ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1:
        DC32     Pixel

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_1:
        DC32     Pixel_1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_2:
        DC32     TIME1flag_20ms

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_3:
        DC32     periph_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_4:
        DC32     0x4006d000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_5:
        DC32     IntegrationTime

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_6:
        DC32     integration_piont

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_7:
        DC32     IntegrationTime_Right

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_8:
        DC32     integration_piont_Right

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_9:
        DC32     left_l

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_10:
        DC32     left_OFFSET

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_11:
        DC32     right_l

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_12:
        DC32     right_OFFSET

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_13:
        DC32     a

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_14:
        DC32     gravity

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_15:
        DC32     0x3fc33333

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_16:
        DC32     `b`

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
//   4 bytes in section .bss
// 504 bytes in section .text
// 
// 504 bytes of CODE memory
//   4 bytes of DATA memory
//
//Errors: none
//Warnings: none
