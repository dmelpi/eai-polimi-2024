/**
  ******************************************************************************
  * @file    Firmware_Info_PnPL_vtbl.h
  * @author  SRA
  * @brief   Firmware_Info PnPL Component Manager
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
  * dtmi:vespucci:other:firmware_info;3
  *
  * Created by: DTDL2PnPL_cGen version 1.0.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef _PNPL__H_
#define _PNPL__H_

#ifdef __cplusplus
extern "C" {
#endif

char *Firmware_Info_PnPL_vtblGetKey(IPnPLComponent_t *_this);
uint8_t Firmware_Info_PnPL_vtblGetNCommands(IPnPLComponent_t *_this);
char *Firmware_Info_PnPL_vtblGetCommandKey(IPnPLComponent_t *_this, uint8_t id);
uint8_t Firmware_Info_PnPL_vtblGetStatus(IPnPLComponent_t *_this, char **serializedJSON, uint32_t *size,uint8_t pretty);
uint8_t Firmware_Info_PnPL_vtblSetProperty(IPnPLComponent_t *_this, char *serializedJSON);
uint8_t Firmware_Info_PnPL_vtblExecuteFunction(IPnPLComponent_t *_this, char *serializedJSON);

#ifdef __cplusplus
}
#endif

#endif /* _PNPL__H_ */
