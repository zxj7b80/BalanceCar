#ifndef  calculation_H
#define  calculation_H  


//#define TRUE        1
#define SI_SetVal()   PORTE_PCR0 = 1
#define SI_ClrVal()   PORTE_PCR0 = 0
#define CLK_SetVal()  PORTE_PCR1 = 1
#define CLK_ClrVal()  PORTE_PCR1 = 0

void StartIntegration(void);   
void ImageCapture(unsigned char * ImageData);
void SendHex(unsigned char hex);
void SamplingDelay(void);
void CCD_init(void);
void CalculateIntegrationTime(void);
uint8 PixelAverage(uint8 len, uint8 *data);
void SendImageData(unsigned char * ImageData);
void virtual_scope_show(void);
void serial_Txd(void);


#endif
