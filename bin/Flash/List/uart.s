///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      03/Jul/2013  01:12:45 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  D:\balance car_0607直立速度方向\src\Sources\C\Component /
//                    _C\uart.c                                               /
//    Command line =  "D:\balance car_0607直立速度方向\src\Sources\C\Componen /
//                    t_C\uart.c" -D IAR -D TWR_K60N512 -lCN "D:\balance      /
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
//    List file    =  D:\balance car_0607直立速度方向\bin\Flash\List\uart.s   /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME uart

        #define SHT_PROGBITS 0x1

        EXTERN delay_ms
        EXTERN disable_irq
        EXTERN enable_irq

        PUBLIC Uart_Test
        PUBLIC disableuartreint
        PUBLIC enableuartreint
        PUBLIC get_byte_array_from_number
        PUBLIC serial_choose
        PUBLIC uart3_send
        PUBLIC uart_init
        PUBLIC uart_re1
        PUBLIC uart_reN
        PUBLIC uart_send1
        PUBLIC uart_sendN
        PUBLIC uart_sendnumber
        PUBLIC uart_sendstring

// D:\balance car_0607直立速度方向\src\Sources\C\Component_C\uart.c
//    1 //-------------------------------------------------------------------------*
//    2 // 文件名: uart.c                                                          *
//    3 // 说  明: uart构件源文件                                                  *
//    4 //-------------------------------------------------------------------------*
//    5 
//    6 #include "uart.h"
//    7 extern   void delay_ms(uint32 count_val);
//    8 
//    9 //-------------------------------------------------------------------------*
//   10 //函数名: uart_init                                                        *
//   11 //功  能: 初始化uartx模块。                                                *
//   12 //参  数: uartch:串口号                                                    *
//   13 //        sysclk:系统总线时钟，以MHz为单位                                 *
//   14 //        baud:波特率，如9600，38400等，一般来说，速度越慢，通信越稳       *
//   15 //返  回: 无                                                               *
//   16 //说  明:                                                                  *
//   17 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   18 void uart_init (UART_MemMapPtr uartch, uint32 sysclk, uint32 baud)
//   19 {
uart_init:
        PUSH     {R4,R5}
//   20 	register uint16 sbr, brfa;
//   21 	uint8 temp;
//   22 
//   23 	//使能引脚
//   24 	if (uartch == UART0_BASE_PTR)
        LDR.W    R3,??DataTable2  ;; 0x4006a000
        CMP      R0,R3
        BNE.N    ??uart_init_0
