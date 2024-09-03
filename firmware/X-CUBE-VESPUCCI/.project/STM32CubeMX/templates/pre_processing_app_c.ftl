[#ftl]
/**
 ******************************************************************************
 * @file    pre_processing_app.c
 * @author  STMicroelectronics
 * @version 1.0.0
 * @date    June 29, 2022
 *
 * @brief File generated with Handlebars.
 *
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; COPYRIGHT 2022 STMicroelectronics</center></h2>
 *
 * Licensed under MCD-ST Liberty SW License Agreement V2, (the "License");
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *
 *        http://www.st.com/software_license_agreement_liberty_v2
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

#include "sys_functions.h"
#include "arm_math.h"
#include "params.h"
#include "pre_processing_app.h"
#include <stdlib.h>

void pre_processing_init_mcu(pre_processing_data_t* pre_processing_data, float32_t sensor_odr) {
    // Axis selection.
    pre_processing_data->axis_selection_axis = AXIS_SELECTION_AXIS;

    // MFCC.
    arm_status mfcc_status;
    arm_rfft_fast_init_f32(&((*pre_processing_data).mfcc_handler), INPUT_BUFFER_SIZE);
    mfcc_status = arm_dct4_init_f32(&((*pre_processing_data).mfcc_dct4f32), &((*pre_processing_data).mfcc_rfftf32), &((*pre_processing_data).mfcc_cfftradix4f32), MFCC_TRIANGULAR_FILTERS_BANK_SIZE, MFCC_TRIANGULAR_FILTERS_BANK_SIZE / 2.0, 0.125);
    if (mfcc_status != ARM_MATH_SUCCESS) {
        sys_error_handler();
    }
    pre_processing_data->mfcc_triangular_filters_scale = MFCC_TRIANGULAR_FILTERS_SCALE;
    pre_processing_data->mfcc_signal_windowing = MFCC_SIGNAL_WINDOWING;
	triangular_filters_init(INPUT_BUFFER_SIZE, MFCC_TRIANGULAR_FILTERS_BANK_SIZE, MFCC_TRIANGULAR_FILTERS_BANK_FRACTION, sensor_odr, pre_processing_data->mfcc_triangular_filters_scale, (*pre_processing_data).mfcc_bin);
	(*pre_processing_data).mfcc_multipliers = (float32_t*) SysAlloc(INPUT_BUFFER_SIZE * sizeof(float32_t));
    multipliers_init((*pre_processing_data).mfcc_multipliers, INPUT_BUFFER_SIZE, (*pre_processing_data).mfcc_signal_windowing);
}

void pre_processing_process_mcu(tridimensional_data_t* data_in, uint32_t data_in_size, float32_t* data_out, uint32_t data_out_size, pre_processing_data_t* pre_processing_data) {
    // Axis selection.
    float32_t data_0[data_in_size];
    axis_selection(data_in, data_in_size, data_0, data_in_size, pre_processing_data->axis_selection_axis);

    // Mean removal.
    float32_t data_1[data_in_size];
    mean_removal(data_0, data_in_size, data_1, data_in_size);

    // MFCC.
    mfcc(data_1, data_in_size, data_out, data_out_size, ((*pre_processing_data).mfcc_bin), &((*pre_processing_data).mfcc_dct4f32), &((*pre_processing_data).mfcc_handler), (*pre_processing_data).mfcc_signal_windowing, (*pre_processing_data).mfcc_multipliers);
}

void pre_processing_free(pre_processing_data_t* pre_processing_data) {
    // MFCC.
    SysFree((*pre_processing_data).mfcc_multipliers);
}
