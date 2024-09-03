[#ftl] 
/**
******************************************************************************
* @file    ISPU_integration.h
* @author  Andrea Driutti - SW Platforms
* @brief   This file contains an integration with definitions for the BSP Motion Sensors Extended interface for custom boards
******************************************************************************
* @attention
*
* Copyright (c) 2023 STMicroelectronics.
* All rights reserved.
*
******************************************************************************
*/

[#assign useISPU = false]

[#if RTEdatas??]
[#list RTEdatas as define]

[#if define?contains("ISM330IS_ACCGYR_SPI")]
[#assign useISPU = true]
[/#if]

[/#list]
[/#if]

[#if useISPU]
#include "ism330dhcx_reg.h"

int32_t MY_CUSTOM_ISPU_MOTION_SENSOR_Init(uint32_t Instance, uint32_t Functions);
#if (USE_CUSTOM_MOTION_SENSOR_ISM330IS_0 == 1)
int32_t MY_ISM330IS_0_Probe(uint32_t Functions);
int32_t MY_CUSTOM_ISM330IS_0_Init(void);
int32_t MY_CUSTOM_ISM330IS_0_DeInit(void);
int32_t MY_CUSTOM_ISM330IS_0_WriteReg(uint16_t Addr, uint16_t Reg, uint8_t *pdata, uint16_t len);
int32_t MY_CUSTOM_ISM330IS_0_ReadReg(uint16_t Addr, uint16_t Reg, uint8_t *pdata, uint16_t len);
#endif
[/#if]