[#ftl]
/**
******************************************************************************
* @file    MEMS_integration.c
* @author  Andrea Driutti
* @brief   This file contains an integration for the BSP Motion Sensors Extended interface for custom boards
******************************************************************************
* @attention
*
* Copyright (c) 2023 STMicroelectronics.
* All rights reserved.
*
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


/* Includes ------------------------------------------------------------------*/
#include "custom_motion_sensors_ex.h"
#include "MEMS_integration.h"

extern void *MotionCompObj[CUSTOM_MOTION_INSTANCES_NBR];

/**
 * @brief  Set FIFO BDR value
 * @param  Instance the device instance
 * @param  Function Motion sensor function
 * @param  Odr FIFO BDR value
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Set_BDR(uint32_t Instance, uint32_t Function, float Bdr)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_MOTION_SENSOR_IIS3DWB_0 == 1)
	case IIS3DWB_0:
		if(IIS3DWB_FIFO_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if((Function & MOTION_ACCELERO) == MOTION_ACCELERO)
		{
			if(ISM330DHCX_FIFO_ACC_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else if((Function & MOTION_GYRO) == MOTION_GYRO)
		{
			if(ISM330DHCX_FIFO_GYRO_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else
		{
			ret = BSP_ERROR_WRONG_PARAM;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if((Function & MOTION_ACCELERO) == MOTION_ACCELERO)
		{
			if(LSM6DSO32X_FIFO_ACC_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else if((Function & MOTION_GYRO) == MOTION_GYRO)
		{
			if(LSM6DSO32X_FIFO_GYRO_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else
		{
			ret = BSP_ERROR_WRONG_PARAM;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if((Function & MOTION_ACCELERO) == MOTION_ACCELERO)
		{
			if(LSM6DSV16X_FIFO_ACC_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else if((Function & MOTION_GYRO) == MOTION_GYRO)
		{
			if(LSM6DSV16X_FIFO_GYRO_Set_BDR(MotionCompObj[Instance], Bdr) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else
		{
			ret = BSP_ERROR_WRONG_PARAM;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


/**
 * @brief  Set FIFO full interrupt on INT1 pin
 * @param  Instance the device instance
 * @param  Status FIFO full interrupt on INT1 pin
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT1_FIFO_Full(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_MOTION_SENSOR_IIS3DWB_0 == 1)
	case IIS3DWB_0:
		if(IIS3DWB_INT1_Set_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Set_INT1_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Set_INT1_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Set_INT1_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


/**
 * @brief  Set FIFO full interrupt on INT2 pin
 * @param  Instance the device instance
 * @param  Status FIFO full interrupt on INT2 pin
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_MOTION_SENSOR_IIS3DWB_0 == 1)
	case IIS3DWB_0:
		if(IIS3DWB_INT2_Set_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Set_INT2_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif
#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Set_INT2_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Set_INT2_FIFO_Full(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


[#if "${FamilyName}" == "STM32WB"]
/**
  * @brief  Set the LSM6DSO32X FIFO full interrupt on INT2 pin
  * @param  pObj the device pObj
  * @param  Status FIFO full interrupt on INT2 pin status
  * @retval 0 in case of success, an error code otherwise
  */
int32_t LSM6DSO32X_FIFO_Set_INT2_FIFO_Full(LSM6DSO32X_Object_t *pObj, uint8_t Status)
{
  lsm6dso32x_reg_t reg;

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_INT2_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  reg.int2_ctrl.int2_fifo_full = Status;

  if (lsm6dso32x_write_reg(&(pObj->Ctx), LSM6DSO32X_INT2_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  return LSM6DSO32X_OK;
}
[/#if]


/**
 * @brief  Set FIFO watermark level
 * @param  Instance the device instance
 * @param  Watermark FIFO watermark level
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(uint32_t Instance, uint16_t Watermark)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_MOTION_SENSOR_IIS3DWB_0 == 1)
	case IIS3DWB_0:
		if(IIS3DWB_FIFO_Set_Watermark_Level(MotionCompObj[Instance], Watermark) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Set_Watermark_Level(MotionCompObj[Instance], Watermark) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Set_Watermark_Level(MotionCompObj[Instance], Watermark) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Set_Watermark_Level(MotionCompObj[Instance], Watermark) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


/**
 * @brief  Set FIFO stop on watermark
 * @param  Instance the device instance
 * @param  Status FIFO stop on watermark status
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_MOTION_SENSOR_IIS3DWB_0 == 1)
	case IIS3DWB_0:
		if(IIS3DWB_FIFO_Set_Stop_On_Fth(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Set_Stop_On_Fth(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Set_Stop_On_Fth(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Set_Stop_On_Fth(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}



/**
 * @brief  Set FIFO mode
 * @param  Instance the device instance
 * @param  Mode FIFO mode
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(uint32_t Instance, uint8_t Mode)
{
	int32_t ret;

	switch(Instance)
	{

#if (USE_MOTION_SENSOR_IIS3DWB_0 == 1)
	case IIS3DWB_0:
		if(IIS3DWB_FIFO_Set_Mode(MotionCompObj[Instance], (iis3dwb_fifo_mode_t) Mode) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Set_Mode(MotionCompObj[Instance], Mode) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Set_Mode(MotionCompObj[Instance], Mode) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Set_Mode(MotionCompObj[Instance], Mode) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}

[#if useLSM6DSV16X]
/**
  * @brief  Get the LSM6DSV16X FIFO accelero single word (16-bit data)
  * @param  pObj the device pObj
  * @param  Acceleration FIFO single data
  * @retval 0 in case of success, an error code otherwise
  */
int32_t LSM6DSV16X_FIFO_Get_Data_Word(LSM6DSV16X_Object_t *pObj, int16_t *data_raw)
{
  uint8_t data[6];

  if (LSM6DSV16X_FIFO_Get_Data(pObj, data) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  data_raw[0] = ((int16_t)data[1] << 8) | data[0];
  data_raw[1] = ((int16_t)data[3] << 8) | data[2];
  data_raw[2] = ((int16_t)data[5] << 8) | data[4];

  return LSM6DSV16X_OK;
}
[/#if]
[#if useLSM6DSO32X]
/**
  * @brief  Get the LSM6DSO32X FIFO accelero single word (16-bit data)
  * @param  pObj the device pObj
  * @param  Acceleration FIFO single data
  * @retval 0 in case of success, an error code otherwise
  */
int32_t LSM6DSO32X_FIFO_Get_Data_Word(LSM6DSO32X_Object_t *pObj, int16_t *data_raw)
{
  uint8_t data[6];

  if (LSM6DSO32X_FIFO_Get_Data(pObj, data) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  data_raw[0] = ((int16_t)data[1] << 8) | data[0];
  data_raw[1] = ((int16_t)data[3] << 8) | data[2];
  data_raw[2] = ((int16_t)data[5] << 8) | data[4];

  return LSM6DSO32X_OK;
}
[/#if]

/**
 * @brief  Get FIFO single axis data RAW
 * @param  Instance the device instance
 * @param  Function Motion sensor function. Could be:
 *         - MOTION_GYRO or MOTION_ACCELERO
 * @param  Data FIFO single axis data
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Get_Data_Word(uint32_t Instance, uint32_t Function, int16_t *Data)
{
	int32_t ret = 0;

	switch(Instance)
	{
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if((Function & MOTION_ACCELERO) == MOTION_ACCELERO)
		{
			if(ISM330DHCX_FIFO_Get_Data_Word(MotionCompObj[Instance], Data) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else if((Function & MOTION_GYRO) == MOTION_GYRO)
		{
			/*if(ISM330DHCX_FIFO_GYRO_Get_Axes(MotionCompObj[Instance], Data) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}*/
		}
		else
		{
			ret = BSP_ERROR_WRONG_PARAM;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if((Function & MOTION_ACCELERO) == MOTION_ACCELERO)
		{
			if(LSM6DSO32X_FIFO_Get_Data_Word(MotionCompObj[Instance], Data) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else if((Function & MOTION_GYRO) == MOTION_GYRO)
		{
			/*if(LSM6DSO32X_FIFO_GYRO_Get_Axes(MotionCompObj[Instance], Data) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}*/
		}
		else
		{
			ret = BSP_ERROR_WRONG_PARAM;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if((Function & MOTION_ACCELERO) == MOTION_ACCELERO)
		{
			if(LSM6DSV16X_FIFO_Get_Data_Word(MotionCompObj[Instance], Data) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}
		}
		else if((Function & MOTION_GYRO) == MOTION_GYRO)
		{
			/*if(LSM6DSV16X_FIFO_GYRO_Get_Axes(MotionCompObj[Instance], Data) != BSP_ERROR_NONE)
			{
				ret = BSP_ERROR_COMPONENT_FAILURE;
			}
			else
			{
				ret = BSP_ERROR_NONE;
			}*/
		}
		else
		{
			ret = BSP_ERROR_WRONG_PARAM;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}

int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT1(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Overrun_Set_INT1(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Overrun_Set_INT1(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Overrun_Set_INT1(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Overrun_Set_INT2(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Overrun_Set_INT2(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Overrun_Set_INT2(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


[#if useISM330DHCX]
/**
* @brief  Set the ISM330DHCX FIFO overrun interrupt on INT1 pin
* @param  pObj the device pObj
* @param  Status FIFO overrun interrupt on INT1 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t ISM330DHCX_FIFO_Overrun_Set_INT1(ISM330DHCX_Object_t *pObj, uint8_t Status)
{
  ism330dhcx_reg_t reg;

  if (ism330dhcx_read_reg(&(pObj->Ctx), ISM330DHCX_INT1_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  reg.int1_ctrl.int1_fifo_ovr = Status;

  if (ism330dhcx_write_reg(&(pObj->Ctx), ISM330DHCX_INT1_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  return ISM330DHCX_OK;
}


/**
* @brief  Set the ISM330DHCX FIFO overrun interrupt on INT2 pin
* @param  pObj the device pObj
* @param  Status FIFO overrun interrupt on INT2 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t ISM330DHCX_FIFO_Overrun_Set_INT2(ISM330DHCX_Object_t *pObj, uint8_t Status)
{
  ism330dhcx_reg_t reg;

  if (ism330dhcx_read_reg(&(pObj->Ctx), ISM330DHCX_INT2_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  reg.int2_ctrl.int2_fifo_ovr = Status;

  if (ism330dhcx_write_reg(&(pObj->Ctx), ISM330DHCX_INT2_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  return ISM330DHCX_OK;
}
[/#if]


[#if useLSM6DSO32X]
/**
* @brief  Set the LSM6DSO32X FIFO overrun interrupt on INT1 pin
* @param  pObj the device pObj
* @param  Status FIFO overrun interrupt on INT1 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSO32X_FIFO_Overrun_Set_INT1(LSM6DSO32X_Object_t *pObj, uint8_t Status)
{
  lsm6dso32x_reg_t reg;

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_INT1_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  reg.int1_ctrl.int1_fifo_ovr = Status;

  if (lsm6dso32x_write_reg(&(pObj->Ctx), LSM6DSO32X_INT1_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  return LSM6DSO32X_OK;
}


/**
* @brief  Set the LSM6DSO32X FIFO overrun interrupt on INT2 pin
* @param  pObj the device pObj
* @param  Status FIFO overrun interrupt on INT2 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSO32X_FIFO_Overrun_Set_INT2(LSM6DSO32X_Object_t *pObj, uint8_t Status)
{
  lsm6dso32x_reg_t reg;

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_INT2_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  reg.int2_ctrl.int2_fifo_ovr = Status;

  if (lsm6dso32x_write_reg(&(pObj->Ctx), LSM6DSO32X_INT2_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  return LSM6DSO32X_OK;
}
[/#if]

[#if useLSM6DSV16X]
/**
* @brief  Set the LSM6DSV16X FIFO overrun interrupt on INT1 pin
* @param  pObj the device pObj
* @param  Status FIFO overrun interrupt on INT1 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSV16X_FIFO_Overrun_Set_INT1(LSM6DSV16X_Object_t *pObj, uint8_t Status)
{
  lsm6dsv16x_reg_t reg;

  if (lsm6dsv16x_read_reg(&(pObj->Ctx), LSM6DSV16X_INT1_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  reg.int1_ctrl.int1_fifo_ovr = Status;

  if (lsm6dsv16x_write_reg(&(pObj->Ctx), LSM6DSV16X_INT1_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  return LSM6DSV16X_OK;
}

/**
* @brief  Set the LSM6DSV16X FIFO overrun interrupt on INT2 pin
* @param  pObj the device pObj
* @param  Status FIFO overrun interrupt on INT2 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSV16X_FIFO_Overrun_Set_INT2(LSM6DSV16X_Object_t *pObj, uint8_t Status)
{
  lsm6dsv16x_reg_t reg;

  if (lsm6dsv16x_read_reg(&(pObj->Ctx), LSM6DSV16X_INT2_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  reg.int2_ctrl.int2_fifo_ovr = Status;

  if (lsm6dsv16x_write_reg(&(pObj->Ctx), LSM6DSV16X_INT2_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  return LSM6DSV16X_OK;
}
[/#if]

int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT1(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Watermark_Set_INT1(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Watermark_Set_INT1(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Watermark_Set_INT1(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(uint32_t Instance, uint8_t Status)
{
	int32_t ret;

	switch(Instance)
	{
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
	case CUSTOM_ISM330DHCX_0:
		if(ISM330DHCX_FIFO_Watermark_Set_INT2(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
	case CUSTOM_LSM6DSO32X_0:
		if(LSM6DSO32X_FIFO_Watermark_Set_INT2(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
	case CUSTOM_LSM6DSV16X_0:
		if(LSM6DSV16X_FIFO_Watermark_Set_INT2(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
		{
			ret = BSP_ERROR_COMPONENT_FAILURE;
		}
		else
		{
			ret = BSP_ERROR_NONE;
		}
		break;
#endif

	default:
		ret = BSP_ERROR_WRONG_PARAM;
		break;
	}

	return ret;
}


[#if useISM330DHCX]
/**
* @brief  Set the ISM330DHCX FIFO watermark interrupt on INT1 pin
* @param  pObj the device pObj
* @param  Status FIFO watermark interrupt on INT1 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t ISM330DHCX_FIFO_Watermark_Set_INT1(ISM330DHCX_Object_t *pObj, uint8_t Status)
{
  ism330dhcx_reg_t reg;

  if (ism330dhcx_read_reg(&(pObj->Ctx), ISM330DHCX_INT1_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  reg.int1_ctrl.int1_fifo_th = Status;

  if (ism330dhcx_write_reg(&(pObj->Ctx), ISM330DHCX_INT1_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  return ISM330DHCX_OK;
}


/**
* @brief  Set the ISM330DHCX FIFO watermark interrupt on INT2 pin
* @param  pObj the device pObj
* @param  Status FIFO watermark interrupt on INT2 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t ISM330DHCX_FIFO_Watermark_Set_INT2(ISM330DHCX_Object_t *pObj, uint8_t Status)
{
  ism330dhcx_reg_t reg;

  if (ism330dhcx_read_reg(&(pObj->Ctx), ISM330DHCX_INT2_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  reg.int2_ctrl.int2_fifo_th = Status;

  if (ism330dhcx_write_reg(&(pObj->Ctx), ISM330DHCX_INT2_CTRL, &reg.byte, 1) != ISM330DHCX_OK)
  {
    return ISM330DHCX_ERROR;
  }

  return ISM330DHCX_OK;
}
[/#if]


[#if useLSM6DSO32X]
/**
* @brief  Set the LSM6DSO32X FIFO watermark interrupt on INT1 pin
* @param  pObj the device pObj
* @param  Status FIFO watermark interrupt on INT1 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSO32X_FIFO_Watermark_Set_INT1(LSM6DSO32X_Object_t *pObj, uint8_t Status)
{
  lsm6dso32x_reg_t reg;

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_INT1_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  reg.int1_ctrl.int1_fifo_th = Status;

  if (lsm6dso32x_write_reg(&(pObj->Ctx), LSM6DSO32X_INT1_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  return LSM6DSO32X_OK;
}


/**
* @brief  Set the LSM6DSO32X FIFO watermark interrupt on INT2 pin
* @param  pObj the device pObj
* @param  Status FIFO watermark interrupt on INT2 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSO32X_FIFO_Watermark_Set_INT2(LSM6DSO32X_Object_t *pObj, uint8_t Status)
{
  lsm6dso32x_reg_t reg;

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_INT2_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  reg.int2_ctrl.int2_fifo_th = Status;

  if (lsm6dso32x_write_reg(&(pObj->Ctx), LSM6DSO32X_INT2_CTRL, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  return LSM6DSO32X_OK;
}
[/#if]

[#if useLSM6DSV16X]
/**
* @brief  Set the LSM6DSV16X FIFO watermark interrupt on INT1 pin
* @param  pObj the device pObj
* @param  Status FIFO watermark interrupt on INT1 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSV16X_FIFO_Watermark_Set_INT1(LSM6DSV16X_Object_t *pObj, uint8_t Status)
{
  lsm6dsv16x_reg_t reg;

  if (lsm6dsv16x_read_reg(&(pObj->Ctx), LSM6DSV16X_INT1_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  reg.int1_ctrl.int1_fifo_th = Status;

  if (lsm6dsv16x_write_reg(&(pObj->Ctx), LSM6DSV16X_INT1_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  return LSM6DSV16X_OK;
}

/**
* @brief  Set the LSM6DSV16X FIFO watermark interrupt on INT2 pin
* @param  pObj the device pObj
* @param  Status FIFO watermark interrupt on INT2 pin status
* @retval 0 in case of success, an error code otherwise
*/
int32_t LSM6DSV16X_FIFO_Watermark_Set_INT2(LSM6DSV16X_Object_t *pObj, uint8_t Status)
{
  lsm6dsv16x_reg_t reg;

  if (lsm6dsv16x_read_reg(&(pObj->Ctx), LSM6DSV16X_INT2_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  reg.int2_ctrl.int2_fifo_th = Status;

  if (lsm6dsv16x_write_reg(&(pObj->Ctx), LSM6DSV16X_INT2_CTRL, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  return LSM6DSV16X_OK;
}
[/#if]

/**
 * @brief  Get FIFO all status
 * @param  Instance the device instance
 * @param  Status FIFO all status
 * @retval BSP status
 */
[#if useLSM6DSV16X]
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Get_All_Status(uint32_t Instance, MY_LSM6DSV16X_Fifo_Status_t *Status)
[/#if]
[#if useISM330DHCX]
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Get_All_Status(uint32_t Instance, ISM330DHCX_Fifo_Status_t *Status)
[/#if]
[#if useLSM6DSO32X]
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Get_All_Status(uint32_t Instance, MY_LSM6DSO32X_Fifo_Status_t *Status)
[/#if]
{
  int32_t ret;

  switch (Instance)
  {
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
    case CUSTOM_ISM330DHCX_0:
      if (ISM330DHCX_FIFO_Get_All_Status(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
      break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
    case CUSTOM_LSM6DSO32X_0:
      if (LSM6DSO32X_FIFO_Get_All_Status(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
      break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
    case CUSTOM_LSM6DSV16X_0:
      if (LSM6DSV16X_FIFO_Get_All_Status(MotionCompObj[Instance], Status) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
      break;
#endif

    default:
      ret = BSP_ERROR_WRONG_PARAM;
      break;
  }

  return ret;
}

[#if useLSM6DSO32X]
/**
  * @brief  Get the LSM6DSO32X FIFO all status
  * @param  pObj the device pObj
  * @param  Status FIFO register content
  * @retval 0 in case of success, an error code otherwise
  */
int32_t LSM6DSO32X_FIFO_Get_All_Status(LSM6DSO32X_Object_t *pObj, MY_LSM6DSO32X_Fifo_Status_t *Status)
{
  lsm6dso32x_reg_t reg;

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_FIFO_STATUS1, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  if (lsm6dso32x_read_reg(&(pObj->Ctx), LSM6DSO32X_FIFO_STATUS2, &reg.byte, 1) != LSM6DSO32X_OK)
  {
    return LSM6DSO32X_ERROR;
  }

  Status->FifoWatermark = reg.fifo_status2.fifo_wtm_ia;
  Status->FifoFull = reg.fifo_status2.fifo_full_ia;
  Status->FifoOverrun = reg.fifo_status2.fifo_ovr_ia;
  Status->CounterBdr = reg.fifo_status2.counter_bdr_ia;
  Status->FifoOverrunLatched = reg.fifo_status2.over_run_latched;

  return LSM6DSO32X_OK;
}
[/#if]

[#if useLSM6DSV16X]
/**
  * @brief  Get the LSM6DSV16X FIFO all status
  * @param  pObj the device pObj
  * @param  Status FIFO register content
  * @retval 0 in case of success, an error code otherwise
  */
int32_t LSM6DSV16X_FIFO_Get_All_Status(LSM6DSV16X_Object_t *pObj, MY_LSM6DSV16X_Fifo_Status_t *Status)
{
  lsm6dsv16x_reg_t reg;

  if (lsm6dsv16x_read_reg(&(pObj->Ctx), LSM6DSV16X_FIFO_STATUS1, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  if (lsm6dsv16x_read_reg(&(pObj->Ctx), LSM6DSV16X_FIFO_STATUS2, &reg.byte, 1) != LSM6DSV16X_OK)
  {
    return LSM6DSV16X_ERROR;
  }

  Status->FifoWatermark = reg.fifo_status2.fifo_wtm_ia;
  Status->FifoFull = reg.fifo_status2.fifo_full_ia;
  Status->FifoOverrun = reg.fifo_status2.fifo_ovr_ia;
  Status->CounterBdr = reg.fifo_status2.counter_bdr_ia;
  Status->FifoOverrunLatched = reg.fifo_status2.fifo_ovr_latched;

  return LSM6DSV16X_OK;
}
[/#if]

/**
 * @brief  Get number of unread FIFO samples
 * @param  Instance the device instance
 * @param  NumSamples number of unread FIFO samples
 * @retval BSP status
 */
int32_t MY_CUSTOM_MOTION_SENSOR_FIFO_Get_Num_Samples(uint32_t Instance, uint16_t *NumSamples)
{
  int32_t ret;

  switch (Instance)
  {
#if (USE_CUSTOM_MOTION_SENSOR_ISM330DHCX_0 == 1)
    case CUSTOM_ISM330DHCX_0:
      if (ISM330DHCX_FIFO_Get_Num_Samples(MotionCompObj[Instance], NumSamples) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
      break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSO32X_0 == 1)
    case CUSTOM_LSM6DSO32X_0:
      if (LSM6DSO32X_FIFO_Get_Num_Samples(MotionCompObj[Instance], NumSamples) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
      break;
#endif

#if (USE_CUSTOM_MOTION_SENSOR_LSM6DSV16X_0 == 1)
    case CUSTOM_LSM6DSV16X_0:
      if (LSM6DSV16X_FIFO_Get_Num_Samples(MotionCompObj[Instance], NumSamples) != BSP_ERROR_NONE)
      {
        ret = BSP_ERROR_COMPONENT_FAILURE;
      }
      else
      {
        ret = BSP_ERROR_NONE;
      }
      break;
#endif

    default:
      ret = BSP_ERROR_WRONG_PARAM;
      break;
  }

  return ret;
}