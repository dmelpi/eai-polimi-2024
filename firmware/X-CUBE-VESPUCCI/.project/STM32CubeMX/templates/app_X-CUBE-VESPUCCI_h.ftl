[#ftl]
[#assign moduleName = "vespucci"]
[#if ModuleName??]
    [#assign moduleName = ModuleName]
[/#if]
/**
  ******************************************************************************
  * File Name          : app_${moduleName?lower_case}.h
  * Description        : This file provides code for the configuration
  *                      of the ${name} instances.
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __APP_${moduleName?upper_case?replace("-","_")}_H
#define __APP_${moduleName?upper_case?replace("-","_")}_H

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include <stdbool.h>
#include "pre_processing_app.h"
#include "ai_app.h"
#include "params.h"
#include "custom_motion_sensors_ex.h"
[#if useISM330IS]
#include "custom_ispu_motion_sensors_ex.h"
[/#if]
#include "arm_math.h"
#include "network.h"
#include "MEMS_integration.h"
#include "custom_bus.h"
#include "App_model.h"
#include "usb_device.h"
#include "usbd_cdc_if.h"
[#if useISM330IS]
#include "ism330is_ispu.h"
[/#if]
[#if useISM330DHCX]
#include "ism330dhcx_mlc.h"
[/#if]
[#if useLSM6DSO32X]
#include "lsm6dso32x_mlc.h"
[/#if]
[#if useLSM6DSV16X]
#include "lsm6dsv16x_mlc.h"
[/#if]

#include "PnPL_Init.h"
#include "IAi_Application_Mcu.h"
#include "Ai_Application_Mcu_PnPL.h"
#include "IAi_Application_Mcu_vtbl.h"
#include "IAi_Application_Mlc.h"
#include "Ai_Application_Mlc_PnPL.h"
#include "IAi_Application_Mlc_vtbl.h"
[#if useISM330IS]
#include "IAi_Application_Ispu.h"
#include "Ai_Application_Ispu_PnPL.h"
#include "IAi_Application_Ispu_vtbl.h"
[/#if]
[#if "${FamilyName}" != "STM32WB"]
#include "IController.h"
#include "Controller_PnPL.h"
#include "IController_vtbl.h"
[/#if]
#include "PnPLCompManager.h"

/* Exported defines ----------------------------------------------------------*/
[#if useISM330DHCX]
#define     SENSOR_ODR     ISM330DHCX_ACC_ODR
#define     SENSOR_FS      ISM330DHCX_ACC_FS
#define     SENSOR_INTERNAL_FREQ  ISM330DHCX_INTERNAL_FREQ_FINE
#define     SENSOR_0       CUSTOM_ISM330DHCX_0                        // Sensor used
#define     SENSOR_0_FUNC_CFG_ACCESS    ISM330DHCX_FUNC_CFG_ACCESS
#define     SENSOR_0_MLC0_SRC     ISM330DHCX_MLC0_SRC
#define     SENSOR_0_MLC1_SRC     ISM330DHCX_MLC1_SRC
#define     SENSOR_0_MLC2_SRC     ISM330DHCX_MLC2_SRC
#define     SENSOR_0_MLC3_SRC     ISM330DHCX_MLC3_SRC
#define     SENSOR_0_MLC4_SRC     ISM330DHCX_MLC4_SRC
#define     SENSOR_0_MLC5_SRC     ISM330DHCX_MLC5_SRC
#define     SENSOR_0_MLC6_SRC     ISM330DHCX_MLC6_SRC
#define     SENSOR_0_MLC7_SRC     ISM330DHCX_MLC7_SRC
#define     SENSOR_0_BYPASS_MODE  ISM330DHCX_BYPASS_MODE
#define     SENSOR_0_STREAM_MODE  ISM330DHCX_STREAM_MODE
[/#if]
[#if useLSM6DSO32X]
#define     SENSOR_ODR     LSM6DSO32X_ACC_ODR
#define     SENSOR_FS      LSM6DSO32X_ACC_FS
#define     SENSOR_INTERNAL_FREQ  LSM6DSO32X_INTERNAL_FREQ_FINE
#define     SENSOR_0       CUSTOM_LSM6DSO32X_0                        // Sensor used
#define     SENSOR_0_FUNC_CFG_ACCESS    LSM6DSO32X_FUNC_CFG_ACCESS
#define     SENSOR_0_MLC0_SRC     LSM6DSO32X_MLC0_SRC
#define     SENSOR_0_MLC1_SRC     LSM6DSO32X_MLC1_SRC
#define     SENSOR_0_MLC2_SRC     LSM6DSO32X_MLC2_SRC
#define     SENSOR_0_MLC3_SRC     LSM6DSO32X_MLC3_SRC
#define     SENSOR_0_MLC4_SRC     LSM6DSO32X_MLC4_SRC
#define     SENSOR_0_MLC5_SRC     LSM6DSO32X_MLC5_SRC
#define     SENSOR_0_MLC6_SRC     LSM6DSO32X_MLC6_SRC
#define     SENSOR_0_MLC7_SRC     LSM6DSO32X_MLC7_SRC
#define     SENSOR_0_BYPASS_MODE  LSM6DSO32X_BYPASS_MODE
#define     SENSOR_0_STREAM_MODE  LSM6DSO32X_STREAM_MODE
[/#if]
[#if useLSM6DSV16X]
#define     SENSOR_ODR     LSM6DSV16X_ACC_ODR
#define     SENSOR_FS      LSM6DSV16X_ACC_FS
#define     SENSOR_INTERNAL_FREQ  LSM6DSV16X_INTERNAL_FREQ
#define     SENSOR_0       CUSTOM_LSM6DSV16X_0                        // Sensor used
#define     SENSOR_0_FUNC_CFG_ACCESS    LSM6DSV16X_FUNC_CFG_ACCESS
#define     SENSOR_0_MLC1_SRC     LSM6DSV16X_MLC1_SRC
#define     SENSOR_0_MLC2_SRC     LSM6DSV16X_MLC2_SRC
#define     SENSOR_0_MLC3_SRC     LSM6DSV16X_MLC3_SRC
#define     SENSOR_0_MLC4_SRC     LSM6DSV16X_MLC4_SRC
#define     SENSOR_0_BYPASS_MODE  LSM6DSV16X_BYPASS_MODE
#define     SENSOR_0_STREAM_MODE  LSM6DSV16X_STREAM_MODE
[/#if]
[#if useISM330IS]
#define     SENSOR_ISPU_FUNC_CFG_ACCESS   ISM330IS_FUNC_CFG_ACCESS
#define     SENSOR_ISPU_DOUT      ISM330IS_ISPU_DOUT_06_L
#define     SENSOR_ISPU    CUSTOM_ISM330IS_0                          // Sensor ISPU used
[/#if]
[#if "${FamilyName}" == "STM32WB"]
#define     COMMAND_BUFFER_SIZE  (128*1024)                           // 128KB
[/#if]
[#if "${FamilyName}" != "STM32WB"]
#define     COMMAND_BUFFER_SIZE  (256*1024)                           // 256KB
[/#if]
#define     PRINTED_BUFFER_SIZE  (8*1024)

#define CHECK_BSP_FUNCTION(function) \
		{ \
	if ((ret = function) != BSP_ERROR_NONE) { \
		return ret; \
	} \
		}

#define RESET_STRING(string) \
		{ \
	memset(string, 0, strlen(string)); \
		}

#define PRINT(message, ...) \
		{ \
	RESET_STRING(buffer_to_write); \
	uint32_t n = snprintf(buffer_to_write, PRINTED_BUFFER_SIZE, message, ##__VA_ARGS__); \
	CDC_Transmit_FS((uint8_t*) buffer_to_write, n); \
		}

typedef enum {
	MCU,
	MLC,
	ISPU
} ai_type_t;

// List of possible commands.
// MCU
#if 0
"{\"ai_application_mcu*start\":\"\"}"
"{\"ai_application_mcu*stop\":\"\"}"
// MLC
"{\"ai_application_mlc*start\":\"\"}"
"{\"ai_application_mlc*stop\":\"\"}"
"{\"ai_application_mlc*load_ucf\":{\"arguments\":{\"ucf_content_size\": ucf_string_size, \"ucf_content\": ucf_string}}}"
[#if useISM330IS]
// ISPU
"{\"ai_application_ispu*start\":\"\"}"
"{\"ai_application_ispu*stop\":\"\"}"
"{\"ai_application_ispu*load_ucf\":{\"arguments\":{\"ucf_content_size\": ucf_string_size, \"ucf_content\": ucf_string}}}"
[/#if]
[#if "${FamilyName}" != "STM32WB"]
// CONTROLLER
"{\"controller*switch_bank\":\"\"}"
[/#if]
#endif

/* Public variables   --------------------------------------------------------*/
extern char *command_buffer_ptr;                                // Pointer to the beginning of the command buffer.
extern char *command_buffer_write_ptr;                          // Pointer to the current write position in the command buffer.
extern char mlc_model_filename[50];                             // Pointer to the MLC Model Filename
extern char ispu_model_filename[50];                            // Pointer to the ISPU Model Filename
extern bool command_received;                                   // Flag when command is received from USB.
extern char buffer_to_write[PRINTED_BUFFER_SIZE];               // Buffer to be printed (it will contain the telemetries).
extern ai_type_t default_ai;                                    // Selected use-case.
extern int mcu_inference;                                       // Flag when the application MCU is started.
extern int mlc_inference;                                       // Flag when the application MLC is started.
[#if useISM330IS]
extern int ispu_inference;                                      // Flag when the application ISPU is started.
[/#if]
extern uint32_t mlc_register;                                   // MLC Output Register number.
extern ucf_line_t* current_mlc_configuration;                   // MLC configuration in use.
extern uint32_t current_mlc_configuration_size;                 // MLC configuration size.
[#if useISM330IS]
extern ucf_line_ext_t* current_ispu_configuration;              // ISPU configuration in use.
extern uint32_t current_ispu_configuration_size;                // ISPU configuration size.
[/#if]

/* Exported functions --------------------------------------------------------*/
int32_t MX_X_CUBE_VESPUCCI_Init(void);                                                           // Initialization function.
int32_t MX_X_CUBE_VESPUCCI_Process(void);                                                        // Processing function.
int32_t send_telemetries_mcu();                                                                  // Send the telemetries for the mcu use case.
int32_t send_telemetries_mlc();                                                                  // Send the telemetries for the mlc use case.
[#if useISM330IS]
int32_t send_telemetries_ispu();                                                                 // Send the telemetries for the ispu use case.
[/#if]
int32_t debug_fifo_status();                                                                     // Debugging FIFO status.
int32_t sensor_init();                                                                           // Initializing sensor.
void pnpl_init();                                                                                // PnPL initialization function.
void pnpl_process();                                                                             // PnPL processing function.
void read_mlc_output(uint8_t* mlc_output_reg);                                                   // Reading the content of the MLC output registers.
[#if useISM330IS]
void read_ispu_output(uint8_t* ispu_output_reg);                                                 // Reading the content of the ISPU output registers.
[/#if]
void load_mlc_configuration(ucf_line_t* mlc_configuration, uint32_t ucf_number_of_lines);        // Programming the registers inside the MLC.
uint32_t get_ucf_number_of_lines(int32_t ucf_content_size, const char *ucf_content);             // Extracting the number of lines from the .ucf file.
void fill_mlc_configuration(const char* ucf_content, ucf_line_t* mlc_configuration);             // Filling MLC configuration structure from UCF file.
void get_mlc_register(const char* ucf_content, uint32_t *mlc_register);                          // Getting MLC register from UCF file.
[#if useISM330IS]
void load_ispu_configuration(ucf_line_ext_t* ispu_configuration, uint32_t ucf_number_of_lines);  // Programming the registers inside the ISPU.
void fill_ispu_configuration(const char* ucf_content, ucf_line_ext_t* ispu_configuration);       // Filling ISPU configuration structure from UCF file.
[/#if]
void send_identity();                                                                            // Sending Board-ID and Firmware-ID.
void send_status();                                                                              // Sending the Properties Status.
void identify_get_cmd(PnPLCommand_t *command, char **serializedJSON);                            // Identify the type of get command.
[#if useISM330IS]
bool ispu_get_mounted();                                                                         // Understands if ISPU is mounted or not.
[/#if]
float32_t compute_actual_odr();                                                                  // Function to compute actual sensor ODR, without drift.
void jump_to_bootloader();                                                                       // Set the DFU mode.

#ifdef __cplusplus
}
#endif

#endif /* __APP_${moduleName?upper_case?replace("-","_")}_H */

