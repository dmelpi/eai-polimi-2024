[#ftl]
/**
  ******************************************************************************
  * @file    IAi_Application_Mcu.h
  * @author  SRA
  * @brief
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
  * This file has been auto generated from the following DTDL Component:
  * dtmi:vespucci:steval_mkboxpro:ai_inertial:other:ai_application_mcu;1
  *
  * Created by: DTDL2PnPL_cGen version 1.0.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

#ifndef INCLUDE_IAI_APPLICATION_MCU_H_
#define INCLUDE_IAI_APPLICATION_MCU_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "stdint.h"

/**
  * Create  type name for IAi_Application_Mcu.
  */
typedef struct _IAi_Application_Mcu_t IAi_Application_Mcu_t;

/* Public API declarations ---------------------------------------------------*/

/* Public interface */
inline uint8_t IAi_Application_Mcu_start(IAi_Application_Mcu_t *_this);
inline uint8_t IAi_Application_Mcu_stop(IAi_Application_Mcu_t *_this);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDE_IAI_APPLICATION_MCU_H_ */
