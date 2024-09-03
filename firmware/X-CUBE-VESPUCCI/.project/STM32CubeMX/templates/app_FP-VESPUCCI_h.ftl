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
#include "custom_ispu_motion_sensors_ex.h"
#include "mlc_conf.h"
#include "ispu_conf.h"

/* Exported defines ----------------------------------------------------------*/
#define     SENSOR_ODR     ISM330DHCX_ACC_ODR
#define     SENSOR_FS      ISM330DHCX_ACC_FS
[#if "${FamilyName}" == "STM32U5" || "${FamilyName}" == "STM32L4"]
#define     SENSOR_0       CUSTOM_ISM330DHCX_0              // Sensor used                   
[/#if] 
[#if "${FamilyName}" == "STM32WB"]
#define     SENSOR_0       CUSTOM_LSM6DSO32X_0              // Sensor used
[/#if]
[#if "${FamilyName}" == "STM32U5" || "${FamilyName}" == "STM32WB"]
#define     SENSOR_ISPU    CUSTOM_ISM330IS_0                // Sensor ISPU used
[/#if]
#define     RECEIVED_BUFFER_SIZE 8192*16
#define     PRINTED_BUFFER_SIZE  1024
#define     COMPRESSED_UCF_LINE_WIDTH  4U
#define     DEFAULT_AI "MLC"

#define CHECK_BSP_FUNCTION(function) \
		{ \
	if ((ret = function) != BSP_ERROR_NONE) { \
		return ret; \
	} \
		}

#define RESET_STRING(string) \
		{ \
	memset(string, 0, strlen((char *)string)); \
		}

#define PRINT(buffer_to_write, message, ...) \
		{ \
	RESET_STRING(buffer_to_write); \
	uint32_t n = snprintf(buffer_to_write, 400, message, ##__VA_ARGS__); \
	CDC_Transmit_FS((uint8_t*) buffer_to_write, n); \
		}

/* Exported functions --------------------------------------------------------*/
int32_t ${fctName}(void);
int32_t ${fctProcessName}(void);
void pnpl_init();
void pnpl_process(char* received_msg);
int32_t send_telemetries_mcu();
int32_t send_telemetries_mlc();
int32_t debug_fifo_status();
ucf_line_t* parse_ucf(const char* ucf_content, ucf_line_t* mlc_configuration);
void clean_mlc_configuration(const ucf_line_t* MLC_configuration);
void acquire_mlc_configuration(const ucf_line_t* mlc_configuration);
size_t len_ucf_mlc(const ucf_line_t** MLC_configuration);
void read_mlc_output(uint8_t* mlc_output_reg);
char* ucf_extract(const char *string);
bool check_command(char *string);
int32_t send_telemetries_ispu();
void acquire_ispu_configuration(const ucf_line_ext_t* ISPU_configuration);
size_t len_ucf_ispu(const ucf_line_ext_t** ISPU_configuration);
void read_ispu_output(uint8_t* ispu_output_reg);
char* compress_ucf_ispu(const char *p_ucf);
void load_compressed_ucf(const char *p_ucf, uint32_t size);
void remove_spaces(char* str);
bool is_valid_cmd(char* command);
bool is_hex(char c);
bool is_ucf_content(const char* input_string);

#ifdef __cplusplus
}
#endif

#endif /* __APP_${moduleName?upper_case?replace("-","_")}_H */

