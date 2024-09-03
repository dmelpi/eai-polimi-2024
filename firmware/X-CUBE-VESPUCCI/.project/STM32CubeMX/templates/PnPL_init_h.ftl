[#ftl]
/**
  ******************************************************************************
  * @file    PnPL_Init.h
  * @author  SRA
  * @brief   PnPL Components initialization functions
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file in
  * the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  *
  ******************************************************************************
  */

/**
  ******************************************************************************
  * This file has been auto generated from the following Device Template Model:
  * dtmi:vespucci:steval_mkboxpro:ai_inertial;1
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

#ifndef PNPL_INIT_H_
#define PNPL_INIT_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "PnPLCompManager.h"
[#if useISM330DHCX]
#include "Ism330dhcx_Acc_PnPL.h"
[/#if]
[#if useLSM6DSO32X]
#include "Lsm6dso32x_Acc_PnPL.h"
[/#if]
[#if useLSM6DSV16X]
#include "Lsm6dsv16x_Acc_PnPL.h"
[/#if]
#include "Ai_Application_Mcu_PnPL.h"
#include "Ai_Application_Mlc_PnPL.h"
[#if useISM330IS]
#include "Ai_Application_Ispu_PnPL.h"
[/#if]
#include "Controller_PnPL.h"
#include "Deviceinformation_PnPL.h"
#include "Firmware_Info_PnPL.h"

#include "IAi_Application_Mcu.h"
#include "IAi_Application_Mcu_vtbl.h"
#include "IAi_Application_Mlc.h"
#include "IAi_Application_Mlc_vtbl.h"
[#if useISM330IS]
#include "IAi_Application_Ispu.h"
#include "IAi_Application_Ispu_vtbl.h"
[/#if]
#include "IController.h"
#include "IController_vtbl.h"


uint8_t PnPL_Components_Alloc();
[#if useISM330IS]
uint8_t PnPL_Components_Init(IAi_Application_Mcu_t iAi_Application_Mcu, IAi_Application_Mlc_t iAi_Application_Mlc, IAi_Application_Ispu_t iAi_Application_Ispu, IController_t iController);
[/#if]
[#if !useISM330IS]
uint8_t PnPL_Components_Init(IAi_Application_Mcu_t iAi_Application_Mcu, IAi_Application_Mlc_t iAi_Application_Mlc, IController_t iController);
[/#if]


#ifdef __cplusplus
}
#endif

#endif /* PNPL_INIT_H_ */