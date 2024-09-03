[#ftl]
/**
******************************************************************************
* @file    ISPU_integration.c
* @author  Andrea Driutti
* @brief   This file contains an integration for the BSP Motion Sensors Extended interface for custom boards in X-CUBE-ISPU
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
/* Includes ------------------------------------------------------------------*/
#include "custom_ispu_motion_sensors.h"
#include "ISPU_integration.h"

/* This "redundant" line is here to fulfil MISRA C-2012 rule 8.4 */
extern void *IspuMotionCompObj[CUSTOM_ISPU_MOTION_INSTANCES_NBR];

/* We define a jump table in order to get the correct index from the desired function. */
/* This table should have a size equal to the maximum value of a function plus 1.      */
static uint32_t FunctionIndex[] = {0, 0, 1, 1, 2, 2, 2, 2};
static MOTION_SENSOR_FuncDrv_t *MotionFuncDrv[CUSTOM_ISPU_MOTION_INSTANCES_NBR][CUSTOM_MOTION_FUNCTIONS_NBR];
static MOTION_SENSOR_CommonDrv_t *MotionDrv[CUSTOM_ISPU_MOTION_INSTANCES_NBR];
static CUSTOM_ISPU_MOTION_SENSOR_Ctx_t MotionCtx[CUSTOM_ISPU_MOTION_INSTANCES_NBR];

/* MISRAC2012-Rule-11.5 violations due to compatibility with external MEMS1 package */

/**
  * @brief  Initializes the motion sensors
  * @param  Instance Motion sensor instance
  * @param  Functions Motion sensor functions. Could be :
  *         - MOTION_GYRO
  *         - MOTION_ACCELERO
  *         - MOTION_MAGNETO
  * @retval BSP status
  */
int32_t MY_CUSTOM_ISPU_MOTION_SENSOR_Init(uint32_t Instance, uint32_t Functions)
{
  int32_t ret = BSP_ERROR_NONE;
  uint32_t function = MOTION_GYRO;
  uint32_t i;
  uint32_t component_functions = 0;
  CUSTOM_ISPU_MOTION_SENSOR_Capabilities_t cap;

  switch (Instance)
  {
#if (USE_CUSTOM_MOTION_SENSOR_ISM330IS_0 == 1)
    case CUSTOM_ISM330IS_0:
      if (MY_ISM330IS_0_Probe(Functions) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_NO_INIT;
        break;
      }
      if (MotionDrv[Instance]->GetCapabilities(IspuMotionCompObj[Instance], (void *)&cap) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_UNKNOWN_COMPONENT;
        break;
      }
      if (cap.Acc == 1U)
      {
        component_functions |= MOTION_ACCELERO;
      }
      if (cap.Gyro == 1U)
      {
        component_functions |= MOTION_GYRO;
      }
      if (cap.Magneto == 1U)
      {
        component_functions |= MOTION_MAGNETO;
      }
      break;
#endif /* USE_CUSTOM_MOTION_SENSOR_ISM330IS_0 */
    default:
      ret = BSP_ERROR_WRONG_PARAM;
      break;
  }

  if (ret == BSP_ERROR_NONE)
  {
    for (i = 0; i < CUSTOM_MOTION_FUNCTIONS_NBR; i++)
    {
      if (((Functions & function) == function) && ((component_functions & function) == function))
      {
        if (MotionFuncDrv[Instance][FunctionIndex[function]]->Enable(IspuMotionCompObj[Instance]) != BSP_ERROR_NONE)
        {
          ret = BSP_ERROR_COMPONENT_FAILURE;
          break;
        }
      }
      function = function << 1;
    }
  }

  return ret;
}

#if (USE_CUSTOM_MOTION_SENSOR_ISM330IS_0 == 1)
/**
 * @brief  Register Bus IOs for ISM330IS instance
 * @param  Functions Motion sensor functions. Could be :
 *         - MOTION_GYRO and/or MOTION_ACCELERO
 * @retval BSP status
 */
int32_t MY_ISM330IS_0_Probe(uint32_t Functions)
{
  ISM330IS_IO_t            io_ctx;
  uint8_t                    id;
  static ISM330IS_Object_t ism330is_obj_0;
  ISM330IS_Capabilities_t  cap;
  int32_t                    ret = BSP_ERROR_NONE;

  /* Configure the driver */
  io_ctx.BusType     = ISM330IS_SPI_4WIRES_BUS;
  io_ctx.Address     = 0x0;
  io_ctx.Init        = MY_CUSTOM_ISM330IS_0_Init;
  io_ctx.DeInit      = MY_CUSTOM_ISM330IS_0_DeInit;
  io_ctx.ReadReg     = MY_CUSTOM_ISM330IS_0_ReadReg;
  io_ctx.WriteReg    = MY_CUSTOM_ISM330IS_0_WriteReg;
  io_ctx.GetTick     = BSP_GetTick;

  if (ISM330IS_RegisterBusIO(&ism330is_obj_0, &io_ctx) != ISM330IS_OK)
  {
    ret = BSP_ERROR_UNKNOWN_COMPONENT;
  }
  else if (ISM330IS_ReadID(&ism330is_obj_0, &id) != ISM330IS_OK)
  {
    ret = BSP_ERROR_UNKNOWN_COMPONENT;
  }
  else if (id != ISM330IS_ID)
  {
    ret = BSP_ERROR_UNKNOWN_COMPONENT;
  }
  else
  {
    (void)ISM330IS_GetCapabilities(&ism330is_obj_0, &cap);
    MotionCtx[CUSTOM_ISM330IS_0].Functions = ((uint32_t)cap.Gyro) | ((uint32_t)cap.Acc << 1) | ((uint32_t)cap.Magneto << 2);

    IspuMotionCompObj[CUSTOM_ISM330IS_0] = &ism330is_obj_0;
    MotionDrv[CUSTOM_ISM330IS_0] = (MOTION_SENSOR_CommonDrv_t *)&ISM330IS_COMMON_Driver;

    if ((ret == BSP_ERROR_NONE) && ((Functions & MOTION_GYRO) == MOTION_GYRO) && (cap.Gyro == 1U))
    {
      MotionFuncDrv[CUSTOM_ISM330IS_0][FunctionIndex[MOTION_GYRO]] = (MOTION_SENSOR_FuncDrv_t *)&ISM330IS_GYRO_Driver;

      if (MotionDrv[CUSTOM_ISM330IS_0]->Init(IspuMotionCompObj[CUSTOM_ISM330IS_0]) != ISM330IS_OK)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
    }
    if ((ret == BSP_ERROR_NONE) && ((Functions & MOTION_ACCELERO) == MOTION_ACCELERO) && (cap.Acc == 1U))
    {
      MotionFuncDrv[CUSTOM_ISM330IS_0][FunctionIndex[MOTION_ACCELERO]] =
        (MOTION_SENSOR_FuncDrv_t *)&ISM330IS_ACC_Driver;

      if (MotionDrv[CUSTOM_ISM330IS_0]->Init(IspuMotionCompObj[CUSTOM_ISM330IS_0]) != ISM330IS_OK)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
    }
    if ((ret == BSP_ERROR_NONE) && ((Functions & MOTION_MAGNETO) == MOTION_MAGNETO))
    {
      /* Return an error if the application try to initialize a function not supported by the component */
      ret = BSP_ERROR_COMPONENT_FAILURE;
    }
  }

  return ret;
}

/**
 * @brief  Initialize SPI bus for ISM330IS
 * @retval BSP status
 */
int32_t MY_CUSTOM_ISM330IS_0_Init(void)
{
  int32_t ret = BSP_ERROR_UNKNOWN_FAILURE;

  if(CUSTOM_ISM330IS_0_SPI_Init() == BSP_ERROR_NONE)
  {
    ret = BSP_ERROR_NONE;
  }

  return ret;
}

/**
 * @brief  DeInitialize SPI bus for ISM330IS
 * @retval BSP status
 */
int32_t MY_CUSTOM_ISM330IS_0_DeInit(void)
{
  int32_t ret = BSP_ERROR_UNKNOWN_FAILURE;

  if(CUSTOM_ISM330IS_0_SPI_DeInit() == BSP_ERROR_NONE)
  {
    ret = BSP_ERROR_NONE;
  }

  return ret;
}

/**
 * @brief  Write register by SPI bus for ISM330IS
 * @param  Addr not used, it is only for BSP compatibility
 * @param  Reg the starting register address to be written
 * @param  pdata the pointer to the data to be written
 * @param  len the length of the data to be written
 * @retval BSP status
 */
int32_t MY_CUSTOM_ISM330IS_0_WriteReg(uint16_t Addr, uint16_t Reg, uint8_t *pdata, uint16_t len)
{
  int32_t ret = BSP_ERROR_NONE;
  uint8_t dataReg = (uint8_t)Reg;

  /* CS Enable */
  HAL_GPIO_WritePin(CUSTOM_ISM330IS_0_CS_PORT, CUSTOM_ISM330IS_0_CS_PIN, GPIO_PIN_RESET);

  if (CUSTOM_ISM330IS_0_SPI_Send(&dataReg, 1) != BSP_ERROR_NONE)
  {
    ret = BSP_ERROR_UNKNOWN_FAILURE;
  }

  if (CUSTOM_ISM330IS_0_SPI_Send(pdata, len) != BSP_ERROR_NONE)
  {
    ret = BSP_ERROR_UNKNOWN_FAILURE;
  }

  /* CS Disable */
  HAL_GPIO_WritePin(CUSTOM_ISM330IS_0_CS_PORT, CUSTOM_ISM330IS_0_CS_PIN, GPIO_PIN_SET);

  return ret;
}

/**
 * @brief  Read register by SPI bus for ISM330IS
 * @param  Addr not used, it is only for BSP compatibility
 * @param  Reg the starting register address to be read
 * @param  pdata the pointer to the data to be read
 * @param  len the length of the data to be read
 * @retval BSP status
 */
int32_t MY_CUSTOM_ISM330IS_0_ReadReg(uint16_t Addr, uint16_t Reg, uint8_t *pdata, uint16_t len)
{
  int32_t ret = BSP_ERROR_NONE;
  uint8_t dataReg = (uint8_t)Reg;

  dataReg |= 0x80;

  /* CS Enable */
  HAL_GPIO_WritePin(CUSTOM_ISM330IS_0_CS_PORT, CUSTOM_ISM330IS_0_CS_PIN, GPIO_PIN_RESET);

  if (CUSTOM_ISM330IS_0_SPI_Send(&dataReg, 1) != BSP_ERROR_NONE)
  {
    ret = BSP_ERROR_UNKNOWN_FAILURE;
  }

  if (CUSTOM_ISM330IS_0_SPI_Recv(pdata, len) != BSP_ERROR_NONE)
  {
    ret = BSP_ERROR_UNKNOWN_FAILURE;
  }

  /* CS Disable */
  HAL_GPIO_WritePin(CUSTOM_ISM330IS_0_CS_PORT, CUSTOM_ISM330IS_0_CS_PIN, GPIO_PIN_SET);

  return ret;
}
#endif
[/#if]