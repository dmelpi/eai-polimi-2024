################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/Middlewares/Third_Party/Parson_DataOoExchange/parson/parson.c 

OBJS += \
./Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.o 

C_DEPS += \
./Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.o: C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/Middlewares/Third_Party/Parson_DataOoExchange/parson/parson.c Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/X-CUBE-VESPUCCI/Data Exchange/parson/parson.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Middlewares-2f-X-2d-CUBE-2d-VESPUCCI-2f-Data-20-Exchange-2f-parson

clean-Middlewares-2f-X-2d-CUBE-2d-VESPUCCI-2f-Data-20-Exchange-2f-parson:
	-$(RM) ./Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.cyclo ./Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.d ./Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.o ./Middlewares/X-CUBE-VESPUCCI/Data\ Exchange/parson/parson.su

.PHONY: clean-Middlewares-2f-X-2d-CUBE-2d-VESPUCCI-2f-Data-20-Exchange-2f-parson