//   25 	{
//   26 		//在PTD6上使能UART0_TXD功能
//   27 		PORTD_PCR6 = PORT_PCR_MUX(0x3);
        LDR.W    R3,??DataTable2_1  ;; 0x4004c018
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   28 		//在PTD7上使能UART0_RXD
//   29 		PORTD_PCR7 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_2  ;; 0x4004c01c
        MOV      R4,#+768
        STR      R4,[R3, #+0]
        B.N      ??uart_init_1
//   30 	}else if (uartch == UART1_BASE_PTR)
??uart_init_0:
        LDR.W    R3,??DataTable2_3  ;; 0x4006b000
        CMP      R0,R3
        BNE.N    ??uart_init_2
//   31 	{
//   32 		//在PTC4上使能UART1_TXD功能
//   33 		PORTC_PCR4 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_4  ;; 0x4004b010
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   34 		
//   35 		//在PTC3上使能UART1_RXD
//   36 		PORTC_PCR3 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_5  ;; 0x4004b00c
        MOV      R4,#+768
        STR      R4,[R3, #+0]
        B.N      ??uart_init_1
//   37 	}else if (uartch == UART2_BASE_PTR)
??uart_init_2:
        LDR.W    R3,??DataTable2_6  ;; 0x4006c000
        CMP      R0,R3
        BNE.N    ??uart_init_3
//   38 	{
//   39 		//在PTD3上使能UART2_TXD功能
//   40 		PORTD_PCR3 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_7  ;; 0x4004c00c
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   41 		//在PTD2上使能UART2_RXD
//   42 		PORTD_PCR2 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_8  ;; 0x4004c008
        MOV      R4,#+768
        STR      R4,[R3, #+0]
        B.N      ??uart_init_1
//   43 	}else if (uartch == UART3_BASE_PTR)
??uart_init_3:
        LDR.W    R3,??DataTable2_9  ;; 0x4006d000
        CMP      R0,R3
        BNE.N    ??uart_init_4
//   44 	{
//   45 		//在PTC17上使能UART3_TXD功能
//   46 		PORTC_PCR17 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_10  ;; 0x4004b044
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   47 		//在PTC16上使能UART3_RXD
//   48 		PORTC_PCR16 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_11  ;; 0x4004b040
        MOV      R4,#+768
        STR      R4,[R3, #+0]
        B.N      ??uart_init_1
//   49 	}else if (uartch == UART4_BASE_PTR)
??uart_init_4:
        LDR.W    R3,??DataTable2_12  ;; 0x400ea000
        CMP      R0,R3
        BNE.N    ??uart_init_5
//   50 	{
//   51 		//在PTE24上使能UART4_TXD功能
//   52 		PORTE_PCR24 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_13  ;; 0x4004d060
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   53 		//在PTE25上使能UART4_RXD
//   54 		PORTE_PCR25 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_14  ;; 0x4004d064
        MOV      R4,#+768
        STR      R4,[R3, #+0]
        B.N      ??uart_init_1
//   55 	}else if (uartch == UART5_BASE_PTR)
??uart_init_5:
        LDR.W    R3,??DataTable2_15  ;; 0x400eb000
        CMP      R0,R3
        BNE.N    ??uart_init_1
//   56 	{
//   57 		//在PTE8上使能UART5_TXD功能
//   58 		PORTE_PCR8 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_16  ;; 0x4004d020
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   59 		//在PTE9上使能UART5_RXD
//   60 		PORTE_PCR9 = PORT_PCR_MUX(0x3); 
        LDR.W    R3,??DataTable2_17  ;; 0x4004d024
        MOV      R4,#+768
        STR      R4,[R3, #+0]
//   61 	}
//   62 	 
//   63 	//使能串口时钟    
//   64 	if(uartch == UART0_BASE_PTR)
??uart_init_1:
        LDR.W    R3,??DataTable2  ;; 0x4006a000
        CMP      R0,R3
        BNE.N    ??uart_init_6
//   65 		SIM_SCGC4 |= SIM_SCGC4_UART0_MASK;
        LDR.W    R3,??DataTable2_18  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x400
        LDR.W    R4,??DataTable2_18  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_7
//   66 	else
//   67 		if (uartch == UART1_BASE_PTR)
??uart_init_6:
        LDR.W    R3,??DataTable2_3  ;; 0x4006b000
        CMP      R0,R3
        BNE.N    ??uart_init_8
//   68 			SIM_SCGC4 |= SIM_SCGC4_UART1_MASK;
        LDR.W    R3,??DataTable2_18  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x800
        LDR.W    R4,??DataTable2_18  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_7
//   69 		else
//   70 			if (uartch == UART2_BASE_PTR)
??uart_init_8:
        LDR.W    R3,??DataTable2_6  ;; 0x4006c000
        CMP      R0,R3
        BNE.N    ??uart_init_9
//   71 				SIM_SCGC4 |= SIM_SCGC4_UART2_MASK;
        LDR.W    R3,??DataTable2_18  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x1000
        LDR.W    R4,??DataTable2_18  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_7
//   72 			else
//   73 				if(uartch == UART3_BASE_PTR)
??uart_init_9:
        LDR.W    R3,??DataTable2_9  ;; 0x4006d000
        CMP      R0,R3
        BNE.N    ??uart_init_10
//   74 					SIM_SCGC4 |= SIM_SCGC4_UART3_MASK;
        LDR.W    R3,??DataTable2_18  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x2000
        LDR.W    R4,??DataTable2_18  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_7
//   75 				else
//   76 					if(uartch == UART4_BASE_PTR)
??uart_init_10:
        LDR.W    R3,??DataTable2_12  ;; 0x400ea000
        CMP      R0,R3
        BNE.N    ??uart_init_11
//   77 						SIM_SCGC1 |= SIM_SCGC1_UART4_MASK;
        LDR.W    R3,??DataTable2_19  ;; 0x40048028
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x400
        LDR.W    R4,??DataTable2_19  ;; 0x40048028
        STR      R3,[R4, #+0]
        B.N      ??uart_init_7
//   78 					else
//   79 						SIM_SCGC1 |= SIM_SCGC1_UART5_MASK;
??uart_init_11:
        LDR.W    R3,??DataTable2_19  ;; 0x40048028
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x800
        LDR.W    R4,??DataTable2_19  ;; 0x40048028
        STR      R3,[R4, #+0]
//   80 								
//   81 	//禁止发送接受
//   82 	UART_C2_REG(uartch) &= ~(UART_C2_TE_MASK
//   83 				| UART_C2_RE_MASK );
??uart_init_7:
        LDRB     R3,[R0, #+3]
        ANDS     R3,R3,#0xF3
        STRB     R3,[R0, #+3]
//   84 	
//   85 	//配置成8位无校验模式
//   86 	UART_C1_REG(uartch) = 0;
        MOVS     R3,#+0
        STRB     R3,[R0, #+2]
//   87 	
//   88 	//计算波特率，串口0、1使用内核时钟，其它串口使用外设时钟，系统时钟为
//   89 	//外设时钟的2倍
//   90 	if ((uartch == UART0_BASE_PTR) | (uartch == UART1_BASE_PTR))//
        LDR.N    R3,??DataTable2  ;; 0x4006a000
        CMP      R0,R3
        BEQ.N    ??uart_init_12
        MOVS     R3,#+0
        LDR.N    R4,??DataTable2_3  ;; 0x4006b000
        CMP      R0,R4
        BEQ.N    ??uart_init_12
        ORRS     R3,R3,#0x0
        UXTB     R3,R3            ;; ZeroExt  R3,R3,#+24,#+24
        CMP      R3,#+0
        BEQ.N    ??uart_init_13
//   91 		sysclk+=sysclk;
??uart_init_12:
        ADDS     R1,R1,R1
//   92 	
//   93 	sbr = (uint16)((sysclk*1000)/(baud * 16));
??uart_init_13:
        MOV      R3,#+1000
        MUL      R3,R3,R1
        LSLS     R4,R2,#+4
        UDIV     R3,R3,R4
//   94 	temp = UART_BDH_REG(uartch) & ~(UART_BDH_SBR(0x1F));
        LDRB     R4,[R0, #+0]
        ANDS     R4,R4,#0xE0
//   95 	UART_BDH_REG(uartch) = temp |  UART_BDH_SBR(((sbr & 0x1F00) >> 8));
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        LSRS     R5,R3,#+8
        ANDS     R5,R5,#0x1F
        ORRS     R4,R5,R4
        STRB     R4,[R0, #+0]
//   96 	UART_BDL_REG(uartch) = (uint8)(sbr & UART_BDL_SBR_MASK);
        STRB     R3,[R0, #+1]
//   97 	brfa = (((sysclk*32000)/(baud * 16)) - (sbr * 32));
        MOV      R4,#+32000
        MULS     R1,R4,R1
        LSLS     R2,R2,#+4
        UDIV     R1,R1,R2
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        SUBS     R1,R1,R3, LSL #+5
//   98 	temp = UART_C4_REG(uartch) & ~(UART_C4_BRFA(0x1F));
        LDRB     R2,[R0, #+10]
        ANDS     R4,R2,#0xE0
//   99 	UART_C4_REG(uartch) = temp |  UART_C4_BRFA(brfa);    
        ANDS     R1,R1,#0x1F
        ORRS     R1,R1,R4
        STRB     R1,[R0, #+10]
//  100 	
//  101 	//使能发送接受
//  102 	UART_C2_REG(uartch) |= (UART_C2_TE_MASK
//  103 				| UART_C2_RE_MASK );
        LDRB     R1,[R0, #+3]
        ORRS     R1,R1,#0xC
        STRB     R1,[R0, #+3]
//  104 }
        POP      {R4,R5}
        BX       LR               ;; return
//  105 
//  106 //-------------------------------------------------------------------------*
//  107 //函数名: uart_re1                                                         *
//  108 //功  能: 串行接受1个字节                                                  *
//  109 //参  数: uartch: 串口号                                                   *
//  110 //         ch:    接收到的字节                                             *
//  111 //返  回: 成功:1;失败:0                                                    *
//  112 //说  明:                                                                  *
//  113 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  114 uint8 uart_re1 (UART_MemMapPtr uartch,uint8 *ch)
//  115 {
//  116     uint32 k;
//  117     
//  118     for (k = 0; k < 0xfbbb; k++)//有时间限制
uart_re1:
        MOVS     R2,#+0
        B.N      ??uart_re1_0
??uart_re1_1:
        ADDS     R2,R2,#+1
??uart_re1_0:
        MOVW     R3,#+64443
        CMP      R2,R3
        BCS.N    ??uart_re1_2
//  119 		if((UART_S1_REG(uartch) & UART_S1_RDRF_MASK)!= 0)//判断接收缓冲区是否满
        LDRB     R3,[R0, #+4]
        LSLS     R3,R3,#+26
        BPL.N    ??uart_re1_1
//  120 		{
//  121 			*ch = UART_D_REG(uartch);
        LDRB     R0,[R0, #+7]
        STRB     R0,[R1, #+0]
//  122 			return 1; 			//接受成功
        MOVS     R0,#+1
        B.N      ??uart_re1_3
//  123 		} 
//  124 	if(k>=0xfbbb) 
??uart_re1_2:
        MOVW     R0,#+64443
        CMP      R2,R0
        BCC.N    ??uart_re1_4
//  125 	{
//  126 		return 0;			//接受失败
        MOVS     R0,#+0
        B.N      ??uart_re1_3
//  127 	} 
//  128     return 0;
??uart_re1_4:
        MOVS     R0,#+0
??uart_re1_3:
        BX       LR               ;; return
//  129 }
//  130 
//  131 //-------------------------------------------------------------------------*
//  132 //函数名: uart_send1                                                       *
//  133 //功  能: 串行发送1个字节                                                  *
//  134 //参  数: uartch: 串口号                                                   *
//  135 //         ch:    要发送的字节                                             *
//  136 //返  回: 无                                                               *
//  137 //说  明:                                                                  *
//  138 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  139 void uart_send1 (UART_MemMapPtr uartch, uint8 ch)
//  140 {
//  141     //等待发送缓冲区空
//  142     while(!(UART_S1_REG(uartch) & UART_S1_TDRE_MASK));
uart_send1:
??uart_send1_0:
        LDRB     R2,[R0, #+4]
        LSLS     R2,R2,#+24
        BPL.N    ??uart_send1_0
//  143     //发送数据
//  144     UART_D_REG(uartch) = (uint8)ch;
        STRB     R1,[R0, #+7]
//  145  }
        BX       LR               ;; return
//  146 
//  147 //-------------------------------------------------------------------------*
//  148 //函数名: uart_reN                                                         *
//  149 //功  能: 串行 接收n个字节                                                 *
//  150 //参  数: uartch: 串口号                                                   *
//  151 //        buff: 接收缓冲区                                                 *
//  152 //		  len:接收长度                                             *
//  153 //返  回: 1:成功;0:失败                                                    *
//  154 //说  明:                                                                  *
//  155 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  156 uint8 uart_reN (UART_MemMapPtr uartch ,uint8* buff,uint16 len)
//  157 {
uart_reN:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
//  158     uint16 m=0; 
        MOVS     R7,#+0
        B.N      ??uart_reN_0
//  159     while (m < len)
//  160     { 	          
//  161   	    if(0==uart_re1(uartch,&buff[m]))
//  162   	    	return 0;  //接收失败
//  163   	    else m++;
??uart_reN_1:
        ADDS     R7,R7,#+1
??uart_reN_0:
        UXTH     R7,R7            ;; ZeroExt  R7,R7,#+16,#+16
        UXTH     R6,R6            ;; ZeroExt  R6,R6,#+16,#+16
        CMP      R7,R6
        BCS.N    ??uart_reN_2
        UXTH     R7,R7            ;; ZeroExt  R7,R7,#+16,#+16
        ADDS     R1,R7,R5
        MOVS     R0,R4
        BL       uart_re1
        CMP      R0,#+0
        BNE.N    ??uart_reN_1
        MOVS     R0,#+0
        B.N      ??uart_reN_3
//  164     } 
//  165     
//  166     return 1;          //接收成功
??uart_reN_2:
        MOVS     R0,#+1
??uart_reN_3:
        POP      {R1,R4-R7,PC}    ;; return
//  167     
//  168 }
//  169 
//  170 //-------------------------------------------------------------------------*
//  171 //函数名: uart_sendN                                                       *
//  172 //功  能: 串行 接收n个字节                                                 *
//  173 //参  数: uartch: 串口号                                                   *
//  174 //        buff: 发送缓冲区                                                 *
//  175 //		  len:发送长度                                             *
//  176 //返  回: 无                                                               *
//  177 //说  明:                                                                  *
//  178 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  179 void uart_sendN (UART_MemMapPtr uartch ,uint8* buff,uint16 len)
//  180 {
uart_sendN:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
//  181     int i;
//  182 	for(i=0;i<len;i++)
        MOVS     R7,#+0
        B.N      ??uart_sendN_0
//  183     {
//  184 		uart_send1(uartch,buff[i]);
??uart_sendN_1:
        LDRB     R1,[R7, R5]
        MOVS     R0,R4
        BL       uart_send1
//  185     }
        ADDS     R7,R7,#+1
??uart_sendN_0:
        UXTH     R6,R6            ;; ZeroExt  R6,R6,#+16,#+16
        CMP      R7,R6
        BLT.N    ??uart_sendN_1
//  186 }
        POP      {R0,R4-R7,PC}    ;; return
//  187 
//  188 //-------------------------------------------------------------------------*
//  189 //函数名: enableuartreint                                                  *
//  190 //功  能: 开串口接收中断                                                   *
//  191 //参  数: uartch: 串口号                                                   *
//  192 //        irqno: 对应irq号                                                 *
//  193 //返  回: 无                                                               *
//  194 //说  明:                                                                  *
//  195 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  196 void enableuartreint(UART_MemMapPtr uartch,uint8 irqno)
//  197 {
enableuartreint:
        PUSH     {R7,LR}
//  198 	UART_C2_REG(uartch)|=UART_C2_RIE_MASK;   //开放UART接收中断
        LDRB     R2,[R0, #+3]
        ORRS     R2,R2,#0x20
        STRB     R2,[R0, #+3]
//  199 	enable_irq(irqno);			 //开接收引脚的IRQ中断
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        MOVS     R0,R1
        BL       enable_irq
//  200 }
        POP      {R0,PC}          ;; return
//  201 
//  202 //-------------------------------------------------------------------------*
//  203 //函数名: disableuartreint                                                 *
//  204 //功  能: 关串口接收中断                                                   *
//  205 //参  数: uartch: 串口号                                                   *
//  206 //        irqno: 对应irq号                                                 *
//  207 //返  回: 无                                                               *
//  208 //说  明:                                                                  *
//  209 //-------------------------------------------------------------------------*

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  210 void disableuartreint(UART_MemMapPtr uartch,uint8 irqno)
//  211 {
disableuartreint:
        PUSH     {R7,LR}
//  212 	UART_C2_REG(uartch)&=~UART_C2_RIE_MASK;   //禁止UART接收中断
        LDRB     R2,[R0, #+3]
        ANDS     R2,R2,#0xDF
        STRB     R2,[R0, #+3]
//  213 	disable_irq(irqno);			  //关接收引脚的IRQ中断
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        MOVS     R0,R1
        BL       disable_irq
//  214 }
        POP      {R0,PC}          ;; return
//  215 
//  216 
//  217 
//  218 
//  219 //-------------------------------------------------------------------------
//  220 //函数名称：hw_uart_sendstring                                               
//  221 //功能概要：关串口接收中断                                                   
//  222 //参数说明：uartch: 串口号                                                   
//  223 //           buff: 要发送的值                                                 
//  224 //函数返回： 无                                                               
//  225 //-------------------------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  226 void uart_sendstring (UART_MemMapPtr uartch ,uint8* buff)
//  227 {
uart_sendstring:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
        MOVS     R5,R1
//  228     int i;
//  229 
//  230     for(i=0;buff[i] != 0;i++)
        MOVS     R6,#+0
        B.N      ??uart_sendstring_0
//  231     {
//  232        uart_send1(uartch,buff[i]);
??uart_sendstring_1:
        LDRB     R1,[R6, R5]
        MOVS     R0,R4
        BL       uart_send1
//  233     }
        ADDS     R6,R6,#+1
??uart_sendstring_0:
        LDRB     R0,[R6, R5]
        CMP      R0,#+0
        BNE.N    ??uart_sendstring_1
//  234 }
        POP      {R4-R6,PC}       ;; return
//  235 //-------------------------------------------------------------------------
//  236 //函数名称：hw_get_byte_array_from_number                                               
//  237 //功能概要：将数组number转换成ASCII码的形式放到数组中                                                
//  238 //参数说明：number: 要转换的数字                                                   
//  239 //          length: 长度        
//  240 //           array: 转换完的结果数组
//  241 //函数返回： 无                                                               
//  242 //-------------------------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  243 uint8 get_byte_array_from_number(uint8 array [], int * length, int number)
//  244 {
get_byte_array_from_number:
        PUSH     {R1-R5}
//  245     int i = 0;
        MOVS     R3,#+0
//  246     int j = 0;
        MOVS     R4,#+0
//  247     uint8 pBuff [10];
//  248     if(number < 0)
        CMP      R2,#+0
        BPL.N    ??get_byte_array_from_number_0
//  249     {
//  250         return 1;
        MOVS     R0,#+1
        B.N      ??get_byte_array_from_number_1
//  251     }
//  252     i = 0;
??get_byte_array_from_number_0:
        MOVS     R3,#+0
//  253     if(number == 0) //如果数字是0
        CMP      R2,#+0
        BNE.N    ??get_byte_array_from_number_2
//  254     {
//  255         i = 1;
        MOVS     R3,#+1
//  256         *length = i;
        STR      R3,[R1, #+0]
//  257         array[0] = '0';
        MOVS     R1,#+48
        STRB     R1,[R0, #+0]
//  258         return 0;
        MOVS     R0,#+0
        B.N      ??get_byte_array_from_number_1
//  259     }
//  260     
//  261     while(number > 0)
//  262     {
//  263         pBuff[i++] = number % 10;
??get_byte_array_from_number_3:
        MOVS     R4,#+10
        SDIV     R5,R2,R4
        MLS      R4,R4,R5,R2
        ADD      R5,SP,#+0
        STRB     R4,[R3, R5]
        ADDS     R3,R3,#+1
//  264         number = number/10; 
        MOVS     R4,#+10
        SDIV     R2,R2,R4
//  265     }
??get_byte_array_from_number_2:
        CMP      R2,#+1
        BGE.N    ??get_byte_array_from_number_3
//  266     
//  267     *length = i;
        STR      R3,[R1, #+0]
//  268     //将解析的ASCII码数据存放在array中
//  269     for(j = 0; j < i; j++)
        MOVS     R4,#+0
        B.N      ??get_byte_array_from_number_4
//  270     {
//  271         array[j] = pBuff[i - j - 1] + '0';
??get_byte_array_from_number_5:
        SUBS     R1,R3,R4
        ADD      R2,SP,#+0
        ADDS     R1,R1,R2
        LDRB     R1,[R1, #-1]
        ADDS     R1,R1,#+48
        STRB     R1,[R4, R0]
//  272     }
        ADDS     R4,R4,#+1
??get_byte_array_from_number_4:
        CMP      R4,R3
        BLT.N    ??get_byte_array_from_number_5
//  273     //array[j] = '\0';
//  274     return 0;
        MOVS     R0,#+0
??get_byte_array_from_number_1:
        POP      {R1-R5}
        BX       LR               ;; return
//  275 }
//  276 
//  277 
//  278 //-------------------------------------------------------------------------
//  279 //函数名称：hw_uart_sendnumber                                               
//  280 //功能概要：将数字转换成字符串发送出去  如123转换成"123"发送出去                                                
//  281 //参数说明：uartch: 串口号                                                   
//  282 //           buff: 要发送的值                                                 
//  283 //函数返回： 无                                                               
//  284 //-------------------------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  285 uint8 uart_sendnumber(UART_MemMapPtr uartch , uint8 number)
//  286 {
uart_sendnumber:
        PUSH     {R0-R4,LR}
        MOVS     R4,R0
//  287     uint8 array[10];
//  288     int len = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+0]
//  289     if(get_byte_array_from_number(array, &len, number) == 0)
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        MOVS     R2,R1
        ADD      R1,SP,#+0
        ADD      R0,SP,#+4
        BL       get_byte_array_from_number
        CMP      R0,#+0
        BNE.N    ??uart_sendnumber_0
//  290     {
//  291     	uart_sendN(uartch, (uint8*)array, len);
        LDR      R2,[SP, #+0]
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        ADD      R1,SP,#+4
        MOVS     R0,R4
        BL       uart_sendN
//  292     }
//  293     else
//  294     {
//  295         return 0;
//  296     } 
//  297     return 1;
        MOVS     R0,#+1
        B.N      ??uart_sendnumber_1
??uart_sendnumber_0:
        MOVS     R0,#+0
??uart_sendnumber_1:
        ADD      SP,SP,#+16
        POP      {R4,PC}          ;; return
//  298 }
//  299 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  300 void uart3_send ( char ch)
//  301 {
//  302     //等待发送缓冲区空
//  303     while(!(UART_S1_REG(UART3) & UART_S1_TDRE_MASK));
uart3_send:
??uart3_send_0:
        LDR.N    R1,??DataTable2_20  ;; 0x4006d004
        LDRB     R1,[R1, #+0]
        LSLS     R1,R1,#+24
        BPL.N    ??uart3_send_0
//  304     //发送数据
//  305     UART_D_REG(UART3) = (uint8)ch;
        LDR.N    R1,??DataTable2_21  ;; 0x4006d007
        STRB     R0,[R1, #+0]
//  306 }
        BX       LR               ;; return
//  307 
//  308 //针对MiniIMU AHRS软件的参数串口波形测试

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  309 void Uart_Test(uint16 ax,uint16 ay,uint16 az,uint16 gx,uint16 gy,uint16 gz,
//  310 					uint16 hx,uint16 hy,uint16 hz)
//  311 {
Uart_Test:
        PUSH     {R0-R2,R4-R11,LR}
        MOV      R9,R3
        LDR      R4,[SP, #+48]
        LDR      R5,[SP, #+52]
        LDR      R6,[SP, #+56]
        LDR      R7,[SP, #+60]
        LDR      R8,[SP, #+64]
//  312  	unsigned int temp=0xaF+9;
        MOVS     R10,#+184
//  313 	char ctemp;
//  314 	uart3_send(0xa5);
        MOVS     R0,#+165
        BL       uart3_send
//  315 	uart3_send(0x5a);
        MOVS     R0,#+90
        BL       uart3_send
//  316 	uart3_send(14+8);
        MOVS     R0,#+22
        BL       uart3_send
//  317 	uart3_send(0xA2);
        MOVS     R0,#+162
        BL       uart3_send
//  318         
//  319 	ctemp=ax>>8;
        LDRH     R0,[SP, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R11,R0,#+8
//  320 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  321 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  322 	ctemp=ax;
        LDRH     R11,[SP, #+0]
//  323 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  324 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  325 
//  326 	ctemp=ay>>8;
        LDRH     R0,[SP, #+4]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R11,R0,#+8
//  327 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  328 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  329 	ctemp=ay;
        LDRH     R11,[SP, #+4]
//  330 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  331 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  332         
//  333 	ctemp=az>>8;
        LDRH     R0,[SP, #+8]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R11,R0,#+8
//  334 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  335 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  336 	ctemp=az;
        LDRH     R11,[SP, #+8]
//  337 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  338 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  339 
//  340 	ctemp=gx>>8;
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        LSRS     R11,R9,#+8
//  341 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  342 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  343 	ctemp=gx;
        MOV      R11,R9
//  344 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  345 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  346 //-----------------------------
//  347 	ctemp=gy>>8;
        UXTH     R4,R4            ;; ZeroExt  R4,R4,#+16,#+16
        LSRS     R11,R4,#+8
//  348 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  349 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  350 	ctemp=gy;
        MOV      R11,R4
//  351 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  352 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  353         
//  354 	ctemp=gz>>8;
        UXTH     R5,R5            ;; ZeroExt  R5,R5,#+16,#+16
        LSRS     R11,R5,#+8
//  355 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  356 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  357 	ctemp=gz;
        MOV      R11,R5
//  358 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  359 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  360 //--------------------------
//  361         
//  362 	ctemp=hx>>8;
        UXTH     R6,R6            ;; ZeroExt  R6,R6,#+16,#+16
        LSRS     R11,R6,#+8
//  363 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  364 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  365 	ctemp=hx;
        MOV      R11,R6
//  366 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  367 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  368         
//  369 	ctemp=hy>>8;
        UXTH     R7,R7            ;; ZeroExt  R7,R7,#+16,#+16
        LSRS     R11,R7,#+8
//  370 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  371 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  372 	ctemp=hy;
        MOV      R11,R7
//  373 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  374 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  375 
//  376 	ctemp=hz>>8;
        UXTH     R8,R8            ;; ZeroExt  R8,R8,#+16,#+16
        LSRS     R11,R8,#+8
//  377 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  378 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  379 	ctemp=hz;
        MOV      R11,R8
//  380 	uart3_send(ctemp);
        MOV      R0,R11
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  381 	temp+=ctemp;
        UXTAB    R10,R10,R11
//  382 
//  383 	uart3_send(temp%256);
        MOV      R1,#+256
        UDIV     R0,R10,R1
        MLS      R0,R0,R1,R10
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       uart3_send
//  384 	uart3_send(0xaa);
        MOVS     R0,#+170
        BL       uart3_send
//  385 }
        POP      {R0-R2,R4-R11,PC}  ;; return
//  386 //串口发送数据

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  387 void serial_choose()
//  388 {
serial_choose:
        PUSH     {R7,LR}
//  389 
//  390     //帧头数据
//  391     uart_send1 (UART3, 0xa5);
        MOVS     R1,#+165
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  392 
//  393     uart_send1 (UART3, 0x5a);
        MOVS     R1,#+90
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  394 
//  395 	//选择的线条
//  396 	//此处选择了第一,二,三条线
//  397 
//  398     uart_send1 (UART3, 0x01);
        MOVS     R1,#+1
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  399     uart_send1 (UART3, 0x01);
        MOVS     R1,#+1
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  400     uart_send1 (UART3, 0x01);
        MOVS     R1,#+1
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  401     uart_send1 (UART3, 0x00);
        MOVS     R1,#+0
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  402     uart_send1 (UART3, 0x00);
        MOVS     R1,#+0
        LDR.N    R0,??DataTable2_9  ;; 0x4006d000
        BL       uart_send1
//  403     delay_ms(10);
        MOVS     R0,#+10
        BL       delay_ms
//  404 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2:
        DC32     0x4006a000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_1:
        DC32     0x4004c018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_2:
        DC32     0x4004c01c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_3:
        DC32     0x4006b000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_4:
        DC32     0x4004b010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_5:
        DC32     0x4004b00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_6:
        DC32     0x4006c000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_7:
        DC32     0x4004c00c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_8:
        DC32     0x4004c008

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_9:
        DC32     0x4006d000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_10:
        DC32     0x4004b044

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_11:
        DC32     0x4004b040

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_12:
        DC32     0x400ea000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_13:
        DC32     0x4004d060

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_14:
        DC32     0x4004d064

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_15:
        DC32     0x400eb000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_16:
        DC32     0x4004d020

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_17:
        DC32     0x4004d024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_18:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_19:
        DC32     0x40048028

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_20:
        DC32     0x4006d004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_21:
        DC32     0x4006d007

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  405 
//  406 
//  407 
//  408 
//  409 
//  410 
//  411 
//  412 
//  413 
//  414 
//  415 
//  416 
//  417 
// 
// 1 326 bytes in section .text
// 
// 1 326 bytes of CODE memory
//
//Errors: none
//Warnings: none
