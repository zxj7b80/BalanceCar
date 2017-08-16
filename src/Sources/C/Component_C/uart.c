//-------------------------------------------------------------------------*
// 文件名: uart.c                                                          *
// 说  明: uart构件源文件                                                  *
//-------------------------------------------------------------------------*

#include "uart.h"
extern   void delay_ms(uint32 count_val);

//-------------------------------------------------------------------------*
//函数名: uart_init                                                        *
//功  能: 初始化uartx模块。                                                *
//参  数: uartch:串口号                                                    *
//        sysclk:系统总线时钟，以MHz为单位                                 *
//        baud:波特率，如9600，38400等，一般来说，速度越慢，通信越稳       *
//返  回: 无                                                               *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
void uart_init (UART_MemMapPtr uartch, uint32 sysclk, uint32 baud)
{
	register uint16 sbr, brfa;
	uint8 temp;

	//使能引脚
	if (uartch == UART0_BASE_PTR)
	{
		//在PTD6上使能UART0_TXD功能
		PORTD_PCR6 = PORT_PCR_MUX(0x3);
		//在PTD7上使能UART0_RXD
		PORTD_PCR7 = PORT_PCR_MUX(0x3); 
	}else if (uartch == UART1_BASE_PTR)
	{
		//在PTC4上使能UART1_TXD功能
		PORTC_PCR4 = PORT_PCR_MUX(0x3); 
		
		//在PTC3上使能UART1_RXD
		PORTC_PCR3 = PORT_PCR_MUX(0x3); 
	}else if (uartch == UART2_BASE_PTR)
	{
		//在PTD3上使能UART2_TXD功能
		PORTD_PCR3 = PORT_PCR_MUX(0x3); 
		//在PTD2上使能UART2_RXD
		PORTD_PCR2 = PORT_PCR_MUX(0x3); 
	}else if (uartch == UART3_BASE_PTR)
	{
		//在PTC17上使能UART3_TXD功能
		PORTC_PCR17 = PORT_PCR_MUX(0x3); 
		//在PTC16上使能UART3_RXD
		PORTC_PCR16 = PORT_PCR_MUX(0x3); 
	}else if (uartch == UART4_BASE_PTR)
	{
		//在PTE24上使能UART4_TXD功能
		PORTE_PCR24 = PORT_PCR_MUX(0x3); 
		//在PTE25上使能UART4_RXD
		PORTE_PCR25 = PORT_PCR_MUX(0x3); 
	}else if (uartch == UART5_BASE_PTR)
	{
		//在PTE8上使能UART5_TXD功能
		PORTE_PCR8 = PORT_PCR_MUX(0x3); 
		//在PTE9上使能UART5_RXD
		PORTE_PCR9 = PORT_PCR_MUX(0x3); 
	}
	 
	//使能串口时钟    
	if(uartch == UART0_BASE_PTR)
		SIM_SCGC4 |= SIM_SCGC4_UART0_MASK;
	else
		if (uartch == UART1_BASE_PTR)
			SIM_SCGC4 |= SIM_SCGC4_UART1_MASK;
		else
			if (uartch == UART2_BASE_PTR)
				SIM_SCGC4 |= SIM_SCGC4_UART2_MASK;
			else
				if(uartch == UART3_BASE_PTR)
					SIM_SCGC4 |= SIM_SCGC4_UART3_MASK;
				else
					if(uartch == UART4_BASE_PTR)
						SIM_SCGC1 |= SIM_SCGC1_UART4_MASK;
					else
						SIM_SCGC1 |= SIM_SCGC1_UART5_MASK;
								
	//禁止发送接受
	UART_C2_REG(uartch) &= ~(UART_C2_TE_MASK
				| UART_C2_RE_MASK );
	
	//配置成8位无校验模式
	UART_C1_REG(uartch) = 0;
	
	//计算波特率，串口0、1使用内核时钟，其它串口使用外设时钟，系统时钟为
	//外设时钟的2倍
	if ((uartch == UART0_BASE_PTR) | (uartch == UART1_BASE_PTR))//
		sysclk+=sysclk;
	
	sbr = (uint16)((sysclk*1000)/(baud * 16));
	temp = UART_BDH_REG(uartch) & ~(UART_BDH_SBR(0x1F));
	UART_BDH_REG(uartch) = temp |  UART_BDH_SBR(((sbr & 0x1F00) >> 8));
	UART_BDL_REG(uartch) = (uint8)(sbr & UART_BDL_SBR_MASK);
	brfa = (((sysclk*32000)/(baud * 16)) - (sbr * 32));
	temp = UART_C4_REG(uartch) & ~(UART_C4_BRFA(0x1F));
	UART_C4_REG(uartch) = temp |  UART_C4_BRFA(brfa);    
	
	//使能发送接受
	UART_C2_REG(uartch) |= (UART_C2_TE_MASK
				| UART_C2_RE_MASK );
}

