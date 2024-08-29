
/**
  ******************************************************************************
  * @file    App_Model.c
  * @author  SRA
  * @brief   App Application Model and PnPL Components APIs
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

#include "app_x-cube-vespucci.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "ism330is.h"

/* USER includes -------------------------------------------------------------*/

/* USER private function prototypes ------------------------------------------*/

/* USER defines --------------------------------------------------------------*/

static uint8_t sensors_cnt = 0;

AppModel_t app_model;

static void ToggleFlashBank(void)
{
	FLASH_OBProgramInitTypeDef    OBInit;
	/* Set BFB2 bit to enable boot from Flash Bank2 */
	/* Allow Access to Flash control registers and user Flash */
	HAL_FLASH_Unlock();

	/* Allow Access to option bytes sector */
	HAL_FLASH_OB_Unlock();

	/* Get the Dual boot configuration status */
	HAL_FLASHEx_OBGetConfig(&OBInit);

	/* Enable/Disable dual boot feature */
	OBInit.OptionType = OPTIONBYTE_USER;
	OBInit.USERType   = OB_USER_SWAP_BANK;

	if (((OBInit.USERConfig) & (FLASH_OPTR_SWAP_BANK)) == FLASH_OPTR_SWAP_BANK)
	{
		OBInit.USERConfig &= ~FLASH_OPTR_SWAP_BANK;
	}
	else
	{
		OBInit.USERConfig = FLASH_OPTR_SWAP_BANK;
	}

	//SYS_DEBUGF(SYS_DBG_LEVEL_WARNING, ("HW: Switching Bank\r\n"));
	if(HAL_FLASHEx_OBProgram (&OBInit) != HAL_OK)
	{
		/*
	    Error occurred while setting option bytes configuration.
	    User can add here some code to deal with this error.
	    To know the code error, user can call function 'HAL_FLASH_GetError()'
		 */
		while(1);
	}

	/* Start the Option Bytes programming process */
	if (HAL_FLASH_OB_Launch() != HAL_OK) {
		/*
	    Error occurred while reloading option bytes configuration.
	    User can add here some code to deal with this error.
	    To know the code error, user can call function 'HAL_FLASH_GetError()'
		 */
		while(1);
	}
	HAL_FLASH_OB_Lock();
	HAL_FLASH_Lock();
}

AppModel_t* getAppModel(void)
{
  return &app_model;
}

/* Device Components APIs ----------------------------------------------------*/

/* LSM6DSV16X_ACC PnPL Component ---------------------------------------------*/
static SensorModel_t lsm6dsv16x_acc_model;

uint8_t lsm6dsv16x_acc_comp_init(void)
{
	lsm6dsv16x_acc_model.comp_name = lsm6dsv16x_acc_get_key();

	uint16_t id = sensors_cnt;
	sensors_cnt +=1;
	app_model.s_models[id] = &lsm6dsv16x_acc_model;

	/* USER Component initialization code */
	return 0;
}
char* lsm6dsv16x_acc_get_key(void)
{
	return "lsm6dsv16x_acc";
}

uint8_t lsm6dsv16x_acc_get_odr(float *value)
{
	/* USER Code */
	*value = LSM6DSV16X_ACC_ODR;
	return 0;
}
uint8_t lsm6dsv16x_acc_get_fs(float *value)
{
	/* USER Code */
	*value = LSM6DSV16X_ACC_FS;
	return 0;
}
uint8_t lsm6dsv16x_acc_get_stream_id(int8_t *value)
{
	/* USER Code */
	return 0;
}
uint8_t lsm6dsv16x_acc_get_ep_id(int8_t *value)
{
	/* USER Code */
	return 0;
}

/* AI Application MCU PnPL Component -----------------------------------------*/
uint8_t ai_application_mcu_comp_init(void)
{
	app_model.ai_application_mcu_model.comp_name = ai_application_mcu_get_key();

	/* USER Component initialization code */
	return 0;
}
char* ai_application_mcu_get_key(void)
{
	return "ai_application_mcu";
}

