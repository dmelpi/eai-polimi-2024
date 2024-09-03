[#ftl]
/**
  ******************************************************************************
  * @file    PnPLCompManager_Conf.h
  * @author  SRA
  * @brief   PnPL Components Manager configuration template file.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */

/**
  ******************************************************************************
  * This file has been auto generated from the following Device Template Model:
  * dtmi:vespucci:steval_stwinkt1:ai_vibration_analysis_bm_steval_stwinbx1;1
  *
  * Created by: DTDL2PnPL_cGen version 1.0.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

[#assign useISM330IS = false]
[#assign useISM330DHCX = false]
[#assign useLSM6DSO32X = false]
[#assign useLSM6DSV16X = false]

[#if RTEdatas??]
[#list RTEdatas as define]

[#if define?contains("ISM330IS_ACCGYR_SPI")]
[#assign useISM330IS = true]
[/#if]
[#if define?contains("ISM330DHCX_ACCGYR_SPI")]
[#assign useISM330DHCX = true]
[/#if]
[#if define?contains("LSM6DSO32X_ACCGYR_I2C")]
[#assign useLSM6DSO32X = true]
[/#if]
[#if define?contains("LSM6DSV16X_ACCGYRQVAR_SPI")]
[#assign useLSM6DSV16X = true]
[/#if]

[/#list]
[/#if]

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __PNPL_COMP_MANAGER_CONF_H__
#define __PNPL_COMP_MANAGER_CONF_H__

#ifdef __cplusplus
extern "C" {
#endif

[#if "${FamilyName}" == "STM32U5"]
#if useLSM6DSV16X
#include "stm32u5xx_hal.h"
	
#define BOARD_ID   0x0D
#else
#include "stm32u5xx_hal.h"
	
#define BOARD_ID   0x0E
#endif
[/#if]

[#if "${FamilyName}" == "STM32L4"]
#include "stm32l4xx_hal.h"

#define BOARD_ID   0x09
[/#if]

[#if "${FamilyName}" == "STM32WB"]
#include "stm32wbxx_hal.h"

#define BOARD_ID   0x0C
[/#if]

#ifdef __cplusplus
}
#endif

#endif /* __PNPL_COMP_MANAGER_CONF_H__*/
