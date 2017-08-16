///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      19/Feb/2014  21:38:23 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  D:\FREESCALE���ܳ�����\freescale(��)\����\balance       /
//                    car�����ƣ�\src\Sources\C\Component_C\decoder.c         /
//    Command line =  "D:\FREESCALE���ܳ�����\freescale(��)\����\balance      /
//                    car�����ƣ�\src\Sources\C\Component_C\decoder.c" -D     /
//                    IAR -D TWR_K60N512 -lCN "D:\FREESCALE���ܳ�����\freesca /
//                    le(��)\����\balance car�����ƣ�\bin\Flash\List\" -lB    /
//                    "D:\FREESCALE���ܳ�����\freescale(��)\����\balance      /
//                    car�����ƣ�\bin\Flash\List\" -o                         /
//                    "D:\FREESCALE���ܳ�����\freescale(��)\����\balance      /
//                    car�����ƣ�\bin\Flash\Obj\" --no_cse --no_unroll        /
//                    --no_inline --no_code_motion --no_tbaa --no_clustering  /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    E:\IAREW6.3\arm\INC\c\DLib_Config_Normal.h -I           /
//                    "D:\FREESCALE���ܳ�����\freescale(��)\����\balance      /
//                    car�����ƣ�\src\Sources\H\" -I                          /
//                    "D:\FREESCALE���ܳ�����\freescale(��)\����\balance      /
//                    car�����ƣ�\src\Sources\H\Component_H\" -I              /
//                    "D:\FREESCALE���ܳ�����\freescale(��)\����\balance      /
//                    car�����ƣ�\src\Sources\H\Frame_H\" -Ol                 /
//                    --use_c++_inline                                        /
//    List file    =  D:\FREESCALE���ܳ�����\freescale(��)\����\balance       /
//                    car�����ƣ�\bin\Flash\List\decoder.s                    /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME decoder

        #define SHT_PROGBITS 0x1

        PUBLIC FTM_QUAD_init

