///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      05/May/2013  16:44:10 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  C:\Users\hp\Desktop\balance car\src\Sources\C\isr.c     /
//    Command line =  "C:\Users\hp\Desktop\balance car\src\Sources\C\isr.c"   /
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
//    List file    =  C:\Users\hp\Desktop\balance car\bin\Ram\List\isr.s      /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME isr

        #define SHT_PROGBITS 0x1

        EXTERN FTM_PWM_ChangeDuty
        EXTERN GetrighttMotorPulse
        EXTERN __aeabi_cfcmple
        EXTERN __aeabi_cfrcmple
        EXTERN __aeabi_d2f
        EXTERN __aeabi_dadd
        EXTERN __aeabi_ddiv
        EXTERN __aeabi_dmul
        EXTERN __aeabi_f2d
        EXTERN __aeabi_f2iz
        EXTERN __aeabi_fadd
        EXTERN __aeabi_fdiv
        EXTERN __aeabi_fmul
        EXTERN __aeabi_fsub
        EXTERN __aeabi_i2d
        EXTERN __aeabi_i2f
        EXTERN gravity
        EXTERN gyro
        EXTERN hw_ad_ave

        PUBLIC AngleCalculate
        PUBLIC AngleControl
        PUBLIC GetInputVoltageAverage
        PUBLIC GetleftMotorPulse
        PUBLIC GetrightMotorPulse
        PUBLIC MotorOutput
        PUBLIC MotorSpeedOut
        PUBLIC SET_SPEED
        PUBLIC SetMotorVoltage
        PUBLIC SpeedControl
        PUBLIC SpeedControlOutput
        PUBLIC car_speed
        PUBLIC g_1MSEntCnt
        PUBLIC g_fAngleControlOut
        PUBLIC g_fCarAngle
        PUBLIC g_fCarSpeed
        PUBLIC g_fDirectionControlOut
        PUBLIC g_fDirectionControlOutNew
        PUBLIC g_fDirectionControlOutOld
        PUBLIC g_fGravityAngle
        PUBLIC g_fGyroscopeAngleIntergral
        PUBLIC g_fGyroscopeAngleSpeed
        PUBLIC g_fLeftMotorOut
        PUBLIC g_fRightMotorOut
        PUBLIC g_fSpeedControlIntegral
        PUBLIC g_fSpeedControlOut
        PUBLIC g_fSpeedControlOutNew
        PUBLIC g_fSpeedControlOutOld
        PUBLIC g_lnInputVoltageSigma
        PUBLIC g_n1MSEventCount
        PUBLIC g_nDirectionControlCount
        PUBLIC g_nDirectionControlPeriod
        PUBLIC g_nInputVoltage
        PUBLIC g_nLeftMotorPulse
        PUBLIC g_nLeftMotorPulseSigma
        PUBLIC g_nRightMotorPulse
        PUBLIC g_nRightMotorPulseSigma
        PUBLIC g_nSpeedControlCount
        PUBLIC g_nSpeedControlPeriod
        PUBLIC get_ad
        PUBLIC gyro_direction
        PUBLIC pit0_isr

// C:\Users\hp\Desktop\balance car\src\Sources\C\isr.c
//    1 //-------------------------------------------------------------------------*
//    2 // 文件名: isr.c                                                           *
//    3 // 说  明: 中断处理例程                                                    *
//    4 //---------------苏州大学飞思卡尔嵌入式系统实验室2011年--------------------*
//    5 
//    6 #include "includes.h"
//    7 void MotorSpeedOut(void);
//    8 void SpeedControl(void);
//    9 void SpeedControlOutput(void);
//   10 void AngleCalculate(void);
//   11 void AngleControl(void);
//   12 void MotorOutput(void);
//   13 void GetInputVoltageAverage(int j);
//   14 void get_ad(void);
//   15 void GetleftMotorPulse(void);
//   16 void GetrighttMotorPulse(void);
//   17 void SetMotorVoltage(float fLeftVal, float fRightVal);
//   18 //uint8 g_nSpeedControlCount=0; 

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   19 uint8 g_1MSEntCnt=0;
g_1MSEntCnt:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   20 unsigned int   g_n1MSEventCount =0;
g_n1MSEventCount:
        DS8 4
