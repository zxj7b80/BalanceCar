///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/May/2013  10:25:55 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  C:\Users\hp\Desktop\balance car\src\Sources\C\I2C.c     /
//    Command line =  "C:\Users\hp\Desktop\balance car\src\Sources\C\I2C.c"   /
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
//    List file    =  C:\Users\hp\Desktop\balance car\bin\Ram\List\I2C.s      /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME I2C

        #define SHT_PROGBITS 0x1

        PUBLIC hw_i2c_init
        PUBLIC hw_iic_read1
        PUBLIC hw_iic_readn
        PUBLIC hw_iic_write1
        PUBLIC hw_iic_writen
        PUBLIC hw_send_signal
        PUBLIC hw_wait

// C:\Users\hp\Desktop\balance car\src\Sources\C\I2C.c
//    1 //============================================================================
//    2 // 文件名称：hw_i2c.h                                                          
//    3 // 功能概要：uart构件头文件
//    4 // 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//    5 // 版本更新:    时间                         版本                     作者                          修改
//    6 //           2011-11-17     V1.0       stone    编写了K60的i2c驱动
//    7 //============================================================================
//    8 
//    9 
//   10 #ifndef __I2C_H__
//   11 #define __I2C_H__
//   12 	
//   13 #include "common.h"
//   14 #include "i2c.h"
//   15 
//   16 //============================================================================
//   17 //函数名称：hw_i2c_init                                                        
//   18 //功能概要：初始化IICX模块。                                                
//   19 //参数说明：num:模块号                                                         
//   20 //函数返回：无                                                                  
//   21 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   22 void hw_i2c_init(I2C_MemMapPtr num)
//   23 {
//   24 	
//   25 	if(num == I2C0)
hw_i2c_init:
        LDR.N    R1,??DataTable1  ;; 0x40066000
        CMP      R0,R1
        BNE.N    ??hw_i2c_init_0
