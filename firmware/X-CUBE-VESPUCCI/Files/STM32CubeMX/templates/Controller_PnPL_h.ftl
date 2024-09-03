[#ftl]
/**
  ******************************************************************************
  * @file    Controller_PnPL.h
  * @author  SRA
  * @brief   Controller PnPL Component Manager
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
  * dtmi:vespucci:steval_mkboxpro:ai_inertial:other:controller;1
  *
  * Created by: DTDL2PnPL_cGen version 1.0.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef _PNPL_CONTROLLER_H_
#define _PNPL_CONTROLLER_H_



#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "parson.h"
#include "IPnPLComponent.h"
#include "IPnPLComponent_vtbl.h"
#include "IController.h"
#include "IController_vtbl.h"

/**
  * Create a type name for _Controller_PnPL.
 */
typedef struct _Controller_PnPL Controller_PnPL;

/* Public API declaration ----------------------------------------------------*/

IPnPLComponent_t *Controller_PnPLAlloc(void);

/**
  * Initialize the default parameters.
  *
 */
uint8_t Controller_PnPLInit(IPnPLComponent_t *_this,  IController_t *inf);


/**
  * Get the IPnPLComponent interface for the component.
  * @param _this [IN] specifies a pointer to a PnPL component.
  * @return a pointer to the generic object ::IPnPLComponent if success,
  * or NULL if out of memory error occurs.
 */
IPnPLComponent_t *Controller_PnPLGetComponentIF(Controller_PnPL *_this);

#ifdef __cplusplus
}
#endif

#endif /* _PNPL_CONTROLLER_H_ */