//   21 
//   22 
//   23 
//   24 
//   25 #define MOTOR_OUT_MAX 1.0
//   26 #define MOTOR_OUT_MIN	-1.0
//   27 
//   28 #define GRAVITY_OFFSET              gravity // 1202//  1231    
//   29 #define GYROSCOPE_OFFSET            gyro   // 1436
//   30 #define GYROSCOPE_OFFSET_DIRECTION   gyro_direction
//   31 #define GRAVITY_ANGLE_RATIO              0.202
//   32 #define GYROSCOPE_ANGLE_RATIO          0.95 //0.232//0.35
//   33 #define GRAVITY_ADJUST_TIME_CONSTANT     3.0
//   34 #define GYROSCOPE_ANGLE_SIGMA_FREQUENCY  200
//   35 #define CAR_ANGLE_SET                  0
//   36 #define ANGLE_CONTROL_P              0.1//0.15 0.09
//   37 #define CAR_ANGLE_SPEED_SET              0
//   38 #define ANGLE_CONTROL_D        0.0016// 0.0016//0.002 
//   39 #define ANGLE_CONTROL_OUT_MAX			MOTOR_OUT_MAX *10
//   40 #define ANGLE_CONTROL_OUT_MIN			MOTOR_OUT_MIN * 10
//   41 #define LEFT_RIGHT_MINIMUM               300
//   42 #define DIR_CONTROL_P                   0.62//0.35 //0.35好
//   43 #define DIR_CONTROL_D                   0.0008
//   44 #define DIRECTION_CONTROL_DEADVALUE      0
//   45 
//   46 #define DIRECTION_CONTROL_OUT_MAX		MOTOR_OUT_MAX
//   47 #define DIRECTION_CONTROL_OUT_MIN		MOTOR_OUT_MIN
//   48 #define DIRECTION_CONTROL_PERIOD         10
//   49 #define CAR_SPEED_CONSTANT               0.2
//   50 
//   51 //unsigned char flag_increase=0;
//   52 //unsigned char flag_decrease=0;
//   53 //#define CAR_SPEED_SET             0.0//30.0//12.5// 10.5    //  car_speed
//   54 #define CAR_SPEED_STEP               0.8   //每100毫秒增加的速度
//   55 //#define CAR_SPEED_SET_INCREASE   5.0
//   56 //#define CAR_SPEED_SET_MAX  CAR_SPEED_SET+CAR_SPEED_SET_INCREASE
//   57 #define DIR_DEFAULT_MIN   50
//   58 
//   59 #define SPEED_CONTROL_P          0.09//0.25
//   60 #define SPEED_CONTROL_I       0.014// 0.05
//   61 
//   62 
//   63 #define SPEED_CONTROL_OUT_MAX			MOTOR_OUT_MAX *10
//   64 #define SPEED_CONTROL_OUT_MIN			MOTOR_OUT_MIN * 10
//   65 #define SPEED_CONTROL_PERIOD            100
//   66 #define MOTOR_OUT_DEAD_VAL             0
//   67 #define MOTOR_LEFT_SPEED_POSITIVE		(g_fLeftMotorOut > 0)
//   68 #define MOTOR_RIGHT_SPEED_POSITIVE		(g_fRightMotorOut > 0)
//   69 
//   70 #define DIR_LEFT_OFFSET  15 //742 //dir_left_offset//688    659  702
//   71 #define DIR_RIGHT_OFFSET 37 //dir_right_offset// 688
//   72 
//   73 //------------------------------------------------------------------------------
//   74 //#define ANGLE_CONTROL_P_1   0.1
//   75 //#define ANGLE_CONTROL_D_1   0.002
//   76 //#define ANGLE_CONTROL_P_2   0.25
//   77 //#define ANGLE_CONTROL_D_2   0.002
//   78 extern int gravity,gyro;
//   79 //int dir_left_offset,dir_right_offset;

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   80 float car_speed=20.0;
car_speed:
        DATA
        DC32 41A00000H
//   81 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   82  int gyro_direction;
gyro_direction:
        DS8 4
//   83  
//   84 //--------------------------------------------------------------------------

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   85 long int 	g_lnInputVoltageSigma[5]={0};    	
g_lnInputVoltageSigma:
        DS8 20

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   86 int       g_nInputVoltage[5]={0};   
g_nInputVoltage:
        DS8 20
//   87 
//   88 #define VOLTAGE_GRAVITY    g_nInputVoltage[0]
//   89 #define VOLTAGE_GYRO       g_nInputVoltage[1]
//   90 #define VOLTAGE_LEFT       g_nInputVoltage[2]
//   91 #define VOLTAGE_RIGHT      g_nInputVoltage[3]		
//   92 #define DIR_CONTROL_D_VALUE  g_nInputVoltage[4]

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   93 float g_fGravityAngle=0;
g_fGravityAngle:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   94 float g_fGyroscopeAngleSpeed =0;
g_fGyroscopeAngleSpeed:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   95 float g_fCarAngle=0;
g_fCarAngle:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   96 float g_fGyroscopeAngleIntergral =0;
g_fGyroscopeAngleIntergral:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   97 float g_fAngleControlOut=0;
g_fAngleControlOut:
        DS8 4
//   98 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   99 float g_fDirectionControlOutOld=0;
g_fDirectionControlOutOld:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  100 float g_fDirectionControlOutNew =0;
g_fDirectionControlOutNew:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  101 float g_fDirectionControlOut=0;
g_fDirectionControlOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  102 int   g_nDirectionControlPeriod=0;
g_nDirectionControlPeriod:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  103 int   g_nDirectionControlCount =0;
g_nDirectionControlCount:
        DS8 4
//  104 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  105  int g_nLeftMotorPulseSigma =0;
g_nLeftMotorPulseSigma:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  106  int g_nRightMotorPulseSigma=0;
g_nRightMotorPulseSigma:
        DS8 4
//  107 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  108 float g_fCarSpeed=0;
g_fCarSpeed:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  109 float g_fSpeedControlIntegral=0;
g_fSpeedControlIntegral:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  110 float g_fSpeedControlOutOld =0;
g_fSpeedControlOutOld:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  111 float g_fSpeedControlOutNew =0;
g_fSpeedControlOutNew:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  112 float g_fSpeedControlOut =0;
g_fSpeedControlOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//  113 uint8   g_nSpeedControlPeriod=0;
g_nSpeedControlPeriod:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  114 extern int  g_nSpeedControlCount =0;
g_nSpeedControlCount:
        DS8 4
//  115 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  116 float g_fLeftMotorOut=0;
g_fLeftMotorOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  117 float g_fRightMotorOut =0;
g_fRightMotorOut:
        DS8 4
//  118 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  119  int  g_nLeftMotorPulse=0;
g_nLeftMotorPulse:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  120  int  g_nRightMotorPulse=0;
g_nRightMotorPulse:
        DS8 4