uint8_t ai_application_mcu_get_enable(bool *value)
{
	/* USER Code */
	if(mcu_inference){
		*value = true;
	}
	else{
		*value = false;
	}
	return 0;
}
uint8_t ai_application_mcu_start(IAi_Application_Mcu_t *ifn)
{
	default_ai = MCU;
	sensor_init();
	// Set the FIFO to Continuous/Stream Mode.
	MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	mcu_inference = 1;
	return 0;
}
uint8_t ai_application_mcu_stop(IAi_Application_Mcu_t *ifn)
{
	// Set the FIFO to Bypass Mode.
	MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_BYPASS_MODE);                   // Set the FIFO to Bypass Mode
	mcu_inference = 0;
	return 0;
}
uint8_t ai_application_mcu_create_telemetry(int label_id, float accuracy, char **telemetry, uint32_t *size)
{
	PnPLTelemetry_t telemetries[2];
	strcpy(telemetries[0].telemetry_name, "label_id");
	telemetries[0].telemetry_value = (void*)& label_id;
	telemetries[0].telemetry_type = PNPL_INT;
	telemetries[0].n_sub_telemetries = 0;
	strcpy(telemetries[1].telemetry_name, "accuracy");
	telemetries[1].telemetry_value = (void*)& accuracy;
	telemetries[1].telemetry_type = PNPL_FLOAT;
	telemetries[1].n_sub_telemetries = 0;

	PnPLSerializeTelemetry("ai_application_mcu", telemetries, 2, telemetry, size, 0);
	return 0;
}

/* AI Application MLC PnPL Component -----------------------------------------*/
uint8_t ai_application_mlc_comp_init(void)
{
	app_model.ai_application_mlc_model.comp_name = ai_application_mlc_get_key();

	/* USER Component initialization code */
	return 0;
}
char* ai_application_mlc_get_key(void)
{
	return "ai_application_mlc";
}

uint8_t ai_application_mlc_get_enable(bool *value)
{
	/* USER Code */
	if(mlc_inference){
		*value = true;
	}
	else{
		*value = false;
	}
	return 0;
}
uint8_t ai_application_mlc_get_model_filename(char **value)
{
	/* USER Code */
	*value = mlc_model_filename;
	return 0;
}
uint8_t ai_application_mlc_start(IAi_Application_Mlc_t *ifn)
{
	default_ai = MLC;
	load_mlc_configuration(current_mlc_configuration, current_mlc_configuration_size);
	sensor_init();
	mlc_inference = 1;
	if(mcu_inference){
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	}
	return 0;
}
uint8_t ai_application_mlc_stop(IAi_Application_Mlc_t *ifn)
{
	mlc_inference = 0;
	if(mcu_inference){
		sensor_init();
		// Set the FIFO to Continuous/Stream Mode.
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	}
	return 0;
}
uint8_t ai_application_mlc_load_ucf(IAi_Application_Mlc_t *ifn, const char *filename, int32_t content_size, const char *content)
{
	/* USER Code */
	strcpy(mlc_model_filename, filename);

	default_ai = MLC;

	static ucf_line_t* loaded_mlc_configuration;

	// De-allocating space for the MLC configuration structure.
	free(loaded_mlc_configuration);

	// Allocating space for the MLC configuration structure.
	current_mlc_configuration_size = 0;
	current_mlc_configuration_size = get_ucf_number_of_lines(content_size, content);
	loaded_mlc_configuration = (ucf_line_t*) calloc(current_mlc_configuration_size, sizeof(ucf_line_t));

	// Getting MLC register from UCF file.
	get_mlc_register(content, &mlc_register);

	// Filling MLC configuration structure from UCF file.
	fill_mlc_configuration(content, loaded_mlc_configuration);

	// Update MLC configuration structure.
	current_mlc_configuration = loaded_mlc_configuration;

	// Loading MLC configuration into MLC registers.
	load_mlc_configuration(current_mlc_configuration, current_mlc_configuration_size);

	// Starting MLC inference.
	sensor_init();
	mlc_inference = 1;
	if(mcu_inference){
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	}
	return 0;
}
uint8_t ai_application_mlc_create_telemetry(int label_id, char **telemetry, uint32_t *size)
{
	PnPLTelemetry_t telemetries[1];
	strcpy(telemetries[0].telemetry_name, "label_id");
	telemetries[0].telemetry_value = (void*)& label_id;
	telemetries[0].telemetry_type = PNPL_INT;
	telemetries[0].n_sub_telemetries = 0;

	PnPLSerializeTelemetry("ai_application_mlc", telemetries, 1, telemetry, size, 0);
	return 0;
}

