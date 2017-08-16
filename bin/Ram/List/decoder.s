///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/May/2013  16:29:25 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  C:\Users\hp\Desktop\balance                             /
//                    car\src\Sources\C\Component_C\decoder.c                 /
//    Command line =  "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\C\Component_C\decoder.c" -D IAR -D      /
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
//    List file    =  C:\Users\hp\Desktop\balance car\bin\Ram\List\decoder.s  /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME decoder

        #define SHT_PROGBITS 0x1

        PUBLIC FTM_QUAD_init

// C:\Users\hp\Desktop\balance car\src\Sources\C\Component_C\decoder.c
//    1 #include "common.h"
//    2 #include  "decoder.h"
//    3 
//    4 
//    5 
//    6 /*==============================================================================
//    7 ���ܣ�FTM1��FTM2ģ��˫·�������������
//    8 ���ţ�PTA12��PTA13��PTB18��PTB19
//    9 ���ݣ���ʼ��FTM1��FTM2���������빦�ܣ�
//   10 ��������
//   11 ==============================================================================*/

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   12 void FTM_QUAD_init()
//   13 {
//   14    /*ʹ��FTM1��FTM2ʱ��*/
//   15   SIM_SCGC6|=SIM_SCGC6_FTM1_MASK;
FTM_QUAD_init:
        LDR.N    R0,??FTM_QUAD_init_0  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2000000
        LDR.N    R1,??FTM_QUAD_init_0  ;; 0x4004803c
        STR      R0,[R1, #+0]
//   16   SIM_SCGC3|=SIM_SCGC3_FTM2_MASK;
        LDR.N    R0,??FTM_QUAD_init_0+0x4  ;; 0x40048030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000000
        LDR.N    R1,??FTM_QUAD_init_0+0x4  ;; 0x40048030
        STR      R0,[R1, #+0]
//   17   /*�����˿�ʱ��*/
//   18  // SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
//   19   
//   20   /*ѡ��ܽŸ��ù���*/
//   21   PORTA_PCR12 = PORT_PCR_MUX(7);                          //�ض�оƬ��ʲô����
        LDR.N    R0,??FTM_QUAD_init_0+0x8  ;; 0x40049030
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//   22   PORTA_PCR13 = PORT_PCR_MUX(7);
        LDR.N    R0,??FTM_QUAD_init_0+0xC  ;; 0x40049034
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//   23  // PORTA_PCR10 = PORT_PCR_MUX(6);
//   24  // PORTA_PCR11 = PORT_PCR_MUX(6);
//   25   PORTB_PCR18 = PORT_PCR_MUX(6);
        LDR.N    R0,??FTM_QUAD_init_0+0x10  ;; 0x4004a048
        MOV      R1,#+1536
        STR      R1,[R0, #+0]
//   26   PORTB_PCR19 = PORT_PCR_MUX(6);
        LDR.N    R0,??FTM_QUAD_init_0+0x14  ;; 0x4004a04c
        MOV      R1,#+1536
        STR      R1,[R0, #+0]
//   27  
//   28   FTM1_MOD = 65535;                                        //�ɸ�����Ҫ����
        LDR.N    R0,??FTM_QUAD_init_0+0x18  ;; 0x40039008
        MOVW     R1,#+65535
        STR      R1,[R0, #+0]
//   29   FTM2_MOD = 65535;
        LDR.N    R0,??FTM_QUAD_init_0+0x1C  ;; 0x400b8008
        MOVW     R1,#+65535
        STR      R1,[R0, #+0]
//   30   FTM1_CNTIN = 0;
        LDR.N    R0,??FTM_QUAD_init_0+0x20  ;; 0x4003904c
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   31   FTM2_CNTIN = 0;
        LDR.N    R0,??FTM_QUAD_init_0+0x24  ;; 0x400b804c
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   32   FTM1_MODE |= FTM_MODE_WPDIS_MASK;                        //��ֹд����
        LDR.N    R0,??FTM_QUAD_init_0+0x28  ;; 0x40039054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??FTM_QUAD_init_0+0x28  ;; 0x40039054
        STR      R0,[R1, #+0]
//   33   FTM2_MODE |= FTM_MODE_WPDIS_MASK;                        //��ֹд����
        LDR.N    R0,??FTM_QUAD_init_0+0x2C  ;; 0x400b8054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??FTM_QUAD_init_0+0x2C  ;; 0x400b8054
        STR      R0,[R1, #+0]
//   34   FTM1_MODE |= FTM_MODE_FTMEN_MASK;                        //FTMEN=1,�ر�TPM����ģʽ������FTM���й���
        LDR.N    R0,??FTM_QUAD_init_0+0x28  ;; 0x40039054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x28  ;; 0x40039054
        STR      R0,[R1, #+0]
//   35   FTM2_MODE |= FTM_MODE_FTMEN_MASK;                        //FTMEN=1,�ر�TPM����ģʽ������FTM���й���
        LDR.N    R0,??FTM_QUAD_init_0+0x2C  ;; 0x400b8054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x2C  ;; 0x400b8054
        STR      R0,[R1, #+0]
//   36  
//   37   FTM1_QDCTRL |= FTM_QDCTRL_QUADEN_MASK;                   //ʹ����������ģʽ
        LDR.N    R0,??FTM_QUAD_init_0+0x30  ;; 0x40039080
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x30  ;; 0x40039080
        STR      R0,[R1, #+0]
//   38   FTM2_QDCTRL |= FTM_QDCTRL_QUADEN_MASK;                   //ʹ����������ģʽ
        LDR.N    R0,??FTM_QUAD_init_0+0x34  ;; 0x400b8080
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x34  ;; 0x400b8080
        STR      R0,[R1, #+0]
//   39   FTM2_QDCTRL &= ~FTM_QDCTRL_QUADMODE_MASK;                //ѡ������ģʽΪA����B�����ģʽ
        LDR.N    R0,??FTM_QUAD_init_0+0x34  ;; 0x400b8080
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x8
        LDR.N    R1,??FTM_QUAD_init_0+0x34  ;; 0x400b8080
        STR      R0,[R1, #+0]
//   40   FTM1_QDCTRL &= ~FTM_QDCTRL_QUADMODE_MASK;                //ѡ������ģʽΪA����B�����ģʽ
        LDR.N    R0,??FTM_QUAD_init_0+0x30  ;; 0x40039080
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x8
        LDR.N    R1,??FTM_QUAD_init_0+0x30  ;; 0x40039080
        STR      R0,[R1, #+0]
//   41   //FTM1_SC |= FTM_SC_CLKS(3);                               //ѡ���ⲿʱ��
//   42   // FTM1_CONF |=FTM_CONF_BDMMODE(3);                      //�ɸ�����Ҫѡ��
//   43  // FTM2_SC |= FTM_SC_CLKS(3);
//   44   // FTM2_CONF |=FTM_CONF_BDMMODE(3);
//   45   FTM1_CNT=0; 
        LDR.N    R0,??FTM_QUAD_init_0+0x38  ;; 0x40039004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   46   FTM2_CNT=0; 
        LDR.N    R0,??FTM_QUAD_init_0+0x3C  ;; 0x400b8004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   47 }
        BX       LR               ;; return
        Nop      
        DATA
??FTM_QUAD_init_0:
        DC32     0x4004803c
        DC32     0x40048030
        DC32     0x40049030
        DC32     0x40049034
        DC32     0x4004a048
        DC32     0x4004a04c
        DC32     0x40039008
        DC32     0x400b8008
        DC32     0x4003904c
        DC32     0x400b804c
        DC32     0x40039054
        DC32     0x400b8054
        DC32     0x40039080
        DC32     0x400b8080
        DC32     0x40039004
        DC32     0x400b8004

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//   48 
//   49 
//   50 
//   51 
//   52 
//   53 
//   54 
//   55 
//   56 
//   57 
//   58 
//   59 
//   60 
//   61 
//   62 
//   63 
//   64 
//   65 
//   66 
//   67 
//   68 
//   69 
//   70 
//   71 
//   72 
//   73 
//   74 
//   75 
//   76 /*************************************************************************
//   77 *  �������ƣ�FTM2_QUAD_DIR_init
//   78 *  ����˵������������ �������ģʽ��ʼ������
//   79 *  �������أ���
//   80 *  �޸�ʱ�䣺2012-1-26
//   81 *  ��    ע��
//   82              ������ʹ�� A10 ��A11 ����������Ϊ��ת�������� A���B �����롣 
//   83               B·���Ƽ���������  �ߵ�ƽʱ�������������
//   84               A·��������
//   85               ��B·Ĭ������
//   86 *************************************************************************/
//   87 /*void FTM_QUAD_DIR_init()
//   88 {
//   89    
//   90     SIM_SCGC6 |=SIM_SCGC6_FTM1_MASK;                             //ʹ��FTM1ʱ��
//   91     SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;                           //ʹ��FTM2ʱ��
//   92     
//   93     SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
//   94     SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
//   95     
//   96     PORT_PCR_REG(PORTA_BASE_PTR, 12) = (0|PORT_PCR_MUX(7)|0x10);     // PTA12
//   97     PORT_PCR_REG(PORTA_BASE_PTR, 13) = (0|PORT_PCR_MUX(7)|0x13);     // PTA13
//   98     PORT_PCR_REG(PORTB_BASE_PTR, 18) = PORT_PCR_MUX(6);              // PTB18
//   99     PORT_PCR_REG(PORTB_BASE_PTR, 19) = PORT_PCR_MUX(6);              // PTB19
//  100       
//  101     FTM_MODE_REG(FTM1_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //д������ֹ
//  102     FTM_QDCTRL_REG(FTM1_BASE_PTR)  &=~FTM_QDCTRL_QUADMODE_MASK;       //AB��ͬʱȷ������ͼ���ֵ
//  103     FTM_CNTIN_REG(FTM1_BASE_PTR)    = 0;                             //FTM1��������ʼֵΪ0
//  104     FTM_MOD_REG(FTM1_BASE_PTR)      = 0xFFFF;                        //FTM1��������ֵΪ0
//  105     
//  106     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //д������ֹ
//  107     FTM_QDCTRL_REG(FTM2_BASE_PTR)  &= ~FTM_QDCTRL_QUADMODE_MASK;     //AB ��������ģʽ
//  108     FTM_CNTIN_REG(FTM2_BASE_PTR)    = 0;                             //FTM��������ʼֵΪ0
//  109     FTM_MOD_REG(FTM2_BASE_PTR)      = 0xFFFF;                        //FTM��������ʼֵΪ0
//  110     
//  111     FTM_QDCTRL_REG(FTM1_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //ʹ��FTM1��������ģʽ
//  112     FTM_MODE_REG(FTM1_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;           //FTM1EN=1	
//  113     FTM_CNT_REG(FTM1_BASE_PTR)     = 0; 
//  114     
//  115     FTM_QDCTRL_REG(FTM2_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //ʹ��FTM2��������ģʽ
//  116     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;           //FTM2EN=1	
//  117     FTM_CNT_REG(FTM2_BASE_PTR)     = 0; 	
//  118 }*/
//  119 
//  120 
//  121 
//  122 
//  123 
//  124 
//  125 
//  126 
//  127 
//  128 
//  129 
//  130 
//  131 
//  132 
//  133 
//  134 
//  135 
//  136 
//  137 
//  138 
//  139 /*************************************************************************
//  140 *  �������ƣ�FTM2_init
//  141 *  ����˵������������ �������ģʽ��ʼ������
//  142 *  �������أ���
//  143 *  �޸�ʱ�䣺2012-1-26
//  144 *  ��    ע��CH0~CH3����ʹ�ù�������δ����⹦��
//  145              ������ʹ�� A10 ��A11 ����������Ϊ��ת�������� A���B �����롣 
//  146 *************************************************************************
//  147 void FTM_QUAD_init()
//  148 {
//  149     SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;                                 //ʹ��FTM2ʱ��
//  150 
//  151     SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
//  152     PORT_PCR_REG(PORTB_BASE_PTR, 18) = PORT_PCR_MUX(6);               // PTB18
//  153     PORT_PCR_REG(PORTB_BASE_PTR, 19) = PORT_PCR_MUX(6);               // PTB19
//  154        
//  155     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //д������ֹ
//  156     FTM_QDCTRL_REG(FTM2_BASE_PTR)  &= ~FTM_QDCTRL_QUADMODE_MASK;     //AB ��������ģʽ
//  157     FTM_CNTIN_REG(FTM2_BASE_PTR)    = 0;                             //FTM��������ʼֵΪ0
//  158     FTM_MOD_REG(FTM2_BASE_PTR)      = 0xFFFF;                        //FTM��������ʼֵΪ0
//  159    
//  160     FTM_QDCTRL_REG(FTM2_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //ʹ��FTM2��������ģʽ
//  161     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;                             //FTM2EN=1	
//  162     FTM_CNT_REG(FTM2_BASE_PTR)    = 0; 	
//  163 }*/
// 
// 260 bytes in section .text
// 
// 260 bytes of CODE memory
//
//Errors: none
//Warnings: none
