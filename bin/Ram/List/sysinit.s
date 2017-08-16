///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      03/May/2013  23:26:18 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  C:\Users\hp\Desktop\balance                             /
//                    car\src\Sources\C\Frame_C\sysinit.c                     /
//    Command line =  "C:\Users\hp\Desktop\balance                            /
//                    car\src\Sources\C\Frame_C\sysinit.c" -D IAR -D          /
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
//    List file    =  C:\Users\hp\Desktop\balance car\bin\Ram\List\sysinit.s  /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME sysinit

        #define SHT_PROGBITS 0x1
        #define SHF_WRITE 0x1
        #define SHF_EXECINSTR 0x4

        PUBLIC core_clk_khz
        PUBLIC core_clk_mhz
        PUBLIC fb_clk_init
        PUBLIC periph_clk_khz
        PUBLIC pll_init
        PUBLIC set_sys_dividers
        PUBLIC sysinit
        PUBLIC trace_clk_init

// C:\Users\hp\Desktop\balance car\src\Sources\C\Frame_C\sysinit.c
//    1 //-------------------------------------------------------------------------*
//    2 // �ļ���:sysinit.c                                                        *
//    3 // ˵  ��: ϵͳ�����ļ�                                                    *
//    4 //-------------------------------------------------------------------------*
//    5 
//    6 #include "sysinit.h"	//ͷ�ļ�
//    7 
//    8 //ȫ�ֱ�������

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    9 int core_clk_khz;
core_clk_khz:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   10 int core_clk_mhz;
core_clk_mhz:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   11 int periph_clk_khz;
periph_clk_khz:
        DS8 4
//   12 
//   13 
//   14 
//   15 //-------------------------------------------------------------------------*
//   16 //������: sysinit                                                          *
//   17 //��  ��: ϵͳ����                                                         * 
//   18 //��  ��: ��						  	           *	
//   19 //��  ��: ��                                                               *
//   20 //˵  ��: ��                                                               *
//   21 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   22 void sysinit (void)
//   23 {
sysinit:
        PUSH     {R7,LR}
