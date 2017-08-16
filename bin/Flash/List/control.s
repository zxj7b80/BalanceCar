///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      30/Sep/2013  21:46:33 /
// IAR ANSI C/C++ Compiler V6.30.4.23288/W32 EVALUATION for ARM               /
// Copyright 1999-2011 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  D:\balance car（9.28高速但出赛道）\src\Sources\C\Compon /
//                    ent_C\control.c                                         /
//    Command line =  "D:\balance car（9.28高速但出赛道）\src\Sources\C\Compo /
//                    nent_C\control.c" -D IAR -D TWR_K60N512 -lCN            /
//                    "D:\balance car（9.28高速但出赛道）\bin\Flash\List\"    /
//                    -lB "D:\balance car（9.28高速但出赛道）\bin\Flash\List\ /
//                    " -o "D:\balance car（9.28高速但出赛道）\bin\Flash\Obj\ /
//                    " --no_cse --no_unroll --no_inline --no_code_motion     /
//                    --no_tbaa --no_clustering --no_scheduling --debug       /
//                    --endian=little --cpu=Cortex-M4 -e --fpu=None           /
//                    --dlib_config E:\IAREW6.3\arm\INC\c\DLib_Config_Normal. /
//                    h -I "D:\balance car（9.28高速但出赛道）\src\Sources\H\ /
//                    " -I "D:\balance car（9.28高速但出赛道）\src\Sources\H\ /
//                    Component_H\" -I "D:\balance                            /
//                    car（9.28高速但出赛道）\src\Sources\H\Frame_H\" -Ol     /
//                    --use_c++_inline                                        /
//    List file    =  D:\balance car（9.28高速但出赛道）\bin\Flash\List\contr /
//                    ol.s                                                    /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME control

        #define SHT_PROGBITS 0x1

        EXTERN LCD_P8x16_number
        EXTERN Pixel
        EXTERN Pixel_1
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
        EXTERN __aeabi_memclr4
        EXTERN a
        EXTERN `b`
        EXTERN delay_ms
        EXTERN gpio_init
        EXTERN hw_ad_ave
        EXTERN hw_ad_once
        EXTERN hw_adc_convertstart
        EXTERN hw_adc_convertstop
        EXTERN hw_adc_init
        EXTERN speedflag
        EXTERN uart_send1

        PUBLIC ADC0_start
        PUBLIC ADC0_stop
        PUBLIC AngleCalculate
        PUBLIC AngleControl
        PUBLIC BlackManange
        PUBLIC CCD_init
        PUBLIC CRC_CHECK
        PUBLIC CalculateIntegrationTime
        PUBLIC CalculateIntegrationTimeRight
        PUBLIC Clear
        PUBLIC DirectionControl
        PUBLIC DirectionControlOutput
        PUBLIC GetInputVoltageAverage
        PUBLIC GetMotorPulse
        PUBLIC GetOFFSET
        PUBLIC GetSamplezhi
        PUBLIC ImageCapture
        PUBLIC ImageCapture_1
        PUBLIC IntegrationTime
        PUBLIC IntegrationTime_Right
        PUBLIC KeyScan
        PUBLIC KeyScan_1
        PUBLIC LCD_show
        PUBLIC MotorOutput
        PUBLIC MotorSpeedOut
        PUBLIC OutData
        PUBLIC OutPut_Data
        PUBLIC PixelAverage
        PUBLIC PixelAverageValue
        PUBLIC PixelAverageValue_Right
        PUBLIC PixelAverageVoltage
        PUBLIC PixelAverageVoltageError
        PUBLIC PixelAverageVoltage_Right
        PUBLIC SamplingDelay
        PUBLIC SendHex
        PUBLIC SendImageData
        PUBLIC SetMotorVoltage
        PUBLIC SpeedControl
        PUBLIC SpeedControlOutput
        PUBLIC StartIntegration
        PUBLIC StartIntegrationRight
        PUBLIC TargetPixelAverageVoltage
        PUBLIC TargetPixelAverageVoltageAllowError
        PUBLIC button_init
        PUBLIC dev
        PUBLIC g_fAngleControlOut
        PUBLIC g_fCarAngle
        PUBLIC g_fCarSpeed
        PUBLIC g_fCarSpeedstart
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
        PUBLIC g_nDirectionControlPeriod
        PUBLIC g_nInputVoltage
        PUBLIC g_nLeftMotorPulse
        PUBLIC g_nLeftMotorPulseSigma
        PUBLIC g_nRightMotorPulse
        PUBLIC g_nRightMotorPulseSigma
        PUBLIC g_nSpeedControlPeriod
        PUBLIC getCCD
        PUBLIC get_ad
        PUBLIC get_left
        PUBLIC get_right
        PUBLIC gravity
        PUBLIC gyro
        PUBLIC gyro_direction
        PUBLIC left
        PUBLIC left_OFFSET
        PUBLIC left_c
        PUBLIC left_l
        PUBLIC right
        PUBLIC right_OFFSET
        PUBLIC right_c
        PUBLIC right_l
        PUBLIC serial_Txd
        PUBLIC virtual_scope_show

// D:\balance car（9.28高速但出赛道）\src\Sources\C\Component_C\control.c
//    1 #include "includes.h"
//    2 /*
//    3 ANGLE_CONTROL_P   ANGLE_CONTROL_D   SPEED_CONTROL_P   SPEED_CONTROL_I   CAR_SPEED_SET   DIR_CONTROL_P   DIR_CONTROL_D
//    4 0.19              0.006             0.03              0.00003           10              0.012           0.001
//    5 0.163             0.006             0.044             0.00003           20              0.017           0.007
//    6 0.169             0.0065            0.049             0.00004           25              0.028           0.0018
//    7 */
//    8 //----------
//    9 #define GRAVITY_OFFSET                      gravity
//   10 #define GYROSCOPE_OFFSET                    gyro   
//   11 #define GYROSCOPE_OFFSET_DIRECTION          gyro_direction
//   12 #define GRAVITY_ANGLE_RATIO                 0.1227
//   13 #define GYROSCOPE_ANGLE_RATIO               0.3
//   14 #define GRAVITY_ADJUST_TIME_CONSTANT        0.35                                                        
//   15 #define GYROSCOPE_ANGLE_SIGMA_FREQUENCY     200
//   16 #define CAR_ANGLE_SET                       0
//   17 #define CAR_ANGLE_SPEED_SET                 0 
//   18 #define ANGLE_CONTROL_P                     0.163//0.171//0.167最好//0.30是上限
//   19 #define ANGLE_CONTROL_D                     0.006//0.007是上限
//   20 #define ANGLE_CONTROL_OUT_MAX	            MOTOR_OUT_MAX *10
//   21 #define ANGLE_CONTROL_OUT_MIN		    MOTOR_OUT_MIN *10
//   22 
//   23 //------------
//   24 #define SPEED_CONTROL_PERIOD                100
//   25 #define CAR_SPEED_CONSTANT                  0.02
//   26 #define SPEED_CONTROL_P                     0.044//0.053//0.049对应0.167//0.044
//   27 #define SPEED_CONTROL_I                     0.00003//0.00003//0.1漂移很明显
//   28 #define SPEED_CONTROL_OUT_MAX		    MOTOR_OUT_MAX *10
//   29 #define SPEED_CONTROL_OUT_MIN		    MOTOR_OUT_MIN *10
//   30 #define CAR_SPEED_SET                       20
//   31 #define CAR_SPEED_STEP                      5//每100毫秒增加的速度
//   32 
//   33 //-----------
//   34 #define SI_SetVal()                         gpio_init (PORTE , 0, 1, 1)
//   35 #define SI_ClrVal()                         gpio_init (PORTE , 0, 1, 0)
//   36 #define CLK_SetVal()                        gpio_init (PORTE , 1, 1, 1)
//   37 #define CLK_ClrVal()                        gpio_init (PORTE , 1, 1, 0)
//   38 #define SI_SetVal_1()                       gpio_init (PORTC , 11, 1, 1)
//   39 #define SI_ClrVal_1()                       gpio_init (PORTC , 11, 1, 0)
//   40 #define CLK_SetVal_1()                      gpio_init (PORTC , 10, 1, 1)
//   41 #define CLK_ClrVal_1()                      gpio_init (PORTC , 10, 1, 0)
//   42 #define DIR_DEFAULT_MIN                     50
//   43 #define DIRECTION_CONTROL_PERIOD            10
//   44 #define DIR_CONTROL_P                       0.017//0.019
//   45 #define DIR_CONTROL_D                       0.0007//0.00095//0.0008//0.0007
//   46 #define DIR_DEV                             dev
//   47 #define GATE                                30
//   48 #define DIRECTION_CONTROL_DEADVALUE         0
//   49 #define DIRECTION_CONTROL_OUT_MAX	    MOTOR_OUT_MAX
//   50 #define DIRECTION_CONTROL_OUT_MIN	    MOTOR_OUT_MIN
//   51 
//   52 //------------
//   53 #define MOTOR_OUT_DEAD_VAL                  0
//   54 #define MOTOR_LEFT_SPEED_POSITIVE	    (g_fLeftMotorOut > 0)
//   55 #define MOTOR_RIGHT_SPEED_POSITIVE	    (g_fRightMotorOut > 0)
//   56 #define MOTOR_OUT_MAX                       1.0
//   57 #define MOTOR_OUT_MIN                      -1.0
//   58 //------------------------------------------------------------------------------

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   59 int16   g_nInputVoltage[5]={0};
g_nInputVoltage:
        DS8 12

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   60 int32	g_lnInputVoltageSigma[5]={0};    	   
g_lnInputVoltageSigma:
        DS8 20
//   61 #define VOLTAGE_GRAVITY                     g_nInputVoltage[0]
//   62 #define VOLTAGE_GYRO                        g_nInputVoltage[1]
//   63 #define VOLTAGE_LEFT                        g_nInputVoltage[2]
//   64 #define VOLTAGE_RIGHT                       g_nInputVoltage[3]		
//   65 #define DIR_CONTROL_D_VALUE                 g_nInputVoltage[4]
//   66 #define key_1                               (((GPIO_PDIR_REG(PTA_BASE_PTR))>>(19))&1)
//   67 //------------------------------------------------------------------------------
//   68 
//   69 //-----------

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   70 int16 left_l=0;
left_l:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   71 int16 right_l=0;
right_l:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   72 int16 dev=0;
dev:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   73 int16 gravity,gyro,gyro_direction;
gravity:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
gyro:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
gyro_direction:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   74 float g_fGravityAngle=0;
g_fGravityAngle:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   75 float g_fGyroscopeAngleSpeed =0;
g_fGyroscopeAngleSpeed:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   76 float g_fCarAngle=0;
g_fCarAngle:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   77 float g_fGyroscopeAngleIntergral =0;
g_fGyroscopeAngleIntergral:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   78 float g_fAngleControlOut=0;
g_fAngleControlOut:
        DS8 4
//   79 
//   80 //-----------

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   81 float g_fCarSpeed=0;
g_fCarSpeed:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   82 float g_fCarSpeedstart=0;
g_fCarSpeedstart:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   83 int16 g_nLeftMotorPulse=0;
g_nLeftMotorPulse:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   84 int16 g_nRightMotorPulse=0;
g_nRightMotorPulse:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   85 float g_fSpeedControlIntegral=0;
g_fSpeedControlIntegral:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   86 float g_fSpeedControlOutOld =0;
g_fSpeedControlOutOld:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   87 float g_fSpeedControlOutNew =0;
g_fSpeedControlOutNew:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   88 float g_fSpeedControlOut =0;
g_fSpeedControlOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   89 uint8 g_nSpeedControlPeriod =0;
g_nSpeedControlPeriod:
        DS8 1
