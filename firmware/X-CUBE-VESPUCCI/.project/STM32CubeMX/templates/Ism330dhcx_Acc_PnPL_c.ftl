[#ftl]
/**
  ******************************************************************************
  * @file    Ism330dhcx_Acc_PnPL.c
  * @author  SRA
  * @brief   Ism330dhcx_Acc PnPL Component Manager
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
  * dtmi:vespucci:steval_stwinbx1:ai_inertial:sensors:ism330dhcx_acc;1
  *
  * Created by: DTDL2PnPL_cGen version 1.0.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include <string.h>
#include "App_model.h"
#include "IPnPLComponent.h"
#include "IPnPLComponent_vtbl.h"
#include "PnPLCompManager.h"

#include "Ism330dhcx_Acc_PnPL.h"
#include "Ism330dhcx_Acc_PnPL_vtbl.h"

static const IPnPLComponent_vtbl sIsm330dhcx_Acc_PnPL_CompIF_vtbl =
{
  Ism330dhcx_Acc_PnPL_vtblGetKey,
  Ism330dhcx_Acc_PnPL_vtblGetNCommands,
  Ism330dhcx_Acc_PnPL_vtblGetCommandKey,
  Ism330dhcx_Acc_PnPL_vtblGetStatus,
  Ism330dhcx_Acc_PnPL_vtblSetProperty,
  Ism330dhcx_Acc_PnPL_vtblExecuteFunction
};

/**
  *  Ism330dhcx_Acc_PnPL internal structure.
  */
struct _Ism330dhcx_Acc_PnPL
{
  /**
    * Implements the IPnPLComponent interface.
    */
  IPnPLComponent_t component_if;

};

/* Objects instance ----------------------------------------------------------*/
static Ism330dhcx_Acc_PnPL sIsm330dhcx_Acc_PnPL;

/* Public API definition -----------------------------------------------------*/
IPnPLComponent_t *Ism330dhcx_Acc_PnPLAlloc()
{
  IPnPLComponent_t *pxObj = (IPnPLComponent_t *) &sIsm330dhcx_Acc_PnPL;
  if (pxObj != NULL)
  {
    pxObj->vptr = &sIsm330dhcx_Acc_PnPL_CompIF_vtbl;
  }
  return pxObj;
}

uint8_t Ism330dhcx_Acc_PnPLInit(IPnPLComponent_t *_this)
{
  IPnPLComponent_t *component_if = _this;
  PnPLAddComponent(component_if);
  ism330dhcx_acc_comp_init();
  return 0;
}


/* IPnPLComponent virtual functions definition -------------------------------*/
char *Ism330dhcx_Acc_PnPL_vtblGetKey(IPnPLComponent_t *_this)
{
  return ism330dhcx_acc_get_key();
}

uint8_t Ism330dhcx_Acc_PnPL_vtblGetNCommands(IPnPLComponent_t *_this)
{
  return 0;
}

char *Ism330dhcx_Acc_PnPL_vtblGetCommandKey(IPnPLComponent_t *_this, uint8_t id)
{
  return "";
}

uint8_t Ism330dhcx_Acc_PnPL_vtblGetStatus(IPnPLComponent_t *_this, char **serializedJSON, uint32_t *size, uint8_t pretty)
{
  JSON_Value *tempJSON;
  JSON_Object *JSON_Status;

  tempJSON = json_value_init_object();
  JSON_Status = json_value_get_object(tempJSON);

  float temp_f = 0;
  ism330dhcx_acc_get_odr(&temp_f);
  json_object_dotset_number(JSON_Status, "ism330dhcx_acc.odr", temp_f);
  ism330dhcx_acc_get_fs(&temp_f);
  json_object_dotset_number(JSON_Status, "ism330dhcx_acc.fs", temp_f);
  /* Next fields are not in DTDL model but added looking @ the component schema
  field (this is :sensors). ONLY for Sensors and Algorithms */
  json_object_dotset_number(JSON_Status, "ism330dhcx_acc.c_type", COMP_TYPE_SENSOR);
  int8_t temp_int8 = 0;
  ism330dhcx_acc_get_stream_id(&temp_int8);
  json_object_dotset_number(JSON_Status, "ism330dhcx_acc.stream_id", temp_int8);
  ism330dhcx_acc_get_ep_id(&temp_int8);
  json_object_dotset_number(JSON_Status, "ism330dhcx_acc.ep_id", temp_int8);

  if (pretty == 1)
  {
    *serializedJSON = json_serialize_to_string_pretty(tempJSON);
    *size = json_serialization_size_pretty(tempJSON);
  }
  else
  {
    *serializedJSON = json_serialize_to_string(tempJSON);
    *size = json_serialization_size(tempJSON);
  }

  /* No need to free temp_j as it is part of tempJSON */
  json_value_free(tempJSON);

  return 0;
}

uint8_t Ism330dhcx_Acc_PnPL_vtblSetProperty(IPnPLComponent_t *_this, char *serializedJSON)
{
  return 0;
}

uint8_t Ism330dhcx_Acc_PnPL_vtblExecuteFunction(IPnPLComponent_t *_this, char *serializedJSON)
{
  return 1;
}
