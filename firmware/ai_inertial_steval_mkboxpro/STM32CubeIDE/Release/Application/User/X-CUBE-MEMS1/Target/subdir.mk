################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/X-CUBE-MEMS1/Target/MEMS_integration.c \
C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/X-CUBE-MEMS1/Target/custom_motion_sensors.c \
C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.c 

OBJS += \
./Application/User/X-CUBE-MEMS1/Target/MEMS_integration.o \
./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.o \
./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.o 

C_DEPS += \
./Application/User/X-CUBE-MEMS1/Target/MEMS_integration.d \
./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.d \
./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.d 


# Each subdirectory must supply rules for building sources it contributes
Application/User/X-CUBE-MEMS1/Target/MEMS_integration.o: C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/X-CUBE-MEMS1/Target/MEMS_integration.c Application/User/X-CUBE-MEMS1/Target/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.o: C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/X-CUBE-MEMS1/Target/custom_motion_sensors.c Application/User/X-CUBE-MEMS1/Target/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.o: C:/Git/vespucci-artifacts/firmware/ai_inertial_steval_mkboxpro/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.c Application/User/X-CUBE-MEMS1/Target/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Application-2f-User-2f-X-2d-CUBE-2d-MEMS1-2f-Target

clean-Application-2f-User-2f-X-2d-CUBE-2d-MEMS1-2f-Target:
	-$(RM) ./Application/User/X-CUBE-MEMS1/Target/MEMS_integration.cyclo ./Application/User/X-CUBE-MEMS1/Target/MEMS_integration.d ./Application/User/X-CUBE-MEMS1/Target/MEMS_integration.o ./Application/User/X-CUBE-MEMS1/Target/MEMS_integration.su ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.cyclo ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.d ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.o ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors.su ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.cyclo ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.d ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.o ./Application/User/X-CUBE-MEMS1/Target/custom_motion_sensors_ex.su

.PHONY: clean-Application-2f-User-2f-X-2d-CUBE-2d-MEMS1-2f-Target

