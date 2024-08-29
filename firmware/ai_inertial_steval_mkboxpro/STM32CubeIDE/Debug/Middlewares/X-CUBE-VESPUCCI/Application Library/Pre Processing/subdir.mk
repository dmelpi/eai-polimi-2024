################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/Middlewares/ST/pre_processing/Src/pre_processing_core.c \
C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/Middlewares/ST/pre_processing/Src/sys_functions.c 

OBJS += \
./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.o \
./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.o 

C_DEPS += \
./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.d \
./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.o: C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/Middlewares/ST/pre_processing/Src/pre_processing_core.c Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/X-CUBE-VESPUCCI/Application Library/Pre Processing/pre_processing_core.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.o: C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/Middlewares/ST/pre_processing/Src/sys_functions.c Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/X-CUBE-VESPUCCI/Application Library/Pre Processing/sys_functions.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Middlewares-2f-X-2d-CUBE-2d-VESPUCCI-2f-Application-20-Library-2f-Pre-20-Processing

clean-Middlewares-2f-X-2d-CUBE-2d-VESPUCCI-2f-Application-20-Library-2f-Pre-20-Processing:
	-$(RM) ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.cyclo ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.d ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.o ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/pre_processing_core.su ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.cyclo ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.d ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.o ./Middlewares/X-CUBE-VESPUCCI/Application\ Library/Pre\ Processing/sys_functions.su

.PHONY: clean-Middlewares-2f-X-2d-CUBE-2d-VESPUCCI-2f-Application-20-Library-2f-Pre-20-Processing

