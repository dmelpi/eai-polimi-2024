[#ftl]
/**
  ******************************************************************************
  * @file    PnPL_Init.c
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

#include "PnPL_Init.h"

[#if useISM330DHCX]
static IPnPLComponent_t *pIsm330dhcx_Acc_PnPLObj = NULL;
[/#if]
[#if useLSM6DSO32X]
static IPnPLComponent_t *pLsm6dso32x_Acc_PnPLObj = NULL;
[/#if]
[#if useLSM6DSV16X]
static IPnPLComponent_t *pLsm6dsv16x_Acc_PnPLObj = NULL;
[/#if]
static IPnPLComponent_t *pAi_Application_Mcu_PnPLObj = NULL;
static IPnPLComponent_t *pAi_Application_Mlc_PnPLObj = NULL;
[#if useISM330IS]
static IPnPLComponent_t *pAi_Application_Ispu_PnPLObj = NULL;
[/#if]
static IPnPLComponent_t *pController_PnPLObj = NULL;
static IPnPLComponent_t *pDeviceinformation_PnPLObj = NULL;
static IPnPLComponent_t *pFirmware_Info_PnPLObj = NULL;

uint8_t PnPL_Components_Alloc()
{
  /* PnPL Components Allocation */
[#if useISM330DHCX]
  pIsm330dhcx_Acc_PnPLObj = Ism330dhcx_Acc_PnPLAlloc();
[/#if]
[#if useLSM6DSO32X]
  pLsm6dso32x_Acc_PnPLObj = Lsm6dso32x_Acc_PnPLAlloc();
[/#if]
[#if useLSM6DSV16X]
  pLsm6dsv16x_Acc_PnPLObj = Lsm6dsv16x_Acc_PnPLAlloc();
[/#if]
  pAi_Application_Mcu_PnPLObj = Ai_Application_Mcu_PnPLAlloc();
  pAi_Application_Mlc_PnPLObj = Ai_Application_Mlc_PnPLAlloc();
[#if useISM330IS]
  pAi_Application_Ispu_PnPLObj = Ai_Application_Ispu_PnPLAlloc();
[/#if]
  pController_PnPLObj = Controller_PnPLAlloc();
  pDeviceinformation_PnPLObj = Deviceinformation_PnPLAlloc();
  pFirmware_Info_PnPLObj = Firmware_Info_PnPLAlloc();
  return 0;
}

[#if useISM330IS]
uint8_t PnPL_Components_Init(IAi_Application_Mcu_t iAi_Application_Mcu, IAi_Application_Mlc_t iAi_Application_Mlc, IAi_Application_Ispu_t iAi_Application_Ispu, IController_t iController)
[/#if]
[#if !useISM330IS]
uint8_t PnPL_Components_Init(IAi_Application_Mcu_t iAi_Application_Mcu, IAi_Application_Mlc_t iAi_Application_Mlc, IController_t iController)
[/#if]
{
  /* Init&Add PnPL Components */
[#if useISM330DHCX]
  Ism330dhcx_Acc_PnPLInit(pIsm330dhcx_Acc_PnPLObj);
[/#if]
[#if useLSM6DSO32X]
  Lsm6dso32x_Acc_PnPLInit(pLsm6dso32x_Acc_PnPLObj);
[/#if]
[#if useLSM6DSV16X]
  Lsm6dsv16x_Acc_PnPLInit(pLsm6dsv16x_Acc_PnPLObj);
[/#if]
  Ai_Application_Mcu_PnPLInit(pAi_Application_Mcu_PnPLObj, &iAi_Application_Mcu);
  Ai_Application_Mlc_PnPLInit(pAi_Application_Mlc_PnPLObj, &iAi_Application_Mlc);
[#if useISM330IS]
  Ai_Application_Ispu_PnPLInit(pAi_Application_Ispu_PnPLObj, &iAi_Application_Ispu);
[/#if]
  Controller_PnPLInit(pController_PnPLObj, &iController);
  Deviceinformation_PnPLInit(pDeviceinformation_PnPLObj);
  Firmware_Info_PnPLInit(pFirmware_Info_PnPLObj);
  return 0;
}