//   90 
//   91 //-----------

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   92 float g_fDirectionControlOutOld=0;
g_fDirectionControlOutOld:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   93 float g_fDirectionControlOutNew =0;
g_fDirectionControlOutNew:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   94 float g_fDirectionControlOut=0;
g_fDirectionControlOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   95 int16 g_nDirectionControlPeriod=0;
g_nDirectionControlPeriod:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   96 int16 left=0;
left:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   97 int16 right=0;
right:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   98 int16 left_c,right_c;
left_c:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
right_c:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//   99 int16 left_OFFSET,right_OFFSET;
left_OFFSET:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
right_OFFSET:
        DS8 2
//  100 //------------

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  101 float g_fLeftMotorOut=0;
g_fLeftMotorOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  102 float g_fRightMotorOut=0;
g_fRightMotorOut:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//  103 int16 g_nLeftMotorPulseSigma =0;
g_nLeftMotorPulseSigma:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//  104 int16 g_nRightMotorPulseSigma=0;
g_nRightMotorPulseSigma:
        DS8 2

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  105 extern int16 OutData[4] = { 0 };//虚拟示波器输出
OutData:
        DS8 8
//  106 extern uint8 a,b;
//  107 extern int16 speedflag;
//  108 //----------------------------------------------------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  109 void get_ad()
//  110 {
get_ad:
        PUSH     {R7,LR}
