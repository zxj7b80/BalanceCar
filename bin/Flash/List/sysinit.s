///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      03/Jul/2013  01:12:44 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  D:\balance car_0607直立速度方向\src\Sources\C\Frame_C\s /
//                    ysinit.c                                                /
//    Command line =  "D:\balance car_0607直立速度方向\src\Sources\C\Frame_C\ /
//                    sysinit.c" -D IAR -D TWR_K60N512 -lCN "D:\balance       /
//                    car_0607直立速度方向\bin\Flash\List\" -lB "D:\balance   /
//                    car_0607直立速度方向\bin\Flash\List\" -o "D:\balance    /
//                    car_0607直立速度方向\bin\Flash\Obj\" --no_cse           /
//                    --no_unroll --no_inline --no_code_motion --no_tbaa      /
//                    --no_clustering --no_scheduling --debug                 /
//                    --endian=little --cpu=Cortex-M4 -e --fpu=None           /
//                    --dlib_config E:\IAREW6.3\arm\INC\c\DLib_Config_Normal. /
//                    h -I "D:\balance car_0607直立速度方向\src\Sources\H\"   /
//                    -I "D:\balance car_0607直立速度方向\src\Sources\H\Compo /
//                    nent_H\" -I "D:\balance car_0607直立速度方向\src\Source /
//                    s\H\Frame_H\" -Ol --use_c++_inline                      /
//    List file    =  D:\balance car_0607直立速度方向\bin\Flash\List\sysinit. /
//                    s                                                       /
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

// D:\balance car_0607直立速度方向\src\Sources\C\Frame_C\sysinit.c
//    1 //-------------------------------------------------------------------------*
//    2 // 文件名:sysinit.c                                                        *
//    3 // 说  明: 系统配置文件                                                    *
//    4 //-------------------------------------------------------------------------*
//    5 
//    6 #include "sysinit.h"	//头文件
//    7 
//    8 //全局变量声明

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
//   13 //-------------------------------------------------------------------------*
//   14 //函数名: sysinit                                                          *
//   15 //功  能: 系统设置                                                         * 
//   16 //参  数: 无						  	           *	
//   17 //返  回: 无                                                               *
//   18 //说  明: 无                                                               *
//   19 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   20 void sysinit (void)
//   21 {
sysinit:
        PUSH     {R7,LR}