// D:\FREESCALE���ܳ�����\freescale(��)\����\balance car�����ƣ�\src\Sources\C\Component_C\decoder.c
//    1 #include "common.h"
//    2 #include "decoder.h"
//    3 /*==============================================================================
//    4 ���ܣ�FTM1��FTM2ģ��˫·�����������
//    5 ���ţ�PTA12��PTA13��PTB18��PTB19
//    6 ���ݣ���ʼ��FTM1��FTM2���������빦��
//    7 ��������
//    8 ==============================================================================*/

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//    9 void FTM_QUAD_init()
//   10 {
//   11    /*ʹ��FTM1��FTM2ʱ��*/
//   12   SIM_SCGC6|=SIM_SCGC6_FTM1_MASK;
FTM_QUAD_init:
        LDR.N    R0,??FTM_QUAD_init_0  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2000000
        LDR.N    R1,??FTM_QUAD_init_0  ;; 0x4004803c
        STR      R0,[R1, #+0]
//   13   SIM_SCGC3|=SIM_SCGC3_FTM2_MASK;
        LDR.N    R0,??FTM_QUAD_init_0+0x4  ;; 0x40048030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000000
        LDR.N    R1,??FTM_QUAD_init_0+0x4  ;; 0x40048030
        STR      R0,[R1, #+0]
//   14   /*�����˿�ʱ��*/
//   15   SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
        LDR.N    R0,??FTM_QUAD_init_0+0x8  ;; 0x40048038
        LDR      R0,[R0, #+0]
        MOV      R1,#+512
        ORRS     R0,R1,R0
        LDR.N    R1,??FTM_QUAD_init_0+0x8  ;; 0x40048038
        STR      R0,[R1, #+0]
//   16   
//   17   /*ѡ��ܽŸ��ù���*/
//   18   PORTA_PCR12 = PORT_PCR_MUX(7);                          //�ض�оƬ��ʲô����
        LDR.N    R0,??FTM_QUAD_init_0+0xC  ;; 0x40049030
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//   19   PORTA_PCR13 = PORT_PCR_MUX(7);
        LDR.N    R0,??FTM_QUAD_init_0+0x10  ;; 0x40049034
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//   20 
//   21   PORTB_PCR18 = PORT_PCR_MUX(6);
        LDR.N    R0,??FTM_QUAD_init_0+0x14  ;; 0x4004a048
        MOV      R1,#+1536
        STR      R1,[R0, #+0]
//   22   PORTB_PCR19 = PORT_PCR_MUX(6);
        LDR.N    R0,??FTM_QUAD_init_0+0x18  ;; 0x4004a04c
        MOV      R1,#+1536
        STR      R1,[R0, #+0]
//   23  
//   24   FTM1_CNTIN = 0;                                          //FTM1��ʼֵ
        LDR.N    R0,??FTM_QUAD_init_0+0x1C  ;; 0x4003904c
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   25   FTM2_CNTIN = 0;
        LDR.N    R0,??FTM_QUAD_init_0+0x20  ;; 0x400b804c
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   26   FTM1_MOD = 65535;                                        //�ɸ�����Ҫ����
        LDR.N    R0,??FTM_QUAD_init_0+0x24  ;; 0x40039008
        MOVW     R1,#+65535
        STR      R1,[R0, #+0]
//   27   FTM2_MOD = 65535;                                        //����ֵ
        LDR.N    R0,??FTM_QUAD_init_0+0x28  ;; 0x400b8008
        MOVW     R1,#+65535
        STR      R1,[R0, #+0]
//   28   
//   29   FTM1_MODE |= FTM_MODE_WPDIS_MASK;                        //��ֹд����
        LDR.N    R0,??FTM_QUAD_init_0+0x2C  ;; 0x40039054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??FTM_QUAD_init_0+0x2C  ;; 0x40039054
        STR      R0,[R1, #+0]
//   30   FTM2_MODE |= FTM_MODE_WPDIS_MASK;                        //��ֹд����
        LDR.N    R0,??FTM_QUAD_init_0+0x30  ;; 0x400b8054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??FTM_QUAD_init_0+0x30  ;; 0x400b8054
        STR      R0,[R1, #+0]
//   31  
//   32   FTM1_QDCTRL|=FTM_QDCTRL_QUADMODE_MASK;                   //AB��ͬʱȷ������ͼ���ֵ  
        LDR.N    R0,??FTM_QUAD_init_0+0x34  ;; 0x40039080
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??FTM_QUAD_init_0+0x34  ;; 0x40039080
        STR      R0,[R1, #+0]
//   33   FTM2_QDCTRL|=FTM_QDCTRL_QUADMODE_MASK;                   //AB��ͬʱȷ������ͼ���ֵ  
        LDR.N    R0,??FTM_QUAD_init_0+0x38  ;; 0x400b8080
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??FTM_QUAD_init_0+0x38  ;; 0x400b8080
        STR      R0,[R1, #+0]
//   34  // FTM2_QDCTRL &= ~FTM_QDCTRL_QUADMODE_MASK;                //ѡ������ģʽΪA����B�����ģʽ
//   35   //FTM1_QDCTRL &= ~FTM_QDCTRL_QUADMODE_MASK;                //ѡ������ģʽΪA����B�����ģʽ
//   36   //FTM1_SC |= FTM_SC_CLKS(3);                               //ѡ���ⲿʱ��
//   37   // FTM1_CONF |=FTM_CONF_BDMMODE(3);                      //�ɸ�����Ҫѡ��
//   38  // FTM2_SC |= FTM_SC_CLKS(3);
//   39   // FTM2_CONF |=FTM_CONF_BDMMODE(3);
//   40   FTM1_QDCTRL |= FTM_QDCTRL_QUADEN_MASK;                   //ʹ����������ģʽ
        LDR.N    R0,??FTM_QUAD_init_0+0x34  ;; 0x40039080
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x34  ;; 0x40039080
        STR      R0,[R1, #+0]
//   41   FTM2_QDCTRL |= FTM_QDCTRL_QUADEN_MASK;                   //ʹ����������ģʽ
        LDR.N    R0,??FTM_QUAD_init_0+0x38  ;; 0x400b8080
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x38  ;; 0x400b8080
        STR      R0,[R1, #+0]
//   42   
//   43   FTM1_MODE |= FTM_MODE_FTMEN_MASK;                        //FTMEN=1,�ر�TPM����ģʽ������FTM���й���
        LDR.N    R0,??FTM_QUAD_init_0+0x2C  ;; 0x40039054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x2C  ;; 0x40039054
        STR      R0,[R1, #+0]
//   44   FTM2_MODE |= FTM_MODE_FTMEN_MASK;                        //FTMEN=1,�ر�TPM����ģʽ������FTM���й���
        LDR.N    R0,??FTM_QUAD_init_0+0x30  ;; 0x400b8054
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??FTM_QUAD_init_0+0x30  ;; 0x400b8054
        STR      R0,[R1, #+0]
//   45   
//   46   FTM1_CNT=0; 
        LDR.N    R0,??FTM_QUAD_init_0+0x3C  ;; 0x40039004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   47   FTM2_CNT=0; 
        LDR.N    R0,??FTM_QUAD_init_0+0x40  ;; 0x400b8004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   48 }
        BX       LR               ;; return
        DATA
??FTM_QUAD_init_0:
        DC32     0x4004803c
        DC32     0x40048030
        DC32     0x40048038
        DC32     0x40049030
        DC32     0x40049034
        DC32     0x4004a048
        DC32     0x4004a04c
        DC32     0x4003904c
        DC32     0x400b804c
        DC32     0x40039008
        DC32     0x400b8008
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
//   49 
//   50 
//   51 
//   52 /*************************************************************************
//   53 *  �������ƣ�FTM2_QUAD_DIR_init
//   54 *  ����˵������������ �������ģʽ��ʼ������
//   55 *  �������أ���
//   56 *  �޸�ʱ�䣺2012-1-26
//   57 *  ��    ע��
//   58              ������ʹ�� A10 ��A11 ����������Ϊ��ת�������� A���B �����롣 
//   59               B·���Ƽ���������  �ߵ�ƽʱ�������������
//   60               A·��������
//   61               ��B·Ĭ������
//   62 *************************************************************************/
//   63 /*void FTM_QUAD_DIR_init()
//   64 {
//   65    
//   66     SIM_SCGC6 |=SIM_SCGC6_FTM1_MASK;                             //ʹ��FTM1ʱ��
//   67     SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;                           //ʹ��FTM2ʱ��
//   68     
//   69     SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;
//   70     SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
//   71     
//   72     PORT_PCR_REG(PORTA_BASE_PTR, 12) = (0|PORT_PCR_MUX(7)|0x10);     // PTA12
//   73     PORT_PCR_REG(PORTA_BASE_PTR, 13) = (0|PORT_PCR_MUX(7)|0x13);     // PTA13
//   74     PORT_PCR_REG(PORTB_BASE_PTR, 18) = PORT_PCR_MUX(6);              // PTB18
//   75     PORT_PCR_REG(PORTB_BASE_PTR, 19) = PORT_PCR_MUX(6);              // PTB19
//   76       
//   77     FTM_MODE_REG(FTM1_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //д������ֹ
//   78     FTM_QDCTRL_REG(FTM1_BASE_PTR)  &=~FTM_QDCTRL_QUADMODE_MASK;       //AB��ͬʱȷ������ͼ���ֵ
//   79     FTM_CNTIN_REG(FTM1_BASE_PTR)    = 0;                             //FTM1��������ʼֵΪ0
//   80     FTM_MOD_REG(FTM1_BASE_PTR)      = 0xFFFF;                        //FTM1��������ֵΪ0
//   81     
//   82     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //д������ֹ
//   83     FTM_QDCTRL_REG(FTM2_BASE_PTR)  &= ~FTM_QDCTRL_QUADMODE_MASK;     //AB ��������ģʽ
//   84     FTM_CNTIN_REG(FTM2_BASE_PTR)    = 0;                             //FTM��������ʼֵΪ0
//   85     FTM_MOD_REG(FTM2_BASE_PTR)      = 0xFFFF;                        //FTM��������ʼֵΪ0
//   86     
//   87     FTM_QDCTRL_REG(FTM1_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //ʹ��FTM1��������ģʽ
//   88     FTM_MODE_REG(FTM1_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;           //FTM1EN=1	
//   89     FTM_CNT_REG(FTM1_BASE_PTR)     = 0; 
//   90     
//   91     FTM_QDCTRL_REG(FTM2_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //ʹ��FTM2��������ģʽ
//   92     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;           //FTM2EN=1	
//   93     FTM_CNT_REG(FTM2_BASE_PTR)     = 0; 	
//   94 }*/
//   95 
//   96 
//   97 
//   98 /*************************************************************************
//   99 *  �������ƣ�FTM2_init
//  100 *  ����˵������������ �������ģʽ��ʼ������
//  101 *  �������أ���
//  102 *  �޸�ʱ�䣺2012-1-26
//  103 *  ��    ע��CH0~CH3����ʹ�ù�������δ����⹦��
//  104              ������ʹ�� A10 ��A11 ����������Ϊ��ת�������� A���B �����롣 
//  105 *************************************************************************
//  106 void FTM_QUAD_init()
//  107 {
//  108     SIM_SCGC3 |= SIM_SCGC3_FTM2_MASK;                                 //ʹ��FTM2ʱ��
//  109 
//  110     SIM_SCGC5 |= SIM_SCGC5_PORTB_MASK;
//  111     PORT_PCR_REG(PORTB_BASE_PTR, 18) = PORT_PCR_MUX(6);               // PTB18
//  112     PORT_PCR_REG(PORTB_BASE_PTR, 19) = PORT_PCR_MUX(6);               // PTB19
//  113        
//  114     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_WPDIS_MASK;           //д������ֹ
//  115     FTM_QDCTRL_REG(FTM2_BASE_PTR)  &= ~FTM_QDCTRL_QUADMODE_MASK;     //AB ��������ģʽ
//  116     FTM_CNTIN_REG(FTM2_BASE_PTR)    = 0;                             //FTM��������ʼֵΪ0
//  117     FTM_MOD_REG(FTM2_BASE_PTR)      = 0xFFFF;                        //FTM��������ʼֵΪ0
//  118    
//  119     FTM_QDCTRL_REG(FTM2_BASE_PTR)  |=FTM_QDCTRL_QUADEN_MASK;         //ʹ��FTM2��������ģʽ
//  120     FTM_MODE_REG(FTM2_BASE_PTR)    |= FTM_MODE_FTMEN_MASK;                             //FTM2EN=1	
//  121     FTM_CNT_REG(FTM2_BASE_PTR)    = 0; 	
//  122 }*/
// 
// 276 bytes in section .text
// 
// 276 bytes of CODE memory
//
//Errors: none
//Warnings: none
