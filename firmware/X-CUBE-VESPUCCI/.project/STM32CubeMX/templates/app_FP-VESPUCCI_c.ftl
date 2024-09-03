[#ftl] 
[#assign moduleName = "vespucci"]
[#if ModuleName??]
[#assign moduleName = ModuleName]
[/#if]
/**
 ******************************************************************************
 * File Name          : app_${moduleName?lower_case}.c
 * Description        : This file provides code for the configuration
 *                      of the ${name} instances.
 ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
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

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "app_${moduleName?lower_case}.h"
#include "main.h"
#include <stdio.h>
#include <ctype.h>
#include "arm_math.h"
#include "network.h"
#include "MEMS_integration.h"
#include "${BoardName}_bus.h"
[#if includes??]
[#list includes as include]
#include "${include}"
[/#list]
[/#if]
#include "App_model.h"
#include "usb_device.h"
#include "usbd_cdc_if.h"

#include "IAi_Application_Mcu.h"
#include "Ai_Application_Mcu_PnPL.h"
#include "IAi_Application_Mcu_vtbl.h"
#include "IAi_Application_Mlc.h"
#include "Ai_Application_Mlc_PnPL.h"
#include "IAi_Application_Mlc_vtbl.h"
#include "IAi_Application_Ispu.h"
#include "Ai_Application_Ispu_PnPL.h"
#include "IAi_Application_Ispu_vtbl.h"
#include "IController.h"
#include "Controller_PnPL.h"
#include "IController_vtbl.h"
#include "PnPLCompManager.h"

/* Definitions ---------------------------------------------------------------*/

/* Private variables ---------------------------------------------------------*/

// Sensor.
uint8_t mems_event_detected;                                        // Set to "1" upon interrupt from FIFO.
float32_t sensor_acc_sensitivity;                                   // Sensitivity.

// Pre-processing.
pre_processing_data_t pre_processing_data;                          // Pre-processing data.

// Processing variables.
char buffer_to_write[PRINTED_BUFFER_SIZE] = {0};                    // Buffer to be written.
int data_received;                                                  // Flag when data are received from USB serial communication.
uint8_t string_received[RECEIVED_BUFFER_SIZE];                      // Buffer received from USB serial communication.
int ispu_inference = 0;                                             // Flag when the application ISPU is started.
int mlc_inference = 0;                                              // Flag when the application MLC is started.
int mcu_inference = 0;                                              // Flag when the application MCU is started.

// Time measurement.
int32_t start_time;
int32_t stop_time;
int32_t time;

/* Functions -----------------------------------------------------------------*/

/*
 * Initialization (sensor, pre-processing pipeline, AI-processing pipeline).
 */
int32_t MX_Vespucci_Init(void) {
	int32_t ret = 0;

	// Sensor initialization timeout (required for sensor boot and to open the terminal).
	HAL_Delay(100);

	// Initializing sensor.
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_Init(SENSOR_0, MOTION_ACCELERO));                                       // Sensor initialization
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_SetOutputDataRate(SENSOR_0, MOTION_ACCELERO, SENSOR_ODR));              // Sensor ODR
	CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_BDR(SENSOR_0, MOTION_ACCELERO, SENSOR_ODR));                // FIFO ODR (Note: all APIs with "MY" are implemented in the MEMS_integration.c file, not in the X-CUBE-MEMS1 pack)
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_SetFullScale(SENSOR_0, MOTION_ACCELERO, SENSOR_FS));                    // Sensor Full Scale

    [#if "${FamilyName}" == "STM32U5" || "${FamilyName}" == "STM32WB"]
	[#if useISPU]
    // Initializing ISPU sensor.
	CHECK_BSP_FUNCTION(CUSTOM_ISPU_MOTION_SENSOR_Init(SENSOR_ISPU, MOTION_ACCELERO));                               // Sensor ISPU initialization
    [/#if]
	[/#if]

	// Getting sensor sensitivity.
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_GetSensitivity(SENSOR_0, MOTION_ACCELERO, &sensor_acc_sensitivity));

	// Initializing sensor FIFO.
	// Sensor FIFO init
	if (INPUT_BUFFER_SIZE == 512){
     	[#if "${FamilyName}" == "STM32L4" || "${FamilyName}" == "STM32U5"]
	    CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT1_FIFO_Full(SENSOR_0, ENABLE));                      // Interrupt set at FIFO_FULL (all FIFO used)
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT1(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT1(SENSOR_0, ENABLE));
		[/#if]
		[#if "${FamilyName}" == "STM32WB"]
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, ENABLE));                      // Interrupt set at FIFO_FULL (all FIFO used)
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
		[/#if]
	} else {
		[#if "${FamilyName}" == "STM32L4" || "${FamilyName}" == "STM32U5"]   
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT1_FIFO_Full(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(SENSOR_0, INPUT_BUFFER_SIZE));          // Set the Watermark level to INPUT_BUFFER_SIZE
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT1(SENSOR_0, ENABLE));                      // Enable the Watermark Interrupt
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT1(SENSOR_0, ENABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(SENSOR_0,  ENABLE));                        // Limit the FIFO depth to the Watermark level             
		[/#if]
		[#if "${FamilyName}" == "STM32WB"]
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT1_FIFO_Full(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(SENSOR_0, INPUT_BUFFER_SIZE));          // Set the Watermark level to INPUT_BUFFER_SIZE
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, ENABLE));                      // Enable the Watermark Interrupt
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(SENSOR_0,  ENABLE));                        // Limit the FIFO depth to the Watermark level     
		[/#if]
	}
	[#if "${FamilyName}" == "STM32L4" || "${FamilyName}" == "STM32U5"]
	CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  ISM330DHCX_BYPASS_MODE));                   // Set the FIFO to Bypass Mode
	[/#if]
	[#if "${FamilyName}" == "STM32WB"]
	CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  LSM6DSO32X_BYPASS_MODE));                   // Set the FIFO to Bypass Mode
	[/#if]

	// Initializing pre-processing.
	pre_processing_init(&pre_processing_data);

	// Initializing AI-processing.
	ai_init();

	// Initializing PnPL.
	pnpl_init();

	// Initializing USB.
	MX_USB_Device_Init();

	// USB initialization timeout (required to stabilize the USB peripheral voltage and to open the terminal)
	HAL_Delay(5000);

	// Printing commands format.
	PRINT(buffer_to_write, "Start/Stop commands\r\n"
			"----------------------------------------------------------------------\r\n"
			"Format: \r\n"
			"Start: {\"ai_application_mcu*start\":\"\"}\r\n"
			"Stop: {\"ai_application_mcu*stop\":\"\"}\r\n"
			"----------------------------------------------------------------------\r\n"
			"Enter a command \r\n");

	// Resetting string.
	RESET_STRING(string_received);

	// Start sending the MCU, MLC or ISPU telemetries.
	if(mcu_inference == 0 && strcmp(DEFAULT_AI,"MCU") == 0){
		// Printing commands format.
		PRINT(buffer_to_write, "Start/Stop commands\r\n"
				"----------------------------------------------------------------------\r\n"
				"Format: \r\n"
				"Start: {\"ai_application_mcu*start\":\"\"}\r\n"
				"Stop: {\"ai_application_mcu*stop\":\"\"}\r\n"
				"----------------------------------------------------------------------\r\n"
				"Enter a command \r\n");
		[#if "${FamilyName}" == "STM32L4" || "${FamilyName}" == "STM32U5"]
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  ISM330DHCX_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
		[/#if]
		[#if "${FamilyName}" == "STM32WB"]
		MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  LSM6DSO32X_STREAM_MODE);                   // Set the FIFO to Continuous/Stream Mode
		[/#if]
		mcu_inference = 1;
	}
	else if(mlc_inference == 0 && strcmp(DEFAULT_AI,"MLC") == 0){
		// Printing commands format.
		PRINT(buffer_to_write, "Start/Stop commands\r\n"
				"------------------------------------------------------------------------------------------\r\n"
				"Format: \r\n"
				"Start: {\"ai_application_mlc*start\":\"\"}\r\n"
				"Stop: {\"ai_application_mlc*stop\":\"\"}\r\n"
				"Load UCF: {\"ai_application_mlc*load_ucf\":{\"arguments\":{\"ucf_content\": ucf_content}}}\r\n"
				"------------------------------------------------------------------------------------------\r\n"
				"Enter a command \r\n");
		// Acquiring the MLC configuration and load the registers.
		acquire_mlc_configuration((const ucf_line_t*)&mlc_conf);
		mlc_inference = 1;
	}
	else if(ispu_inference == 0 && strcmp(DEFAULT_AI,"ISPU") == 0){
		// Printing commands format.
		PRINT(buffer_to_write, "Start/Stop commands\r\n"
				"-------------------------------------------------------------------------------------------\r\n"
				"Format: \r\n"
				"Start: {\"ai_application_ispu*start\":\"\"}\r\n"
				"Stop: {\"ai_application_ispu*stop\":\"\"}\r\n"
				"Load UCF: {\"ai_application_ispu*load_ucf\":{\"arguments\":{\"ucf_content\": ucf_content}}}\r\n"
				"-------------------------------------------------------------------------------------------\r\n"
				"Enter a command \r\n");
		// Acquiring the ISPU configuration and load the registers.
		acquire_ispu_configuration((const ucf_line_ext_t*)&ispu_conf);
		ispu_inference = 1;
	}

	return BSP_ERROR_NONE;
}

/*
 * Processing data (reading commands from USB, sending MLC results or sending telemetry).
 */
int32_t MX_Vespucci_Process(void){

	// When data are received from USB.
	if(data_received){
		data_received = 0;
		pnpl_process((char *)string_received);
		RESET_STRING(string_received);
	}

	// Checking the use case (MCU, MLC or ISPU).
	if(mcu_inference == 1){
		// Sending MCU telemetries.
		send_telemetries_mcu();
	}
	if(mlc_inference == 1){
		// Sending MLC outputs.
		send_telemetries_mlc();
	}
	if(ispu_inference == 1){
		// Sending ISPU telemetries.
		send_telemetries_ispu();
	}

	return BSP_ERROR_NONE;
}

/*
 * Callback to serve the interrupt from the FIFO of the sensor.
 */
[#if "${FamilyName}" == "STM32U5"]
void HAL_GPIO_EXTI_Rising_Callback(uint16_t GPIO_Pin)
{
	mems_event_detected = 1;
}
[/#if]
[#if "${FamilyName}" == "STM32L4" || "${FamilyName}" == "STM32WB"]
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	mems_event_detected = 1;
}
[/#if]

/*
 * PnPL initialization function.
 */
void pnpl_init(){

	/* functions vtbl struct impl */
	static const IAi_Application_Mcu_vtbl ai_mcu_functions =
	{
			ai_application_mcu_start,
			ai_application_mcu_stop
	};

	static const IAi_Application_Mlc_vtbl ai_mlc_functions =
	{
			ai_application_mlc_start,
			ai_application_mlc_stop,
			ai_application_mlc_load_ucf
	};
	
	static const IAi_Application_Ispu_vtbl ai_ispu_functions =
	{
			ai_application_ispu_start,
			ai_application_ispu_stop,
			ai_application_ispu_load_ucf
	};

	static const IController_vtbl controller_functions =
	{
			controller_switch_bank
	};

	static IPnPLComponent_t *pAi_Application_Mcu_PnPLObj = NULL;
	static IPnPLComponent_t *pAi_Application_Mlc_PnPLObj = NULL;
	static IPnPLComponent_t *pAi_Application_Ispu_PnPLObj = NULL;
	static IPnPLComponent_t *pController_PnPLObj = NULL;

	/* IAiApplication and IController object which contains the vtbl */
	static IAi_Application_Mcu_t ai_app_mcu_obj;
	static IAi_Application_Mlc_t ai_app_mlc_obj;
	static IAi_Application_Ispu_t ai_app_ispu_obj;
	static IController_t controller_obj;

	/* Then call this in your code to assign the ai_function defined struct to your ai_app_obj and controller_obj */
	ai_app_mcu_obj.vptr = &ai_mcu_functions;
	ai_app_mlc_obj.vptr = &ai_mlc_functions;
	ai_app_ispu_obj.vptr = &ai_ispu_functions;
	controller_obj.vptr = &controller_functions;

	/* PnPL Components Allocation */
	pAi_Application_Mcu_PnPLObj = Ai_Application_Mcu_PnPLAlloc();
	pAi_Application_Mlc_PnPLObj = Ai_Application_Mlc_PnPLAlloc();
	pAi_Application_Ispu_PnPLObj = Ai_Application_Ispu_PnPLAlloc();
	pController_PnPLObj = Controller_PnPLAlloc();

	/* And pass this object to the PnPL Component init function */
	Ai_Application_Mcu_PnPLInit(pAi_Application_Mcu_PnPLObj, &ai_app_mcu_obj);
	Ai_Application_Mlc_PnPLInit(pAi_Application_Mlc_PnPLObj, &ai_app_mlc_obj);
	Ai_Application_Ispu_PnPLInit(pAi_Application_Ispu_PnPLObj, &ai_app_ispu_obj);
	Controller_PnPLInit(pController_PnPLObj, &controller_obj);

}

/*
 * PnPL parsing function.
 */
void pnpl_process(char* received_msg){

	/* Parse/Serialize PnPL messages */
	PnPLCommand_t PnPLCommand;

	/* received_msg is the input message to parse */
	PnPLParseCommand((char *)received_msg, &PnPLCommand);

	if(PnPLCommand.comm_type == PNPL_CMD_GET)
	{
		char *SerializedJSON;
		uint32_t size;

		PnPLSerializeResponse(&PnPLCommand, &SerializedJSON, &size,0);
		/* SerializedJSON contains the serialized message */
	}
}

/*
 * Reading sensor, pre-processing raw-data, AI-processing, sending telemetries.
 */
int32_t send_telemetries_mcu(){

	// Interrupt from FIFO
	if(mems_event_detected == 1){
		mems_event_detected = 0;

		// Debugging FIFO status.
		//debug_fifo_status();

		// Time measurement.
		//int32_t time_elapsed = 0;
		//int32_t time_elapsed2 = 0;
		//int32_t post_FIFO_read;
		//int32_t pre_FIFO_read;

		// Processing variables.
		int32_t ret = 0;
		tridimensional_data_t acc_sample_array[INPUT_BUFFER_SIZE];                                      // Sensor accelerometer
		float32_t pre_processing_output_array[INPUT_BUFFER_SIZE/2];                                     // Buffer containing the pre-processed output samples, ready for AI processing
		float32_t ai_output_array[2];                                                                   // Buffer containing the results from the AI processing
		int16_t acc_sample[3];                                                                          // Data bytes of sensor FIFO

		// pre_FIFO_read = BSP_GetTick();

		// Getting data from the sensor.
		for(int jj=0;jj<INPUT_BUFFER_SIZE;jj++){

			// Reading samples from the FIFO.
			CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Get_Data_Word(SENSOR_0, MOTION_ACCELERO, acc_sample));

			// Conversion from [mg] to [g].
			acc_sample_array[jj].x = ((float)acc_sample[0])*sensor_acc_sensitivity*0.001;
			acc_sample_array[jj].y = ((float)acc_sample[1])*sensor_acc_sensitivity*0.001;
			acc_sample_array[jj].z = ((float)acc_sample[2])*sensor_acc_sensitivity*0.001;
		}

		// Pre-processing.
		pre_processing_process(acc_sample_array, INPUT_BUFFER_SIZE, pre_processing_output_array, AI_NETWORK_IN_1_SIZE, &pre_processing_data);

		// AI-processing.
		aiProcess(pre_processing_output_array, ai_output_array);

		// Getting neural network prediction.
		int label_id = (int) ai_output_array[0];
		float accuracy = ai_output_array[1];

		// Creating PnPL telemetry message.
		char *telemetry = NULL;
		uint32_t size = 100;
		ai_application_mcu_create_telemetry(label_id, accuracy, &telemetry, &size);

		// Checking null pointer exception.
		if(telemetry)
		{
			// Appending the new line character to the telemetry message.
			char *ch = "\r\n";
			strcat(telemetry, ch);

			// Printing telemetry message.
			PRINT(buffer_to_write, telemetry);

			// Clearing telemetry message.
			json_free_serialized_string(telemetry);
		}

		// Time measurement.
		// post_FIFO_read = BSP_GetTick();
		// time_elapsed = post_FIFO_read - pre_FIFO_read;
	}

	return BSP_ERROR_NONE;
}

/*
 * Sending MLC register outputs.
 */
int32_t send_telemetries_mlc(){
	uint8_t mlc_output_reg[8] = {0};
	read_mlc_output(mlc_output_reg);
	
	// Creating PnPL telemetry message.
	char *telemetry = NULL;
	uint32_t size = 100;
	ai_application_mlc_create_telemetry((int)mlc_output_reg[0], &telemetry, &size);

	// Checking null pointer exception.
	if(telemetry)
	{
		// Appending the new line character to the telemetry message.
		char *ch = "\r\n";
		strcat(telemetry, ch);

		// Printing telemetry message.
		PRINT(buffer_to_write, telemetry);

		// Clearing telemetry message.
		json_free_serialized_string(telemetry);
	}
	return BSP_ERROR_NONE;
}

/*
 * Debugging FIFO status.
 */
int32_t debug_fifo_status(void) {
	int32_t ret = 0;
	[#if "${FamilyName}" == "STM32U5" || "${FamilyName}" == "STM32L4"]
	ISM330DHCX_Fifo_Status_t reg;
	[/#if]
	[#if "${FamilyName}" == "STM32WB"]
	MY_LSM6DSO32X_Fifo_Status_t reg;
	[/#if]
	char buffer[INPUT_BUFFER_SIZE];
	uint16_t samples = 0;

	CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Get_All_Status(SENSOR_0, &reg));

	if (reg.FifoWatermark)
	{
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Get_Num_Samples(SENSOR_0, &samples));
	}

	PRINT(buffer, "WTM, OVR, FULL, CBDR, OVRL : %d, %d, %d, %d, %d SAMPLES: %u\r\n\r\n", reg.FifoWatermark, reg.FifoOverrun, reg.FifoFull, reg.CounterBdr, reg.FifoOverrunLatched, samples);

	return BSP_ERROR_NONE;
}

/*
 * Extracting the UCF content from the .ucf file.
 */
char* ucf_extract(const char *string){

	int stop_cycle = 0;
	char *substring;

	do{
		// Pointer to the initial character to keep.
		substring = strchr(string, 'A');

		// Check if the new string is valid.
		if(substring[1]=='c'){
			if(substring[2]==' '){
				stop_cycle = 1;
				break;
			}
		}
	}while(stop_cycle==0);

	// Copying the pointer to the output buffer.
	return substring;
}

/*
 * Parsing of the UCF file content.
 */
ucf_line_t* parse_ucf(const char* ucf_content, ucf_line_t* mlc_configuration){

	char input[strlen(ucf_content) + 1];
	strcpy(input, ucf_content);

	const char* delimiters = "\n ";
	char *token = strtok(input, delimiters);

	int i = 0;
	while (token != NULL) {
		uint8_t addr, data;

		// Extracting the Ac characters at the beginning of the token.
		char cmd_char[2];
		strcpy(cmd_char, token);
		if(strcmp(cmd_char,"Ac")==0){

			// Extracting the first hexadecimal value after "Ac".
			char* hex_address = strtok(NULL, delimiters);

			// Extracting the second hexadecimal value after "Ac".
			char* hex_data = strtok(NULL, delimiters);

			// Converting into uint8_t type.
			addr = (uint8_t) strtol(hex_address, NULL, 16);
			data = (uint8_t) strtol(hex_data, NULL, 16);

			// Passing the values to the output structure.
			mlc_configuration[i].address = addr;
			mlc_configuration[i].data = data;
		}

		// Going on with the next token.
		token = strtok(NULL, delimiters);
		i++;
	}

	free(token);

	return mlc_configuration;
}

/*
 * Calculating the length of the MLC_configuration structure.
 */
size_t len_ucf_mlc(const ucf_line_t** MLC_configuration){
	// Create a temporary copy of the MLC_configuration array to avoid modifying the original
	const ucf_line_t* config = *MLC_configuration;

	// Iterate over each line in the configuration until NULL is reached
	int len = 0;
	while (config[len].address != 0 || config[len].data != 0) {
		len++;
	}

	return len;
}

/*
 * Cleaning the registers inside the MLC.
 */
void clean_mlc_configuration(const ucf_line_t* MLC_configuration){
	int i;
	size_t len = len_ucf_mlc((const ucf_line_t**)&MLC_configuration);
	for(i=0;i<len;i++)
	{
		CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, 0, 0);
	}
}

/*
 * Programming the registers inside the MLC.
 */
void acquire_mlc_configuration(const ucf_line_t* MLC_configuration){
	int i;
	size_t len = len_ucf_mlc((const ucf_line_t**)&MLC_configuration);
	for(i=0;i<len;i++)
	{
		CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, MLC_configuration[i].address, MLC_configuration[i].data);
	}
}

/*
 * Reading the content of the MLC output registers.
 */
void read_mlc_output(uint8_t* mlc_output_reg){

    [#if "${FamilyName}" == "STM32L4" || "${FamilyName}" == "STM32U5"]
	(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, ISM330DHCX_FUNC_CFG_ACCESS, 0x80);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC0_SRC, &mlc_output_reg[0]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC1_SRC, &mlc_output_reg[1]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC2_SRC, &mlc_output_reg[2]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC3_SRC, &mlc_output_reg[3]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC4_SRC, &mlc_output_reg[4]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC5_SRC, &mlc_output_reg[5]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC6_SRC, &mlc_output_reg[6]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, ISM330DHCX_MLC7_SRC, &mlc_output_reg[7]);
	(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, ISM330DHCX_FUNC_CFG_ACCESS, 0x00);
	[/#if]
	[#if "${FamilyName}" == "STM32WB"]
	(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, LSM6DSO32X_FUNC_CFG_ACCESS, 0x80);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC0_SRC, &mlc_output_reg[0]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC1_SRC, &mlc_output_reg[1]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC2_SRC, &mlc_output_reg[2]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC3_SRC, &mlc_output_reg[3]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC4_SRC, &mlc_output_reg[4]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC5_SRC, &mlc_output_reg[5]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC6_SRC, &mlc_output_reg[6]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, LSM6DSO32X_MLC7_SRC, &mlc_output_reg[7]);
	(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, LSM6DSO32X_FUNC_CFG_ACCESS, 0x00);
	[/#if]
}

/*
 * Checking if the command is valid (number of braces).
 */
bool check_command(char *string) {
    int count = 0; // keep track of number of braces
    while (*string != '\0') {
        if (*string == '{') {
            count++;
        } else if (*string == '}') {
            count--;
        }
        string++;
    }
    return (count == 0);
}

/*
 * Sending ISPU register outputs.
 */
int32_t send_telemetries_ispu(){
	uint8_t ispu_output_reg[4] = {0};
	read_ispu_output(ispu_output_reg);
	
	// Creating PnPL telemetry message.
	char *telemetry = NULL;
	uint32_t size = 100;
	ai_application_ispu_create_telemetry((int)*ispu_output_reg, &telemetry, &size);

	// Checking null pointer exception.
	if(telemetry)
	{
		// Appending the new line character to the telemetry message.
		char *ch = "\r\n";
		strcat(telemetry, ch);

		// Printing telemetry message.
		PRINT(buffer_to_write, telemetry);

		// Clearing telemetry message.
		json_free_serialized_string(telemetry);
	}
	return BSP_ERROR_NONE;
}

/*
 * Programming the registers inside the ISPU (used in the Init function, only at the beginning).
 */
void acquire_ispu_configuration(const ucf_line_ext_t* ISPU_configuration){
	int i;
	size_t len = len_ucf_ispu((const ucf_line_ext_t**)&ISPU_configuration);
	for(i=0;i<len;i++){
		if (ISPU_configuration[i].op == MEMS_UCF_OP_WRITE){
			(void)CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, ISPU_configuration[i].address, ISPU_configuration[i].data);
		}
		else if (ISPU_configuration[i].op == MEMS_UCF_OP_DELAY){
			HAL_Delay(ISPU_configuration[i].data);
		}
	}
}

/*
 * Calculating the length of the ISPU_configuration structure.
 */
size_t len_ucf_ispu(const ucf_line_ext_t** ISPU_configuration){
	// Create a temporary copy of the ISPU_configuration array to avoid modifying the original
	const ucf_line_ext_t* config = *ISPU_configuration;

	// Iterate over each line in the configuration until NULL is reached
	int len = 0;
	while (config[len].address != 0 || config[len].data != 0) {
		len++;
	}

	return len;
}

/*
 * Reading the content of the ISPU output registers.
 */
void read_ispu_output(uint8_t* ispu_output_reg){

	(void)CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, ISM330IS_FUNC_CFG_ACCESS, 0x80);
	(void)CUSTOM_ISPU_MOTION_SENSOR_Read_Register(SENSOR_ISPU, ISM330IS_ISPU_DOUT_06_L , &ispu_output_reg[0]);
	(void)CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, ISM330IS_FUNC_CFG_ACCESS, 0x00);
}

/*
 * Compress the ucf file such that it occupies less space in memory.
 */
char* compress_ucf_ispu(const char *p_ucf) {
    char* modified_lines = malloc(strlen(p_ucf) + 1);
    int line_count = 0;
    int i = 0;

    // Remove "Ac" and spaces, and concatenate the lines without wrapping
    while (p_ucf[i] != '\0') {
        if (p_ucf[i] == 'A' && p_ucf[i + 1] == 'c') {
            i += 2; // Skip "Ac " prefix
        } else if (p_ucf[i] == ' ') {
            i++;    // Skip spaces
        } else if (p_ucf[i] == '\n' || p_ucf[i] == '\r' || p_ucf[i] == '\\' || p_ucf[i] == 'n') {
            i++;    // Skip newlines
        } else if (strncmp(&p_ucf[i], "WAIT5", 5) == 0) {
            modified_lines[line_count++] = 'W';
            modified_lines[line_count++] = '0';
            modified_lines[line_count++] = '0';
            modified_lines[line_count++] = '5';
            i += 5;
        } else {
            modified_lines[line_count++] = p_ucf[i++];
        }
    }
    modified_lines[line_count] = '\0'; // Null-terminate the modified lines

    return modified_lines;
}

/*
 * Load the compressed ucf file content in the ISPU registers.
 */
void load_compressed_ucf(const char *p_ucf, uint32_t size)
{
    uint32_t ucf_lines = size / COMPRESSED_UCF_LINE_WIDTH;
    uint32_t i;
    uint8_t ucf_reg[2] = {0};
    uint8_t ucf_data[2] = {0};
    uint8_t reg;
    uint8_t data;

    for (i = 0; i < ucf_lines; i++) {
        if (*p_ucf == 'W' || *p_ucf == 'w') {
            /* Wait command */
            p_ucf += 3;
            char first_digit[2];
            first_digit[0] = *p_ucf;
            first_digit[1] = '\0';
            uint16_t delay_ms = strtol(first_digit, NULL, 10);

            // Implement delay function for the specified milliseconds
            HAL_Delay(delay_ms);
            p_ucf++;
        } else {
        	/* Write command */
        	ucf_reg[0] = *(p_ucf++);
        	ucf_reg[1] = *(p_ucf++);
        	reg = (uint8_t) strtol((const char*) ucf_reg, NULL, 16);

        	ucf_data[0] = *(p_ucf++);
        	ucf_data[1] = *(p_ucf++);
        	data = (uint8_t) strtol((const char*) ucf_data, NULL, 16);

        	// Implement sensor register write function
        	(void)CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, reg, data);
        }
    }
}

/*
 * Helper function to remove spaces from a string.
 */
void remove_spaces(char* str) {
    int len = strlen(str);
    int i, j;
    for (i = 0, j = 0; i < len; i++) {
        if (!isspace((unsigned char)str[i])) {
            str[j++] = str[i];
        }
    }
    str[j] = '\0';
}

/*
 * Function to understand if a command is valid.
 */
bool is_valid_cmd(char* command) {
	char* temp_command = command;
    // List of possible commands
    // MCU
    char start_mcu[] = "{\"ai_application_mcu*start\":\"\"}";
    char stop_mcu[] = "{\"ai_application_mcu*stop\":\"\"}";
    // MLC
    char start_mlc[] = "{\"ai_application_mlc*start\":\"\"}";
    char stop_mlc[] = "{\"ai_application_mlc*stop\":\"\"}";
    char load_ucf_mlc[] = "{\"ai_application_mlc*load_ucf\":{\"arguments\":{\"ucf_content\":\"";
    // ISPU
    char start_ispu[] = "{\"ai_application_ispu*start\":\"\"}";
    char stop_ispu[] = "{\"ai_application_ispu*stop\":\"\"}";
    char load_ucf_ispu[] = "{\"ai_application_ispu*load_ucf\":{\"arguments\":{\"ucf_content\":\"";

    // Remove spaces from the command
    remove_spaces(command);

    // Remove spaces from the expected commands
    remove_spaces(start_mcu);
    remove_spaces(stop_mcu);
    remove_spaces(start_mlc);
    remove_spaces(stop_mlc);
    remove_spaces(load_ucf_mlc);
    remove_spaces(start_ispu);
    remove_spaces(stop_ispu);
    remove_spaces(load_ucf_ispu);

    // Compare the command with the expected commands
    bool is_valid =
        (strcmp(command, start_mcu) == 0) ||
        (strcmp(command, stop_mcu) == 0) ||
        (strcmp(command, start_mlc) == 0) ||
        (strcmp(command, stop_mlc) == 0) ||
        (strncmp(command, load_ucf_mlc, strlen(load_ucf_mlc)) == 0) ||
        (strcmp(command, start_ispu) == 0) ||
        (strcmp(command, stop_ispu) == 0) ||
        (strncmp(command, load_ucf_ispu, strlen(load_ucf_ispu)) == 0);

    command = temp_command;
    return is_valid;
}

/*
 * Function to understand if a character is hexadecimal.
 */
bool is_hex(char c) {
    return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');
}

/*
 * With this function its possible to understand if a string contains the ucf file.
 */
bool is_ucf_content(const char* input_string) {
    int i = 0;
    while (input_string[i] != '\0') {
        if (input_string[i] == 'A' && input_string[i + 1] == 'c') {
            if ((is_hex(input_string[i + 3]) && is_hex(input_string[i + 4])) ||
                is_hex(input_string[i + 2]) || is_hex(input_string[i + 3])) {
                return true;
            }
        }
        i++;
    }
    return false;
}