/* AI Application ISPU PnPL Component ----------------------------------------*/
uint8_t ai_application_ispu_comp_init(void)
{
	app_model.ai_application_ispu_model.comp_name = ai_application_ispu_get_key();

	/* USER Component initialization code */
	return 0;
}
char* ai_application_ispu_get_key(void)
{
	return "ai_application_ispu";
}

uint8_t ai_application_ispu_get_enable(bool *value)
{
	/* USER Code */
	if(ispu_inference){
		*value = true;
	}
	else{
		*value = false;
	}
	return 0;
}
uint8_t ai_application_ispu_get_mounted(bool *value)
{
	/* USER Code */
	*value = ispu_get_mounted();
	return 0;
}
uint8_t ai_application_ispu_get_model_filename(char **value)
{
	/* USER Code */
	*value = ispu_model_filename;
	return 0;
}
uint8_t ai_application_ispu_start(IAi_Application_Ispu_t *ifn)
{
	default_ai = ISPU;
	int32_t ret = sensor_init();
	if(ret == BSP_ERROR_NONE){
		load_ispu_configuration(current_ispu_configuration, current_ispu_configuration_size);
		// Starting ISPU inference.
		ispu_inference = 1;
	}
	if(mcu_inference){
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	}
	return 0;
}
uint8_t ai_application_ispu_stop(IAi_Application_Ispu_t *ifn)
{
	ispu_inference = 0;
	if(mcu_inference){
		sensor_init();
		// Set the FIFO to Continuous/Stream Mode.
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	}
	return 0;
}
uint8_t ai_application_ispu_load_ucf(IAi_Application_Ispu_t *ifn, const char *filename, int32_t content_size, const char *content)
{
	/* USER Code */
	strcpy(ispu_model_filename, filename);

	default_ai = ISPU;

	static ucf_line_ext_t* loaded_ispu_configuration;

	// De-allocating space for the ISPU configuration structure.
	free(loaded_ispu_configuration);

	// Allocating space for the ISPU configuration structure.
	current_ispu_configuration_size = 0;
	current_ispu_configuration_size = get_ucf_number_of_lines(content_size, content);
	loaded_ispu_configuration = (ucf_line_ext_t*) calloc(current_ispu_configuration_size, sizeof(ucf_line_ext_t));

	// Filling ISPU configuration structure from UCF file.
	fill_ispu_configuration(content, loaded_ispu_configuration);

	// Update ISPU configuration structure.
	current_ispu_configuration = loaded_ispu_configuration;

	int32_t ret = sensor_init();

	// Loading ISPU configuration into ISPU registers.
	if(ret == BSP_ERROR_NONE){
		load_ispu_configuration(current_ispu_configuration, current_ispu_configuration_size);
		// Starting ISPU inference.
		ispu_inference = 1;
	}
	if(mcu_inference){
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
	}
	return 0;
}
uint8_t ai_application_ispu_create_telemetry(int label_id, char **telemetry, uint32_t *size)
{
	PnPLTelemetry_t telemetries[1];
	strcpy(telemetries[0].telemetry_name, "label_id");
	telemetries[0].telemetry_value = (void*)& label_id;
	telemetries[0].telemetry_type = PNPL_INT;
	telemetries[0].n_sub_telemetries = 0;

	PnPLSerializeTelemetry("ai_application_ispu", telemetries, 1, telemetry, size, 0);
	return 0;
}