//  111    VOLTAGE_GRAVITY = hw_ad_ave(0,8,12,20);                 //均值滤波得加速度电压信号(PTB0)
        MOVS     R3,#+20
        MOVS     R2,#+12
        MOVS     R1,#+8
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.W    R1,??DataTable23
        STRH     R0,[R1, #+0]
//  112    VOLTAGE_GYRO = hw_ad_ave(0,9,12,20);                    //--------得平衡陀螺仪电压信号(PTB1)
        MOVS     R3,#+20
        MOVS     R2,#+12
        MOVS     R1,#+9
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.W    R1,??DataTable23
        STRH     R0,[R1, #+2]
//  113    DIR_CONTROL_D_VALUE = hw_ad_ave(0,12,12,20);            //---------得转向陀螺仪电压信号(PTB2)
        MOVS     R3,#+20
        MOVS     R2,#+12
        MOVS     R1,#+12
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.W    R1,??DataTable23
        STRH     R0,[R1, #+8]
//  114 }
        POP      {R0,PC}          ;; return
//  115 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  116 void GetSamplezhi()
//  117 {
GetSamplezhi:
        PUSH     {R7,LR}
//  118     g_lnInputVoltageSigma[0]+= hw_ad_ave(0,8,12,20);   
        MOVS     R3,#+20
        MOVS     R2,#+12
        MOVS     R1,#+8
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.W    R1,??DataTable22
        LDR      R1,[R1, #+0]
        UXTAH    R0,R1,R0
        LDR.W    R1,??DataTable22
        STR      R0,[R1, #+0]
//  119     g_lnInputVoltageSigma[1]+= hw_ad_ave(0,9,12,20);
        MOVS     R3,#+20
        MOVS     R2,#+12
        MOVS     R1,#+9
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.W    R1,??DataTable22
        LDR      R1,[R1, #+4]
        UXTAH    R0,R1,R0
        LDR.W    R1,??DataTable22
        STR      R0,[R1, #+4]
//  120     g_lnInputVoltageSigma[2]+= hw_ad_ave(0,12,12,20);
        MOVS     R3,#+20
        MOVS     R2,#+12
        MOVS     R1,#+12
        MOVS     R0,#+0
        BL       hw_ad_ave
        LDR.W    R1,??DataTable22
        LDR      R1,[R1, #+8]
        UXTAH    R0,R1,R0
        LDR.W    R1,??DataTable22
        STR      R0,[R1, #+8]
//  121 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  122 void GetOFFSET()
//  123 {
//  124     gravity=g_lnInputVoltageSigma[0]/1000;
GetOFFSET:
        LDR.W    R0,??DataTable22
        LDR      R0,[R0, #+0]
        MOV      R1,#+1000
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable22_1
        STRH     R0,[R1, #+0]
//  125     gyro =g_lnInputVoltageSigma[1]/1000;
        LDR.W    R0,??DataTable22
        LDR      R0,[R0, #+4]
        MOV      R1,#+1000
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable22_2
        STRH     R0,[R1, #+0]
//  126     gyro_direction= g_lnInputVoltageSigma[2]/1000;  
        LDR.W    R0,??DataTable22
        LDR      R0,[R0, #+8]
        MOV      R1,#+1000
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable27
        STRH     R0,[R1, #+0]
//  127 }
        BX       LR               ;; return
//  128 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  129 void GetInputVoltageAverage(int j)
//  130 {
//  131 	int i;
//  132         for(i = 0; i < 5; i ++) 
GetInputVoltageAverage:
        MOVS     R1,#+0
        B.N      ??GetInputVoltageAverage_0
//  133 	{
//  134 		g_nInputVoltage[i] = (int)(g_lnInputVoltageSigma[i] /j);
??GetInputVoltageAverage_1:
        LDR.W    R2,??DataTable22
        LDR      R2,[R2, R1, LSL #+2]
        SDIV     R2,R2,R0
        LDR.W    R3,??DataTable23
        STRH     R2,[R3, R1, LSL #+1]
//  135 		g_lnInputVoltageSigma[i] = 0;
        LDR.W    R2,??DataTable22
        MOVS     R3,#+0
        STR      R3,[R2, R1, LSL #+2]
//  136 	}
        ADDS     R1,R1,#+1
??GetInputVoltageAverage_0:
        CMP      R1,#+5
        BLT.N    ??GetInputVoltageAverage_1
//  137 }
        BX       LR               ;; return
//  138 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  139 void AngleCalculate(void)
//  140 {
AngleCalculate:
        PUSH     {LR}
//  141       float Value;
//  142       g_fGravityAngle=(VOLTAGE_GRAVITY-GRAVITY_OFFSET) * GRAVITY_ANGLE_RATIO ;           
        LDR.W    R0,??DataTable23
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable22_1
        LDRSH    R1,[R1, #+0]
        SUBS     R0,R0,R1
        BL       __aeabi_i2d
        LDR.W    R2,??DataTable23_1  ;; 0x67381d7e
        LDR.W    R3,??DataTable23_2  ;; 0x3fbf6944
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        LDR.W    R1,??DataTable23_3
        STR      R0,[R1, #+0]
//  143       g_fGyroscopeAngleSpeed=(VOLTAGE_GYRO-GYROSCOPE_OFFSET) * GYROSCOPE_ANGLE_RATIO;
        LDR.W    R0,??DataTable23
        LDRSH    R0,[R0, #+2]
        LDR.W    R1,??DataTable22_2
        LDRSH    R1,[R1, #+0]
        SUBS     R0,R0,R1
        BL       __aeabi_i2d
        MOVS     R2,#+858993459
        LDR.W    R3,??DataTable23_4  ;; 0x3fd33333
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        LDR.W    R1,??DataTable23_5
        STR      R0,[R1, #+0]
//  144       
//  145       g_fCarAngle=g_fGyroscopeAngleIntergral;      
        LDR.W    R0,??DataTable23_6
        LDR.W    R1,??DataTable28
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
//  146    
//  147       Value=(g_fGravityAngle-g_fCarAngle)/GRAVITY_ADJUST_TIME_CONSTANT;
        LDR.W    R0,??DataTable23_3
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable23_6
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        BL       __aeabi_f2d
        MOVS     R2,#+1717986918
        LDR.W    R3,??DataTable23_7  ;; 0x3fd66666
        BL       __aeabi_ddiv
        BL       __aeabi_d2f
//  148       
//  149       g_fGyroscopeAngleIntergral+=(g_fGyroscopeAngleSpeed+Value)/GYROSCOPE_ANGLE_SIGMA_FREQUENCY;   
        LDR.W    R1,??DataTable23_5
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable24  ;; 0x43480000
        BL       __aeabi_fdiv
        LDR.W    R1,??DataTable28
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable28
        STR      R0,[R1, #+0]
//  150 }
        POP      {PC}             ;; return
//  151 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  152 void AngleControl(void) 
//  153 {
AngleControl:
        PUSH     {R4,R5,LR}
//  154         float fValue;
//  155 
//  156 	fValue = (CAR_ANGLE_SET - g_fCarAngle) * ANGLE_CONTROL_P +(CAR_ANGLE_SPEED_SET - g_fGyroscopeAngleSpeed) * ANGLE_CONTROL_D;
        LDR.W    R0,??DataTable23_6
        LDR      R0,[R0, #+0]
        EORS     R0,R0,#0x80000000
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable24_1  ;; 0x1a9fbe77
        LDR.W    R3,??DataTable24_2  ;; 0x3fc4dd2f
        BL       __aeabi_dmul
        MOVS     R4,R0
        MOVS     R5,R1
        LDR.W    R0,??DataTable23_5
        LDR      R0,[R0, #+0]
        EORS     R0,R0,#0x80000000
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable25  ;; 0xbc6a7efa
        LDR.W    R3,??DataTable25_1  ;; 0x3f789374
        BL       __aeabi_dmul
        MOVS     R2,R4
        MOVS     R3,R5
        BL       __aeabi_dadd
        BL       __aeabi_d2f
//  157         /*
//  158         if(fValue > ANGLE_CONTROL_OUT_MAX)			
//  159           fValue = ANGLE_CONTROL_OUT_MAX;
//  160         else if(fValue < ANGLE_CONTROL_OUT_MIN)
//  161           fValue = ANGLE_CONTROL_OUT_MIN;
//  162         */
//  163 	g_fAngleControlOut = fValue;
        LDR.W    R1,??DataTable29
        STR      R0,[R1, #+0]
//  164 }
        POP      {R4,R5,PC}       ;; return
//  165 //-----------------------速度控制-------------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  166 void GetMotorPulse()
//  167 {
GetMotorPulse:
        PUSH     {LR}
//  168   uint32  nLeftPulse,nRightPulse; 
//  169   nLeftPulse=FTM1_CNT;
        LDR.W    R0,??DataTable25_2  ;; 0x40039004
        LDR      R0,[R0, #+0]
//  170   nRightPulse=FTM2_CNT;
        LDR.W    R1,??DataTable29_1  ;; 0x400b8004
        LDR      R1,[R1, #+0]
//  171   g_nLeftMotorPulse = -(int32)nLeftPulse;       //注意编码器的安装
        LDR.W    R2,??DataTable25_3
        RSBS     R0,R0,#+0
        STRH     R0,[R2, #+0]
//  172   g_nRightMotorPulse = (int32)nRightPulse;
        LDR.W    R0,??DataTable25_4
        STRH     R1,[R0, #+0]
//  173   if(!MOTOR_LEFT_SPEED_POSITIVE)		g_nLeftMotorPulse = -g_nLeftMotorPulse;
        LDR.W    R0,??DataTable25_5
        LDR      R0,[R0, #+0]
        MOVS     R1,#+0
        BL       __aeabi_cfrcmple
        BCC.N    ??GetMotorPulse_0
        LDR.W    R0,??DataTable25_3
        LDRSH    R0,[R0, #+0]
        RSBS     R0,R0,#+0
        LDR.W    R1,??DataTable25_3
        STRH     R0,[R1, #+0]
//  174   g_nLeftMotorPulseSigma +=g_nLeftMotorPulse;
??GetMotorPulse_0:
        LDR.W    R0,??DataTable25_6
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable25_3
        LDRH     R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.W    R1,??DataTable25_6
        STRH     R0,[R1, #+0]
//  175   if(!MOTOR_RIGHT_SPEED_POSITIVE)		g_nRightMotorPulse = -g_nRightMotorPulse;
        LDR.W    R0,??DataTable26
        LDR      R0,[R0, #+0]
        MOVS     R1,#+0
        BL       __aeabi_cfrcmple
        BCC.N    ??GetMotorPulse_1
        LDR.W    R0,??DataTable25_4
        LDRSH    R0,[R0, #+0]
        RSBS     R0,R0,#+0
        LDR.W    R1,??DataTable25_4
        STRH     R0,[R1, #+0]
//  176   g_nRightMotorPulseSigma +=g_nRightMotorPulse;	
??GetMotorPulse_1:
        LDR.W    R0,??DataTable26_1
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable25_4
        LDRH     R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.W    R1,??DataTable26_1
        STRH     R0,[R1, #+0]
//  177   FTM1_CNT=0; 
        LDR.W    R0,??DataTable25_2  ;; 0x40039004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  178   FTM2_CNT=0; 
        LDR.W    R0,??DataTable29_1  ;; 0x400b8004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  179 }
        POP      {PC}             ;; return
//  180 //-------------目前速度控制不明显，尚无处理方案--------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  181 void SpeedControl(void)
//  182 {
SpeedControl:
        PUSH     {R4,R5,LR}
//  183 	float fP,fI, fDelta;
//  184         
//  185 	g_fCarSpeed = (g_nLeftMotorPulseSigma + g_nRightMotorPulseSigma)/2;//合理吗？有没有更准确的方法？
        LDR.W    R0,??DataTable25_6
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable26_1
        LDRSH    R1,[R1, #+0]
        ADDS     R0,R1,R0
        MOVS     R1,#+2
        SDIV     R0,R0,R1
        BL       __aeabi_i2f
        LDR.W    R1,??DataTable27_1
        STR      R0,[R1, #+0]
//  186 	g_nLeftMotorPulseSigma = g_nRightMotorPulseSigma = 0;
        MOVS     R0,#+0
        LDR.W    R1,??DataTable26_1
        STRH     R0,[R1, #+0]
        LDR.W    R1,??DataTable25_6
        STRH     R0,[R1, #+0]
//  187 	g_fCarSpeed *= CAR_SPEED_CONSTANT;
        LDR.W    R0,??DataTable27_1
        LDR      R0,[R0, #+0]
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable27_2  ;; 0x47ae147b
        LDR.W    R3,??DataTable27_3  ;; 0x3f947ae1
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        LDR.W    R1,??DataTable27_1
        STR      R0,[R1, #+0]
//  188 
//  189         if(g_fCarSpeedstart<CAR_SPEED_SET)
        LDR.W    R0,??DataTable27_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable27_5  ;; 0x41a00000
        BL       __aeabi_cfcmple
        BCS.N    ??SpeedControl_0
//  190         {
//  191 	   g_fCarSpeedstart+=CAR_SPEED_STEP;
        LDR.W    R0,??DataTable27_4
        LDR      R1,[R0, #+0]
        LDR.W    R0,??DataTable27_6  ;; 0x40a00000
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable27_4
        STR      R0,[R1, #+0]
//  192         } 
//  193         if(g_fCarSpeedstart>CAR_SPEED_SET)
??SpeedControl_0:
        LDR.W    R0,??DataTable27_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable27_7  ;; 0x41a00001
        BL       __aeabi_cfrcmple
        BHI.N    ??SpeedControl_1
//  194         {
//  195 	   g_fCarSpeedstart-=CAR_SPEED_STEP;           
        LDR.W    R0,??DataTable27_4
        LDR      R1,[R0, #+0]
        LDR.W    R0,??DataTable27_8  ;; 0xc0a00000
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable27_4
        STR      R0,[R1, #+0]
//  196         } 
//  197         
//  198         if(speedflag<30) //speedflag的递加应该设在中断中
??SpeedControl_1:
        LDR.W    R0,??DataTable27_9
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+30
        BGE.N    ??SpeedControl_2
//  199         {
//  200           fDelta = g_fCarSpeedstart - g_fCarSpeed;
        LDR.W    R0,??DataTable27_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable27_1
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R5,R0
        B.N      ??SpeedControl_3
//  201         }
//  202         else	
//  203         {
//  204           fDelta = CAR_SPEED_SET - g_fCarSpeed;
??SpeedControl_2:
        LDR.W    R0,??DataTable27_5  ;; 0x41a00000
        LDR.W    R1,??DataTable27_1
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R5,R0
//  205         }
//  206         
//  207         fDelta = g_fCarSpeedstart - g_fCarSpeed;
??SpeedControl_3:
        LDR.W    R0,??DataTable27_4
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable27_1
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R5,R0
//  208 	fP = fDelta * SPEED_CONTROL_P;
        MOVS     R0,R5
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable27_10  ;; 0x20c49ba
        LDR.W    R3,??DataTable27_11  ;; 0x3fa6872b
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        MOVS     R4,R0
//  209 	fI = fDelta * SPEED_CONTROL_I;
        MOVS     R0,R5
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable27_12  ;; 0x4d551d69
        LDR.W    R3,??DataTable27_13  ;; 0x3eff7510
        BL       __aeabi_dmul
        BL       __aeabi_d2f
//  210 	g_fSpeedControlIntegral += fI;		
        LDR.W    R1,??DataTable28_1
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable28_1
        STR      R0,[R1, #+0]
//  211 	if(g_fSpeedControlIntegral > SPEED_CONTROL_OUT_MAX)	
        LDR.W    R0,??DataTable28_1
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable28_2  ;; 0x41200001
        BL       __aeabi_cfrcmple
        BHI.N    ??SpeedControl_4
//  212 		g_fSpeedControlIntegral = SPEED_CONTROL_OUT_MAX;
        LDR.W    R0,??DataTable28_1
        LDR.W    R1,??DataTable29_2  ;; 0x41200000
        STR      R1,[R0, #+0]
//  213 	if(g_fSpeedControlIntegral < SPEED_CONTROL_OUT_MIN)  	
??SpeedControl_4:
        LDR.W    R0,??DataTable28_1
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable29_3  ;; 0xc1200000
        BL       __aeabi_cfcmple
        BCS.N    ??SpeedControl_5
//  214 		g_fSpeedControlIntegral = SPEED_CONTROL_OUT_MIN;
        LDR.W    R0,??DataTable28_1
        LDR.W    R1,??DataTable29_3  ;; 0xc1200000
        STR      R1,[R0, #+0]
//  215 	
//  216 	g_fSpeedControlOutOld = g_fSpeedControlOutNew;
??SpeedControl_5:
        LDR.W    R0,??DataTable29_4
        LDR.W    R1,??DataTable29_5
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
//  217 
//  218 	g_fSpeedControlOutNew = fP + g_fSpeedControlIntegral;
        LDR.W    R0,??DataTable28_1
        LDR      R0,[R0, #+0]
        MOVS     R1,R4
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable29_5
        STR      R0,[R1, #+0]
//  219 }
        POP      {R4,R5,PC}       ;; return
//  220 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  221 void SpeedControlOutput(void) 
//  222 {
SpeedControlOutput:
        PUSH     {R4,LR}
//  223 	float fValue3;
//  224 	fValue3 = g_fSpeedControlOutNew - g_fSpeedControlOutOld;
        LDR.W    R0,??DataTable29_5
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable29_4
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R4,R0
//  225 	g_fSpeedControlOut = fValue3 * (g_nSpeedControlPeriod + 1) / SPEED_CONTROL_PERIOD + g_fSpeedControlOutOld;	
        LDR.W    R0,??DataTable29_6
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        LDR.W    R1,??DataTable30  ;; 0x42c80000
        BL       __aeabi_fdiv
        LDR.W    R1,??DataTable29_4
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable33
        STR      R0,[R1, #+0]
//  226 }
        POP      {R4,PC}          ;; return
//  227 
//  228 
//  229 //-------------------------------------方向控制-------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  230 void CCD_init(void)
//  231 {
CCD_init:
        PUSH     {R7,LR}
//  232   gpio_init (PORTE , 0, 1, 1);
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+0
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  233   gpio_init (PORTE , 1, 1, 1);
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  234   gpio_init (PORTC , 10, 1, 1);
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  235   gpio_init (PORTC , 11, 1, 1);
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+11
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  236   hw_adc_init(1);
        MOVS     R0,#+1
        BL       hw_adc_init
//  237 }
        POP      {R0,PC}          ;; return
//  238 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  239 void button_init()
//  240 {
button_init:
        PUSH     {R7,LR}
//  241    SIM_SCGC5 |= SIM_SCGC5_PORTA_MASK;    //打开PORTD端口的时钟
        LDR.W    R0,??DataTable30_2  ;; 0x40048038
        LDR      R0,[R0, #+0]
        MOV      R1,#+512
        ORRS     R0,R1,R0
        LDR.W    R1,??DataTable30_2  ;; 0x40048038
        STR      R0,[R1, #+0]
//  242    PORTA_PCR19=(0|PORT_PCR_MUX(1));
        LDR.W    R0,??DataTable30_3  ;; 0x4004904c
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//  243    gpio_init (PORTA,19, 0,0);
        MOVS     R3,#+0
        MOVS     R2,#+0
        MOVS     R1,#+19
        LDR.W    R0,??DataTable34  ;; 0x400ff000
        BL       gpio_init
//  244 }
        POP      {R0,PC}          ;; return
//  245 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  246 void ADC0_stop(void)
//  247 {
ADC0_stop:
        PUSH     {R7,LR}
//  248     hw_adc_convertstop(0,8);
        MOVS     R1,#+8
        MOVS     R0,#+0
        BL       hw_adc_convertstop
//  249     hw_adc_convertstop(0,9);
        MOVS     R1,#+9
        MOVS     R0,#+0
        BL       hw_adc_convertstop
//  250     hw_adc_convertstop(0,12);
        MOVS     R1,#+12
        MOVS     R0,#+0
        BL       hw_adc_convertstop
//  251 }
        POP      {R0,PC}          ;; return
//  252 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  253 void ADC0_start(void)
//  254 {
ADC0_start:
        PUSH     {R7,LR}
//  255     hw_adc_convertstart(0,8,12);
        MOVS     R2,#+12
        MOVS     R1,#+8
        MOVS     R0,#+0
        BL       hw_adc_convertstart
//  256     hw_adc_convertstart(0,9,12);
        MOVS     R2,#+12
        MOVS     R1,#+9
        MOVS     R0,#+0
        BL       hw_adc_convertstart
//  257     hw_adc_convertstart(0,12,12);
        MOVS     R2,#+12
        MOVS     R1,#+12
        MOVS     R0,#+0
        BL       hw_adc_convertstart
//  258 }
        POP      {R0,PC}          ;; return
//  259 
//  260 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  261 void StartIntegration(void) 
//  262 {
StartIntegration:
        PUSH     {R4,LR}
//  263     unsigned char i;
//  264 
//  265     SI_SetVal();            /* SI  = 1 */   
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+0
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  266     SamplingDelay();
        BL       SamplingDelay
//  267     CLK_SetVal();           /* CLK = 1 */  
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  268     SamplingDelay();
        BL       SamplingDelay
//  269     SI_ClrVal();            /* SI  = 0 */   
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+0
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  270     SamplingDelay();
        BL       SamplingDelay
//  271     CLK_ClrVal();           /* CLK = 0 */
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  272    
//  273     for(i=0; i<127; i++) 
        MOVS     R4,#+0
        B.N      ??StartIntegration_0
//  274     {
//  275         SamplingDelay();
??StartIntegration_1:
        BL       SamplingDelay
//  276         SamplingDelay();
        BL       SamplingDelay
//  277         CLK_SetVal();       /* CLK = 1 */        
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  278         SamplingDelay();
        BL       SamplingDelay
//  279         SamplingDelay();
        BL       SamplingDelay
//  280         CLK_ClrVal();       /* CLK = 0 */       
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  281     }
        ADDS     R4,R4,#+1
??StartIntegration_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+127
        BCC.N    ??StartIntegration_1
//  282     SamplingDelay();
        BL       SamplingDelay
//  283     SamplingDelay();
        BL       SamplingDelay
//  284     CLK_SetVal();           /* CLK = 1 */
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  285     SamplingDelay();
        BL       SamplingDelay
//  286     SamplingDelay();
        BL       SamplingDelay
//  287     CLK_ClrVal();           /* CLK = 0 */
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  288   
//  289 }
        POP      {R4,PC}          ;; return
//  290 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  291 void StartIntegrationRight(void) 
//  292 {
StartIntegrationRight:
        PUSH     {R4,LR}
//  293     unsigned char i;
//  294 
//  295     //SI_SetVal();            /* SI  = 1 */
//  296     SI_SetVal_1();      
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+11
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  297     SamplingDelay();
        BL       SamplingDelay
//  298     //CLK_SetVal();           /* CLK = 1 */
//  299     CLK_SetVal_1();  
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  300     SamplingDelay();
        BL       SamplingDelay
//  301     //SI_ClrVal();            /* SI  = 0 */
//  302     SI_ClrVal_1(); 
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+11
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  303     SamplingDelay();
        BL       SamplingDelay
//  304     //CLK_ClrVal();           /* CLK = 0 */
//  305     CLK_ClrVal_1(); 
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  306 
//  307     for(i=0; i<127; i++) 
        MOVS     R4,#+0
        B.N      ??StartIntegrationRight_0
//  308     {
//  309         SamplingDelay();
??StartIntegrationRight_1:
        BL       SamplingDelay
//  310         SamplingDelay();
        BL       SamplingDelay
//  311         //CLK_SetVal();       /* CLK = 1 */
//  312         CLK_SetVal_1();  
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  313         SamplingDelay();
        BL       SamplingDelay
//  314         SamplingDelay();
        BL       SamplingDelay
//  315         //CLK_ClrVal();       /* CLK = 0 */
//  316         CLK_ClrVal_1();  
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  317     }
        ADDS     R4,R4,#+1
??StartIntegrationRight_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+127
        BCC.N    ??StartIntegrationRight_1
//  318     SamplingDelay();
        BL       SamplingDelay
//  319     SamplingDelay();
        BL       SamplingDelay
//  320     //CLK_SetVal();           /* CLK = 1 */
//  321     CLK_SetVal_1();  
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  322     SamplingDelay();
        BL       SamplingDelay
//  323     SamplingDelay();
        BL       SamplingDelay
//  324     //CLK_ClrVal();           /* CLK = 0 */
//  325     CLK_ClrVal_1();   
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  326 }
        POP      {R4,PC}          ;; return
//  327 
//  328 
//  329 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  330 void ImageCapture(uint8 * ImageData)       
//  331 {
ImageCapture:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
//  332     unsigned char i;
//  333     extern uint8 AtemP;
//  334 
//  335     SI_SetVal();            /* SI  = 1 */
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+0
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  336     SamplingDelay();
        BL       SamplingDelay
//  337     CLK_SetVal();           /* CLK = 1 */  
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  338     SamplingDelay();
        BL       SamplingDelay
//  339     SI_ClrVal();            /* SI  = 0 */
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+0
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  340     SamplingDelay();
        BL       SamplingDelay
//  341    
//  342 //Delay 10us for sample the first pixel
//  343     for(i = 0; i < 50; i++) 
        MOVS     R5,#+0
        B.N      ??ImageCapture_0
//  344     {
//  345       SamplingDelay();  //200ns
??ImageCapture_1:
        BL       SamplingDelay
//  346     }
        ADDS     R5,R5,#+1
??ImageCapture_0:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+50
        BCC.N    ??ImageCapture_1
//  347 
//  348 
//  349 //Sampling Pixel 1
//  350     *ImageData =  hw_ad_once(1, 6, 8);
        MOVS     R2,#+8
        MOVS     R1,#+6
        MOVS     R0,#+1
        BL       hw_ad_once
        STRB     R0,[R4, #+0]
//  351     ImageData ++ ;
        ADDS     R4,R4,#+1
//  352     CLK_ClrVal();           /* CLK = 0 */
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  353 
//  354     for(i=0; i<127; i++) 
        MOVS     R5,#+0
        B.N      ??ImageCapture_2
//  355     {
//  356         SamplingDelay();
??ImageCapture_3:
        BL       SamplingDelay
//  357         SamplingDelay();
        BL       SamplingDelay
//  358         CLK_SetVal();       /* CLK = 1 */
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  359         SamplingDelay();
        BL       SamplingDelay
//  360         SamplingDelay();
        BL       SamplingDelay
//  361        
//  362         //Sampling Pixel 2~128
//  363         *ImageData = hw_ad_once(1, 6, 8);
        MOVS     R2,#+8
        MOVS     R1,#+6
        MOVS     R0,#+1
        BL       hw_ad_once
        STRB     R0,[R4, #+0]
//  364         ImageData ++;
        ADDS     R4,R4,#+1
//  365         CLK_ClrVal();       /* CLK = 0 */
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  366     }
        ADDS     R5,R5,#+1
??ImageCapture_2:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+127
        BCC.N    ??ImageCapture_3
//  367     SamplingDelay();
        BL       SamplingDelay
//  368     SamplingDelay();
        BL       SamplingDelay
//  369     CLK_SetVal();           /* CLK = 1 */
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  370     SamplingDelay();
        BL       SamplingDelay
//  371     SamplingDelay();
        BL       SamplingDelay
//  372     CLK_ClrVal();           /* CLK = 0 */
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+1
        LDR.W    R0,??DataTable30_1  ;; 0x400ff100
        BL       gpio_init
//  373 }
        POP      {R0,R4,R5,PC}    ;; return
//  374 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  375 void ImageCapture_1(uint8 * ImageData_1)         
//  376 {
ImageCapture_1:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
//  377     unsigned char i;
//  378     extern uint8 AtemP;
//  379 
//  380     //SI_SetVal();            /* SI  = 1 */
//  381     SI_SetVal_1();
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+11
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  382     SamplingDelay();
        BL       SamplingDelay
//  383     //CLK_SetVal();           /* CLK = 1 */
//  384     CLK_SetVal_1();    
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  385     SamplingDelay();
        BL       SamplingDelay
//  386     //SI_ClrVal();            /* SI  = 0 */
//  387     SI_ClrVal_1(); 
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+11
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  388     SamplingDelay();
        BL       SamplingDelay
//  389 
//  390    
//  391 //Delay 10us for sample the first pixel
//  392     for(i = 0; i < 50; i++) 
        MOVS     R5,#+0
        B.N      ??ImageCapture_1_0
//  393     {
//  394       SamplingDelay();  //200ns
??ImageCapture_1_1:
        BL       SamplingDelay
//  395     }
        ADDS     R5,R5,#+1
??ImageCapture_1_0:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+50
        BCC.N    ??ImageCapture_1_1
//  396 
//  397 
//  398 //Sampling Pixel 1
//  399     //*ImageData =  hw_ad_once(1, 6, 8);
//  400     //ImageData ++ ;
//  401     *ImageData_1= hw_ad_once(1, 7, 8);              
        MOVS     R2,#+8
        MOVS     R1,#+7
        MOVS     R0,#+1
        BL       hw_ad_once
        STRB     R0,[R4, #+0]
//  402     ImageData_1 ++;
        ADDS     R4,R4,#+1
//  403     //CLK_ClrVal();           /* CLK = 0 */
//  404     CLK_ClrVal_1(); 
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  405 
//  406     for(i=0; i<127; i++) 
        MOVS     R5,#+0
        B.N      ??ImageCapture_1_2
//  407     {
//  408         SamplingDelay();
??ImageCapture_1_3:
        BL       SamplingDelay
//  409         SamplingDelay();
        BL       SamplingDelay
//  410         //CLK_SetVal();       /* CLK = 1 */
//  411         CLK_SetVal_1(); 
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  412         SamplingDelay();
        BL       SamplingDelay
//  413         SamplingDelay();
        BL       SamplingDelay
//  414         //Sampling Pixel 2~128
//  415 
//  416         //*ImageData = hw_ad_once(1, 6, 8);
//  417         //ImageData ++;
//  418         *ImageData_1= hw_ad_once(1, 7, 8);  
        MOVS     R2,#+8
        MOVS     R1,#+7
        MOVS     R0,#+1
        BL       hw_ad_once
        STRB     R0,[R4, #+0]
//  419         ImageData_1++;
        ADDS     R4,R4,#+1
//  420 
//  421         //CLK_ClrVal();       /* CLK = 0 */
//  422         CLK_ClrVal_1(); 
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  423     }
        ADDS     R5,R5,#+1
??ImageCapture_1_2:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+127
        BCC.N    ??ImageCapture_1_3
//  424     SamplingDelay();
        BL       SamplingDelay
//  425     SamplingDelay();
        BL       SamplingDelay
//  426     //CLK_SetVal();           /* CLK = 1 */
//  427     CLK_SetVal_1();    
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  428     SamplingDelay();
        BL       SamplingDelay
//  429     SamplingDelay();
        BL       SamplingDelay
//  430     //CLK_ClrVal();           /* CLK = 0 */
//  431     CLK_ClrVal_1(); 
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable33_1  ;; 0x400ff080
        BL       gpio_init
//  432 }
        POP      {R0,R4,R5,PC}    ;; return
//  433 
//  434 extern uint8 Pixel[128];
//  435 extern uint8 Pixel_1[128];

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//  436 uint8  PixelAverageValue=0;                                       /* 128个像素点的平均AD值 */
PixelAverageValue:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//  437 uint8  PixelAverageVoltage=0;                                     /* 128个像素点的平均电压值的10倍 */
PixelAverageVoltage:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//  438 uint8  PixelAverageValue_Right=0;
PixelAverageValue_Right:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//  439 uint8  PixelAverageVoltage_Right=0;
PixelAverageVoltage_Right:
        DS8 1

        SECTION `.data`:DATA:REORDER:NOROOT(1)
//  440 int16  TargetPixelAverageVoltage = 30;                          /* 设定目标平均电压值，实际电压的10倍 */
TargetPixelAverageVoltage:
        DATA
        DC16 30

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
//  441 int16  PixelAverageVoltageError = 0;                            /* 设定目标平均电压值与实际值的偏差，实际电压的10倍 */
PixelAverageVoltageError:
        DS8 2

        SECTION `.data`:DATA:REORDER:NOROOT(1)
//  442 int16  TargetPixelAverageVoltageAllowError = 2;                 /* 设定目标平均电压值允许的偏差，实际电压的10倍 */
TargetPixelAverageVoltageAllowError:
        DATA
        DC16 2

        SECTION `.data`:DATA:REORDER:NOROOT(0)
//  443 uint8  IntegrationTime = 10;                                    /* 曝光时间，单位ms */
IntegrationTime:
        DATA
        DC8 10

        SECTION `.data`:DATA:REORDER:NOROOT(0)
//  444 uint8  IntegrationTime_Right = 10;                              // 曝光时间，单位ms
IntegrationTime_Right:
        DATA
        DC8 10
//  445 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  446 void CalculateIntegrationTime(void) 
//  447 {
CalculateIntegrationTime:
        PUSH     {R7,LR}
//  448     PixelAverageValue = PixelAverage(128,Pixel);/* 计算128个像素点的平均AD值 */
        LDR.W    R1,??DataTable34_1
        MOVS     R0,#+128
        BL       PixelAverage
        LDR.W    R1,??DataTable34_2
        STRB     R0,[R1, #+0]
//  449     
//  450     PixelAverageVoltage = (uint8)((int)PixelAverageValue * 25 / 128);/* 计算128个像素点的平均电压值,实际值的10倍 */
        LDR.W    R0,??DataTable34_2
        LDRB     R0,[R0, #+0]
        MOVS     R1,#+25
        MULS     R0,R1,R0
        MOVS     R1,#+128
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable34_3
        STRB     R0,[R1, #+0]
//  451 
//  452     PixelAverageVoltageError = TargetPixelAverageVoltage - PixelAverageVoltage;
        LDR.W    R0,??DataTable34_4
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable34_3
        LDRB     R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable34_5
        STRH     R0,[R1, #+0]
//  453     if(PixelAverageVoltageError < -TargetPixelAverageVoltageAllowError)
        LDR.W    R0,??DataTable34_5
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable34_6
        LDRSH    R1,[R1, #+0]
        CMN      R0,R1
        BGE.N    ??CalculateIntegrationTime_0
//  454       IntegrationTime--;                                 
        LDR.W    R0,??DataTable34_7
        LDRB     R0,[R0, #+0]
        SUBS     R0,R0,#+1
        LDR.W    R1,??DataTable34_7
        STRB     R0,[R1, #+0]
//  455     if(PixelAverageVoltageError > TargetPixelAverageVoltageAllowError)
??CalculateIntegrationTime_0:
        LDR.W    R0,??DataTable34_6
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable34_5
        LDRSH    R1,[R1, #+0]
        CMP      R0,R1
        BGE.N    ??CalculateIntegrationTime_1
//  456       IntegrationTime++;
        LDR.W    R0,??DataTable34_7
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable34_7
        STRB     R0,[R1, #+0]
//  457     if(IntegrationTime <= 1)
??CalculateIntegrationTime_1:
        LDR.W    R0,??DataTable34_7
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCS.N    ??CalculateIntegrationTime_2
//  458       IntegrationTime = 1;
        LDR.W    R0,??DataTable34_7
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//  459     if(IntegrationTime >= 20)
??CalculateIntegrationTime_2:
        LDR.W    R0,??DataTable34_7
        LDRB     R0,[R0, #+0]
        CMP      R0,#+20
        BCC.N    ??CalculateIntegrationTime_3
//  460       IntegrationTime = 20;
        LDR.W    R0,??DataTable34_7
        MOVS     R1,#+20
        STRB     R1,[R0, #+0]
//  461 }
??CalculateIntegrationTime_3:
        POP      {R0,PC}          ;; return
//  462 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  463 void CalculateIntegrationTimeRight(void) 
//  464 {
CalculateIntegrationTimeRight:
        PUSH     {R7,LR}
//  465     PixelAverageValue_Right = PixelAverage(128,Pixel_1);/* 计算128个像素点的平均AD值 */
        LDR.W    R1,??DataTable34_8
        MOVS     R0,#+128
        BL       PixelAverage
        LDR.W    R1,??DataTable34_9
        STRB     R0,[R1, #+0]
//  466     
//  467     PixelAverageVoltage_Right = (uint8)((int)PixelAverageValue_Right * 25 / 128);/* 计算128个像素点的平均电压值,实际值的10倍 */
        LDR.W    R0,??DataTable34_9
        LDRB     R0,[R0, #+0]
        MOVS     R1,#+25
        MULS     R0,R1,R0
        MOVS     R1,#+128
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable34_10
        STRB     R0,[R1, #+0]
//  468 
//  469     PixelAverageVoltageError = TargetPixelAverageVoltage - PixelAverageVoltage_Right;
        LDR.W    R0,??DataTable34_4
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable34_10
        LDRB     R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable34_5
        STRH     R0,[R1, #+0]
//  470     if(PixelAverageVoltageError < -TargetPixelAverageVoltageAllowError)
        LDR.W    R0,??DataTable34_5
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable34_6
        LDRSH    R1,[R1, #+0]
        CMN      R0,R1
        BGE.N    ??CalculateIntegrationTimeRight_0
//  471       IntegrationTime_Right--;                                 
        LDR.W    R0,??DataTable34_11
        LDRB     R0,[R0, #+0]
        SUBS     R0,R0,#+1
        LDR.W    R1,??DataTable34_11
        STRB     R0,[R1, #+0]
//  472     if(PixelAverageVoltageError > TargetPixelAverageVoltageAllowError)
??CalculateIntegrationTimeRight_0:
        LDR.W    R0,??DataTable34_6
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable34_5
        LDRSH    R1,[R1, #+0]
        CMP      R0,R1
        BGE.N    ??CalculateIntegrationTimeRight_1
//  473       IntegrationTime_Right++;
        LDR.W    R0,??DataTable34_11
        LDRB     R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.W    R1,??DataTable34_11
        STRB     R0,[R1, #+0]
//  474     if(IntegrationTime_Right <= 1)
??CalculateIntegrationTimeRight_1:
        LDR.W    R0,??DataTable34_11
        LDRB     R0,[R0, #+0]
        CMP      R0,#+2
        BCS.N    ??CalculateIntegrationTimeRight_2
//  475       IntegrationTime_Right = 1;
        LDR.W    R0,??DataTable34_11
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//  476     if(IntegrationTime_Right >= 20)
??CalculateIntegrationTimeRight_2:
        LDR.W    R0,??DataTable34_11
        LDRB     R0,[R0, #+0]
        CMP      R0,#+20
        BCC.N    ??CalculateIntegrationTimeRight_3
//  477       IntegrationTime_Right = 20;
        LDR.W    R0,??DataTable34_11
        MOVS     R1,#+20
        STRB     R1,[R0, #+0]
//  478 }
??CalculateIntegrationTimeRight_3:
        POP      {R0,PC}          ;; return
//  479 
//  480 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  481 uint8 PixelAverage(uint8 len, uint8 *data) 
//  482 {
PixelAverage:
        PUSH     {R4}
//  483   uint8 i;
//  484   uint16 sum = 0;
        MOVS     R3,#+0
//  485   for(i = 0; i<len; i++) 
        MOVS     R2,#+0
        B.N      ??PixelAverage_0
//  486   {
//  487      sum = sum + *data++;
??PixelAverage_1:
        LDRB     R4,[R1, #+0]
        UXTAB    R3,R3,R4
        ADDS     R1,R1,#+1
//  488   }
        ADDS     R2,R2,#+1
??PixelAverage_0:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R2,R0
        BCC.N    ??PixelAverage_1
//  489   return ((uint8)(sum/len));
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        SDIV     R0,R3,R0
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R4}
        BX       LR               ;; return
//  490 }
//  491 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  492 void get_left()
//  493 {
//  494     int16 i;
//  495     left=255;
get_left:
        LDR.W    R0,??DataTable34_12
        MOVS     R1,#+255
        STRH     R1,[R0, #+0]
//  496     for(i=127;i>2;i--)
        MOVS     R0,#+127
        B.N      ??get_left_0
??get_left_1:
        SUBS     R0,R0,#+1
??get_left_0:
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        CMP      R0,#+3
        BLT.N    ??get_left_2
//  497     {
//  498        if((Pixel[i]-Pixel[i-3])>GATE)
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        LDR.W    R1,??DataTable34_1
        LDRB     R1,[R0, R1]
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        LDR.W    R2,??DataTable34_1
        ADDS     R2,R0,R2
        LDRB     R2,[R2, #-3]
        SUBS     R1,R1,R2
        CMP      R1,#+31
        BLT.N    ??get_left_1
//  499        { 
//  500          left=i-3;
        SUBS     R0,R0,#+3
        LDR.W    R1,??DataTable34_12
        STRH     R0,[R1, #+0]
//  501          break;
//  502        }
//  503     }
//  504     left_c=left_OFFSET-left;   
??get_left_2:
        LDR.W    R0,??DataTable34_13
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable34_12
        LDRH     R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable34_14
        STRH     R0,[R1, #+0]
//  505 }
        BX       LR               ;; return
//  506 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  507 void get_right()
//  508 {
//  509    int16 i;
//  510    right=255;   
get_right:
        LDR.W    R0,??DataTable34_15
        MOVS     R1,#+255
        STRH     R1,[R0, #+0]
//  511    for(i=0;i<125;i++) 
        MOVS     R0,#+0
        B.N      ??get_right_0
??get_right_1:
        ADDS     R0,R0,#+1
??get_right_0:
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        CMP      R0,#+125
        BGE.N    ??get_right_2
//  512    { 
//  513       if((Pixel_1[i]-Pixel_1[i+3])>GATE)
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        LDR.W    R1,??DataTable34_8
        LDRB     R1,[R0, R1]
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        LDR.W    R2,??DataTable34_8
        ADDS     R2,R0,R2
        LDRB     R2,[R2, #+3]
        SUBS     R1,R1,R2
        CMP      R1,#+31
        BLT.N    ??get_right_1
//  514       {
//  515         right=i+3;
        ADDS     R0,R0,#+3
        LDR.W    R1,??DataTable34_15
        STRH     R0,[R1, #+0]
//  516         break;
//  517       }
//  518    }
//  519    right_c=right_OFFSET-right;
??get_right_2:
        LDR.W    R0,??DataTable34_16
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable34_15
        LDRH     R1,[R1, #+0]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable34_17
        STRH     R0,[R1, #+0]
//  520 }
        BX       LR               ;; return
//  521 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  522 void getCCD()
//  523 {
getCCD:
        PUSH     {R7,LR}
//  524     ImageCapture(Pixel);    
        LDR.W    R0,??DataTable34_1
        BL       ImageCapture
//  525     CalculateIntegrationTime();
        BL       CalculateIntegrationTime
//  526     ImageCapture_1(Pixel_1);
        LDR.W    R0,??DataTable34_8
        BL       ImageCapture_1
//  527     CalculateIntegrationTimeRight();
        BL       CalculateIntegrationTimeRight
//  528 
//  529     get_left();
        BL       get_left
//  530     get_right();
        BL       get_right
//  531     left_l+=left;
        LDR.W    R0,??DataTable34_18
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable34_12
        LDRH     R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.W    R1,??DataTable34_18
        STRH     R0,[R1, #+0]
//  532     right_l+=right;
        LDR.W    R0,??DataTable34_19
        LDRH     R0,[R0, #+0]
        LDR.W    R1,??DataTable34_15
        LDRH     R1,[R1, #+0]
        ADDS     R0,R1,R0
        LDR.W    R1,??DataTable34_19
        STRH     R0,[R1, #+0]
//  533 }
        POP      {R0,PC}          ;; return
//  534 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  535 void BlackManange() 
//  536 {  
//  537   //两边都没丢失
//  538   if((left!=255)&&(right!=255)) DIR_DEV =(left_c+right_c)/2; 
BlackManange:
        LDR.W    R0,??DataTable34_12
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BEQ.N    ??BlackManange_0
        LDR.W    R0,??DataTable34_15
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BEQ.N    ??BlackManange_0
        LDR.W    R0,??DataTable34_14
        LDRSH    R0,[R0, #+0]
        LDR.W    R1,??DataTable34_17
        LDRSH    R1,[R1, #+0]
        ADDS     R0,R1,R0
        MOVS     R1,#+2
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable34_20
        STRH     R0,[R1, #+0]
//  539   //右边沿丢失    /*右边可能丢掉右边的线，但检测到左边的线，则右边所得数值极偏小*/
//  540   if((left!=255)&&(right==255)) DIR_DEV =left_c; 
??BlackManange_0:
        LDR.W    R0,??DataTable34_12
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BEQ.N    ??BlackManange_1
        LDR.W    R0,??DataTable34_15
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BNE.N    ??BlackManange_1
        LDR.W    R0,??DataTable34_20
        LDR.W    R1,??DataTable34_14
        LDRH     R1,[R1, #+0]
        STRH     R1,[R0, #+0]
//  541   //左边沿丢失    /*左边可能丢掉左边的线，但检测到右边的线，则左边所得数值极偏大*/
//  542   if((left==255)&&(right!=255)) DIR_DEV =right_c;
??BlackManange_1:
        LDR.W    R0,??DataTable34_12
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BNE.N    ??BlackManange_2
        LDR.W    R0,??DataTable34_15
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BEQ.N    ??BlackManange_2
        LDR.W    R0,??DataTable34_20
        LDR.W    R1,??DataTable34_17
        LDRH     R1,[R1, #+0]
        STRH     R1,[R0, #+0]
//  543   //左右都丢失
//  544   if((left==255)&&(right==255)) DIR_DEV=DIR_DEV*2/3;
??BlackManange_2:
        LDR.W    R0,??DataTable34_12
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BNE.N    ??BlackManange_3
        LDR.W    R0,??DataTable34_15
        LDRSH    R0,[R0, #+0]
        CMP      R0,#+255
        BNE.N    ??BlackManange_3
        LDR.W    R0,??DataTable34_20
        LDRSH    R0,[R0, #+0]
        LSLS     R0,R0,#+1
        MOVS     R1,#+3
        SDIV     R0,R0,R1
        LDR.W    R1,??DataTable34_20
        STRH     R0,[R1, #+0]
//  545 }
??BlackManange_3:
        BX       LR               ;; return
//  546 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  547 void LCD_show()
//  548 {
LCD_show:
        PUSH     {R7,LR}
//  549     LCD_P8x16_number(10,0,left_OFFSET);
        LDR.W    R0,??DataTable34_13
        LDRSH    R2,[R0, #+0]
        MOVS     R1,#+0
        MOVS     R0,#+10
        BL       LCD_P8x16_number
//  550     LCD_P8x16_number(70,0,right_OFFSET);
        LDR.W    R0,??DataTable34_16
        LDRSH    R2,[R0, #+0]
        MOVS     R1,#+0
        MOVS     R0,#+70
        BL       LCD_P8x16_number
//  551     LCD_P8x16_number(10,2,left);
        LDR.W    R0,??DataTable34_12
        LDRSH    R2,[R0, #+0]
        MOVS     R1,#+2
        MOVS     R0,#+10
        BL       LCD_P8x16_number
//  552     LCD_P8x16_number(70,2,right);
        LDR.W    R0,??DataTable34_15
        LDRSH    R2,[R0, #+0]
        MOVS     R1,#+2
        MOVS     R0,#+70
        BL       LCD_P8x16_number
//  553     delay_ms(50);       
        MOVS     R0,#+50
        BL       delay_ms
//  554     //LCD_CLS();   
//  555 }
        POP      {R0,PC}          ;; return
//  556 
//  557 //----------------------------给CCDView发送图像----------------------------------------------------------------//

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  558 void SendImageData(uint8 * ImageData)
//  559 {
SendImageData:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
//  560     unsigned char i;
//  561     unsigned char crc = 0;
        MOVS     R6,#+0
//  562     /* Send Data */    
//  563     uart_send1(UART3,'*');
        MOVS     R1,#+42
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  564     uart_send1(UART3,'L');
        MOVS     R1,#+76
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  565     uart_send1(UART3,'D');
        MOVS     R1,#+68
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  566     
//  567     SendHex(0);
        MOVS     R0,#+0
        BL       SendHex
//  568     SendHex(0);
        MOVS     R0,#+0
        BL       SendHex
//  569     SendHex(0);
        MOVS     R0,#+0
        BL       SendHex
//  570     SendHex(0);    
        MOVS     R0,#+0
        BL       SendHex
//  571     
//  572     for(i=0; i<128; i++) 
        MOVS     R5,#+0
        B.N      ??SendImageData_0
//  573     {
//  574         SendHex(*ImageData ++);
??SendImageData_1:
        LDRB     R0,[R4, #+0]
        BL       SendHex
        ADDS     R4,R4,#+1
//  575     }
        ADDS     R5,R5,#+1
??SendImageData_0:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+128
        BCC.N    ??SendImageData_1
//  576 
//  577     SendHex(crc);
        MOVS     R0,R6
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       SendHex
//  578     uart_send1(UART3,'#');
        MOVS     R1,#+35
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  579 }
        POP      {R4-R6,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable22:
        DC32     g_lnInputVoltageSigma

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable22_1:
        DC32     gravity

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable22_2:
        DC32     gyro
//  580 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  581 void SendHex(unsigned char hex) 
//  582 {
SendHex:
        PUSH     {R4,LR}
        MOVS     R4,R0
//  583   unsigned char temp;
//  584   temp = hex >> 4;
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        LSRS     R0,R4,#+4
//  585   if(temp < 10) 
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+10
        BCS.N    ??SendHex_0
//  586   {
//  587    uart_send1(UART3,temp + '0');
        ADDS     R1,R0,#+48
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
        B.N      ??SendHex_1
//  588   } 
//  589   else 
//  590   {
//  591    uart_send1(UART3,temp - 10 + 'A');
??SendHex_0:
        ADDS     R1,R0,#+55
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  592   }
//  593   temp = hex & 0x0F;
??SendHex_1:
        ANDS     R0,R4,#0xF
//  594   if(temp < 10) 
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+10
        BCS.N    ??SendHex_2
//  595   {
//  596    uart_send1(UART3,temp + '0');
        ADDS     R1,R0,#+48
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
        B.N      ??SendHex_3
//  597   } 
//  598   else 
//  599   {
//  600   uart_send1(UART3,temp - 10 + 'A');
??SendHex_2:
        ADDS     R1,R0,#+55
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        LDR.W    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  601   }
//  602 }
??SendHex_3:
        POP      {R4,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23:
        DC32     g_nInputVoltage

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_1:
        DC32     0x67381d7e

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_2:
        DC32     0x3fbf6944

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_3:
        DC32     g_fGravityAngle

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_4:
        DC32     0x3fd33333

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_5:
        DC32     g_fGyroscopeAngleSpeed

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_6:
        DC32     g_fCarAngle

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable23_7:
        DC32     0x3fd66666
//  603 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//  604 void SamplingDelay(void)//CCD延时程序 200ns
//  605 {
SamplingDelay:
        SUB      SP,SP,#+4
//  606    volatile uint8 i ;
//  607    for(i=0;i<1;i++) 
        MOVS     R0,#+0
        STRB     R0,[SP, #+0]
        B.N      ??SamplingDelay_0
//  608    {
//  609     asm("nop");
??SamplingDelay_1:
        nop              
//  610     asm("nop");
        nop              
//  611    }
        LDRB     R0,[SP, #+0]
        ADDS     R0,R0,#+1
        STRB     R0,[SP, #+0]
??SamplingDelay_0:
        LDRB     R0,[SP, #+0]
        CMP      R0,#+1
        BCC.N    ??SamplingDelay_1
//  612 }
        ADD      SP,SP,#+4
        BX       LR               ;; return
//  613 //----------------------------------------------------------------------------------------------------------//

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  614 void DirectionControl(void)
//  615  {
DirectionControl:
        PUSH     {R4,LR}
//  616 	float  fValue, fDValue;
//  617 	
//  618 	g_fDirectionControlOutOld = g_fDirectionControlOutNew;
        LDR.W    R0,??DataTable34_22
        LDR.W    R1,??DataTable34_23
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
//  619         
//  620 	fValue=DIR_DEV;
        LDR.W    R0,??DataTable34_20
        LDRSH    R0,[R0, #+0]
        BL       __aeabi_i2f
        MOVS     R4,R0
//  621         
//  622         fValue = fValue * DIR_CONTROL_P;
        MOVS     R0,R4
        BL       __aeabi_f2d
        LDR.W    R2,??DataTable34_24  ;; 0xb020c49c
        LDR.W    R3,??DataTable34_25  ;; 0x3f916872
        BL       __aeabi_dmul
        BL       __aeabi_d2f
        MOVS     R4,R0
//  623 	fDValue = (DIR_CONTROL_D_VALUE - GYROSCOPE_OFFSET_DIRECTION) * DIR_CONTROL_D;
        LDR.W    R0,??DataTable34_26
        LDRSH    R0,[R0, #+8]
        LDR.N    R1,??DataTable27
        LDRSH    R1,[R1, #+0]
        SUBS     R0,R0,R1
        BL       __aeabi_i2d
        LDR.W    R2,??DataTable34_27  ;; 0x8db8bac7
        LDR.W    R3,??DataTable34_28  ;; 0x3f46f006
        BL       __aeabi_dmul
        BL       __aeabi_d2f
//  624         
//  625 	fValue+=fDValue;
        MOVS     R1,R4
        BL       __aeabi_fadd
        MOVS     R4,R0
//  626 	/*  
//  627 	if(fValue > 0) fValue += DIRECTION_CONTROL_DEADVALUE;
//  628         if(fValue < 0) fValue -= DIRECTION_CONTROL_DEADVALUE;
//  629 	*/	
//  630 	if(fValue > DIRECTION_CONTROL_OUT_MAX) fValue = DIRECTION_CONTROL_OUT_MAX;
        MOVS     R0,R4
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??DirectionControl_0
        MOVS     R4,#+1065353216
//  631 	if(fValue < DIRECTION_CONTROL_OUT_MIN) fValue = DIRECTION_CONTROL_OUT_MIN;
??DirectionControl_0:
        MOVS     R0,R4
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??DirectionControl_1
        LDR.W    R4,??DataTable34_30  ;; 0xbf800000
//  632 	g_fDirectionControlOutNew = fValue;
??DirectionControl_1:
        LDR.W    R0,??DataTable34_23
        STR      R4,[R0, #+0]
//  633 }
        POP      {R4,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable24:
        DC32     0x43480000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable24_1:
        DC32     0x1a9fbe77

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable24_2:
        DC32     0x3fc4dd2f
//  634     

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  635 void DirectionControlOutput(void) 
//  636 {
DirectionControlOutput:
        PUSH     {R4,LR}
//  637 	float fValue;
//  638 	fValue = g_fDirectionControlOutNew - g_fDirectionControlOutOld;
        LDR.W    R0,??DataTable34_23
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable34_22
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R4,R0
//  639 	g_fDirectionControlOut = fValue * (g_nDirectionControlPeriod + 1) / DIRECTION_CONTROL_PERIOD + g_fDirectionControlOutOld;
        LDR.W    R0,??DataTable34_31
        LDRSH    R0,[R0, #+0]
        ADDS     R0,R0,#+1
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        LDR.N    R1,??DataTable29_2  ;; 0x41200000
        BL       __aeabi_fdiv
        LDR.W    R1,??DataTable34_22
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        LDR.W    R1,??DataTable34_32
        STR      R0,[R1, #+0]
//  640 }
        POP      {R4,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25:
        DC32     0xbc6a7efa

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25_1:
        DC32     0x3f789374

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25_2:
        DC32     0x40039004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25_3:
        DC32     g_nLeftMotorPulse

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25_4:
        DC32     g_nRightMotorPulse

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25_5:
        DC32     g_fLeftMotorOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable25_6:
        DC32     g_nLeftMotorPulseSigma
//  641 
//  642 
//  643 
//  644 //----------------------电机控制--------------------------------------------------

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  645 void MotorOutput(void)
//  646 {
MotorOutput:
        PUSH     {R4,LR}
//  647 	float fLeft, fRight;
//  648 
//  649 	fLeft  = g_fAngleControlOut - g_fSpeedControlOut - g_fDirectionControlOut;
        LDR.N    R0,??DataTable29
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable33
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        LDR.W    R1,??DataTable34_32
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        MOVS     R4,R0
//  650 	fRight = g_fAngleControlOut - g_fSpeedControlOut + g_fDirectionControlOut;
        LDR.N    R0,??DataTable29
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable33
        LDR      R1,[R1, #+0]
        BL       __aeabi_fsub
        LDR.W    R1,??DataTable34_32
        LDR      R1,[R1, #+0]
        BL       __aeabi_fadd
        MOVS     R2,R0
//  651 	
//  652 	if(fLeft > MOTOR_OUT_MAX)		fLeft = MOTOR_OUT_MAX;
        MOVS     R0,R4
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorOutput_0
        MOVS     R4,#+1065353216
//  653 	if(fLeft < MOTOR_OUT_MIN)		fLeft = MOTOR_OUT_MIN;
??MotorOutput_0:
        MOVS     R0,R4
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorOutput_1
        LDR.W    R4,??DataTable34_30  ;; 0xbf800000
//  654 	if(fRight > MOTOR_OUT_MAX)		fRight = MOTOR_OUT_MAX;
??MotorOutput_1:
        MOVS     R0,R2
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorOutput_2
        MOVS     R2,#+1065353216
//  655 	if(fRight < MOTOR_OUT_MIN)		fRight = MOTOR_OUT_MIN;
??MotorOutput_2:
        MOVS     R0,R2
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorOutput_3
        LDR.W    R2,??DataTable34_30  ;; 0xbf800000
//  656 		
//  657 	g_fLeftMotorOut = fLeft;
??MotorOutput_3:
        LDR.W    R0,??DataTable34_33
        STR      R4,[R0, #+0]
//  658 	g_fRightMotorOut = fRight;
        LDR.W    R0,??DataTable34_34
        STR      R2,[R0, #+0]
//  659 	MotorSpeedOut();
        BL       MotorSpeedOut
//  660 }
        POP      {R4,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable26:
        DC32     g_fRightMotorOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable26_1:
        DC32     g_nRightMotorPulseSigma
//  661 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  662 void MotorSpeedOut(void)
//  663 {
MotorSpeedOut:
        PUSH     {R7,LR}
//  664 	float fLeftVal, fRightVal;
//  665 	
//  666 	fLeftVal = g_fLeftMotorOut;
        LDR.W    R0,??DataTable34_33
        LDR      R2,[R0, #+0]
//  667 	fRightVal = g_fRightMotorOut;
        LDR.W    R0,??DataTable34_34
        LDR      R3,[R0, #+0]
//  668         /*
//  669 	if(fLeftVal > 0) 			fLeftVal += MOTOR_OUT_DEAD_VAL;
//  670 	else if(fLeftVal < 0) 		fLeftVal -= MOTOR_OUT_DEAD_VAL;
//  671 	
//  672 	if(fRightVal > 0)			fRightVal += MOTOR_OUT_DEAD_VAL;
//  673 	else if(fRightVal < 0)		fRightVal -= MOTOR_OUT_DEAD_VAL;
//  674 	*/	
//  675 	if(fLeftVal > MOTOR_OUT_MAX)	fLeftVal = MOTOR_OUT_MAX;
        MOVS     R0,R2
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorSpeedOut_0
        MOVS     R2,#+1065353216
//  676 	if(fLeftVal < MOTOR_OUT_MIN)	fLeftVal = MOTOR_OUT_MIN;
??MotorSpeedOut_0:
        MOVS     R0,R2
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorSpeedOut_1
        LDR.W    R2,??DataTable34_30  ;; 0xbf800000
//  677 	if(fRightVal > MOTOR_OUT_MAX)	fRightVal = MOTOR_OUT_MAX;
??MotorSpeedOut_1:
        MOVS     R0,R3
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??MotorSpeedOut_2
        MOVS     R3,#+1065353216
//  678 	if(fRightVal < MOTOR_OUT_MIN)	fRightVal = MOTOR_OUT_MIN;
??MotorSpeedOut_2:
        MOVS     R0,R3
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??MotorSpeedOut_3
        LDR.W    R3,??DataTable34_30  ;; 0xbf800000
//  679 			
//  680 	SetMotorVoltage(fLeftVal, fRightVal);
??MotorSpeedOut_3:
        MOVS     R1,R3
        MOVS     R0,R2
        BL       SetMotorVoltage
//  681 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27:
        DC32     gyro_direction

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_1:
        DC32     g_fCarSpeed

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_2:
        DC32     0x47ae147b

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_3:
        DC32     0x3f947ae1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_4:
        DC32     g_fCarSpeedstart

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_5:
        DC32     0x41a00000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_6:
        DC32     0x40a00000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_7:
        DC32     0x41a00001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_8:
        DC32     0xc0a00000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_9:
        DC32     speedflag

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_10:
        DC32     0x20c49ba

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_11:
        DC32     0x3fa6872b

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_12:
        DC32     0x4d551d69

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable27_13:
        DC32     0x3eff7510
//  682 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  683 void SetMotorVoltage(float fLeftVoltage, float fRightVoltage) 
//  684 {
SetMotorVoltage:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
        MOVS     R5,R1
//  685                                                 // Voltage : > 0 : Move forward
//  686                                                 // Voltage : < 0 : Move backward
//  687 	int16 nPeriod;
//  688 	int16 nOut;
//  689 	
//  690 	nPeriod =1250;
        MOVW     R6,#+1250
//  691         //--------------------------------------------------------------------------
//  692 	if(fLeftVoltage > 1.0) 			fLeftVoltage = 1.0;
        MOVS     R0,R4
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??SetMotorVoltage_0
        MOVS     R4,#+1065353216
        B.N      ??SetMotorVoltage_1
//  693 	else if(fLeftVoltage < -1.0) 	fLeftVoltage = -1.0;
??SetMotorVoltage_0:
        MOVS     R0,R4
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??SetMotorVoltage_1
        LDR.W    R4,??DataTable34_30  ;; 0xbf800000
//  694 	
//  695 	if(fRightVoltage > 1.0) 		fRightVoltage = 1.0;
??SetMotorVoltage_1:
        MOVS     R0,R5
        LDR.W    R1,??DataTable34_29  ;; 0x3f800001
        BL       __aeabi_cfrcmple
        BHI.N    ??SetMotorVoltage_2
        MOVS     R5,#+1065353216
        B.N      ??SetMotorVoltage_3
//  696 	else if(fRightVoltage < -1.0)	fRightVoltage = -1.0;
??SetMotorVoltage_2:
        MOVS     R0,R5
        LDR.W    R1,??DataTable34_30  ;; 0xbf800000
        BL       __aeabi_cfcmple
        BCS.N    ??SetMotorVoltage_3
        LDR.W    R5,??DataTable34_30  ;; 0xbf800000
//  697         //--------------------------------------------------------------------------
//  698 	if(fRightVoltage > 0)                                          //右轮 前
??SetMotorVoltage_3:
        MOVS     R0,R5
        MOVS     R1,#+0
        BL       __aeabi_cfrcmple
        BCS.N    ??SetMotorVoltage_4
//  699         {
//  700           gpio_init(PORTB,10, 1,1);//DIR_B;
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.W    R0,??DataTable34_35  ;; 0x400ff040
        BL       gpio_init
//  701           nOut = (int16)(fRightVoltage * nPeriod);
        SXTH     R6,R6            ;; SignExt  R6,R6,#+16,#+16
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R5
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  702           FTM0_C1V=nPeriod-nOut;
        SXTH     R6,R6            ;; SignExt  R6,R6,#+16,#+16
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        SUBS     R0,R6,R0
        LDR.W    R1,??DataTable34_36  ;; 0x40038018
        STR      R0,[R1, #+0]
        B.N      ??SetMotorVoltage_5
//  703 	}
//  704 	else                                                          //右轮 后
//  705 	{
//  706           gpio_init(PORTB,10, 1,0);// DIR_F ;
??SetMotorVoltage_4:
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+10
        LDR.N    R0,??DataTable34_35  ;; 0x400ff040
        BL       gpio_init
//  707 	  fRightVoltage = -fRightVoltage;
        EORS     R5,R5,#0x80000000
//  708           nOut = (int16)(fRightVoltage * nPeriod);
        SXTH     R6,R6            ;; SignExt  R6,R6,#+16,#+16
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R5
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  709           FTM0_C1V=nOut;
        LDR.N    R1,??DataTable34_36  ;; 0x40038018
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        STR      R0,[R1, #+0]
//  710   	}
//  711         //--------------------------------------------------------------------------	                                            	                                              
//  712 	if(fLeftVoltage > 0)                                           //左轮 前
??SetMotorVoltage_5:
        MOVS     R0,R4
        MOVS     R1,#+0
        BL       __aeabi_cfrcmple
        BCS.N    ??SetMotorVoltage_6
//  713 	{
//  714           gpio_init(PORTB, 9, 1,1);//DIL_B ;
        MOVS     R3,#+1
        MOVS     R2,#+1
        MOVS     R1,#+9
        LDR.N    R0,??DataTable34_35  ;; 0x400ff040
        BL       gpio_init
//  715           nOut = (int16)(fLeftVoltage * nPeriod);
        SXTH     R6,R6            ;; SignExt  R6,R6,#+16,#+16
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  716           FTM0_C0V=nPeriod-nOut;
        SXTH     R6,R6            ;; SignExt  R6,R6,#+16,#+16
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        SUBS     R0,R6,R0
        LDR.N    R1,??DataTable34_37  ;; 0x40038010
        STR      R0,[R1, #+0]
        B.N      ??SetMotorVoltage_7
//  717 	} 
//  718 	else                                                           //左轮 后
//  719 	{ 
//  720 	  gpio_init(PORTB, 9, 1,0);// DIL_F ;
??SetMotorVoltage_6:
        MOVS     R3,#+0
        MOVS     R2,#+1
        MOVS     R1,#+9
        LDR.N    R0,??DataTable34_35  ;; 0x400ff040
        BL       gpio_init
//  721 	  fLeftVoltage = -fLeftVoltage;
        EORS     R4,R4,#0x80000000
//  722 	  nOut = (int16)(fLeftVoltage * nPeriod);
        SXTH     R6,R6            ;; SignExt  R6,R6,#+16,#+16
        MOVS     R0,R6
        BL       __aeabi_i2f
        MOVS     R1,R4
        BL       __aeabi_fmul
        BL       __aeabi_f2iz
//  723           FTM0_C0V=nOut;
        LDR.N    R1,??DataTable34_37  ;; 0x40038010
        SXTH     R0,R0            ;; SignExt  R0,R0,#+16,#+16
        STR      R0,[R1, #+0]
//  724   	}                                
//  725 } 
??SetMotorVoltage_7:
        POP      {R4-R6,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable28:
        DC32     g_fGyroscopeAngleIntergral

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable28_1:
        DC32     g_fSpeedControlIntegral

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable28_2:
        DC32     0x41200001
//  726 
//  727 
//  728 
//  729 
//  730 /****************************虚拟示波器模块******************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  731 void virtual_scope_show(void)
//  732 {
//  733       OutData[0]=0;
virtual_scope_show:
        LDR.N    R0,??DataTable34_38
        MOVS     R1,#+0
        STRH     R1,[R0, #+0]
//  734       OutData[1]=0;
        LDR.N    R0,??DataTable34_38
        MOVS     R1,#+0
        STRH     R1,[R0, #+2]
//  735       OutData[2]=0;
        LDR.N    R0,??DataTable34_38
        MOVS     R1,#+0
        STRH     R1,[R0, #+4]
//  736       OutData[3]=0;
        LDR.N    R0,??DataTable34_38
        MOVS     R1,#+0
        STRH     R1,[R0, #+6]
//  737 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29:
        DC32     g_fAngleControlOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29_1:
        DC32     0x400b8004

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29_2:
        DC32     0x41200000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29_3:
        DC32     0xc1200000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29_4:
        DC32     g_fSpeedControlOutOld

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29_5:
        DC32     g_fSpeedControlOutNew

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable29_6:
        DC32     g_nSpeedControlPeriod
//  738 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  739 void serial_Txd()//传输的一帧数据，包括如下的内容
//  740 {
serial_Txd:
        PUSH     {R4,LR}
        SUB      SP,SP,#+16
//  741         uint8 temp[10]={0};
        ADD      R0,SP,#+0
        MOVS     R1,#+0
        MOVS     R2,#+0
        MOVS     R3,#+0
        STM      R0!,{R1-R3}
        SUBS     R0,R0,#+12
//  742         uint8 i,j;
//  743         //帧头数据
//  744         uart_send1 (UART3, 0xa5);
        MOVS     R1,#+165
        LDR.N    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  745         uart_send1 (UART3, 0x5a);
        MOVS     R1,#+90
        LDR.N    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  746 	
//  747        //第一条曲线的数据
//  748         for(i=0;i<3;i++)
        MOVS     R0,#+0
        B.N      ??serial_Txd_0
//  749         {
//  750            temp[i*2]=(int)OutData[i]/10;
??serial_Txd_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable34_38
        LDRSH    R1,[R1, R0, LSL #+1]
        MOVS     R2,#+10
        SDIV     R1,R1,R2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        ADD      R2,SP,#+0
        STRB     R1,[R2, R0, LSL #+1]
//  751            temp[i*2+1]=(int)OutData[i]%10;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDR.N    R1,??DataTable34_38
        LDRSH    R1,[R1, R0, LSL #+1]
        MOVS     R2,#+10
        SDIV     R3,R1,R2
        MLS      R1,R2,R3,R1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        ADD      R2,SP,#+0
        ADDS     R2,R2,R0, LSL #+1
        STRB     R1,[R2, #+1]
//  752         }
        ADDS     R0,R0,#+1
??serial_Txd_0:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+3
        BCC.N    ??serial_Txd_1
//  753        for(j=0;j<6;j++)
        MOVS     R4,#+0
        B.N      ??serial_Txd_2
//  754        {
//  755           uart_send1 (UART3, temp[j]);
??serial_Txd_3:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+0
        LDRB     R1,[R4, R0]
        LDR.N    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
//  756        }
        ADDS     R4,R4,#+1
??serial_Txd_2:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+6
        BCC.N    ??serial_Txd_3
//  757         delay_ms(10);
        MOVS     R0,#+10
        BL       delay_ms
//  758 }
        POP      {R0-R4,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable30:
        DC32     0x42c80000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable30_1:
        DC32     0x400ff100

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable30_2:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable30_3:
        DC32     0x4004904c
//  759 
//  760 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  761 unsigned short CRC_CHECK(unsigned char *Buf, unsigned char CRC_CNT)
//  762 {
CRC_CHECK:
        PUSH     {R4,R5}
//  763     unsigned short CRC_Temp;
//  764     unsigned char i,j;
//  765     CRC_Temp = 0xffff;
        MOVW     R2,#+65535
//  766 
//  767     for (i=0;i<CRC_CNT; i++)
        MOVS     R3,#+0
        B.N      ??CRC_CHECK_0
??CRC_CHECK_1:
        ADDS     R3,R3,#+1
??CRC_CHECK_0:
        UXTB     R3,R3            ;; ZeroExt  R3,R3,#+24,#+24
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        CMP      R3,R1
        BCS.N    ??CRC_CHECK_2
//  768     {      
//  769         CRC_Temp ^= Buf[i];
        UXTB     R3,R3            ;; ZeroExt  R3,R3,#+24,#+24
        LDRB     R4,[R3, R0]
        EORS     R2,R4,R2
//  770         for (j=0;j<8;j++)
        MOVS     R4,#+0
        B.N      ??CRC_CHECK_3
//  771         {
//  772             if (CRC_Temp & 0x01)
//  773                 CRC_Temp = (CRC_Temp >>1 ) ^ 0xa001;
//  774             else
//  775                 CRC_Temp = CRC_Temp >> 1;
??CRC_CHECK_4:
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        LSRS     R2,R2,#+1
??CRC_CHECK_5:
        ADDS     R4,R4,#+1
??CRC_CHECK_3:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+8
        BCS.N    ??CRC_CHECK_1
        LSLS     R5,R2,#+31
        BPL.N    ??CRC_CHECK_4
        UXTH     R2,R2            ;; ZeroExt  R2,R2,#+16,#+16
        LSRS     R2,R2,#+1
        EOR      R2,R2,#0xA000
        EORS     R2,R2,#0x1
        B.N      ??CRC_CHECK_5
//  776         }
//  777     }
//  778     return(CRC_Temp);
??CRC_CHECK_2:
        MOVS     R0,R2
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        POP      {R4,R5}
        BX       LR               ;; return
//  779 }
//  780 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  781 void OutPut_Data(void)
//  782 {
OutPut_Data:
        PUSH     {R4,LR}
        SUB      SP,SP,#+48
//  783   int temp[4] = {0};
        ADD      R0,SP,#+28
        MOVS     R1,#+16
        BL       __aeabi_memclr4
//  784   unsigned int temp1[4] = {0};
        ADD      R0,SP,#+12
        MOVS     R1,#+16
        BL       __aeabi_memclr4
//  785   unsigned char databuf[10] = {0};
        ADD      R0,SP,#+0
        MOVS     R1,#+0
        MOVS     R2,#+0
        MOVS     R3,#+0
        STM      R0!,{R1-R3}
        SUBS     R0,R0,#+12
//  786   unsigned char i;
//  787   unsigned short CRC16 = 0;
        MOVS     R0,#+0
//  788   for(i=0;i<4;i++)
        MOVS     R4,#+0
        B.N      ??OutPut_Data_0
//  789   {    
//  790     temp[i]  = (int16)OutData[i];
??OutPut_Data_1:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+28
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        LDR.N    R1,??DataTable34_38
        LDRSH    R1,[R1, R4, LSL #+1]
        STR      R1,[R0, R4, LSL #+2]
//  791     temp1[i] = (uint16)temp[i];
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+12
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R1,SP,#+28
        LDRH     R1,[R1, R4, LSL #+2]
        STR      R1,[R0, R4, LSL #+2]
//  792   }
        ADDS     R4,R4,#+1
??OutPut_Data_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+4
        BCC.N    ??OutPut_Data_1
//  793    
//  794   for(i=0;i<4;i++) 
        MOVS     R4,#+0
        B.N      ??OutPut_Data_2
//  795   {
//  796     databuf[i*2]   = (int8)(temp1[i]%256);
??OutPut_Data_3:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+12
        LDR      R0,[R0, R4, LSL #+2]
        MOV      R1,#+256
        UDIV     R2,R0,R1
        MLS      R2,R2,R1,R0
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+0
        STRB     R2,[R0, R4, LSL #+1]
//  797     databuf[i*2+1] = (int8)(temp1[i]/256);
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+12
        LDR      R0,[R0, R4, LSL #+2]
        LSRS     R0,R0,#+8
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R1,SP,#+0
        ADDS     R1,R1,R4, LSL #+1
        STRB     R0,[R1, #+1]
//  798   }
        ADDS     R4,R4,#+1
??OutPut_Data_2:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+4
        BCC.N    ??OutPut_Data_3
//  799   
//  800   CRC16 = CRC_CHECK(databuf,8);
        MOVS     R1,#+8
        ADD      R0,SP,#+0
        BL       CRC_CHECK
//  801   databuf[8] = CRC16%256;
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOV      R1,#+256
        SDIV     R2,R0,R1
        MLS      R2,R2,R1,R0
        STRB     R2,[SP, #+8]
//  802   databuf[9] = CRC16/256;
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOV      R1,#+256
        SDIV     R0,R0,R1
        STRB     R0,[SP, #+9]
//  803   
//  804   for(i=0;i<10;i++)
        MOVS     R4,#+0
        B.N      ??OutPut_Data_4
//  805   uart_send1 (UART3,databuf[i]);
??OutPut_Data_5:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        ADD      R0,SP,#+0
        LDRB     R1,[R4, R0]
        LDR.N    R0,??DataTable34_21  ;; 0x4006d000
        BL       uart_send1
        ADDS     R4,R4,#+1
??OutPut_Data_4:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+10
        BCC.N    ??OutPut_Data_5
//  806 }
        ADD      SP,SP,#+48
        POP      {R4,PC}          ;; return
//  807 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  808 void KeyScan(void) 
//  809 {
KeyScan:
        PUSH     {R7,LR}
//  810   if(key_1==0) 
        LDR.N    R0,??DataTable34_39  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+12
        BMI.N    ??KeyScan_0
//  811   {
//  812       delay_ms(10);
        MOVS     R0,#+10
        BL       delay_ms
//  813       if(key_1==0) 
        LDR.N    R0,??DataTable34_39  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+12
        BMI.N    ??KeyScan_0
//  814       {
//  815         a=255;  
        LDR.N    R0,??DataTable34_40
        MOVS     R1,#+255
        STRB     R1,[R0, #+0]
//  816         LCD_P8x16_number(10,4,a);    
        LDR.N    R0,??DataTable34_40
        LDRB     R2,[R0, #+0]
        MOVS     R1,#+4
        MOVS     R0,#+10
        BL       LCD_P8x16_number
//  817         while(!key_1);
??KeyScan_1:
        LDR.N    R0,??DataTable34_39  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+12
        BPL.N    ??KeyScan_1
//  818       }
//  819   }     
//  820 }
??KeyScan_0:
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  821 void KeyScan_1(void) 
//  822 {
KeyScan_1:
        PUSH     {R7,LR}
//  823   if(key_1==0) 
        LDR.N    R0,??DataTable34_39  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+12
        BMI.N    ??KeyScan_1_0
//  824   {
//  825       delay_ms(10);
        MOVS     R0,#+10
        BL       delay_ms
//  826       if(key_1==0) 
        LDR.N    R0,??DataTable34_39  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+12
        BMI.N    ??KeyScan_1_0
//  827       {
//  828         b=200;  
        LDR.N    R0,??DataTable34_41
        MOVS     R1,#+200
        STRB     R1,[R0, #+0]
//  829         LCD_P8x16_number(10,4,b);    
        LDR.N    R0,??DataTable34_41
        LDRB     R2,[R0, #+0]
        MOVS     R1,#+4
        MOVS     R0,#+10
        BL       LCD_P8x16_number
//  830         while(!key_1);
??KeyScan_1_1:
        LDR.N    R0,??DataTable34_39  ;; 0x400ff010
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+12
        BPL.N    ??KeyScan_1_1
//  831       }
//  832   }     
//  833 }
??KeyScan_1_0:
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable33:
        DC32     g_fSpeedControlOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable33_1:
        DC32     0x400ff080

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  834 void Clear()
//  835 {
//  836     g_lnInputVoltageSigma[0]=0;   
Clear:
        LDR.N    R0,??DataTable34_42
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  837     g_lnInputVoltageSigma[1]=0;
        LDR.N    R0,??DataTable34_42
        MOVS     R1,#+0
        STR      R1,[R0, #+4]
//  838     g_lnInputVoltageSigma[2]=0;
        LDR.N    R0,??DataTable34_42
        MOVS     R1,#+0
        STR      R1,[R0, #+8]
//  839 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34:
        DC32     0x400ff000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_1:
        DC32     Pixel

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_2:
        DC32     PixelAverageValue

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_3:
        DC32     PixelAverageVoltage

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_4:
        DC32     TargetPixelAverageVoltage

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_5:
        DC32     PixelAverageVoltageError

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_6:
        DC32     TargetPixelAverageVoltageAllowError

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_7:
        DC32     IntegrationTime

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_8:
        DC32     Pixel_1

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_9:
        DC32     PixelAverageValue_Right

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_10:
        DC32     PixelAverageVoltage_Right

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_11:
        DC32     IntegrationTime_Right

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_12:
        DC32     left

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_13:
        DC32     left_OFFSET

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_14:
        DC32     left_c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_15:
        DC32     right

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_16:
        DC32     right_OFFSET

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_17:
        DC32     right_c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_18:
        DC32     left_l

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_19:
        DC32     right_l

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_20:
        DC32     dev

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_21:
        DC32     0x4006d000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_22:
        DC32     g_fDirectionControlOutOld

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_23:
        DC32     g_fDirectionControlOutNew

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_24:
        DC32     0xb020c49c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_25:
        DC32     0x3f916872

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_26:
        DC32     g_nInputVoltage

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_27:
        DC32     0x8db8bac7

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_28:
        DC32     0x3f46f006

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_29:
        DC32     0x3f800001

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_30:
        DC32     0xbf800000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_31:
        DC32     g_nDirectionControlPeriod

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_32:
        DC32     g_fDirectionControlOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_33:
        DC32     g_fLeftMotorOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_34:
        DC32     g_fRightMotorOut

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_35:
        DC32     0x400ff040

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_36:
        DC32     0x40038018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_37:
        DC32     0x40038010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_38:
        DC32     OutData

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_39:
        DC32     0x400ff010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_40:
        DC32     a

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_41:
        DC32     `b`

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable34_42:
        DC32     g_lnInputVoltageSigma

        SECTION `.iar_vfe_header`:DATA:REORDER:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC32 0
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC32 0
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        SECTION `.rodata`:CONST:REORDER:NOROOT(2)
        DATA
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        END
//  840 
// 
//   145 bytes in section .bss
//     6 bytes in section .data
//    56 bytes in section .rodata
// 4 726 bytes in section .text
// 
// 4 726 bytes of CODE  memory
//    56 bytes of CONST memory
//   151 bytes of DATA  memory
//
//Errors: none
//Warnings: none