//  121 
//  122 // float OutData[4] = { 0 };  //虚拟示波器输出
//  123 // void OutPut_Data(void);
//  124 
//  125 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  126 float  SET_SPEED=0.0;
SET_SPEED:
        DS8 4
//  127  
//  128 #define CAR_SPEED_SET            SET_SPEED 
//  129  
//  130  
//  131 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//  132 void pit0_isr()                   //定时器1ms中断函数
//  133 {  
pit0_isr:
        PUSH     {R7,LR}
//  134   DisableInterrupts;
        CPSID i         
//  135 
//  136     
//  137   	g_n1MSEventCount ++;
        LDR.W    R0,??DataTable11
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable11
        STR      R0,[R1, #+0]
//  138 
//  139   	//--------------------------------------------------------------------------
//  140 	g_nSpeedControlPeriod ++;
        LDR.W    R0,??DataTable11_1
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable11_1
        STRB     R0,[R1, #+0]
//  141         SpeedControlOutput();
        BL       SpeedControlOutput
//  142   	
//  143   	//g_nDirectionControlPeriod ++;
//  144   	//DirectionControlOutput();
//  145  
//  146  	//--------------------------------------------------------------------------
//  147   	if(g_n1MSEventCount >=5)
        LDR.W    R0,??DataTable11
        LDR      R0,[R0, #+0]
        CMP      R0,#+5
        BCC.N    ??pit0_isr_0
//  148   	 {   
//  149   	                                          // Motor speed adjust
//  150            g_n1MSEventCount = 0;                   // Clear the event counter;
        LDR.W    R0,??DataTable11
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  151            GetleftMotorPulse();
        BL       GetleftMotorPulse
//  152            GetrighttMotorPulse();
        BL       GetrighttMotorPulse
        B.N      ??pit0_isr_1
//  153   	 }
//  154   	 else if(g_n1MSEventCount == 1) 
??pit0_isr_0:
        LDR.W    R0,??DataTable11
        LDR      R0,[R0, #+0]
        CMP      R0,#+1
        BNE.N    ??pit0_isr_2
//  155   	 {                                        // Start ADC convert and Car erect adjust  		 
//  156 			
//  157 	    //SampleInputVoltage();
//  158            get_ad();
        BL       get_ad
//  159 	   AngleCalculate();
        BL       AngleCalculate
        B.N      ??pit0_isr_1
//  160   	 } 
//  161   	 else if(g_n1MSEventCount == 2) 
??pit0_isr_2:
        LDR.W    R0,??DataTable11
        LDR      R0,[R0, #+0]
        CMP      R0,#+2
        BNE.N    ??pit0_isr_3
//  162   	  {          // Get the voltage and start calculation
//  163 		//GetInputVoltageAverage(20);
//  164 		//AngleCalculate();
//  165 	//	 virtual_scope_show();
//  166 		AngleControl();
        BL       AngleControl
//  167 	//	angle_control();	
//  168 		MotorOutput();                          // Output motor control voltage;  		
        BL       MotorOutput
        B.N      ??pit0_isr_1
//  169   	  }
//  170  	 else if(g_n1MSEventCount == 3) 
??pit0_isr_3:
        LDR.W    R0,??DataTable11
        LDR      R0,[R0, #+0]
        CMP      R0,#+3
        BNE.N    ??pit0_isr_1
//  171   	 {                                    // Car speed adjust
//  172   		g_nSpeedControlCount ++;
        LDR.W    R0,??DataTable11_2
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable11_2
        STR      R0,[R1, #+0]
//  173   		if(g_nSpeedControlCount >= 20)
        LDR.W    R0,??DataTable11_2
        LDR      R0,[R0, #+0]
        CMP      R0,#+20
        BLT.N    ??pit0_isr_1
//  174   		 {
//  175   			SpeedControl();
        BL       SpeedControl
//  176   			g_nSpeedControlCount = 0;
        LDR.W    R0,??DataTable11_2
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  177   			g_nSpeedControlPeriod = 0;  			
        LDR.W    R0,??DataTable11_1
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  178   		 }
//  179   	 }   
//  180 /* 	 else if(g_n1MSEventCount == 4)
//  181   	  {                                    // Car direction control
//  182 		g_nDirectionControlCount ++;
//  183 		
//  184 		if(g_nDirectionControlCount >=2)
//  185 		 {
//  186 	  		DirectionControl();
//  187 	  		g_nDirectionControlCount = 0;
//  188 	  		g_nDirectionControlPeriod = 0;
//  189 	          }
//  190     	  }
//  191  	
//  192 */  
//  193     PIT_TFLG(0)|=PIT_TFLG_TIF_MASK;          //清中断标志位
??pit0_isr_1:
        LDR.W    R0,??DataTable11_3  ;; 0x4003710c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.W    R1,??DataTable11_3  ;; 0x4003710c
        STR      R0,[R1, #+0]
//  194     EnableInterrupts;
        CPSIE i         
//  195 }
        POP      {R0,PC}          ;; return
//  196 
//  197 
//  198 
//  199 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  200 void SpeedControlOutput(void) 
//  201 {
SpeedControlOutput:
        PUSH     {R4,LR}
//  202 	float fValue;
//  203 	fValue = g_fSpeedControlOutNew - g_fSpeedControlOutOld;
        LDR.W    R0,??DataTable11_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable11_5
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R4,R0
//  204 	g_fSpeedControlOut = fValue * (g_nSpeedControlPeriod + 1) / SPEED_CONTROL_PERIOD + g_fSpeedControlOutOld;
        LDR.W    R0,??DataTable11_1
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        LDR.W    R1,??DataTable11_6  ;; 0x42c80000
        BL       __aeabi_fdiv
        LDR.W    R1,??DataTable11_5
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable11_7
        STR      R0,[R1, #+0]
//  205 	
//  206 }
        POP      {R4,PC}          ;; return
//  207 
//  208 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  209 void SpeedControl(void)
//  210  {
SpeedControl:
        PUSH     {R4,R5,LR}
//  211 	float fP, fDelta;
//  212 	float fI;
//  213 
//  214 	
//  215 	//--------------------------------------------------------------------------
//  216 	g_fCarSpeed = (g_nLeftMotorPulseSigma + g_nRightMotorPulseSigma) / 2;
        LDR.W    R0,??DataTable11_8
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable11_9
        LDR      R1,[R1, #+0]
        ADDS     R0,R1,R0
        MOVS     R1,#+2
        SDIV     R0,R0,R1
        BL       __aeabi_i2f
        LDR.W    R1,??DataTable11_10
        STR      R0,[R1, #+0]
//  217 	g_nLeftMotorPulseSigma = g_nRightMotorPulseSigma = 0;
        MOVS     R0,#+0
        LDR.W    R1,??DataTable11_9
        STR      R0,[R1, #+0]
        LDR.W    R1,??DataTable11_8
        STR      R0,[R1, #+0]
//  218 	g_fCarSpeed *= CAR_SPEED_CONSTANT;
        LDR.W    R0,??DataTable11_10
        LDR      R0,[R0, #+0]
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable11_11  ;; 0x9999999a
        LDR.W    R3,??DataTable11_12  ;; 0x3fc99999
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        LDR.W    R1,??DataTable11_10
        STR      R0,[R1, #+0]
//  219  /*  
//  220    if(flag_decrease==0)             //1为从最大速度减小
//  221    {
//  222      if(flag_increase==1)           //1为加速
//  223     {
//  224  */    
//  225        if(car_speed<CAR_SPEED_SET)
        LDR.W    R0,??DataTable11_13
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable11_14
        LDR      R1,[R1, #+0]
        BL       __aeabi_cfcmple
        BCS.N    ??SpeedControl_0
//  226       {
//  227 
//  228 		car_speed+=CAR_SPEED_STEP;
        LDR.W    R0,??DataTable11_13
        LDR      R0,[R0, #+0]
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable11_11  ;; 0x9999999a
        LDR.W    R3,??DataTable11_15  ;; 0x3fe99999
        BL       __aeabi_dadd
        BL       __aeabi_d2f
        LDR.W    R1,??DataTable11_13
        STR      R0,[R1, #+0]
//  229 	  	} 
//  230  /*   }
//  231 		else
//  232 		  {
//  233          if(car_speed<CAR_SPEED_SET)
//  234          {
//  235 
//  236 	       	car_speed+=CAR_SPEED_STEP;
//  237 	      	} 
//  238 		  }
//  239     }  
//  240      else
//  241      {
//  242     
//  243         
//  244         
//  245            if(car_speed>CAR_SPEED_SET)
//  246            {
//  247 
//  248 	       	car_speed-=(CAR_SPEED_STEP+0.2);
//  249 	        	} 
//  250         
//  251 	    
//  252 	  	}  */
//  253 	//--------------------------------------------------------------------------
//  254 	fDelta =car_speed;//CAR_SPEED_SET;//car_speed; 
??SpeedControl_0:
        LDR.W    R0,??DataTable11_13
        LDR      R5,[R0, #+0]
//  255 	fDelta -= g_fCarSpeed;
        MOVS     R0,R5
        LDR.W    R1,??DataTable11_10
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R5,R0
//  256 	
//  257 	fP = fDelta * SPEED_CONTROL_P;
        MOVS     R0,R5
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable11_16  ;; 0x70a3d70a
        LDR.W    R3,??DataTable11_17  ;; 0x3fb70a3d
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        MOVS     R4,R0
//  258 	fI = fDelta * SPEED_CONTROL_I;
        MOVS     R0,R5
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable11_18  ;; 0x3126e979
        LDR.W    R3,??DataTable11_19  ;; 0x3f8cac08
        BL       __aeabi_dmul
        BL       __aeabi_d2f
//  259 	g_fSpeedControlIntegral += fI;
        LDR.W    R1,??DataTable11_20
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable11_20
        STR      R0,[R1, #+0]
//  260 	
//  261 			
//  262 	//--------------------------------------------------------------------------
//  263 	
//  264 	if(g_fSpeedControlIntegral > SPEED_CONTROL_OUT_MAX)	
        LDR.W    R0,??DataTable11_20
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable11_21  ;; 0x41200001
        BL       __aeabi_cfrcmple
        BHI.N    ??SpeedControl_1
//  265 		g_fSpeedControlIntegral = SPEED_CONTROL_OUT_MAX;
        LDR.W    R0,??DataTable11_20
        LDR.W    R1,??DataTable11_22  ;; 0x41200000
        STR      R1,[R0, #+0]
//  266 	if(g_fSpeedControlIntegral < SPEED_CONTROL_OUT_MIN)  	
??SpeedControl_1:
        LDR.W    R0,??DataTable11_20
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable11_23  ;; 0xc1200000
        BL       __aeabi_cfcmple
        BCS.N    ??SpeedControl_2
//  267 		g_fSpeedControlIntegral = SPEED_CONTROL_OUT_MIN;
        LDR.W    R0,??DataTable11_20
        LDR.W    R1,??DataTable11_23  ;; 0xc1200000
        STR      R1,[R0, #+0]
//  268 	
//  269 	g_fSpeedControlOutOld = g_fSpeedControlOutNew;
??SpeedControl_2:
        LDR.N    R0,??DataTable11_5
        LDR.N    R1,??DataTable11_4
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
//  270 
//  271 	g_fSpeedControlOutNew = fP + g_fSpeedControlIntegral;
        LDR.W    R0,??DataTable11_20
        LDR      R0,[R0, #+0]
        MOVS     R1,R4
        BL       __aeabi_fadd
        LDR.N    R1,??DataTable11_4
        STR      R0,[R1, #+0]
//  272 
//  273 	
//  274 }
        POP      {R4,R5,PC}       ;; return
//  275 
//  276 
//  277 //----------------------------------------------------------------------------
//  278 //函数名称:AngleCalculate()
//  279 //函数返回:无
//  280 //参数说明:无
//  281 //功能概要:角度计算
//  282 //-----------------------------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  283 void AngleCalculate(void)
//  284 {
AngleCalculate:
        PUSH     {LR}
//  285       float Value;
//  286       g_fGravityAngle=(VOLTAGE_GRAVITY-GRAVITY_OFFSET) * GRAVITY_ANGLE_RATIO ;
        LDR.N    R0,??DataTable11_24
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable11_25
        LDR      R1,[R1, #+0]
        SUBS     R0,R0,R1
        BL       __aeabi_i2d
        LDR.N    R2,??DataTable11_26  ;; 0xd0e56042
        LDR.N    R3,??DataTable11_27  ;; 0x3fc9db22
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        LDR.N    R1,??DataTable11_28
        STR      R0,[R1, #+0]
//  287       
//  288       g_fGyroscopeAngleSpeed=(VOLTAGE_GYRO-GYROSCOPE_OFFSET) * GYROSCOPE_ANGLE_RATIO;
        LDR.N    R0,??DataTable11_24
        LDR      R0,[R0, #+4]
        LDR.N    R1,??DataTable11_29
        LDR      R1,[R1, #+0]
        SUBS     R0,R0,R1
        BL       __aeabi_i2d
        MOVS     R2,#+1717986918
        LDR.N    R3,??DataTable11_30  ;; 0x3fee6666
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        LDR.N    R1,??DataTable11_31
        STR      R0,[R1, #+0]
//  289       
//  290       g_fCarAngle=g_fGyroscopeAngleIntergral;
        LDR.N    R0,??DataTable11_32
        LDR.N    R1,??DataTable11_33
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
//  291       Value=(g_fGravityAngle-g_fCarAngle)/GRAVITY_ADJUST_TIME_CONSTANT;
        LDR.N    R0,??DataTable11_28
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable11_32
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        BL       __aeabi_f2d
        MOVS     R2,#+0
        LDR.N    R3,??DataTable11_34  ;; 0x40080000
        BL       __aeabi_ddiv
        BL       __aeabi_d2f
//  292       
//  293       g_fGyroscopeAngleIntergral+=(g_fGyroscopeAngleSpeed+Value)/GYROSCOPE_ANGLE_SIGMA_FREQUENCY;   
        LDR.N    R1,??DataTable11_31
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.N    R1,??DataTable11_35  ;; 0x43480000
        BL       __aeabi_fdiv
        LDR.N    R1,??DataTable11_33
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.N    R1,??DataTable11_33
        STR      R0,[R1, #+0]
//  294   
//  295   
//  296 }
        POP      {PC}             ;; return
//  297 //============================================================================
//  298 //函数名称: AngleControl(void) 
//  299 //函数返回:无
//  300 //参数说明:无
//  301 //功能概要:角度控制
//  302 //============================================================================
//  303 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  304 void AngleControl(void) 
//  305 {
AngleControl:
        PUSH     {R4,R5,LR}
//  306 	float fValue1;
//  307 
//  308 	fValue1 = (CAR_ANGLE_SET - g_fCarAngle) * ANGLE_CONTROL_P +
//  309 	         (CAR_ANGLE_SPEED_SET - g_fGyroscopeAngleSpeed) * ANGLE_CONTROL_D;
        LDR.N    R0,??DataTable11_32
        LDR      R0,[R0, #+0]
        EORS     R0,R0,#0x80000000
        BL       __aeabi_f2d
        LDR.N    R2,??DataTable11_11  ;; 0x9999999a
        LDR.N    R3,??DataTable11_36  ;; 0x3fb99999
        BL       __aeabi_dmul
        MOVS     R4,R0
        MOVS     R5,R1
        LDR.N    R0,??DataTable11_31
        LDR      R0,[R0, #+0]
        EORS     R0,R0,#0x80000000
        BL       __aeabi_f2d
        LDR.N    R2,??DataTable11_37  ;; 0xeb1c432d
        LDR.N    R3,??DataTable11_38  ;; 0x3f5a36e2
        BL       __aeabi_dmul
        MOVS     R2,R4
        MOVS     R3,R5
        BL       __aeabi_dadd
        BL       __aeabi_d2f
//  310 	         
//  311 	if(fValue1 > ANGLE_CONTROL_OUT_MAX)			fValue1 = ANGLE_CONTROL_OUT_MAX;
        LDR.N    R1,??DataTable11_21  ;; 0x41200001
        BL       __aeabi_cfrcmple
        BHI.N    ??AngleControl_0
        LDR.N    R0,??DataTable11_22  ;; 0x41200000
        B.N      ??AngleControl_1
//  312 	else if(fValue1 < ANGLE_CONTROL_OUT_MIN) 	fValue1 = ANGLE_CONTROL_OUT_MIN;
??AngleControl_0:
        LDR.N    R1,??DataTable11_23  ;; 0xc1200000
        BL       __aeabi_cfcmple
        BCS.N    ??AngleControl_1
        LDR.N    R0,??DataTable11_23  ;; 0xc1200000
//  313 	g_fAngleControlOut = fValue1;
??AngleControl_1:
        LDR.N    R1,??DataTable11_39
        STR      R0,[R1, #+0]
//  314 	
//  315 }
        POP      {R4,R5,PC}       ;; return
//  316 //------------------------------------------------------------------------------
//  317 //函数名称:MotorOutput(void)
//  318 //函数返回:
//  319 //参数说明:
//  320 //功能概要:
//  321 //------------------------------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  322 void MotorOutput(void)
//  323 {
MotorOutput:
        PUSH     {R4,LR}
//  324 	float fLeft, fRight;
//  325 
//  326 	fLeft = g_fAngleControlOut- g_fSpeedControlOut;    //- g_fDirectionControlOut;
        LDR.N    R0,??DataTable11_39
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable11_7
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R4,R0
//  327 	fRight = g_fAngleControlOut - g_fSpeedControlOut;   // + g_fDirectionControlOut;
        LDR.N    R0,??DataTable11_39
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable11_7
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R2,R0
//  328 	
//  329 	if(fLeft > MOTOR_OUT_MAX)		fLeft = MOTOR_OUT_MAX;
        MOVS     R0,R4
        LDR.N    R1,??DataTable11_40  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorOutput_0
        MOVS     R4,#+1065353216
//  330 	if(fLeft < MOTOR_OUT_MIN)		fLeft = MOTOR_OUT_MIN;
??MotorOutput_0:
        MOVS     R0,R4
        LDR.N    R1,??DataTable11_41  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorOutput_1
        LDR.N    R4,??DataTable11_41  ;; 0xbf800000
//  331 	if(fRight > MOTOR_OUT_MAX)		fRight = MOTOR_OUT_MAX;
??MotorOutput_1:
        MOVS     R0,R2
        LDR.N    R1,??DataTable11_40  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorOutput_2
        MOVS     R2,#+1065353216
//  332 	if(fRight < MOTOR_OUT_MIN)		fRight = MOTOR_OUT_MIN;
??MotorOutput_2:
        MOVS     R0,R2
        LDR.N    R1,??DataTable11_41  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorOutput_3
        LDR.N    R2,??DataTable11_41  ;; 0xbf800000
//  333 		
//  334 	g_fLeftMotorOut = fLeft;
??MotorOutput_3:
        LDR.N    R0,??DataTable11_42
        STR      R4,[R0, #+0]
//  335 	g_fRightMotorOut = fRight;
        LDR.N    R0,??DataTable11_43
        STR      R2,[R0, #+0]
//  336 	MotorSpeedOut();
        BL       MotorSpeedOut
//  337 }
        POP      {R4,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  338 void get_ad()
//  339 {
get_ad:
        PUSH     {R7,LR}
//  340    VOLTAGE_GRAVITY = hw_ad_ave(0,12,12,10);                 //均值滤波得加速度电压信号(PTB2)
        MOVS     R3,#+10
        MOVS     R2,#+12
        MOVS     R1,#+12
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.N    R1,??DataTable11_24
        STR      R0,[R1, #+0]
//  341    VOLTAGE_GYRO = hw_ad_ave(0,13,12,10);                  //--------得平衡陀螺仪电压信号(PTB3)
        MOVS     R3,#+10
        MOVS     R2,#+12
        MOVS     R1,#+13
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.N    R1,??DataTable11_24
        STR      R0,[R1, #+4]
//  342    //VOLTAGE_GYRO_2 = hw_ad_ave(0,14,12,10);                  //---------得转向陀螺仪电压信号(PTC0)
//  343 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  344 void GetInputVoltageAverage(int j)
//  345 {
//  346 	int i;
//  347 
//  348 	for(i = 0; i < 5; i ++) 
GetInputVoltageAverage:
        MOVS     R1,#+0
        B.N      ??GetInputVoltageAverage_0
//  349 	{
//  350 		g_nInputVoltage[i] = (int)(g_lnInputVoltageSigma[i] /j);
??GetInputVoltageAverage_1:
        LDR.N    R2,??DataTable11_44
        LDR      R2,[R2, R1, LSL #+2]
        SDIV     R2,R2,R0
        LDR.N    R3,??DataTable11_24
        STR      R2,[R3, R1, LSL #+2]
//  351 		g_lnInputVoltageSigma[i] = 0;
        LDR.N    R2,??DataTable11_44
        MOVS     R3,#+0
        STR      R3,[R2, R1, LSL #+2]
//  352 	}
        ADDS     R1,R1,#+1
??GetInputVoltageAverage_0:
        CMP      R1,#+5
        BLT.N    ??GetInputVoltageAverage_1
//  353 
//  354 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  355 void MotorSpeedOut(void)
//  356 {
MotorSpeedOut:
        PUSH     {R7,LR}
//  357 	float fLeftVal, fRightVal;
//  358 	
//  359 	fLeftVal = g_fLeftMotorOut;
        LDR.N    R0,??DataTable11_42
        LDR      R2,[R0, #+0]
//  360 	fRightVal = g_fRightMotorOut;
        LDR.N    R0,??DataTable11_43
        LDR      R3,[R0, #+0]
//  361 //	if(fLeftVal > 0) 			fLeftVal += MOTOR_OUT_DEAD_VAL;
//  362 //	else if(fLeftVal < 0) 		fLeftVal -= MOTOR_OUT_DEAD_VAL;
//  363 //	
//  364 //	if(fRightVal > 0)			fRightVal += MOTOR_OUT_DEAD_VAL;
//  365 //	else if(fRightVal < 0)		fRightVal -= MOTOR_OUT_DEAD_VAL;
//  366 		
//  367 	if(fLeftVal > MOTOR_OUT_MAX)	fLeftVal = MOTOR_OUT_MAX;
        MOVS     R0,R2
        LDR.N    R1,??DataTable11_40  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorSpeedOut_0
        MOVS     R2,#+1065353216
//  368 	if(fLeftVal < MOTOR_OUT_MIN)	fLeftVal = MOTOR_OUT_MIN;
??MotorSpeedOut_0:
        MOVS     R0,R2
        LDR.N    R1,??DataTable11_41  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorSpeedOut_1
        LDR.N    R2,??DataTable11_41  ;; 0xbf800000
//  369 	if(fRightVal > MOTOR_OUT_MAX)	fRightVal = MOTOR_OUT_MAX;
??MotorSpeedOut_1:
        MOVS     R0,R3
        LDR.N    R1,??DataTable11_40  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorSpeedOut_2
        MOVS     R3,#+1065353216
//  370 	if(fRightVal < MOTOR_OUT_MIN)	fRightVal = MOTOR_OUT_MIN;
??MotorSpeedOut_2:
        MOVS     R0,R3
        LDR.N    R1,??DataTable11_41  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorSpeedOut_3
        LDR.N    R3,??DataTable11_41  ;; 0xbf800000
//  371 			
//  372 	SetMotorVoltage(fLeftVal, fRightVal);
??MotorSpeedOut_3:
        MOVS     R1,R3
        MOVS     R0,R2
        BL       SetMotorVoltage
//  373 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  374 void GetleftMotorPulse()
//  375 {
//  376   uint32  nLeftPulse;
//  377   
//  378   nLeftPulse=FTM1_CNT;
GetleftMotorPulse:
        LDR.N    R0,??DataTable11_45  ;; 0x40039004
        LDR      R0,[R0, #+0]
//  379   g_nLeftMotorPulse = (int)nLeftPulse;
        LDR.N    R1,??DataTable11_46
        STR      R0,[R1, #+0]
//  380   
//  381   g_nLeftMotorPulseSigma +=g_nLeftMotorPulse;
        LDR.N    R0,??DataTable11_8
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable11_46
        LDR      R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.N    R1,??DataTable11_8
        STR      R0,[R1, #+0]
//  382   FTM1_CNT=0;  
        LDR.N    R0,??DataTable11_45  ;; 0x40039004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  383 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  384 void GetrightMotorPulse()
//  385 {
//  386   uint32  nRightPulse; 
//  387   nRightPulse=FTM2_CNT;
GetrightMotorPulse:
        LDR.N    R0,??DataTable11_47  ;; 0x400b8004
        LDR      R0,[R0, #+0]
//  388   g_nRightMotorPulse = (int)nRightPulse;
        LDR.N    R1,??DataTable11_48
        STR      R0,[R1, #+0]
//  389   g_nRightMotorPulseSigma +=g_nRightMotorPulse;	
        LDR.N    R0,??DataTable11_9
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable11_48
        LDR      R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.N    R1,??DataTable11_9
        STR      R0,[R1, #+0]
//  390   FTM2_CNT=0; 
        LDR.N    R0,??DataTable11_47  ;; 0x400b8004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  391 }
        BX       LR               ;; return
//  392  /*
//  393          	g_nLeftMotorPulse = (int)nLeftPulse;
//  394 	
//  395          if(!MOTOR_LEFT_SPEED_POSITIVE)		g_nLeftMotorPulse = -g_nLeftMotorPulse;
//  396          
//  397          g_nLeftMotorPulseSigma +=g_nLeftMotorPulse;
//  398         }
//  399     else 
//  400         {
//  401           nRightPulse=PACNT;
//  402          
//  403             g_nRightMotorPulse = (int)nRightPulse;
//  404          	
//  405         
//  406          if(!MOTOR_RIGHT_SPEED_POSITIVE)		g_nRightMotorPulse = -g_nRightMotorPulse;
//  407          
//  408          	g_nRightMotorPulseSigma +=g_nRightMotorPulse;	
//  409         }*/
//  410 
//  411 //******************************************************************************

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  412 void SetMotorVoltage(float fLeftVoltage, float fRightVoltage) 
//  413 {
SetMotorVoltage:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
        MOVS     R5,R1
//  414                                                 // Voltage : > 0 : Move forward;
//  415                                                 //           < 0 : Move backward
//  416 	int nPeriod;
//  417 	int nOut;
//  418 	
//  419 	nPeriod =100;
        MOVS     R6,#+100
//  420 	
//  421 	//--------------------------------------------------------------------------
//  422 	if(fLeftVoltage > 1.0) 			fLeftVoltage = 1.0;
        MOVS     R0,R4
        LDR.N    R1,??DataTable11_40  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??SetMotorVoltage_0
        MOVS     R4,#+1065353216
        B.N      ??SetMotorVoltage_1
//  423 	else if(fLeftVoltage < -1.0) 	fLeftVoltage = -1.0;
??SetMotorVoltage_0:
        MOVS     R0,R4
        LDR.N    R1,??DataTable11_41  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??SetMotorVoltage_1
        LDR.N    R4,??DataTable11_41  ;; 0xbf800000
//  424 	
//  425 	if(fRightVoltage > 1.0) 		fRightVoltage = 1.0;
??SetMotorVoltage_1:
        MOVS     R0,R5
        LDR.N    R1,??DataTable11_40  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??SetMotorVoltage_2
        MOVS     R5,#+1065353216
        B.N      ??SetMotorVoltage_3
//  426 	else if(fRightVoltage < -1.0)	fRightVoltage = -1.0;
??SetMotorVoltage_2:
        MOVS     R0,R5
        LDR.N    R1,??DataTable11_41  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??SetMotorVoltage_3
        LDR.N    R5,??DataTable11_41  ;; 0xbf800000
//  427   
//  428   
//  429   
//  430    	//--------------------------------------------------------------------------
//  431 	if(fRightVoltage > 0)                                          //右轮 前
??SetMotorVoltage_3:
        MOVS     R0,R5
        MOVS     R1,#+0
        BL       __aeabi_cfrcmple
        BCS.N    ??SetMotorVoltage_4
//  432         {
//  433           //PWMDTY2=0;
//  434           nOut = (int)(fRightVoltage * nPeriod);
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R5
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  435           FTM_PWM_ChangeDuty(0,2, nOut);
        MOVS     R2,R0
        MOVS     R1,#+2
        MOVS     R0,#+0
        BL       FTM_PWM_ChangeDuty
        B.N      ??SetMotorVoltage_5
//  436 	}
//  437 	 else                                                          //右轮 后
//  438 	{
//  439 	
//  440 	  //PWMDTY3=0;
//  441 	 // fRightVoltage = -fRightVoltage;
//  442           nOut = (int)(fRightVoltage * nPeriod);
??SetMotorVoltage_4:
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R5
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  443   	  FTM_PWM_ChangeDuty(0,2, nOut);
        MOVS     R2,R0
        MOVS     R1,#+2
        MOVS     R0,#+0
        BL       FTM_PWM_ChangeDuty
//  444   		 
//  445 	 
//  446 	}
//  447   
//  448   
//  449                                               
//  450 	//--------------------------------------------------------------------------	                                            	                                              
//  451 	if(fLeftVoltage > 0)                                           //左轮 前
??SetMotorVoltage_5:
        MOVS     R0,R4
        MOVS     R1,#+0
        BL       __aeabi_cfrcmple
        BCS.N    ??SetMotorVoltage_6
//  452 	 {
//  453 	 
//  454 	 // PWMDTY0=0;
//  455           nOut = (int)(fLeftVoltage * nPeriod);
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  456   	  FTM_PWM_ChangeDuty(0,1, nOut);
        MOVS     R2,R0
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       FTM_PWM_ChangeDuty
        B.N      ??SetMotorVoltage_7
//  457 	} 
//  458 	else                                                           //左轮 后
//  459 	{ 
//  460 	 // PWMDTY1=0;
//  461 	  //fLeftVoltage = -fLeftVoltage;
//  462 	  nOut = (int)(fLeftVoltage * nPeriod);
??SetMotorVoltage_6:
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  463   	  FTM_PWM_ChangeDuty(0,1, nOut);
        MOVS     R2,R0
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       FTM_PWM_ChangeDuty
//  464 	}                                     
//  465 
//  466 
//  467                             
//  468 } 
??SetMotorVoltage_7:
        POP      {R4-R6,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11:
        DC32     g_n1MSEventCount

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_1:
        DC32     g_nSpeedControlPeriod

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_2:
        DC32     g_nSpeedControlCount

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_3:
        DC32     0x4003710c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_4:
        DC32     g_fSpeedControlOutNew

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_5:
        DC32     g_fSpeedControlOutOld

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_6:
        DC32     0x42c80000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_7:
        DC32     g_fSpeedControlOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_8:
        DC32     g_nLeftMotorPulseSigma

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_9:
        DC32     g_nRightMotorPulseSigma

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_10:
        DC32     g_fCarSpeed

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_11:
        DC32     0x9999999a

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_12:
        DC32     0x3fc99999

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_13:
        DC32     car_speed

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_14:
        DC32     SET_SPEED

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_15:
        DC32     0x3fe99999

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_16:
        DC32     0x70a3d70a

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_17:
        DC32     0x3fb70a3d

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_18:
        DC32     0x3126e979

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_19:
        DC32     0x3f8cac08

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_20:
        DC32     g_fSpeedControlIntegral

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_21:
        DC32     0x41200001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_22:
        DC32     0x41200000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_23:
        DC32     0xc1200000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_24:
        DC32     g_nInputVoltage

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_25:
        DC32     gravity

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_26:
        DC32     0xd0e56042

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_27:
        DC32     0x3fc9db22

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_28:
        DC32     g_fGravityAngle

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_29:
        DC32     gyro

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_30:
        DC32     0x3fee6666

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_31:
        DC32     g_fGyroscopeAngleSpeed

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_32:
        DC32     g_fCarAngle

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_33:
        DC32     g_fGyroscopeAngleIntergral

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_34:
        DC32     0x40080000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_35:
        DC32     0x43480000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_36:
        DC32     0x3fb99999

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_37:
        DC32     0xeb1c432d

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_38:
        DC32     0x3f5a36e2

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_39:
        DC32     g_fAngleControlOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_40:
        DC32     0x3f800001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_41:
        DC32     0xbf800000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_42:
        DC32     g_fLeftMotorOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_43:
        DC32     g_fRightMotorOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_44:
        DC32     g_lnInputVoltageSigma

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_45:
        DC32     0x40039004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_46:
        DC32     g_nLeftMotorPulse

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_47:
        DC32     0x400b8004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable11_48:
        DC32     g_nRightMotorPulse

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
//  469   
//  470 
//  471 
// 
//   142 bytes in section .bss
//     4 bytes in section .data
// 1 434 bytes in section .text
// 
// 1 434 bytes of CODE memory
//   146 bytes of DATA memory
//
//Errors: none
//Warnings: none