/* Controller PnPL Component -------------------------------------------------*/
uint8_t controller_comp_init(void)
{
	app_model.controller_model.comp_name = controller_get_key();

	/* USER Component initialization code */
	return 0;
}
char* controller_get_key(void)
{
	return "controller";
}
uint8_t controller_switch_bank(IController_t *ifn)
{
	ToggleFlashBank();
	return 0;
}
uint8_t controller_set_dfu_mode(IController_t *ifn)
{
  jump_to_bootloader();
  return 0;
}

/* Device Information PnPL Component -----------------------------------------*/
uint8_t DeviceInformation_comp_init(void)
{

	/* USER Component initialization code */
	return 0;
}
char* DeviceInformation_get_key(void)
{
	return "DeviceInformation";
}

uint8_t DeviceInformation_get_manufacturer(char **value)
{
	/* USER Code */
	*value = "STMicroelectronics";
	return 0;
}
uint8_t DeviceInformation_get_model(char **value)
{
	/* USER Code */
	*value = "STEVAL-MKBOXPRO";
	return 0;
}
uint8_t DeviceInformation_get_swVersion(char **value)
{
	/* USER Code */
	*value = "1.0.0";
	return 0;
}
uint8_t DeviceInformation_get_osName(char **value)
{
	/* USER Code */
	*value = "Bare metal";
	return 0;
}
uint8_t DeviceInformation_get_processorArchitecture(char **value)
{
	/* USER Code */
	*value = "ARM Cortex-M33";
	return 0;
}
uint8_t DeviceInformation_get_processorManufacturer(char **value)
{
	/* USER Code */
	*value = "STMicroelectronics";
	return 0;
}
uint8_t DeviceInformation_get_totalStorage(float *value)
{
	/* USER Code */
	*value = 0.0;
	return 0;
}
uint8_t DeviceInformation_get_totalMemory(float *value)
{
	/* USER Code */
	*value = 784.0;
	return 0;
}

/* Firmware Information PnPL Component ---------------------------------------*/
uint8_t firmware_info_comp_init(void)
{
	app_model.firmware_info_model.comp_name = firmware_info_get_key();

	/* USER Component initialization code */
	return 0;
}
char* firmware_info_get_key(void)
{
	return "firmware_info";
}

uint8_t firmware_info_get_alias(char **value)
{
	/* USER Code */
	*value = "STBOX_PRO_001";
	return 0;
}
uint8_t firmware_info_get_fw_name(char **value)
{
	/* USER Code */
	if(default_ai == MCU){
	  *value = "SensorTile.box_PRO_ai_inertial_MCU";
	} else if(default_ai == MLC){
	  *value = "SensorTile.box_PRO_ai_inertial_MLC";
	}
	  else if(default_ai == MLC){
	  *value = "SensorTile.box_PRO_ai_inertial_ISPU";
	}

	return 0;
}
uint8_t firmware_info_get_fw_version(char **value)
{
	/* USER Code */
	*value = "1.0.0";
	return 0;
}
uint8_t firmware_info_get_part_number(char **value)
{
	/* USER Code */
	*value = "ai_inertial";
	return 0;
}
uint8_t firmware_info_get_device_url(char **value)
{
	/* USER Code */
	*value = "www.st.com/sensortileboxpro";
	return 0;
}
uint8_t firmware_info_get_fw_url(char **value)
{
	/* USER Code */
	*value = "";
	return 0;
}
uint8_t firmware_info_get_mac_address(char **value)
{
  /* USER Code */
  *value = "";
  return 0;
}

