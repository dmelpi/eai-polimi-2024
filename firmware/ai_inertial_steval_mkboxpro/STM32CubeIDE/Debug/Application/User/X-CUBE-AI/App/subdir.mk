################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/X-CUBE-AI/App/network.c \
C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/X-CUBE-AI/App/network_data.c \
C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/X-CUBE-AI/App/network_data_params.c 

OBJS += \
./Application/User/X-CUBE-AI/App/network.o \
./Application/User/X-CUBE-AI/App/network_data.o \
./Application/User/X-CUBE-AI/App/network_data_params.o 

C_DEPS += \
./Application/User/X-CUBE-AI/App/network.d \
./Application/User/X-CUBE-AI/App/network_data.d \
./Application/User/X-CUBE-AI/App/network_data_params.d 


# Each subdirectory must supply rules for building sources it contributes
Application/User/X-CUBE-AI/App/network.o: C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/X-CUBE-AI/App/network.c Application/User/X-CUBE-AI/App/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Application/User/X-CUBE-AI/App/network_data.o: C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/X-CUBE-AI/App/network_data.c Application/User/X-CUBE-AI/App/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Application/User/X-CUBE-AI/App/network_data_params.o: C:/Users/MEMS/OneDrive/polimi/2024/ai_inertial_steval_mkboxpro/X-CUBE-AI/App/network_data_params.c Application/User/X-CUBE-AI/App/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../X-CUBE-ISPU/Target -I../../X-CUBE-MEMS1/Target -I../../X-CUBE-VESPUCCI/App -I../../X-CUBE-VESPUCCI/PnPL/Core/Inc -I../../X-CUBE-VESPUCCI/PnPL/PnPL/Inc -I../../USB_Device/Target -I../../USB_Device/App -I../../X-CUBE-VESPUCCI/ai_app -I../../X-CUBE-VESPUCCI/pre_processing -I../../X-CUBE-VESPUCCI/smart_sensors -I../../Core/Inc -I../../Middlewares/ST/AI/Inc -I../../X-CUBE-AI/App -I../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../Drivers/CMSIS/Include -I../../Drivers/BSP/Components/ism330is -I../../Drivers/BSP/Components/Common -I../../Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc -I../../Middlewares/ST/pre_processing/Inc -I../../Middlewares/ST/PnPLCompManager/Inc -I../../Middlewares/ST/DSP/Include -I../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../Middlewares/Third_Party/Parson_DataOoExchange/parson -I../../Drivers/BSP/Components/lsm6dsv16x -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Application-2f-User-2f-X-2d-CUBE-2d-AI-2f-App

clean-Application-2f-User-2f-X-2d-CUBE-2d-AI-2f-App:
	-$(RM) ./Application/User/X-CUBE-AI/App/network.cyclo ./Application/User/X-CUBE-AI/App/network.d ./Application/User/X-CUBE-AI/App/network.o ./Application/User/X-CUBE-AI/App/network.su ./Application/User/X-CUBE-AI/App/network_data.cyclo ./Application/User/X-CUBE-AI/App/network_data.d ./Application/User/X-CUBE-AI/App/network_data.o ./Application/User/X-CUBE-AI/App/network_data.su ./Application/User/X-CUBE-AI/App/network_data_params.cyclo ./Application/User/X-CUBE-AI/App/network_data_params.d ./Application/User/X-CUBE-AI/App/network_data_params.o ./Application/User/X-CUBE-AI/App/network_data_params.su

.PHONY: clean-Application-2f-User-2f-X-2d-CUBE-2d-AI-2f-App