//   24     //ʹ��IO�˿�ʱ��    
//   25     SIM_SCGC5 |= (SIM_SCGC5_PORTA_MASK
//   26                               | SIM_SCGC5_PORTB_MASK
//   27                               | SIM_SCGC5_PORTC_MASK
//   28                               | SIM_SCGC5_PORTD_MASK
//   29                               | SIM_SCGC5_PORTE_MASK );
        LDR.N    R0,??DataTable3  ;; 0x40048038
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3E00
        LDR.N    R1,??DataTable3  ;; 0x40048038
        STR      R0,[R1, #+0]
//   30 
//   31     //����ϵͳʱ��
//   32     core_clk_mhz = pll_init(CORE_CLK_MHZ, REF_CLK);
        MOVS     R1,#+3
        MOVS     R0,#+2
        BL       pll_init
        LDR.N    R1,??DataTable3_1
        STR      R0,[R1, #+0]
//   33     //ͨ��pll_init�����ķ���ֵ�������ں�ʱ�Ӻ�����ʱ��
//   34     core_clk_khz = core_clk_mhz * 1000;
        LDR.N    R0,??DataTable3_1
        LDR      R0,[R0, #+0]
        MOV      R1,#+1000
        MULS     R0,R1,R0
        LDR.N    R1,??DataTable3_2
        STR      R0,[R1, #+0]
//   35     periph_clk_khz = core_clk_khz / (((SIM_CLKDIV1 & SIM_CLKDIV1_OUTDIV2_MASK) >> 24)+ 1);
        LDR.N    R0,??DataTable3_2
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable3_3  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+24,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable3_4
        STR      R0,[R1, #+0]
//   36     //ʹ�ܸ���ʱ�ӣ����ڵ���
//   37     trace_clk_init();	
        BL       trace_clk_init
//   38     //FlexBusʱ�ӳ�ʼ��
//   39     fb_clk_init();
        BL       fb_clk_init
//   40 
//   41 }
        POP      {R0,PC}          ;; return
//   42 
//   43 //-------------------------------------------------------------------------*
//   44 //������: trace_clk_init                                                   *
//   45 //��  ��: ����ʱ�ӳ�ʼ��                                                   * 
//   46 //��  ��: ��							  	   *	
//   47 //��  ��: ��                                                               *
//   48 //˵  ��: ���ڵ���                                                         *
//   49 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   50 void trace_clk_init(void)
//   51 {
//   52     //���ø���ʱ��Ϊ�ں�ʱ��
//   53     SIM_SOPT2 |= SIM_SOPT2_TRACECLKSEL_MASK;	
trace_clk_init:
        LDR.N    R0,??DataTable3_5  ;; 0x40048004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000
        LDR.N    R1,??DataTable3_5  ;; 0x40048004
        STR      R0,[R1, #+0]
//   54     //��PTA6������ʹ��TRACE_CLKOU����
//   55     PORTA_PCR6 = ( PORT_PCR_MUX(0x7));
        LDR.N    R0,??DataTable3_6  ;; 0x40049018
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//   56 }
        BX       LR               ;; return
//   57 
//   58 //-------------------------------------------------------------------------*
//   59 //������: fb_clk_init                                                      *
//   60 //��  ��: FlexBusʱ�ӳ�ʼ��                                                * 
//   61 //��  ��: ��								   *	
//   62 //��  ��: ��                                                               *
//   63 //˵  ��:                                                                  *
//   64 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   65 void fb_clk_init(void)
//   66 {
//   67     //ʹ��FlexBusģ��ʱ��
//   68     SIM_SCGC7 |= SIM_SCGC7_FLEXBUS_MASK;
fb_clk_init:
        LDR.N    R0,??DataTable3_7  ;; 0x40048040
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable3_7  ;; 0x40048040
        STR      R0,[R1, #+0]
//   69     //��PTA6������ʹ��FB_CLKOUT����
//   70     PORTC_PCR3 = ( PORT_PCR_MUX(0x5));
        LDR.N    R0,??DataTable3_8  ;; 0x4004b00c
        MOV      R1,#+1280
        STR      R1,[R0, #+0]
//   71 }
        BX       LR               ;; return
//   72 
//   73 //-------------------------------------------------------------------------*
//   74 //������: pll_init                                                         *
//   75 //��  ��: pll��ʼ��                                                        * 
//   76 //��  ��: clk_option:ʱ��ѡ��						   * 
//   77 //		  crystal_val:ʱ��ֵ                                       *	
//   78 //��  ��: ʱ��Ƶ��ֵ                                                       *
//   79 //˵  ��:                                                                  *
//   80 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   81 unsigned char pll_init(unsigned char clk_option, unsigned char crystal_val)
//   82 {
pll_init:
        PUSH     {R7,LR}
        MOVS     R2,R1
//   83     unsigned char pll_freq;
//   84     
//   85     if (clk_option > 3) {return 0;}   //���û��ѡ����õ�ѡ���򷵻�0
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+4
        BCC.N    ??pll_init_0
        MOVS     R0,#+0
        B.N      ??pll_init_1
//   86     if (crystal_val > 15) {return 1;} // ���������õľ���ѡ������򷵻�1
??pll_init_0:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+16
        BCC.N    ??pll_init_2
        MOVS     R0,#+1
        B.N      ??pll_init_1
//   87     
//   88     //���ﴦ��Ĭ�ϵ�FEIģʽ
//   89     //�����ƶ���FBEģʽ
//   90     #if (defined(K60_CLK) || defined(ASB817))
//   91              MCG_C2 = 0;
??pll_init_2:
        LDR.N    R2,??DataTable3_9  ;; 0x40064001
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//   92     #else
//   93              //ʹ���ⲿ����
//   94              MCG_C2 = MCG_C2_RANGE(2) | MCG_C2_HGO_MASK | MCG_C2_EREFS_MASK;
//   95     #endif
//   96     
//   97     //��ʼ��������ͷ�����״̬��������GPIO
//   98     SIM_SCGC4 |= SIM_SCGC4_LLWU_MASK;
        LDR.N    R2,??DataTable3_10  ;; 0x40048034
        LDR      R2,[R2, #+0]
        ORRS     R2,R2,#0x10000000
        LDR.N    R3,??DataTable3_10  ;; 0x40048034
        STR      R2,[R3, #+0]
//   99     LLWU_CS |= LLWU_CS_ACKISO_MASK;
        LDR.N    R2,??DataTable3_11  ;; 0x4007c008
        LDRB     R2,[R2, #+0]
        ORRS     R2,R2,#0x80
        LDR.N    R3,??DataTable3_11  ;; 0x4007c008
        STRB     R2,[R3, #+0]
//  100     
//  101     //ѡ���ⲿ���񣬲ο���Ƶ������IREFS�������ⲿ����
//  102     MCG_C1 = MCG_C1_CLKS(2) | MCG_C1_FRDIV(3);
        LDR.N    R2,??DataTable3_12  ;; 0x40064000
        MOVS     R3,#+152
        STRB     R3,[R2, #+0]
//  103     
//  104     //�ȴ������ȶ�	
//  105     #if (!defined(K60_CLK) && !defined(ASB817))
//  106     while (!(MCG_S & MCG_S_OSCINIT_MASK)){};  
//  107     #endif
//  108     
//  109     //�ȴ��ο�ʱ��״̬λ����
//  110     while (MCG_S & MCG_S_IREFST_MASK){}; 
??pll_init_3:
        LDR.N    R2,??DataTable3_13  ;; 0x40064006
        LDRB     R2,[R2, #+0]
        LSLS     R2,R2,#+27
        BMI.N    ??pll_init_3
//  111     //�ȴ�ʱ��״̬λ��ʾʱ��Դ�����ⲿ�ο�ʱ��
//  112     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x2){}; 
??pll_init_4:
        LDR.N    R2,??DataTable3_13  ;; 0x40064006
        LDRB     R2,[R2, #+0]
        UBFX     R2,R2,#+2,#+2
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+2
        BNE.N    ??pll_init_4
//  113     
//  114     //����FBEģʽ
//  115     #if (defined(K60_CLK))
//  116     MCG_C5 = MCG_C5_PRDIV(0x18);
        LDR.N    R2,??DataTable3_14  ;; 0x40064004
        MOVS     R3,#+24
        STRB     R3,[R2, #+0]
//  117     #else
//  118     
//  119     //����PLL��Ƶ����ƥ�����õľ���
//  120     MCG_C5 = MCG_C5_PRDIV(crystal_val); 
//  121     #endif
//  122     
//  123     //ȷ��MCG_C6���ڸ�λ״̬����ֹLOLIE��PLL����ʱ�ӿ���������PLL VCO��Ƶ��
//  124     MCG_C6 = 0x0;
        LDR.N    R2,??DataTable3_15  ;; 0x40064005
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//  125     //ѡ��PLL VCO��Ƶ����ϵͳʱ�ӷ�Ƶ��ȡ����ʱ��ѡ��
//  126     switch (clk_option) {
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??pll_init_5
        CMP      R0,#+2
        BEQ.N    ??pll_init_6
        BCC.N    ??pll_init_7
        CMP      R0,#+3
        BEQ.N    ??pll_init_8
        B.N      ??pll_init_9
//  127     case 0:
//  128       //����ϵͳ��Ƶ��
//  129       //MCG=PLL, core = MCG, bus = MCG, FlexBus = MCG, Flash clock= MCG/2
//  130       set_sys_dividers(0,0,0,1);
??pll_init_5:
        MOVS     R3,#+1
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       set_sys_dividers
//  131       //����VCO��Ƶ����ʹ��PLLΪ50MHz, LOLIE=0, PLLS=1, CME=0, VDIV=1
//  132       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(1); //VDIV = 1 (x25)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+65
        STRB     R1,[R0, #+0]
//  133       pll_freq = 50;
        MOVS     R1,#+50
//  134       break;
        B.N      ??pll_init_9
//  135     case 1:
//  136       //����ϵͳ��Ƶ��
//  137       //MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//  138       set_sys_dividers(0,1,1,3);
??pll_init_7:
        MOVS     R3,#+3
        MOVS     R2,#+1
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       set_sys_dividers
//  139       //����VCO��Ƶ����ʹ��PLLΪ100MHz, LOLIE=0, PLLS=1, CME=0, VDIV=26
//  140       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(26); //VDIV = 26 (x50)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+90
        STRB     R1,[R0, #+0]
//  141       pll_freq = 100;
        MOVS     R1,#+100
//  142       break;
        B.N      ??pll_init_9
//  143     case 2:
//  144       //����ϵͳ��Ƶ��
//  145       //MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//  146       set_sys_dividers(0,1,1,3);
??pll_init_6:
        MOVS     R3,#+3
        MOVS     R2,#+1
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       set_sys_dividers
//  147       //����VCO��Ƶ����ʹ��PLLΪ96MHz, LOLIE=0, PLLS=1, CME=0, VDIV=24
//  148       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(24); //VDIV = 24 (x48)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+88
        STRB     R1,[R0, #+0]
//  149       pll_freq = 96;
        MOVS     R1,#+96
//  150       break;
        B.N      ??pll_init_9
//  151     case 3:
//  152       //����ϵͳ��Ƶ��
//  153       //MCG=PLL, core = MCG, bus = MCG, FlexBus = MCG, Flash clock= MCG/2
//  154       set_sys_dividers(0,0,0,1);
??pll_init_8:
        MOVS     R3,#+1
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       set_sys_dividers
//  155       //����VCO��Ƶ����ʹ��PLLΪ48MHz, LOLIE=0, PLLS=1, CME=0, VDIV=0
//  156       MCG_C6 = MCG_C6_PLLS_MASK; //VDIV = 0 (x24)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+64
        STRB     R1,[R0, #+0]
//  157       pll_freq = 48;
        MOVS     R1,#+48
//  158       break;
//  159     }
//  160     while (!(MCG_S & MCG_S_PLLST_MASK)){}; // wait for PLL status bit to set
??pll_init_9:
        LDR.N    R0,??DataTable3_13  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BPL.N    ??pll_init_9
//  161     
//  162     while (!(MCG_S & MCG_S_LOCK_MASK)){}; // Wait for LOCK bit to set
??pll_init_10:
        LDR.N    R0,??DataTable3_13  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+25
        BPL.N    ??pll_init_10
//  163     
//  164     //����PBEģʽ
//  165     
//  166     //ͨ������CLKSλ������PEEģʽ
//  167     // CLKS=0, FRDIV=3, IREFS=0, IRCLKEN=0, IREFSTEN=0
//  168     MCG_C1 &= ~MCG_C1_CLKS_MASK;
        LDR.N    R0,??DataTable3_12  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x3F
        LDR.N    R2,??DataTable3_12  ;; 0x40064000
        STRB     R0,[R2, #+0]
//  169     
//  170     //�ȴ�ʱ��״̬λ����
//  171     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x3){};
??pll_init_11:
        LDR.N    R0,??DataTable3_13  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+3
        BNE.N    ??pll_init_11
//  172     
//  173     //��ʼ����PEEģʽ
//  174     
//  175     return pll_freq;
        MOVS     R0,R1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??pll_init_1:
        POP      {R1,PC}          ;; return
//  176 }

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_1:
        DC32     core_clk_mhz

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_2:
        DC32     core_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_3:
        DC32     0x40048044

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_4:
        DC32     periph_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_5:
        DC32     0x40048004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_6:
        DC32     0x40049018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_7:
        DC32     0x40048040

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_8:
        DC32     0x4004b00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_9:
        DC32     0x40064001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_10:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_11:
        DC32     0x4007c008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_12:
        DC32     0x40064000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_13:
        DC32     0x40064006

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_14:
        DC32     0x40064004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable3_15:
        DC32     0x40064005
//  177 
//  178 //-------------------------------------------------------------------------*
//  179 //������: set_sys_dividers                                                 *
//  180 //��  ��: ����ϵϵͳ��Ƶ��                                                 * 
//  181 //��  ��: Ԥ��Ƶֵ   							   *	
//  182 //��  ��: ��                                                               *
//  183 //˵  ��: �˺����������RAM��ִ�У�������������e2448����FLASHʱ�ӷ�Ƶ�ı�* 
//  184 //        ʱ�������ֹFLASH��Ԥȡ���ܡ���ʱ�ӷ�Ƶ�ı�֮�󣬱�����ʱһС��ʱ*
//  185 //	 ��ſ��Դ���ʹ��Ԥȡ���ܡ�                                        * 
//  186 //-------------------------------------------------------------------------*

        SECTION `.textrw`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, SHF_WRITE | SHF_EXECINSTR
        THUMB
//  187 __ramfunc void set_sys_dividers(uint32 outdiv1, uint32 outdiv2, uint32 outdiv3, uint32 outdiv4)
//  188 {
set_sys_dividers:
        PUSH     {R4-R6}
//  189     uint32 temp_reg;
//  190     uint8 i;
//  191     //����FMC_PFAPR��ǰ��ֵ
//  192     temp_reg = FMC_PFAPR;
        LDR.N    R4,??set_sys_dividers_0  ;; 0x4001f000
        LDR      R4,[R4, #+0]
//  193     
//  194     //ͨ��M&PFD��λM0PFD����ֹԤȡ����
//  195     FMC_PFAPR |= FMC_PFAPR_M7PFD_MASK | FMC_PFAPR_M6PFD_MASK | FMC_PFAPR_M5PFD_MASK
//  196                      | FMC_PFAPR_M4PFD_MASK | FMC_PFAPR_M3PFD_MASK | FMC_PFAPR_M2PFD_MASK
//  197                      | FMC_PFAPR_M1PFD_MASK | FMC_PFAPR_M0PFD_MASK;
        LDR.N    R5,??set_sys_dividers_0  ;; 0x4001f000
        LDR      R5,[R5, #+0]
        ORRS     R5,R5,#0xFF0000
        LDR.N    R6,??set_sys_dividers_0  ;; 0x4001f000
        STR      R5,[R6, #+0]
//  198     
//  199     //��ʱ�ӷ�Ƶ����������ֵ  
//  200     SIM_CLKDIV1 = SIM_CLKDIV1_OUTDIV1(outdiv1) | SIM_CLKDIV1_OUTDIV2(outdiv2) 
//  201                       | SIM_CLKDIV1_OUTDIV3(outdiv3) | SIM_CLKDIV1_OUTDIV4(outdiv4);
        LSLS     R1,R1,#+24
        ANDS     R1,R1,#0xF000000
        ORRS     R0,R1,R0, LSL #+28
        LSLS     R1,R2,#+20
        ANDS     R1,R1,#0xF00000
        ORRS     R0,R1,R0
        LSLS     R1,R3,#+16
        ANDS     R1,R1,#0xF0000
        ORRS     R0,R1,R0
        LDR.N    R1,??set_sys_dividers_0+0x4  ;; 0x40048044
        STR      R0,[R1, #+0]
//  202     
//  203     //�ȴ���Ƶ���ı�
//  204     for (i = 0 ; i < outdiv4 ; i++)
        MOVS     R0,#+0
        B.N      ??set_sys_dividers_1
??set_sys_dividers_2:
        ADDS     R0,R0,#+1
??set_sys_dividers_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,R3
        BCC.N    ??set_sys_dividers_2
//  205     {}
//  206     
//  207     //���´�FMC_PFAPR��ԭʼֵ
//  208     FMC_PFAPR = temp_reg; 
        LDR.N    R0,??set_sys_dividers_0  ;; 0x4001f000
        STR      R4,[R0, #+0]
//  209     
//  210     return;
        POP      {R4-R6}
        BX       LR               ;; return
        DATA
??set_sys_dividers_0:
        DC32     0x4001f000
        DC32     0x40048044
//  211 }

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  212 
//  213 
//  214 
//  215 
//  216 
//  217 
// 
//  12 bytes in section .bss
// 426 bytes in section .text
//  76 bytes in section .textrw
// 
// 502 bytes of CODE memory
//  12 bytes of DATA memory
//
//Errors: none
//Warnings: none
