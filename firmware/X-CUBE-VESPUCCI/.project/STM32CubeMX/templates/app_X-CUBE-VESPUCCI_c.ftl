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

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "app_x-cube-vespucci.h"
#include "main.h"
#include <stdio.h>
#include <ctype.h>

/* Definitions ---------------------------------------------------------------*/

/* Private variables ---------------------------------------------------------*/

// Sensor.
uint8_t mems_event_detected;                                        // Set to "1" upon interrupt from FIFO.
[#if "${FamilyName}" != "STM32WB"]
uint8_t mlc_event_detected;                                         // Set to "1" upon interrupt from MLC.
[/#if]
float32_t sensor_acc_sensitivity;                                   // Sensitivity.
float32_t sensor_odr;                                               // Sensor actual ODR, considering the drift.

// Pre-processing.
pre_processing_data_t pre_processing_data;                          // Pre-processing data.

// Processing variables.
char command_buffer_static[COMMAND_BUFFER_SIZE];                    // Buffer containing the command received from USB.
char *command_buffer_ptr;                                           // Pointer to the beginning of the command buffer.
char *command_buffer_write_ptr;                                     // Pointer to the current write position in the command buffer.
char mlc_model_filename[50];                                        // Pointer to the MLC Model Filename
char ispu_model_filename[50];                                       // Pointer to the ISPU Model Filename
uint32_t command_buffer_size;                                       // Command buffer size.
bool command_received;                                              // Flag when command is received from USB.
char buffer_to_write[PRINTED_BUFFER_SIZE];                          // Buffer to be printed (it will contain the telemetries).
ai_type_t default_ai;                                               // Selected use-case.
int mcu_inference;                                                  // Flag when the application MCU is started.
int mlc_inference;                                                  // Flag when the application MLC is started.
[#if useISM330IS]
int ispu_inference;                                                 // Flag when the application ISPU is started.
[/#if]
int get_identity;                                                   // Flag when board_id and fw_id are requested.
uint32_t mlc_register;                                              // MLC Output Register number.
char identity[1024];                                                // String containing the board-id and firmware-id.
char status[1024];                                                  // String containing the status.
int get_status;                                                     // Flag when properties are requested.
[#if useISM330IS]
int ispu_mounted;                                                   // Flag when ISPU is mounted.
[/#if]

// Time measurement.
int32_t start_time;
int32_t stop_time;
int32_t time;

// Timer settings.
[#if "${FamilyName}" != "STM32WB"]
extern TIM_HandleTypeDef htim1;
[/#if]
[#if "${FamilyName}" == "STM32WB"]
extern TIM_HandleTypeDef htim2;
[/#if]
int tim_interrupt = 0;

// MLC configuration.
ucf_line_t* current_mlc_configuration = &((ucf_line_t*) (mlc_configuration))[0];                      // MLC configuration in use.
uint32_t current_mlc_configuration_size = sizeof(mlc_configuration)/sizeof(ucf_line_t);               // MLC configuration size.

[#if useISM330IS]
// ISPU configuration.
ucf_line_ext_t* current_ispu_configuration = &((ucf_line_ext_t*) (ispu_configuration))[0];            // ISPU configuration in use.
uint32_t current_ispu_configuration_size = sizeof(ispu_configuration)/sizeof(ucf_line_ext_t);         // ISPU configuration size.
[/#if]

/* Functions -----------------------------------------------------------------*/
[#if "${FamilyName}" == "STM32U5"]
static void SystemPower_Config(void);
[/#if]

/*
 * Initialization (sensor, pre-processing pipeline, AI-processing pipeline).
 */
int32_t MX_X_CUBE_VESPUCCI_Init(void) {
	int32_t ret = 0;
	
	[#if "${FamilyName}" == "STM32U5"]
	// Configure the System Power.
	SystemPower_Config();
	[/#if]
	
	// Inizializzazione del timer hardware.
	[#if "${FamilyName}" != "STM32WB"]
    HAL_TIM_Base_Start_IT(&htim1);
    [/#if]
    [#if "${FamilyName}" == "STM32WB"]
    HAL_TIM_Base_Start_IT(&htim2);
    [/#if]

	// Initializing USB.
	MX_USB_Device_Init();

	// USB initialization timeout (required to stabilize the USB peripheral voltage and to open the terminal).
	HAL_Delay(500);
	
	// Use case default selection (MCU, MLC, ISPU).
	default_ai = MCU;

	// Setting Firmware ID 
	PnPLSetFWID(default_ai == MCU ? 0x01 : (default_ai == MLC ? 0X02 : 0X03));

	// Initializing sensor.
	[#if useISM330IS]
	ispu_mounted = 0;
	[/#if]
	ret = sensor_init();
	sensor_odr = compute_actual_odr();

	// Initializing pre-processing.
	pre_processing_init_mcu(&pre_processing_data, sensor_odr);

	// Initializing AI-processing.
	ai_init();

	// Initializing PnPL.
	pnpl_init();

	// Resetting and initializing buffers.
	memset((char *) command_buffer_static, 0, COMMAND_BUFFER_SIZE);
	memset((char *) buffer_to_write, 0, PRINTED_BUFFER_SIZE);
	command_buffer_ptr = &command_buffer_static[0];
	command_buffer_write_ptr = &command_buffer_static[0];
	command_buffer_size = 0;
	command_received = false;
	[#if useLSM6DSV16X]
	mlc_register = 1;
	[/#if]
	[#if useLSM6DSO32X || useISM330DHCX]
	mlc_register = 0;
	[/#if]
	get_identity = 0;
	memset((char *) identity, 0, 1024);
	get_status = 0;

	// Printing commands format.
	PRINT("COMMANDS\r\n"
			"MCU: \r\n"
			"Start: {\"ai_application_mcu*start\":\"\"}\r\n"
			"Stop: {\"ai_application_mcu*stop\":\"\"}\r\n"
			"MLC: \r\n"
			"Start: {\"ai_application_mlc*start\":\"\"}\r\n"
			"Stop: {\"ai_application_mlc*stop\":\"\"}\r\n"
			"{\"ai_application_mlc*load_ucf\":{\"arguments\":{\"ucf_content_size\":<ucf_file_size_in_bytes>,\"ucf_content\":\"<ucf_file_content>\"}}}\r\n"
			[#if useISM330IS]
			"ISPU: \r\n"
			"Start: {\"ai_application_ispu*start\":\"\"}\r\n"
			"Stop: {\"ai_application_ispu*stop\":\"\"}\r\n"
			"{\"ai_application_ispu*load_ucf\":{\"arguments\":{\"ucf_content_size\":<ucf_file_size_in_bytes>,\"ucf_content\":\"<ucf_file_content>\"}}}\r\n"
            [/#if]
			"SET DFU MODE: \r\n"
			"{\"controller*set_dfu_mode\":\"\"}\r\n"
			[#if "${FamilyName}" != "STM32WB"]
			"SWAP BANK: \r\n"
			"{\"controller*switch_bank\":\"\"}\r\n"
			[/#if]
			"Terminate each command with CR+LF characters, you can set them within the client connected to the board.\r\n\r\n");

	// Copy the names of the original .ucf files
	[#if useISM330DHCX]   
	strcpy(mlc_model_filename, "vibration_monitoring_mlc.ucf");
	[/#if]
	[#if useLSM6DSO32X]   
	strcpy(mlc_model_filename, "vibration_monitoring_mlc.ucf");
	[/#if]
	[#if useLSM6DSV16X]   
	strcpy(mlc_model_filename, "asset_tracking_mlc.ucf");
	[/#if]	
	[#if useISM330IS]
	strcpy(ispu_model_filename, "pedometer_ispu.ucf");
	[/#if]
	
	// Load the default ucf files.
	if (default_ai == MLC) {
		// Acquiring the MLC configuration and load the registers.
		load_mlc_configuration((ucf_line_t*) &mlc_configuration, current_mlc_configuration_size);
	}

    [#if useISM330IS]   
	if (default_ai == ISPU && ret == BSP_ERROR_NONE) {
		// Acquiring the ISPU configuration and load the registers.
		load_ispu_configuration((ucf_line_ext_t*)&ispu_configuration, current_ispu_configuration_size);
	}
	[/#if]

	// Start sending the telemetries.
	if (mcu_inference == 0 && default_ai == MCU) {
		// Set the FIFO to Continuous/Stream Mode.
		[#if useISM330DHCX]   
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  ISM330DHCX_STREAM_MODE));
		[/#if]
		[#if useLSM6DSO32X]   
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  LSM6DSO32X_STREAM_MODE));
		[/#if]
		[#if useLSM6DSV16X]   
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  LSM6DSV16X_STREAM_MODE));
		[/#if]	
		// Starting MCU inference.
		mcu_inference = 1;
	} else if (mlc_inference == 0 && default_ai == MLC) {
		// Starting MLC inference.
		mlc_inference = 1;
	} [#if useISM330IS]else if (ispu_inference == 0 && default_ai == ISPU && ret == BSP_ERROR_NONE) {
		// Starting ISPU inference.
		ispu_inference = 1;
	}
	[/#if]
	
	return BSP_ERROR_NONE;
}

/*
 * Processing data (reading commands from USB and sending telemetries to USB).
 */
int32_t MX_X_CUBE_VESPUCCI_Process(void) {

	// Executing command.
	if (command_received) {                                                     // Check if command is received.
		command_received = false;
		pnpl_process(command_buffer_ptr);                                       // Serve the command received.
		// Resetting command buffer.                                            
		command_buffer_size = command_buffer_write_ptr - command_buffer_ptr;    // Size of the last command received.
		memset((char *) command_buffer_ptr, 0, command_buffer_size);            // Resetting the command buffer.
		command_buffer_write_ptr = command_buffer_ptr;                          // Move the write pointer to point to the initial position of the command buffer.
		command_buffer_size = 0;
	}

	// Sending MCU telemetries.
	if (mcu_inference == 1) {
		send_telemetries_mcu();
	}

	// Sending MLC telemetries.
	if (mlc_inference == 1) {
		send_telemetries_mlc();
	}

    [#if useISM330IS]
	// Sending ISPU telemetries.
	if (ispu_inference == 1) {
		send_telemetries_ispu();
	}
	[/#if]

	if (get_identity == 1){
		send_identity();
	}

	if (get_status == 1){
		send_status();
	}
	
	if(tim_interrupt){
		tim_interrupt = 0;
	}

	return BSP_ERROR_NONE;
}

[#if "${FamilyName}" == "STM32U5"]
/**
 * @brief Power Configuration
 * @retval None
 */
static void SystemPower_Config(void)
{

	HAL_PWREx_EnableVddIO2();
	/*
	 * Disable the internal Pull-Up in Dead Battery pins of UCPD peripheral
	 */
	HAL_PWREx_DisableUCPDDeadBattery();
	/* USER CODE BEGIN PWR */
	/* USER CODE END PWR */
}
[/#if]

/*
 * Callback to serve the interrupt from the FIFO of the sensor.
 */
[#if "${FamilyName}" != "STM32L4" && useLSM6DSV16X]
void HAL_GPIO_EXTI_Rising_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin == GPIO_PIN_11){
		mems_event_detected = 1;
	} else if(GPIO_Pin == GPIO_PIN_4){
		mlc_event_detected = 1;
	}
}
[/#if]
[#if "${FamilyName}" != "STM32L4" && useISM330DHCX]
void HAL_GPIO_EXTI_Rising_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin == GPIO_PIN_4){
		mems_event_detected = 1;
	} else if(GPIO_Pin == GPIO_PIN_8){
		mlc_event_detected = 1;
	} 
}
[/#if]
[#if "${FamilyName}" == "STM32L4"]
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin == GPIO_PIN_8){
		mems_event_detected = 1;
	} else if(GPIO_Pin == GPIO_PIN_4){
		mlc_event_detected = 1;
	} 
}
[/#if]
[#if "${FamilyName}" == "STM32WB"]
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin == GPIO_PIN_12){
		mems_event_detected = 1;
	} 
}
[/#if]

/*
 * PnPL initialization function.
 */
void pnpl_init(){

	/* IAiApplication and IController object which contains the vtbl */
	static IAi_Application_Mcu_t ai_app_mcu_obj;
	static IAi_Application_Mlc_t ai_app_mlc_obj;
	[#if useISM330IS]
	static IAi_Application_Ispu_t ai_app_ispu_obj;
	[/#if]
	static IController_t controller_obj;

	PnPL_Components_Alloc();
	[#if !useISM330IS]
	PnPL_Components_Init(ai_app_mcu_obj, ai_app_mlc_obj, controller_obj);
	[/#if]
	[#if useISM330IS]
	PnPL_Components_Init(ai_app_mcu_obj, ai_app_mlc_obj, ai_app_ispu_obj, controller_obj);
	[/#if]
}


/*
 * PnPL parsing function.
 */
void pnpl_process(char *command) {

	/* Parse/Serialize PnPL messages */
	PnPLCommand_t PnPLCommand;
	char *SerializedJSON;
	uint32_t size;

	// Parsing load/start/stop commands.
	PnPLParseCommand(command, &PnPLCommand);

    if(PnPLCommand.comm_type == PNPL_CMD_GET){
		PnPLSerializeResponse(&PnPLCommand, &SerializedJSON, &size,0);
		identify_get_cmd(&PnPLCommand,&SerializedJSON);
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
		pre_processing_process_mcu(acc_sample_array, INPUT_BUFFER_SIZE, pre_processing_output_array, AI_NETWORK_IN_1_SIZE, &pre_processing_data);

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
		if(telemetry){
			// Appending the new line character to the telemetry message.
			char *ch = "\r\n";
			strcat(telemetry, ch);

			// Printing telemetry message.
			PRINT(telemetry);

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
int32_t send_telemetries_mlc() {
	uint8_t mlc_output_reg[8] = {0};

	// Reading MLC output.
	read_mlc_output(mlc_output_reg);

    [#if "${FamilyName}" != "STM32WB"]
	if(mlc_event_detected || tim_interrupt){

        mlc_event_detected = 0;
    [/#if]
	[#if "${FamilyName}" == "STM32WB"]
	if(mems_event_detected || tim_interrupt){

        mems_event_detected = 0;
    [/#if]
		// Creating PnPL telemetry message.
		char *telemetry = NULL;
		uint32_t size = 128;
		ai_application_mlc_create_telemetry((int)mlc_output_reg[mlc_register], &telemetry, &size);

		// Checking null pointer exception.
		if(telemetry)
		{
			// Appending the new line character to the telemetry message.
			char *ch = "\r\n";
			strcat(telemetry, ch);

			// Printing telemetry message if MLC output value is changed.
			PRINT(telemetry);

			// Clearing telemetry message.
			json_free_serialized_string(telemetry);
		}
	}

	return BSP_ERROR_NONE;
}

/*
 * Debugging FIFO status.
 */
int32_t debug_fifo_status(void) {
	int32_t ret = 0;
	[#if useLSM6DSV16X]
	MY_LSM6DSV16X_Fifo_Status_t reg;
	[/#if]
	[#if useISM330DHCX]
	ISM330DHCX_Fifo_Status_t reg;
	[/#if]
	[#if useLSM6DSO32X]
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
 * Programming the registers inside the MLC.
 */
void load_mlc_configuration(ucf_line_t* mlc_configuration, uint32_t ucf_number_of_lines) {
	// Iterating over each line in the configuration until NULL is reached.
	for (uint32_t i = 0; i < ucf_number_of_lines; i++) {
		CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, mlc_configuration[i].address, mlc_configuration[i].data);
	}
}


/*
 * Reading the content of the MLC output registers.
 */
void read_mlc_output(uint8_t* mlc_output_reg){

[#if useLSM6DSV16X]
	(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, SENSOR_0_FUNC_CFG_ACCESS, 0x80);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC1_SRC, &mlc_output_reg[1]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC2_SRC, &mlc_output_reg[2]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC3_SRC, &mlc_output_reg[3]);
	(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC4_SRC, &mlc_output_reg[4]);
	(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, SENSOR_0_FUNC_CFG_ACCESS, 0x00);
[/#if]
[#if useISM330DHCX || useLSM6DSO32X]
(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, SENSOR_0_FUNC_CFG_ACCESS, 0x80);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC0_SRC, &mlc_output_reg[0]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC1_SRC, &mlc_output_reg[1]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC2_SRC, &mlc_output_reg[2]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC3_SRC, &mlc_output_reg[3]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC4_SRC, &mlc_output_reg[4]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC5_SRC, &mlc_output_reg[5]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC6_SRC, &mlc_output_reg[6]);
(void)CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_0_MLC7_SRC, &mlc_output_reg[7]);
(void)CUSTOM_MOTION_SENSOR_Write_Register(SENSOR_0, SENSOR_0_FUNC_CFG_ACCESS, 0x00);
[/#if]
}

[#if useISM330IS]
/*
 * Sending ISPU register outputs.
 */
int32_t send_telemetries_ispu() {
	uint8_t ispu_output_reg[4] = {0};
	static uint8_t old_ispu_value;

	// Reading ISPU output.
	read_ispu_output(ispu_output_reg);

	if((*ispu_output_reg != old_ispu_value) || tim_interrupt){

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
			PRINT(telemetry);

			// Clearing telemetry message.
			json_free_serialized_string(telemetry);
		}
	}
	// Updating old MLC value.
	old_ispu_value = *ispu_output_reg;

	return BSP_ERROR_NONE;
}

/*
 * Programming the registers inside the ISPU (used in the Init function, only at the beginning).
 */
void load_ispu_configuration(ucf_line_ext_t* ispu_configuration, uint32_t ucf_number_of_lines) {
	// Iterating over each line in the configuration until NULL is reached.
	for (uint32_t i = 0; i < ucf_number_of_lines; i++) {
		if (ispu_configuration[i].op == MEMS_UCF_OP_WRITE) {
			CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, ispu_configuration[i].address, ispu_configuration[i].data);
		} else if (ispu_configuration[i].op == MEMS_UCF_OP_DELAY) {
			HAL_Delay(ispu_configuration[i].data);
		}
	}
}


/*
 * Reading the content of the ISPU output registers.
 */
void read_ispu_output(uint8_t* ispu_output_reg) {
	(void)CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, SENSOR_ISPU_FUNC_CFG_ACCESS, 0x80);
	(void)CUSTOM_ISPU_MOTION_SENSOR_Read_Register(SENSOR_ISPU, SENSOR_ISPU_DOUT , &ispu_output_reg[0]);
	(void)CUSTOM_ISPU_MOTION_SENSOR_Write_Register(SENSOR_ISPU, SENSOR_ISPU_FUNC_CFG_ACCESS, 0x00);
}
[/#if]

/*
 * Initialization (sensor).
 */
int32_t sensor_init() {
	int32_t ret = 0;

	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_Init(SENSOR_0, MOTION_ACCELERO));                                       // Sensor initialization
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_SetOutputDataRate(SENSOR_0, MOTION_ACCELERO, SENSOR_ODR));              // Sensor ODR
	CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_BDR(SENSOR_0, MOTION_ACCELERO, SENSOR_ODR));                // FIFO ODR (Note: all APIs with "MY" are implemented in the MEMS_integration.c file, not in the X-CUBE-MEMS1 pack)
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_SetFullScale(SENSOR_0, MOTION_ACCELERO, SENSOR_FS));                    // Sensor Full Scale

    [#if useISM330IS]
	if(default_ai==ISPU){
		// Initializing ISPU sensor.
		CHECK_BSP_FUNCTION(CUSTOM_ISPU_MOTION_SENSOR_Init(SENSOR_ISPU, MOTION_ACCELERO));                               // Sensor ISPU initialization
	    if(ret == BSP_ERROR_UNKNOWN_COMPONENT){
	    	ispu_mounted = 0;
	    }
	    else if(ret ==  BSP_ERROR_NONE){
	    	ispu_mounted = 1;
	    }
	}
    [/#if]
	
	// Getting sensor sensitivity.
	CHECK_BSP_FUNCTION(CUSTOM_MOTION_SENSOR_GetSensitivity(SENSOR_0, MOTION_ACCELERO, &sensor_acc_sensitivity));

	// Initializing sensor FIFO.
	// Sensor FIFO init.
	[#if "${FamilyName}" == "STM32WB"]
	if (INPUT_BUFFER_SIZE == 512){
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, ENABLE));                      // Interrupt set at FIFO_FULL (all FIFO used)
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
	} else {
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(SENSOR_0, INPUT_BUFFER_SIZE));          // Set the Watermark level to INPUT_BUFFER_SIZE
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, ENABLE));                      // Enable the Watermark Interrupt
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(SENSOR_0,  ENABLE));                        // Limit the FIFO depth to the Watermark level
	}
	[/#if]
	[#if "${FamilyName}" == "STM32L4"]
	if (INPUT_BUFFER_SIZE == 512){
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT1_FIFO_Full(SENSOR_0, ENABLE));                      // Interrupt set at FIFO_FULL (all FIFO used)
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT1(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT1(SENSOR_0, ENABLE));
	} else {
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT1_FIFO_Full(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(SENSOR_0, INPUT_BUFFER_SIZE));          // Set the Watermark level to INPUT_BUFFER_SIZE
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT1(SENSOR_0, ENABLE));                      // Enable the Watermark Interrupt
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT1(SENSOR_0, ENABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(SENSOR_0,  ENABLE));                        // Limit the FIFO depth to the Watermark level
	}
	[/#if]
	[#if "${FamilyName}" == "STM32U5" && useLSM6DSV16X]
	if (INPUT_BUFFER_SIZE == 256){
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, ENABLE));                      // Interrupt set at FIFO_FULL (all FIFO used)
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
	} else {
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(SENSOR_0, INPUT_BUFFER_SIZE));          // Set the Watermark level to INPUT_BUFFER_SIZE
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, ENABLE));                      // Enable the Watermark Interrupt
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(SENSOR_0,  ENABLE));                        // Limit the FIFO depth to the Watermark level
	}
	[/#if]
	[#if "${FamilyName}" == "STM32U5" && useISM330DHCX]
	if (INPUT_BUFFER_SIZE == 512){
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, ENABLE));                      // Interrupt set at FIFO_FULL (all FIFO used)
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
	} else {
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_INT2_FIFO_Full(SENSOR_0, DISABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Watermark_Level(SENSOR_0, INPUT_BUFFER_SIZE));          // Set the Watermark level to INPUT_BUFFER_SIZE
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Watermark_Set_INT2(SENSOR_0, ENABLE));                      // Enable the Watermark Interrupt
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Overrun_Set_INT2(SENSOR_0, ENABLE));
		CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Stop_On_Fth(SENSOR_0,  ENABLE));                        // Limit the FIFO depth to the Watermark level
	}
	[/#if]
	CHECK_BSP_FUNCTION(MY_CUSTOM_MOTION_SENSOR_FIFO_Set_Mode(SENSOR_0,  SENSOR_0_BYPASS_MODE));                     // Set the FIFO to Bypass Mode

	return BSP_ERROR_NONE;
}


/*
 * Extracting the number of lines from the .ucf file.
 */
uint32_t get_ucf_number_of_lines(int32_t ucf_content_size, const char *ucf_content) {
	uint32_t ucf_number_of_lines = 0;
	uint32_t i;

	for (i = 0; i < ucf_content_size-ucf_number_of_lines; i++) {
		if(ucf_content[i]=='\n'){
			ucf_number_of_lines++;
		}
	}

	return ucf_number_of_lines;
}
/*uint32_t get_ucf_number_of_lines(int32_t ucf_content_size, const char *ucf_content) {
	uint32_t ucf_number_of_lines = 0;
	uint32_t i;

	for (i = 0; i < ucf_content_size; i++) {
		if(ucf_content[i]=='#'){
			ucf_number_of_lines++;
		}
	}

	return ucf_number_of_lines;
}*/


/*
 * Filling MLC configuration structure from UCF file.
 */
void fill_mlc_configuration(const char* ucf_content, ucf_line_t* mlc_configuration) {

	const char* delimiters = "\n ";
	char *token;
	uint32_t i = 0;
	uint8_t addr, data;

	// Parsing UCF file.
	char *start = strstr(ucf_content, "Ac ");
	//char *input = (char *) calloc(strlen(start) + 1, sizeof(char));
	//strcpy(input, start);
	token = strtok(start, delimiters);
	while (token != NULL) {
		// Extracting the Ac characters at the beginning of the token.
		char cmd_char[2];
		strcpy(cmd_char, token);
		if (strcmp(cmd_char, "Ac") == 0) {
			// Extracting the first hexadecimal value after "Ac".
			char* hex_address = strtok(NULL, delimiters);
			// Extracting the second hexadecimal value after "Ac".
			char* hex_data = strtok(NULL, delimiters);
			// Converting into uint8_t type.
			addr = (uint8_t) strtol(hex_address, NULL, 16);
			data = (uint8_t) strtol(hex_data, NULL, 16);
			// Filling MLC configuration structure.
			mlc_configuration[i].address = addr;
			mlc_configuration[i].data = data;
		}
		// Going on with the next token.
		token = strtok(NULL, delimiters);
		i++;
	}
	free(token);
}

[#if useISM330IS]
/*
 * Filling ISPU configuration structure from UCF file.
 */
void fill_ispu_configuration(const char* ucf_content, ucf_line_ext_t* ispu_configuration) {

	const char* delimiters = "\n ";
	char *token;
	uint32_t i = 0;
	uint8_t addr, data, delay;

	// Parsing UCF file.
	char *start = strstr(ucf_content, "Ac ");
	//char *input = (char *) calloc(strlen(start) + 1, sizeof(char));
	//strcpy(input, start);
	token = strtok(start, delimiters);
	while (token != NULL) {
		// Extracting the Ac characters at the beginning of the token.
		char cmd_char[2];
		strcpy(cmd_char, token);
		if (strcmp(cmd_char, "Ac") == 0) {
			// Extracting the first hexadecimal value after "Ac".
			char* hex_address = strtok(NULL, delimiters);
			// Extracting the second hexadecimal value after "Ac".
			char* hex_data = strtok(NULL, delimiters);
			// Converting into uint8_t type.
			addr = (uint8_t) strtol(hex_address, NULL, 16);
			data = (uint8_t) strtol(hex_data, NULL, 16);
			// Filling ISPU configuration structure.
			ispu_configuration[i].op = 1;
			ispu_configuration[i].address = addr;
			ispu_configuration[i].data = data;
		} else if (strcmp(token, "WAIT") == 0) {
			// Extracting the first hexadecimal value after "WAIT".
			char* delay_char = strtok(NULL, delimiters);
			// Converting into uint8_t type.
			delay = (uint8_t) strtol(delay_char, NULL, 16);
			// If the token is "WAIT", set the op field to 2.
			ispu_configuration[i].op = 2;
			ispu_configuration[i].address = 0;
			ispu_configuration[i].data = delay;
		}
		// Going on with the next token.
		token = strtok(NULL, delimiters);
		i++;
	}
	free(token);
}
[/#if]

/*
 * Getting MLC register from UCF file.
 */
void get_mlc_register(const char* ucf_content, uint32_t *mlc_register) {

	char *start = strstr(ucf_content, "<MLC");
	if (start == NULL) {
		return;
	}
	start += 4;   // skip "<MLC"
	char *end = strstr(start, "_SRC>");
	if (end == NULL) {
		return;
	}
	int len = end - start;
	char *mlc_str = (char *) calloc(len + 1, sizeof(char));
	strncpy(mlc_str, start, len);
	mlc_str[len] = '\0';
	*mlc_register = atoi(mlc_str);
}


/*
 * Sending Board-ID and Firmware-ID.
 */
void send_identity(){
	get_identity = 0;

	// Appending the new line character to the identity message.
	char *ch = "\r\n";
	strcat(identity, ch);

	PRINT(identity);
}


/*
 * Sending the Properties Status.
 */
void send_status(){
	get_status = 0;

	// Appending the new line character to the identity message.
	char *ch = "\r\n";
	strcat(status, ch);

	PRINT(status);
}


/*
 * Identify the type of get command.
 */
void identify_get_cmd(PnPLCommand_t *command, char **serializedJSON){

	memset(identity, 0, strlen(identity));
	memset(status, 0, strlen(status));
	if(command->comm_type == PNPL_CMD_SYSTEM_INFO){
		get_identity = 1;
		memcpy(identity,*serializedJSON,strlen(*serializedJSON));
	}
	else if(command->comm_type == PNPL_CMD_GET){
		get_status = 1;
		memcpy(status,*serializedJSON,strlen(*serializedJSON));
	}
}

[#if useISM330IS]
/*
 * Understands if ISPU is mounted or not.
 */
bool ispu_get_mounted(){

	return ispu_mounted;
}
[/#if]

/*
 * Periodic interrupt for MLC use-case.
 */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
    [#if "${FamilyName}" != "STM32WB"]
    if (htim->Instance == TIM1) {
	[/#if]
	[#if "${FamilyName}" == "STM32WB"]
	if (htim->Instance == TIM2) {
	[/#if]
        tim_interrupt = 1;
    }
}

/*
 * Function to compute actual sensor ODR, without drift.
 *
 * @brief  Difference in percentage of the effective ODR (and timestamp rate) with respect to the typical. Step: 0.13%. 8-bit format, 2's complement.
 */
float32_t compute_actual_odr(){
	uint8_t odr;
	CUSTOM_MOTION_SENSOR_Read_Register(SENSOR_0, SENSOR_INTERNAL_FREQ, &odr);
	[#if useLSM6DSV16X]
	return (7680 * (1 + 0.0013*(float32_t)odr))/4;
	[/#if]
	[#if useISM330DHCX || useLSM6DSO32X]
	return (6667 + (0.0015*(float32_t)odr)*6667)/4;
	[/#if]
}

[#if "${FamilyName}" == "STM32WB" || "${FamilyName}" == "STM32L4"]
/*
 * Set the DFU Mode.
 */
void jump_to_bootloader(void)
{
    __enable_irq();
    HAL_RCC_DeInit();
    HAL_DeInit();
    SysTick->CTRL = SysTick->LOAD = SysTick->VAL = 0;
    __HAL_SYSCFG_REMAPMEMORY_SYSTEMFLASH();

	/* Initialize user application's Stack Pointer */
    const uint32_t p = (*((uint32_t *) 0x1FFF0000));
    __set_MSP( p );
	
	/* Jump to user application */
    void (*SysMemBootJump)(void);
    SysMemBootJump = (void (*)(void)) (*((uint32_t *) 0x1FFF0004));
    SysMemBootJump();

    while( 1 ) {}
}
[/#if]
[#if "${FamilyName}" == "STM32U5"]
/*
 * Set the DFU Mode.
 */
void jump_to_bootloader( void )
{
	/*  Disable interrupts for timers */
	HAL_NVIC_DisableIRQ(TIM6_IRQn);

	/*  Disable ICACHE */
	HAL_ICACHE_DeInit();

	/* Jump to user application */
	typedef  void (*pFunction)(void);
	pFunction JumpToApplication;
	uint32_t JumpAddress;
	JumpAddress = *(__IO uint32_t *) (0x0BF90000 + 4);
	JumpToApplication = (pFunction) JumpAddress;

	/* Initialize user application's Stack Pointer */
	__set_MSP(*(__IO uint32_t *) 0x0BF90000);
	JumpToApplication();

}
[/#if]