//   26 	{
//   27 		//打开I2C0模块时钟
//   28 		SIM_SCGC4 |= SIM_SCGC4_I2C0_MASK; 
        LDR.N    R0,??DataTable1_1  ;; 0x40048034
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x40
        LDR.N    R1,??DataTable1_1  ;; 0x40048034
        STR      R0,[R1, #+0]
//   29 		//配置引脚复用为I2C0功能
//   30 		//I2C0 SCL使用PTD8
//   31 		//I2C0 SDA使用PTD9
//   32 		PORTD_PCR9 = PORT_PCR_MUX(2);
        LDR.N    R0,??DataTable1_2  ;; 0x4004c024
        MOV      R1,#+512
        STR      R1,[R0, #+0]
//   33 		PORTD_PCR8 = PORT_PCR_MUX(2);
        LDR.N    R0,??DataTable1_3  ;; 0x4004c020
        MOV      R1,#+512
        STR      R1,[R0, #+0]
//   34 		//设置 MULT 和 ICR   
//   35 		//芯片手册推荐设置100K以减小MCU负载
//   36 		//k60的MCU总线频率为48M，在总线上分频
//   37 		I2C0_F  = 0x65;   
        LDR.N    R0,??DataTable1_4  ;; 0x40066001
        MOVS     R1,#+101
        STRB     R1,[R0, #+0]
//   38 		//使能I2C0，不发送应答信号
//   39 		I2C0_C1 = I2C_C1_IICEN_MASK | I2C_C1_TXAK_MASK;      
        LDR.N    R0,??DataTable1_5  ;; 0x40066002
        MOVS     R1,#+136
        STRB     R1,[R0, #+0]
        B.N      ??hw_i2c_init_1
//   40 	}
//   41 	else
//   42 	{
//   43 		//打开I2C1模块时钟
//   44 		SIM_SCGC4 |= SIM_SCGC4_I2C1_MASK; 
??hw_i2c_init_0:
        LDR.N    R0,??DataTable1_1  ;; 0x40048034
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable1_1  ;; 0x40048034
        STR      R0,[R1, #+0]
//   45 		//配置引脚复用为I2C1功能
//   46 		//I2C1 SCL使用PTC10
//   47 		//I2C1 SDA使用PTC11
//   48 		PORTC_PCR10 = PORT_PCR_MUX(2);
        LDR.N    R0,??DataTable1_6  ;; 0x4004b028
        MOV      R1,#+512
        STR      R1,[R0, #+0]
//   49 		PORTC_PCR11 = PORT_PCR_MUX(2);
        LDR.N    R0,??DataTable1_7  ;; 0x4004b02c
        MOV      R1,#+512
        STR      R1,[R0, #+0]
//   50 		//设置 MULT 和 ICR   
//   51 		//芯片手册推荐设置100K以减小MCU负载
//   52 		//k60的MCU总线频率为48M，在总线上分频
//   53 		I2C1_F  = 0x65;   
        LDR.N    R0,??DataTable1_8  ;; 0x40067001
        MOVS     R1,#+101
        STRB     R1,[R0, #+0]
//   54 		//使能I2C1，不发送应答信号
//   55 		I2C1_C1 = I2C_C1_IICEN_MASK | I2C_C1_TXAK_MASK;      
        LDR.N    R0,??DataTable1_9  ;; 0x40067002
        MOVS     R1,#+136
        STRB     R1,[R0, #+0]
//   56 	}
//   57 }
??hw_i2c_init_1:
        BX       LR               ;; return
//   58 
//   59 //============================================================================
//   60 //函数名称：hw_send_signal                                                        
//   61 //功能概要：根据需要产生开始或停止信号   。                                                
//   62 //参数说明：         num:模块号       
//   63 //          Signal: 'S'(Start),产生开始信号      'O'(Over),  产生停止信号               
//   64 //函数返回：无                                                                  
//   65 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   66 void hw_send_signal(uint8 Signal,I2C_MemMapPtr num)
//   67 {
//   68 	
//   69 	if(num == I2C0)//模块0
hw_send_signal:
        LDR.N    R2,??DataTable1  ;; 0x40066000
        CMP      R1,R2
        BNE.N    ??hw_send_signal_0
//   70 	{
//   71 		if (Signal == 'S')    
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+83
        BNE.N    ??hw_send_signal_1
//   72 		{
//   73 		  i2c0_Start(); //主机模式选择位MST由0变为1,可以产生开始信号  
        LDR.N    R0,??DataTable1_5  ;; 0x40066002
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x20
        LDR.N    R1,??DataTable1_5  ;; 0x40066002
        STRB     R0,[R1, #+0]
        B.N      ??hw_send_signal_2
//   74 		}
//   75 		else if (Signal == 'O')
??hw_send_signal_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+79
        BNE.N    ??hw_send_signal_2
//   76 		{
//   77 		  i2c0_Stop();//主机模式选择位MST由1变为0,可以产生停止信号
        LDR.N    R0,??DataTable1_5  ;; 0x40066002
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xDF
        LDR.N    R1,??DataTable1_5  ;; 0x40066002
        STRB     R0,[R1, #+0]
        B.N      ??hw_send_signal_2
//   78 		}
//   79 	}
//   80 	else if(num == I2C1)//模块1
??hw_send_signal_0:
        LDR.N    R2,??DataTable1_10  ;; 0x40067000
        CMP      R1,R2
        BNE.N    ??hw_send_signal_2
//   81 	{
//   82 		if (Signal == 'S')    
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+83
        BNE.N    ??hw_send_signal_3
//   83 		{
//   84 		  i2c1_Start(); //主机模式选择位MST由0变为1,可以产生开始信号  
        LDR.N    R0,??DataTable1_9  ;; 0x40067002
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x20
        LDR.N    R1,??DataTable1_9  ;; 0x40067002
        STRB     R0,[R1, #+0]
        B.N      ??hw_send_signal_2
//   85 		}
//   86 		else if (Signal == 'O')
??hw_send_signal_3:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+79
        BNE.N    ??hw_send_signal_2
//   87 		{
//   88 		  i2c1_Stop();//主机模式选择位MST由1变为0,可以产生停止信号
        LDR.N    R0,??DataTable1_9  ;; 0x40067002
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xDF
        LDR.N    R1,??DataTable1_9  ;; 0x40067002
        STRB     R0,[R1, #+0]
//   89 		}
//   90 	}
//   91 	        
//   92                                               
//   93       
//   94 }
??hw_send_signal_2:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1:
        DC32     0x40066000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_1:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_2:
        DC32     0x4004c024

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_3:
        DC32     0x4004c020

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_4:
        DC32     0x40066001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_5:
        DC32     0x40066002

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_6:
        DC32     0x4004b028

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_7:
        DC32     0x4004b02c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_8:
        DC32     0x40067001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_9:
        DC32     0x40067002

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_10:
        DC32     0x40067000
//   95 
//   96 
//   97 
//   98 //============================================================================
//   99 //函数名称：hw_wait                                                        
//  100 //功能概要： 在时限内,循环检测接收应答标志位,或传送完成标志位,判断MCU         
//  101 //          是否接收到应答信号或一个字节是否已在总线上传送完毕                                            
//  102 //参数说明：         num:模块号       
//  103 //               x:x = 'A'(Ack),等待应答;x = 'T'(Transmission),等待一个字节        
//  104 //                 数据传输完成                   
//  105 //函数返回：0:收到应答信号或一个字节传送完毕;
//  106 //         1:未收到应答信号或一个 字节没传送完                                                                                                                            
//  107 //============================================================================
//  108 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  109 uint8 hw_wait(uint8 x,I2C_MemMapPtr num)
//  110 {
hw_wait:
        PUSH     {R4}
//  111     uint16 ErrTime, i;
//  112     ErrTime = 255*10;            //定义查询超时时限
        MOVW     R2,#+2550
//  113 
//  114 	for (i = 0;i < ErrTime;i++)
        MOVS     R3,#+0
        B.N      ??hw_wait_0
??hw_wait_1:
        ADDS     R3,R3,#+1
??hw_wait_0:
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        CMP      R3,R2
        BCS.N    ??hw_wait_2
//  115 	{
//  116 		if (x == 'A')           //等待应答信号
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+65
        BNE.N    ??hw_wait_3
//  117 		{
//  118 			  if(( I2C_S_REG(num)  & I2C_S_RXAK_MASK)==0)
        LDRB     R4,[R1, #+3]
        LSLS     R4,R4,#+31
        BMI.N    ??hw_wait_1
//  119 				 return 0;      //传送完一个字节后,收到了从机的应答信号               
        MOVS     R0,#+0
        B.N      ??hw_wait_4
//  120 		}
//  121 		else if (x == 'T')      //等待传送完成一个字节信号
??hw_wait_3:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+84
        BNE.N    ??hw_wait_1
//  122 		{
//  123 			if ((I2C_S_REG(num) & I2C_S_IICIF_MASK) != 0)    
        LDRB     R4,[R1, #+3]
        LSLS     R4,R4,#+30
        BPL.N    ??hw_wait_1
//  124 			{
//  125 				(I2C_S_REG(num) |=(0 | I2C_S_IICIF_MASK));  //清IICIF标志位
        LDRB     R0,[R1, #+3]
        ORRS     R0,R0,#0x2
        STRB     R0,[R1, #+3]
//  126 				return 0;       //成功发送完一个字节
        MOVS     R0,#+0
        B.N      ??hw_wait_4
//  127 			}       
//  128 		}
//  129 	}
//  130 	if (i >= ErrTime)
??hw_wait_2:
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        CMP      R3,R2
        BCC.N    ??hw_wait_5
//  131 		return 1;               //超时,没有收到应答信号或发送完一个字节   	
        MOVS     R0,#+1
        B.N      ??hw_wait_4
//  132 }
??hw_wait_5:
??hw_wait_4:
        POP      {R4}
        BX       LR               ;; return
//  133 
//  134 
//  135 //============================================================================
//  136 //函数名称：hw_iic_read1                                                        
//  137 //功能概要：从从机读1个字节数据                                            
//  138 //参数说明：  num:模块号       
//  139 //          DeviceAddr:设备地址    
//  140 //          AccessAddr:访问地址
//  141 //          Data:带回收到的一个字节数据  
//  142 //函数返回：为0,成功读一个字节;为1,读一个字节失败  
//  143 //函数说明: 内部调用 hw_send_signal,hw_wait  
//  144 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  145 uint8 hw_iic_read1(I2C_MemMapPtr num,uint8 DeviceAddr, uint8 AccessAddr, uint8 *Data)
//  146 {      
hw_iic_read1:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R7,R2
        MOVS     R6,R3
//  147       
//  148 	I2C_C1_REG(num)     |= 0x10;           //TX = 1,MCU设置为发送模式
        LDRB     R0,[R4, #+2]
        ORRS     R0,R0,#0x10
        STRB     R0,[R4, #+2]
//  149 	hw_send_signal('S',num);               //发送开始信号 
        MOVS     R1,R4
        MOVS     R0,#+83
        BL       hw_send_signal
//  150 	I2C_D_REG(num)  = DeviceAddr & 0xfe;   //发送设备地址,并通知从机接收数据
        ANDS     R0,R5,#0xFE
        STRB     R0,[R4, #+4]
//  151 	 
//  152 	if (hw_wait('T',num))                  //等待一个字节数据传送完成  
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_0
//  153 	{      
//  154 
//  155 		return 1;                         //没有传送成功,读一个字节失败   
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  156 	}
//  157 	if (hw_wait('A',num))                 //等待从机应答信号 
??hw_iic_read1_0:
        MOVS     R1,R4
        MOVS     R0,#+65
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_2
//  158 	{
//  159 
//  160 		return 1;                         //没有等到应答信号,读一个字节失败 
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  161 	}
//  162 	I2C_D_REG(num)  = AccessAddr;        //发送访问地址    
??hw_iic_read1_2:
        STRB     R7,[R4, #+4]
//  163 	if (hw_wait('T',num))                //等待一个字节数据传送完成 
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_3
//  164 	{
//  165 	 
//  166 		return 1;                        //没有传送成功,读一个字节失败
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  167 	}
//  168 	if (hw_wait('A',num))                //等待从机应答信号   
??hw_iic_read1_3:
        MOVS     R1,R4
        MOVS     R0,#+65
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_4
//  169 	{
//  170 	  
//  171 		return 1;                        //没有等到应答信号,读一个字节失败  
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  172 	}
//  173 	I2C_C1_REG(num) |= 0x04;//当MCU在主机模 式下，向该位写1将产生一个重新开始信号  
??hw_iic_read1_4:
        LDRB     R0,[R4, #+2]
        ORRS     R0,R0,#0x4
        STRB     R0,[R4, #+2]
//  174 	I2C_D_REG(num) = DeviceAddr | 0x01; //通知从机改为发送数据    
        ORRS     R0,R5,#0x1
        STRB     R0,[R4, #+4]
//  175 	if (hw_wait('T',num))               //等待一个字节数据传送完成  
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_5
//  176 	{
//  177 	 
//  178 		return 1;                       //没有传送成功,读一个字节失败 
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  179 	}
//  180 	if (hw_wait('A',num))               //等待从机应答信号  
??hw_iic_read1_5:
        MOVS     R1,R4
        MOVS     R0,#+65
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_6
//  181 	{
//  182 	 
//  183 		return 1;                      //没有等到应答信号,读一个字节失败
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  184 	}
//  185 	I2C_C1_REG(num) &= 0xef;           //TX = 0,MCU设置为接收模式    
??hw_iic_read1_6:
        LDRB     R0,[R4, #+2]
        ANDS     R0,R0,#0xEF
        STRB     R0,[R4, #+2]
//  186 	*Data = I2C_D_REG(num);            //读出IIC1D,准备接收数据   
        LDRB     R0,[R4, #+4]
        STRB     R0,[R6, #+0]
//  187 	if (hw_wait('T',num))              //等待一个字节数据传送完成  
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_read1_7
//  188 	{  
//  189 	 
//  190 		return 1;                      //没有传送成功,读一个字节失败  
        MOVS     R0,#+1
        B.N      ??hw_iic_read1_1
//  191 	}
//  192 	hw_send_signal('O',num);           //发送停止信号    
??hw_iic_read1_7:
        MOVS     R1,R4
        MOVS     R0,#+79
        BL       hw_send_signal
//  193 	*Data = I2C_D_REG(num);            //读出接收到的一个数据    
        LDRB     R0,[R4, #+4]
        STRB     R0,[R6, #+0]
//  194 	
//  195 	return 0;                          //正确接收到一个字节数据
        MOVS     R0,#+0
??hw_iic_read1_1:
        POP      {R1,R4-R7,PC}    ;; return
//  196 	
//  197 }
//  198 
//  199 //============================================================================
//  200 //函数名称：hw_iic_write1                                                        
//  201 //功能概要：向从机写1个字节数据                                           
//  202 //参数说明：  num:模块号       
//  203 //          DeviceAddr:设备地址    
//  204 //          AccessAddr:访问地址
//  205 //          Data:要发给从机的1个字节数据  
//  206 //函数返回：为0,成功写一个字节;为1,写一个字节失败 
//  207 //函数说明: 内部调用 hw_send_signal,hw_wait  
//  208 //============================================================================
//  209 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  210 uint8 hw_iic_write1(I2C_MemMapPtr num,uint8 DeviceAddr, uint8 AccessAddr, uint8 Data)
//  211 {
hw_iic_write1:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
        MOVS     R7,R3
//  212 	I2C_C1_REG(num) |= 0x10;             //TX = 1,MCU设置为发送模式
        LDRB     R0,[R4, #+2]
        ORRS     R0,R0,#0x10
        STRB     R0,[R4, #+2]
//  213     hw_send_signal('S',num);             //发送开始信号
        MOVS     R1,R4
        MOVS     R0,#+83
        BL       hw_send_signal
//  214     I2C_D_REG(num) = DeviceAddr & 0xfe;  //发送设备地址,并通知从机接收数据
        ANDS     R0,R5,#0xFE
        STRB     R0,[R4, #+4]
//  215     if (hw_wait('T',num))                //等待一个字节数据传送完成
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_write1_0
//  216         return 1;                        //没有传送成功,写一个字节失败
        MOVS     R0,#+1
        B.N      ??hw_iic_write1_1
//  217     if (hw_wait('A',num))               //等待从机应答信号
??hw_iic_write1_0:
        MOVS     R1,R4
        MOVS     R0,#+65
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_write1_2
//  218         return 1;                       //没有等到应答信号,写一个字节失败   
        MOVS     R0,#+1
        B.N      ??hw_iic_write1_1
//  219     I2C_D_REG(num) = AccessAddr;         //发送访问地址
??hw_iic_write1_2:
        STRB     R6,[R4, #+4]
//  220     if (hw_wait('T',num))               //等待一个字节数据传送完成
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_write1_3
//  221         return 1;                       //没有传送成功,写一个字节失败
        MOVS     R0,#+1
        B.N      ??hw_iic_write1_1
//  222     if (hw_wait('A',num))               //等待从机应答信号
??hw_iic_write1_3:
        MOVS     R1,R4
        MOVS     R0,#+65
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_write1_4
//  223         return 1;                      //没有等到应答信号,写一个字节失败   
        MOVS     R0,#+1
        B.N      ??hw_iic_write1_1
//  224     I2C_D_REG(num) = Data;             //写数据
??hw_iic_write1_4:
        STRB     R7,[R4, #+4]
//  225     if (hw_wait('T',num))              //等待一个字节数据传送完成
        MOVS     R1,R4
        MOVS     R0,#+84
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_write1_5
//  226         return 1;                      //没有传送成功,写一个字节失败
        MOVS     R0,#+1
        B.N      ??hw_iic_write1_1
//  227     if (hw_wait('A',num))              //等待从机应答信号
??hw_iic_write1_5:
        MOVS     R1,R4
        MOVS     R0,#+65
        BL       hw_wait
        CMP      R0,#+0
        BEQ.N    ??hw_iic_write1_6
//  228         return 1;                      //没有等到应答信号,写一个字节失败   
        MOVS     R0,#+1
        B.N      ??hw_iic_write1_1
//  229     hw_send_signal('O',num);           //发送停止信号
??hw_iic_write1_6:
        MOVS     R1,R4
        MOVS     R0,#+79
        BL       hw_send_signal
//  230     return 0;
        MOVS     R0,#+0
??hw_iic_write1_1:
        POP      {R1,R4-R7,PC}    ;; return
//  231 }
//  232 
//  233 
//  234 //============================================================================
//  235 //函数名称：hw_iic_readn                                                        
//  236 //功能概要： 从从机读N个字节数据                                             
//  237 //参数说明：  num:模块号       
//  238 //          DeviceAddr:设备地址    
//  239 //          AccessAddr:访问地址
//  240 //          Data:读出数据的缓冲区
//  241 //          N:从从机读的字节个数 
//  242 //函数返回： 为0,成功读N个字节;为1,读N个字节失败  
//  243 //函数说明: 内部调用hw_iic_read1  
//  244 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  245 uint8 hw_iic_readn(I2C_MemMapPtr num,uint8 DeviceAddr, uint8 AccessAddr, uint8 Data[], uint8 N)
//  246 {
hw_iic_readn:
        PUSH     {R3-R9,LR}
        MOVS     R5,R0
        MOVS     R6,R1
        MOVS     R7,R2
        MOV      R8,R3
        LDR      R4,[SP, #+32]
//  247     uint16 i, j;
//  248     for (i = 0;i < N;i++)
        MOVS     R9,#+0
        B.N      ??hw_iic_readn_0
??hw_iic_readn_1:
        ADDS     R9,R9,#+1
??hw_iic_readn_0:
        MOVS     R0,R4
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R9,R0
        BCS.N    ??hw_iic_readn_2
//  249     {
//  250         for(j = 0;j <15*40 ;j++); //最小延时(发送的每个字节之间要有时间间隔)
        MOVS     R0,#+0
        B.N      ??hw_iic_readn_3
??hw_iic_readn_4:
        ADDS     R0,R0,#+1
??hw_iic_readn_3:
        MOV      R1,#+600
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R0,R1
        BCC.N    ??hw_iic_readn_4
//  251         if (hw_iic_read1(num,DeviceAddr, AccessAddr + i, &Data[i]))  
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        ADDS     R3,R9,R8
        ADDS     R2,R9,R7
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        MOVS     R1,R6
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        MOVS     R0,R5
        BL       hw_iic_read1
        CMP      R0,#+0
        BEQ.N    ??hw_iic_readn_1
//  252             return 1;             //其中一个字节没有接收到,返回失败标志:1
        MOVS     R0,#+1
        B.N      ??hw_iic_readn_5
//  253     }
//  254     if (i >= N)
??hw_iic_readn_2:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        UXTH     R4,R4            ;; ZeroExt  R4,R4,#+16,#+16
        CMP      R9,R4
        BCC.N    ??hw_iic_readn_6
//  255         return 0;                 //成功接收N个数据,返回成功标志:0
        MOVS     R0,#+0
        B.N      ??hw_iic_readn_5
//  256 }
??hw_iic_readn_6:
??hw_iic_readn_5:
        POP      {R1,R4-R9,PC}    ;; return
//  257 
//  258 
//  259 //============================================================================
//  260 //函数名称：hw_iic_writen                                                        
//  261 //功能概要： 向从机写N个字节数据                                              
//  262 //参数说明：  num:模块号       
//  263 //          DeviceAddr:设备地址    
//  264 //          AccessAddr:访问地址
//  265 //          Data:要写入的数据  
//  266 //          N:从从机读的字节个数 
//  267 //函数返回： 为0,成功写N个字节;为1,写N个字节失败
//  268 //函数说明: 内部调用hw_iic_write1   
//  269 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  270 uint8 hw_iic_writen(I2C_MemMapPtr num,uint8 DeviceAddr, uint8 AccessAddr,uint8 Data[], uint8 N)
//  271 {
hw_iic_writen:
        PUSH     {R3-R9,LR}
        MOVS     R5,R0
        MOVS     R6,R1
        MOVS     R7,R2
        MOV      R8,R3
        LDR      R4,[SP, #+32]
//  272     uint16 i, j;
//  273     for (i = 0;i < N;i++)
        MOVS     R9,#+0
        B.N      ??hw_iic_writen_0
??hw_iic_writen_1:
        ADDS     R9,R9,#+1
??hw_iic_writen_0:
        MOVS     R0,R4
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R9,R0
        BCS.N    ??hw_iic_writen_2
//  274     {
//  275         for(j = 0;j < 15*40;j++); //最小延时(发送的每个字节之间要有时间间隔)
        MOVS     R0,#+0
        B.N      ??hw_iic_writen_3
??hw_iic_writen_4:
        ADDS     R0,R0,#+1
??hw_iic_writen_3:
        MOV      R1,#+600
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R0,R1
        BCC.N    ??hw_iic_writen_4
//  276         if (hw_iic_write1(num,DeviceAddr, AccessAddr + i, Data[i]))
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        LDRB     R3,[R9, R8]
        ADDS     R2,R9,R7
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        MOVS     R1,R6
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        MOVS     R0,R5
        BL       hw_iic_write1
        CMP      R0,#+0
        BEQ.N    ??hw_iic_writen_1
//  277             return 1;            //其中一个字节没有发送出去,返回失败标志:1
        MOVS     R0,#+1
        B.N      ??hw_iic_writen_5
//  278     }
//  279     if (i >= N)
??hw_iic_writen_2:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        UXTH     R9,R9            ;; ZeroExt  R9,R9,#+16,#+16
        UXTH     R4,R4            ;; ZeroExt  R4,R4,#+16,#+16
        CMP      R9,R4
        BCC.N    ??hw_iic_writen_6
//  280         return 0;                //成功发送N个数据,返回成功标志:0
        MOVS     R0,#+0
        B.N      ??hw_iic_writen_5
//  281 }
??hw_iic_writen_6:
??hw_iic_writen_5:
        POP      {R1,R4-R9,PC}    ;; return

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  282 
//  283 #endif 
// 
// 846 bytes in section .text
// 
// 846 bytes of CODE memory
//
//Errors: none
//Warnings: 3
