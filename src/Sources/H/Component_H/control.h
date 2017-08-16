#ifndef __CONTROL_H__
#define __CONTROL_H__
//1 Í·ÎÄ¼þ
#include "common.h"

void get_ad(void);
void GetSamplezhi();
void GetOFFSET();
void GetInputVoltageAverage(int j);
void AngleCalculate(void);
void AngleControl(void);
void GetMotorPulse(void);
void SpeedControl(void);
void SpeedControlOutput(void);
void StartIntegration(void); 
void StartIntegrationRight(void); 
void ImageCapture(unsigned char * ImageData);
void ImageCapture_1(uint8 *ImageData_1);
void SendHex(unsigned char hex);
void SamplingDelay(void);
void CCD_init(void);
void CalculateIntegrationTime(void);
void CalculateIntegrationTimeRight(void);
uint8 PixelAverage(uint8 len, uint8 *data);
void SendImageData(unsigned char * ImageData);
void virtual_scope_show(void);
void serial_Txd(void);
void DirectionControl(void);
void DirectionControlOutput(void);
void MotorOutput(void);
void MotorSpeedOut(void);
void SetMotorVoltage(float fLeftVal, float fRightVal);
void virtual_scope_show(void);
void serial_Txd();
unsigned short CRC_CHECK(unsigned char *Buf, unsigned char CRC_CNT);
void OutPut_Data(void);
void ImageDeal();
void ADC0_stop(void);
void ADC0_start(void);
void DealImage(void);
void DealImage_2(void);
void getCCD(void);
void LCD_show(void);
void button_init();
void get_left();
void get_right();
void KeyScan();
void BlackManange(); 
void KeyScan_1(void);
void Clear();
#endif