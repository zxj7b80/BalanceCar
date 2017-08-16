#include"delay.h"

void delay(uint32 a) 
{
  uint32 i;
  for(i=0;i<a;i++);
}

void delay_ms(uint32 count_val)
{
  /* Make sure the clock to the LPTMR is enabled */
  SIM_SCGC5|=SIM_SCGC5_LPTIMER_MASK; 
  
  /* Set the compare value to the number of ms to delay */
  LPTMR0_CMR = count_val; 
  
  /* Set up LPTMR to use 1kHz LPO with no prescaler as its clock source */
  LPTMR0_PSR = LPTMR_PSR_PCS(1)|LPTMR_PSR_PBYP_MASK; 
  
  /* Start the timer */
  LPTMR0_CSR |= LPTMR_CSR_TEN_MASK; 

  /* Wait for counter to reach compare value */
  while (!(LPTMR0_CSR & LPTMR_CSR_TCF_MASK));
  
  /* Clear Timer Compare Flag */
  LPTMR0_CSR &= ~LPTMR_CSR_TEN_MASK;
  
  return;
}