//-------------------------------------------------------------------------*
//函数名: uart_re1                                                         *
//功  能: 串行接受1个字节                                                  *
//参  数: uartch: 串口号                                                   *
//         ch:    接收到的字节                                             *
//返  回: 成功:1;失败:0                                                    *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
uint8 uart_re1 (UART_MemMapPtr uartch,uint8 *ch)
{
    uint32 k;
    
    for (k = 0; k < 0xfbbb; k++)//有时间限制
		if((UART_S1_REG(uartch) & UART_S1_RDRF_MASK)!= 0)//判断接收缓冲区是否满
		{
			*ch = UART_D_REG(uartch);
			return 1; 			//接受成功
		} 
	if(k>=0xfbbb) 
	{
		return 0;			//接受失败
	} 
    return 0;
}

//-------------------------------------------------------------------------*
//函数名: uart_send1                                                       *
//功  能: 串行发送1个字节                                                  *
//参  数: uartch: 串口号                                                   *
//         ch:    要发送的字节                                             *
//返  回: 无                                                               *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
void uart_send1 (UART_MemMapPtr uartch, uint8 ch)
{
    //等待发送缓冲区空
    while(!(UART_S1_REG(uartch) & UART_S1_TDRE_MASK));
    //发送数据
    UART_D_REG(uartch) = (uint8)ch;
 }

//-------------------------------------------------------------------------*
//函数名: uart_reN                                                         *
//功  能: 串行 接收n个字节                                                 *
//参  数: uartch: 串口号                                                   *
//        buff: 接收缓冲区                                                 *
//		  len:接收长度                                             *
//返  回: 1:成功;0:失败                                                    *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
uint8 uart_reN (UART_MemMapPtr uartch ,uint8* buff,uint16 len)
{
    uint16 m=0; 
    while (m < len)
    { 	          
  	    if(0==uart_re1(uartch,&buff[m]))
  	    	return 0;  //接收失败
  	    else m++;
    } 
    
    return 1;          //接收成功
    
}

//-------------------------------------------------------------------------*
//函数名: uart_sendN                                                       *
//功  能: 串行 接收n个字节                                                 *
//参  数: uartch: 串口号                                                   *
//        buff: 发送缓冲区                                                 *
//		  len:发送长度                                             *
//返  回: 无                                                               *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
void uart_sendN (UART_MemMapPtr uartch ,uint8* buff,uint16 len)
{
    int i;
	for(i=0;i<len;i++)
    {
		uart_send1(uartch,buff[i]);
    }
}

//-------------------------------------------------------------------------*
//函数名: enableuartreint                                                  *
//功  能: 开串口接收中断                                                   *
//参  数: uartch: 串口号                                                   *
//        irqno: 对应irq号                                                 *
//返  回: 无                                                               *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
void enableuartreint(UART_MemMapPtr uartch,uint8 irqno)
{
	UART_C2_REG(uartch)|=UART_C2_RIE_MASK;   //开放UART接收中断
	enable_irq(irqno);			 //开接收引脚的IRQ中断
}

//-------------------------------------------------------------------------*
//函数名: disableuartreint                                                 *
//功  能: 关串口接收中断                                                   *
//参  数: uartch: 串口号                                                   *
//        irqno: 对应irq号                                                 *
//返  回: 无                                                               *
//说  明:                                                                  *
//-------------------------------------------------------------------------*
void disableuartreint(UART_MemMapPtr uartch,uint8 irqno)
{
	UART_C2_REG(uartch)&=~UART_C2_RIE_MASK;   //禁止UART接收中断
	disable_irq(irqno);			  //关接收引脚的IRQ中断
}




