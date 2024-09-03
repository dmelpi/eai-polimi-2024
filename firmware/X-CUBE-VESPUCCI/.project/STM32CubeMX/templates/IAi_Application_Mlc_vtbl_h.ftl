[#ftl]
/**
  ******************************************************************************
  * @file    IAi_Application_Mlc_vtbl.h
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
  * dtmi:vespucci:steval_mkboxpro:ai_inertial:other:ai_application_mlc;1
  *
  * Created by: DTDL2PnPL_cGen version 1.0.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

#ifndef INCLUDE_IAI_APPLICATION_MLC_VTBL_H_
#define INCLUDE_IAI_APPLICATION_MLC_VTBL_H_

#ifdef __cplusplus
extern "C" {
#endif

/**
  * Create a type name for IAi_Application_Mlc_vtbl.
  */
typedef struct _IAi_Application_Mlc_vtbl IAi_Application_Mlc_vtbl;

struct _IAi_Application_Mlc_vtbl
{
  uint8_t (*ai_application_mlc_start)(IAi_Application_Mlc_t * _this);
  uint8_t (*ai_application_mlc_stop)(IAi_Application_Mlc_t * _this);
  uint8_t (*ai_application_mlc_load_ucf)(IAi_Application_Mlc_t * _this, const char *filename, uint32_t ucf_content_size, const char *ucf_content);
};

struct _IAi_Application_Mlc_t
{
  /**
    * Pointer to the virtual table for the class.
    */
  const IAi_Application_Mlc_vtbl *vptr;
};

/* Inline functions definition -----------------------------------------------*/
inline uint8_t IAi_Application_Mlc_start(IAi_Application_Mlc_t *_this)
{
  return _this->vptr->ai_application_mlc_start(_this);
}
inline uint8_t IAi_Application_Mlc_stop(IAi_Application_Mlc_t *_this)
{
  return _this->vptr->ai_application_mlc_stop(_this);
}
inline uint8_t IAi_Application_Mlc_load_ucf(IAi_Application_Mlc_t *_this, const char *filename, uint32_t ucf_content_size, const char *ucf_content)
{
  return _this->vptr->ai_application_mlc_load_ucf(_this, filename, ucf_content_size, ucf_content);
}

#ifdef __cplusplus
}
#endif

#endif /* INCLUDE_IAI_APPLICATION_MLC_VTBL_H_ */
