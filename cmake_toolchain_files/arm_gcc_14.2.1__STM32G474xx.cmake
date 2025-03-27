cmake_minimum_required(VERSION 3.15)

if (${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
	set(toolchain_dir      "${CMAKE_CURRENT_LIST_DIR}/../arm-gnu-toolchain/arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi")
	set(EXEC_SUFFIX      ".exe")
	set(CMAKE_MAKE_PROGRAM "${CMAKE_CURRENT_LIST_DIR}/../ninja/win/ninja.exe")
	set(PYTHON_EXECUTABLE "python" CACHE FILEPATH "Python executable")

elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
	set(toolchain_dir      "${CMAKE_CURRENT_LIST_DIR}/../arm-gnu-toolchain/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi")
	set(EXEC_SUFFIX      "")
	set(CMAKE_MAKE_PROGRAM "${CMAKE_CURRENT_LIST_DIR}/../ninja/linux/ninja" CACHE FILEPATH "Ninja executable")
    set(PYTHON_EXECUTABLE "python3" CACHE FILEPATH "Python executable")
else()
	message(STATUS "${CMAKE_HOST_SYSTEM_NAME}")
	message(SEND_ERROR "Host OS ${CMAKE_HOST_SYSTEM_NAME} is not supported")
endif()

set(CMAKE_SYSTEM_NAME       Generic)
set(CMAKE_SYSTEM_VERSION    14.2.1)
set(CMAKE_SYSTEM_PROCESSOR  STM32G474xx)

set(TOOLS_DIR          "${CMAKE_CURRENT_LIST_DIR}/../utility")
set(toolchain_bin_dir  "${toolchain_dir}/bin")
set(toolchain_inc_dir  "${toolchain_dir}/arm-none-eabi/include")
set(toolchain_lib_dir  "${toolchain_dir}/arm-none-eabi/lib")

set(ARM_OPTIONS
 -mcpu=cortex-m4
 -mthumb
 -mfpu=fpv4-sp-d16
 -mfloat-abi=hard
 # --specs=nano.specs
 --specs=nosys.specs
 -u_printf_float
 -u_scanf_float
)

add_compile_options(
 ${ARM_OPTIONS}
 -ggdb
 -fno-builtin
 -ffunction-sections
 -fdata-sections
 -fomit-frame-pointer
 "$<$<COMPILE_LANGUAGE:CXX>:-fexceptions>"
 "$<$<COMPILE_LANGUAGE:CXX>:-funwind-tables>"
 #"$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>"
 #"$<$<COMPILE_LANGUAGE:CXX>:-fno-unwind-tables>"
 "$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>"
 "$<$<COMPILE_LANGUAGE:CXX>:-fno-threadsafe-statics>"
 "$<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp>"
 -MMD
 -MP
 )

add_link_options(
 ${ARM_OPTIONS}
 -Wl,-gc-sections
 -Wl,--print-memory-usage
 -Wl,--no-warn-rwx-segments
 -Wl,-lstdc++
 -Wl,-lsupc++
)


set(CMAKE_C_COMPILER   "${toolchain_bin_dir}/arm-none-eabi-gcc${EXEC_SUFFIX}")
set(CMAKE_CXX_COMPILER "${toolchain_bin_dir}/arm-none-eabi-g++${EXEC_SUFFIX}")
set(CMAKE_ASM_COMPILER "${toolchain_bin_dir}/arm-none-eabi-gcc${EXEC_SUFFIX}")
set(CMAKE_OBJCOPY      "${toolchain_bin_dir}/arm-none-eabi-objcopy${EXEC_SUFFIX}")
set(CMAKE_SIZE         "${toolchain_bin_dir}/arm-none-eabi-size${EXEC_SUFFIX}")

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_FIND_ROOT_PATH "${toolchain_dir}")

set(CMAKE_TRY_COMPILE_TARGET_TYPE     STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)