//-------------------------------------------------------------------------
//函数名称：hw_uart_sendstring                                               
//功能概要：关串口接收中断                                                   
//参数说明：uartch: 串口号                                                   
//           buff: 要发送的值                                                 
//函数返回： 无                                                               
//-------------------------------------------------------------------------
void uart_sendstring (UART_MemMapPtr uartch ,uint8* buff)
{
    int i;

    for(i=0;buff[i] != 0;i++)
    {
       uart_send1(uartch,buff[i]);
    }
}
//-------------------------------------------------------------------------
//函数名称：hw_get_byte_array_from_number                                               
//功能概要：将数组number转换成ASCII码的形式放到数组中                                                
//参数说明：number: 要转换的数字                                                   
//          length: 长度        
//           array: 转换完的结果数组
//函数返回： 无                                                               
//-------------------------------------------------------------------------
uint8 get_byte_array_from_number(uint8 array [], int * length, int number)
{
    int i = 0;
    int j = 0;
    uint8 pBuff [10];
    if(number < 0)
    {
        return 1;
    }
    i = 0;
    if(number == 0) //如果数字是0
    {
        i = 1;
        *length = i;
        array[0] = '0';
        return 0;
    }
    
    while(number > 0)
    {
        pBuff[i++] = number % 10;
        number = number/10; 
    }
    
    *length = i;
    //将解析的ASCII码数据存放在array中
    for(j = 0; j < i; j++)
    {
        array[j] = pBuff[i - j - 1] + '0';
    }
    //array[j] = '\0';
    return 0;
}


//-------------------------------------------------------------------------
//函数名称：hw_uart_sendnumber                                               
//功能概要：将数字转换成字符串发送出去  如123转换成"123"发送出去                                                
//参数说明：uartch: 串口号                                                   
//           buff: 要发送的值                                                 
//函数返回： 无                                                               
//-------------------------------------------------------------------------
uint8 uart_sendnumber(UART_MemMapPtr uartch , uint8 number)
{
    uint8 array[10];
    int len = 0;
    if(get_byte_array_from_number(array, &len, number) == 0)
    {
    	uart_sendN(uartch, (uint8*)array, len);
    }
    else
    {
        return 0;
    } 
    return 1;
}

void uart3_send ( char ch)
{
    //等待发送缓冲区空
    while(!(UART_S1_REG(UART3) & UART_S1_TDRE_MASK));
    //发送数据
    UART_D_REG(UART3) = (uint8)ch;
}

//针对MiniIMU AHRS软件的参数串口波形测试
void Uart_Test(uint16 ax,uint16 ay,uint16 az,uint16 gx,uint16 gy,uint16 gz,
					uint16 hx,uint16 hy,uint16 hz)
{
 	unsigned int temp=0xaF+9;
	char ctemp;
	uart3_send(0xa5);
	uart3_send(0x5a);
	uart3_send(14+8);
	uart3_send(0xA2);
        
	ctemp=ax>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=ax;
	uart3_send(ctemp);
	temp+=ctemp;

	ctemp=ay>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=ay;
	uart3_send(ctemp);
	temp+=ctemp;
        
	ctemp=az>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=az;
	uart3_send(ctemp);
	temp+=ctemp;

	ctemp=gx>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=gx;
	uart3_send(ctemp);
	temp+=ctemp;
//-----------------------------
	ctemp=gy>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=gy;
	uart3_send(ctemp);
	temp+=ctemp;
        
	ctemp=gz>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=gz;
	uart3_send(ctemp);
	temp+=ctemp;
//--------------------------
        
	ctemp=hx>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=hx;
	uart3_send(ctemp);
	temp+=ctemp;
        
	ctemp=hy>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=hy;
	uart3_send(ctemp);
	temp+=ctemp;

	ctemp=hz>>8;
	uart3_send(ctemp);
	temp+=ctemp;
	ctemp=hz;
	uart3_send(ctemp);
	temp+=ctemp;

	uart3_send(temp%256);
	uart3_send(0xaa);
}
//串口发送数据
void serial_choose()
{

    //帧头数据
    uart_send1 (UART3, 0xa5);

    uart_send1 (UART3, 0x5a);

	//选择的线条
	//此处选择了第一,二,三条线

    uart_send1 (UART3, 0x01);
    uart_send1 (UART3, 0x01);
    uart_send1 (UART3, 0x01);
    uart_send1 (UART3, 0x00);
    uart_send1 (UART3, 0x00);
    delay_ms(10);
}