//   22     //使能IO端口时钟    
//   23     SIM_SCGC5 |= (SIM_SCGC5_PORTA_MASK
//   24                               | SIM_SCGC5_PORTB_MASK
//   25                               | SIM_SCGC5_PORTC_MASK
//   26                               | SIM_SCGC5_PORTD_MASK
//   27                               | SIM_SCGC5_PORTE_MASK );
        LDR.N    R0,??DataTable3  ;; 0x40048038
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3E00
        LDR.N    R1,??DataTable3  ;; 0x40048038
        STR      R0,[R1, #+0]
//   28 
//   29     //开启系统时钟
//   30     core_clk_mhz = pll_init(CORE_CLK_MHZ, REF_CLK);
        MOVS     R1,#+16
        MOVS     R0,#+5
        BL       pll_init
        LDR.N    R1,??DataTable3_1
        STR      R0,[R1, #+0]
//   31     //通过pll_init函数的返回值来计算内核时钟和外设时钟
//   32     core_clk_khz = core_clk_mhz * 1000;
        LDR.N    R0,??DataTable3_1
        LDR      R0,[R0, #+0]
        MOV      R1,#+1000
        MULS     R0,R1,R0
        LDR.N    R1,??DataTable3_2
        STR      R0,[R1, #+0]
//   33     periph_clk_khz = core_clk_khz / (((SIM_CLKDIV1 & SIM_CLKDIV1_OUTDIV2_MASK) >> 24)+ 1);
        LDR.N    R0,??DataTable3_2
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable3_3  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+24,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable3_4
        STR      R0,[R1, #+0]
//   34     //使能跟踪时钟，用于调试
//   35     trace_clk_init();	
        BL       trace_clk_init
//   36     //FlexBus时钟初始化
//   37     fb_clk_init();
        BL       fb_clk_init
//   38 
//   39 }
        POP      {R0,PC}          ;; return
//   40 
//   41 //-------------------------------------------------------------------------*
//   42 //函数名: trace_clk_init                                                   *
//   43 //功  能: 跟踪时钟初始化                                                   * 
//   44 //参  数: 无							  	   *	
//   45 //返  回: 无                                                               *
//   46 //说  明: 用于调试                                                         *
//   47 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   48 void trace_clk_init(void)
//   49 {
//   50     //设置跟踪时钟为内核时钟
//   51     SIM_SOPT2 |= SIM_SOPT2_TRACECLKSEL_MASK;	
trace_clk_init:
        LDR.N    R0,??DataTable3_5  ;; 0x40048004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000
        LDR.N    R1,??DataTable3_5  ;; 0x40048004
        STR      R0,[R1, #+0]
//   52     //在PTA6引脚上使能TRACE_CLKOU功能
//   53     PORTA_PCR6 = ( PORT_PCR_MUX(0x7));
        LDR.N    R0,??DataTable3_6  ;; 0x40049018
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//   54 }
        BX       LR               ;; return
//   55 
//   56 //-------------------------------------------------------------------------*
//   57 //函数名: fb_clk_init                                                      *
//   58 //功  能: FlexBus时钟初始化                                                * 
//   59 //参  数: 无								   *	
//   60 //返  回: 无                                                               *
//   61 //说  明:                                                                  *
//   62 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   63 void fb_clk_init(void)
//   64 {
//   65     //使能FlexBus模块时钟
//   66     SIM_SCGC7 |= SIM_SCGC7_FLEXBUS_MASK;
fb_clk_init:
        LDR.N    R0,??DataTable3_7  ;; 0x40048040
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable3_7  ;; 0x40048040
        STR      R0,[R1, #+0]
//   67     //在PTA6引脚上使能FB_CLKOUT功能
//   68     PORTC_PCR3 = ( PORT_PCR_MUX(0x5));
        LDR.N    R0,??DataTable3_8  ;; 0x4004b00c
        MOV      R1,#+1280
        STR      R1,[R0, #+0]
//   69 }
        BX       LR               ;; return
//   70 
//   71 //-------------------------------------------------------------------------*
//   72 //函数名: pll_init                                                         *
//   73 //功  能: pll初始化                                                        * 
//   74 //参  数: clk_option:时钟选项						   * 
//   75 //		  crystal_val:时钟值                                       *	
//   76 //返  回: 时钟频率值                                                       *
//   77 //说  明:                                                                  *
//   78 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   79 unsigned char pll_init(unsigned char clk_option, unsigned char crystal_val)
//   80 {
pll_init:
        PUSH     {R7,LR}
        MOVS     R2,R1
//   81     unsigned char pll_freq;
//   82     
//   83     if (clk_option > 8) {return 0;}   //如果没有选择可用的选项则返回0
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+9
        BCC.N    ??pll_init_0
        MOVS     R0,#+0
        B.N      ??pll_init_1
//   84     if (crystal_val > 16) {return 1;} // 如果如果可用的晶体选项不可用则返回1
??pll_init_0:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+17
        BCC.N    ??pll_init_2
        MOVS     R0,#+1
        B.N      ??pll_init_1
//   85     
//   86     //这里处在默认的FEI模式
//   87     //首先移动到FBE模式
//   88     
//   89     #if (defined(K60_CLK))   
//   90              MCG_C2 = 0;
??pll_init_2:
        LDR.N    R2,??DataTable3_9  ;; 0x40064001
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//   91     #else
//   92     
//   93              //使能外部晶振
//   94              MCG_C2 = MCG_C2_RANGE(2) | MCG_C2_HGO_MASK | MCG_C2_EREFS_MASK;
//   95     #endif
//   96     
//   97     //初始化晶振后释放锁定状态的振荡器和GPIO
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
//  101     //选择外部晶振，参考分频器，清IREFS来启动外部晶振
//  102     MCG_C1 = MCG_C1_CLKS(2) | MCG_C1_FRDIV(3);
        LDR.N    R2,??DataTable3_12  ;; 0x40064000
        MOVS     R3,#+152
        STRB     R3,[R2, #+0]
//  103     
//  104     //等待晶振稳定	
//  105     #if (!defined(K60_CLK))
//  106     while (!(MCG_S & MCG_S_OSCINIT_MASK)){};  
//  107     #endif
//  108     
//  109     //等待参考时钟状态位清零
//  110     while (MCG_S & MCG_S_IREFST_MASK){}; 
??pll_init_3:
        LDR.N    R2,??DataTable3_13  ;; 0x40064006
        LDRB     R2,[R2, #+0]
        LSLS     R2,R2,#+27
        BMI.N    ??pll_init_3
//  111     //等待时钟状态位显示时钟源来自外部参考时钟
//  112     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x2){}; 
??pll_init_4:
        LDR.N    R2,??DataTable3_13  ;; 0x40064006
        LDRB     R2,[R2, #+0]
        UBFX     R2,R2,#+2,#+2
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+2
        BNE.N    ??pll_init_4
//  113     
//  114     //进入FBE模式
//  115     
//  116     #if (defined(K60_CLK))          //使用外部的50M晶振 
//  117   //MCG_C5 = MCG_C5_PRDIV(0x18);    //当然需要25分频，在本函数里没有XTAL50，所以搞了个K60_CLK，表示用了外部的50M
//  118   //MCG_C5 = MCG_C5_PRDIV(0x13);    //20分频，50M晶振，2.5M  
//  119   //MCG_C5 = MCG_C5_PRDIV(12);      //13分频  3.846M  150M时钟频率使用
//  120   //MCG_C5 = MCG_C5_PRDIV(3);       //外部使用的是8M晶振的状况   1:2分频  3:4分频
//  121     MCG_C5 = MCG_C5_PRDIV(0x0e);    //180M
        LDR.N    R2,??DataTable3_14  ;; 0x40064004
        MOVS     R3,#+14
        STRB     R3,[R2, #+0]
//  122   // MCG_C5 = MCG_C5_PRDIV(0x0C);    //207M
//  123   //MCG_C5 = MCG_C5_PRDIV(0x0b);    //225M
//  124     #else
//  125     
//  126     //配置PLL分频器来匹配所用的晶振
//  127     MCG_C5 = MCG_C5_PRDIV(crystal_val); 
//  128     #endif
//  129     
//  130     //确保MCG_C6处于复位状态，禁止LOLIE、PLL、和时钟控制器，清PLL VCO分频器
//  131     MCG_C6 = 0x0;
        LDR.N    R2,??DataTable3_15  ;; 0x40064005
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//  132     //选择PLL VCO分频器，系统时钟分频器取决于时钟选项
//  133     switch (clk_option) {
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??pll_init_5
        CMP      R0,#+2
        BEQ.N    ??pll_init_6
        BCC.N    ??pll_init_7
        CMP      R0,#+4
        BEQ.N    ??pll_init_8
        BCC.N    ??pll_init_9
        CMP      R0,#+6
        BEQ.N    ??pll_init_10
        BCC.N    ??pll_init_11
        CMP      R0,#+7
        BEQ.N    ??pll_init_12
        B.N      ??pll_init_13
//  134     case 0:
//  135       //设置系统分频器
//  136       //MCG=PLL, core = MCG, bus = MCG, FlexBus = MCG, Flash clock= MCG/2
//  137       set_sys_dividers(0,0,0,1);
??pll_init_5:
        MOVS     R3,#+1
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       set_sys_dividers
//  138       //设置VCO分频器，使能PLL为50MHz, LOLIE=0, PLLS=1, CME=0, VDIV=1
//  139       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(1); //VDIV = 1 (x25)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+65
        STRB     R1,[R0, #+0]
//  140       pll_freq = 50;
        MOVS     R1,#+50
//  141       break;
        B.N      ??pll_init_13
//  142     case 1:
//  143       //设置系统分频器
//  144       //MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//  145       set_sys_dividers(0,1,1,3);
??pll_init_7:
        MOVS     R3,#+3
        MOVS     R2,#+1
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       set_sys_dividers
//  146       //设置VCO分频器，使能PLL为100MHz, LOLIE=0, PLLS=1, CME=0, VDIV=26
//  147       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(26); //VDIV = 26 (x50)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+90
        STRB     R1,[R0, #+0]
//  148       pll_freq = 100;
        MOVS     R1,#+100
//  149       break;
        B.N      ??pll_init_13
//  150     case 2:
//  151       //设置系统分频器
//  152       //MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//  153       set_sys_dividers(0,1,1,3);
??pll_init_6:
        MOVS     R3,#+3
        MOVS     R2,#+1
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       set_sys_dividers
//  154       //设置VCO分频器，使能PLL为96MHz, LOLIE=0, PLLS=1, CME=0, VDIV=24
//  155       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(24); //VDIV = 24 (x48)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+88
        STRB     R1,[R0, #+0]
//  156       pll_freq =120;
        MOVS     R1,#+120
//  157       break;
        B.N      ??pll_init_13
//  158     case 3:
//  159       //设置系统分频器
//  160       //MCG=PLL, core = MCG, bus = MCG, FlexBus = MCG, Flash clock= MCG/2
//  161       set_sys_dividers(0,0,0,1);
??pll_init_9:
        MOVS     R3,#+1
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       set_sys_dividers
//  162       //设置VCO分频器，使能PLL为48MHz, LOLIE=0, PLLS=1, CME=0, VDIV=0
//  163       MCG_C6 = MCG_C6_PLLS_MASK; //VDIV = 0 (x24)
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+64
        STRB     R1,[R0, #+0]
//  164       pll_freq = 48;
        MOVS     R1,#+48
//  165       break;
        B.N      ??pll_init_13
//  166     case 4:
//  167       set_sys_dividers(0,2,2,5);  //core=150M, bus=50M, FlexBus=50M, Flash Clk=25M
??pll_init_8:
        MOVS     R3,#+5
        MOVS     R2,#+2
        MOVS     R1,#+2
        MOVS     R0,#+0
        BL       set_sys_dividers
//  168       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(15); //VDIV = 15 (3.846x39) 150MHz
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+79
        STRB     R1,[R0, #+0]
//  169       pll_freq = 150;
        MOVS     R1,#+150
//  170       break;
        B.N      ??pll_init_13
//  171     case 5:
//  172       set_sys_dividers(0,2,2,7);  //core=180M, bus=60M, FlexBus=60M, Flash Clk=30M
??pll_init_11:
        MOVS     R3,#+7
        MOVS     R2,#+2
        MOVS     R1,#+2
        MOVS     R0,#+0
        BL       set_sys_dividers
//  173       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(30); //VDIV = 15 (3.846x39) 150MHz
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+94
        STRB     R1,[R0, #+0]
//  174       pll_freq = 180;
        MOVS     R1,#+180
//  175       break;
        B.N      ??pll_init_13
//  176     case 6:
//  177       set_sys_dividers(0,2,2,7);  //core=180M, bus=60M, FlexBus=60M, Flash Clk=30M
??pll_init_10:
        MOVS     R3,#+7
        MOVS     R2,#+2
        MOVS     R1,#+2
        MOVS     R0,#+0
        BL       set_sys_dividers
//  178       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(30); //VDIV = 15 (3.846x39) 150MHz
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+94
        STRB     R1,[R0, #+0]
//  179       pll_freq = 207;
        MOVS     R1,#+207
//  180       break;
        B.N      ??pll_init_13
//  181     case 7:
//  182       set_sys_dividers(0,2,2,8);  //core=180M, bus=60M, FlexBus=60M, Flash Clk=30M
??pll_init_12:
        MOVS     R3,#+8
        MOVS     R2,#+2
        MOVS     R1,#+2
        MOVS     R0,#+0
        BL       set_sys_dividers
//  183       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(30); //VDIV = 15 (3.846x39) 150MHz
        LDR.N    R0,??DataTable3_15  ;; 0x40064005
        MOVS     R1,#+94
        STRB     R1,[R0, #+0]
//  184       pll_freq = 225;
        MOVS     R1,#+225
//  185       break;
//  186     }
//  187     while (!(MCG_S & MCG_S_PLLST_MASK)){}; // wait for PLL status bit to set
??pll_init_13:
        LDR.N    R0,??DataTable3_13  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BPL.N    ??pll_init_13
//  188     
//  189     while (!(MCG_S & MCG_S_LOCK_MASK)){}; // Wait for LOCK bit to set
??pll_init_14:
        LDR.N    R0,??DataTable3_13  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+25
        BPL.N    ??pll_init_14
//  190     
//  191     //进入PBE模式
//  192     
//  193     //通过清零CLKS位来进入PEE模式
//  194     // CLKS=0, FRDIV=3, IREFS=0, IRCLKEN=0, IREFSTEN=0
//  195     MCG_C1 &= ~MCG_C1_CLKS_MASK;
        LDR.N    R0,??DataTable3_12  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x3F
        LDR.N    R2,??DataTable3_12  ;; 0x40064000
        STRB     R0,[R2, #+0]
//  196     
//  197     //等待时钟状态位更新
//  198     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x3){};
??pll_init_15:
        LDR.N    R0,??DataTable3_13  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+3
        BNE.N    ??pll_init_15
//  199     
//  200     //开始进入PEE模式
//  201     
//  202     return pll_freq;
        MOVS     R0,R1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??pll_init_1:
        POP      {R1,PC}          ;; return
//  203 }

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
//  204 
//  205 //-------------------------------------------------------------------------*
//  206 //函数名: set_sys_dividers                                                 *
//  207 //功  能: 设置系系统分频器                                                 * 
//  208 //参  数: 预分频值   							   *	
//  209 //返  回: 无                                                               *
//  210 //说  明: 此函数必须放在RAM里执行，否则会产生错误e2448。当FLASH时钟分频改变* 
//  211 //        时，必须禁止FLASH的预取功能。在时钟分频改变之后，必须延时一小段时*
//  212 //	 间才可以从新使能预取功能。                                        * 
//  213 //-------------------------------------------------------------------------*

        SECTION `.textrw`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, SHF_WRITE | SHF_EXECINSTR
        THUMB
//  214 __ramfunc void set_sys_dividers(uint32 outdiv1, uint32 outdiv2, uint32 outdiv3, uint32 outdiv4)
//  215 {
set_sys_dividers:
        PUSH     {R4-R6}
//  216     uint32 temp_reg;
//  217     uint8 i;
//  218     //保存FMC_PFAPR当前的值
//  219     temp_reg = FMC_PFAPR;
        LDR.N    R4,??set_sys_dividers_0  ;; 0x4001f000
        LDR      R4,[R4, #+0]
//  220     
//  221     //通过M&PFD置位M0PFD来禁止预取功能
//  222     FMC_PFAPR |= FMC_PFAPR_M7PFD_MASK | FMC_PFAPR_M6PFD_MASK | FMC_PFAPR_M5PFD_MASK
//  223                      | FMC_PFAPR_M4PFD_MASK | FMC_PFAPR_M3PFD_MASK | FMC_PFAPR_M2PFD_MASK
//  224                      | FMC_PFAPR_M1PFD_MASK | FMC_PFAPR_M0PFD_MASK;
        LDR.N    R5,??set_sys_dividers_0  ;; 0x4001f000
        LDR      R5,[R5, #+0]
        ORRS     R5,R5,#0xFF0000
        LDR.N    R6,??set_sys_dividers_0  ;; 0x4001f000
        STR      R5,[R6, #+0]
//  225     
//  226     //给时钟分频器设置期望值  
//  227     SIM_CLKDIV1 = SIM_CLKDIV1_OUTDIV1(outdiv1) | SIM_CLKDIV1_OUTDIV2(outdiv2) 
//  228                       | SIM_CLKDIV1_OUTDIV3(outdiv3) | SIM_CLKDIV1_OUTDIV4(outdiv4);
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
//  229     
//  230     //等待分频器改变
//  231     for (i = 0 ; i < outdiv4 ; i++)
        MOVS     R0,#+0
        B.N      ??set_sys_dividers_1
??set_sys_dividers_2:
        ADDS     R0,R0,#+1
??set_sys_dividers_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,R3
        BCC.N    ??set_sys_dividers_2
//  232     {}
//  233     
//  234     //从新存FMC_PFAPR的原始值
//  235     FMC_PFAPR = temp_reg; 
        LDR.N    R0,??set_sys_dividers_0  ;; 0x4001f000
        STR      R4,[R0, #+0]
//  236     
//  237     return;
        POP      {R4-R6}
        BX       LR               ;; return
        DATA
??set_sys_dividers_0:
        DC32     0x4001f000
        DC32     0x40048044
//  238 }

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  239 
//  240 
//  241 
//  242 
//  243 
//  244 
// 
//  12 bytes in section .bss
// 526 bytes in section .text
//  76 bytes in section .textrw
// 
// 602 bytes of CODE memory
//  12 bytes of DATA memory
//
//Errors: none
//Warnings: none
