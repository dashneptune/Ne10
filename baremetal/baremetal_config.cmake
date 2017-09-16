# A CMake toolchain file so we can cross-compile for the AM3358 bare-metal

#  Usage:
#   $ mkdir build && cd build
#   $ cmake -DCMAKE_TOOLCHAIN_FILE=path/of/baremetal_config.cmake ..
#   $ make
#



include(CMakeForceCompiler)

# The Generic system name is used for embedded targets (targets without OS) in
# CMake
set( CMAKE_SYSTEM_NAME          Generic )
set( CMAKE_SYSTEM_PROCESSOR     AM3358 )

# Set a toolchain path. You only need to set this if the toolchain isn't in
# your system path. Don't forget a trailing path separator!
set( TC_PATH "/home/marcintrosh/ti/gcc-arm-none-eabi-4_9-2015q3/bin/")



# The toolchain prefix for all toolchain executables
set( CROSS_COMPILE arm-none-eabi-)

set( CMAKE_C_COMPILER ${TC_PATH}${CROSS_COMPILE}gcc )  
set( CMAKE_CXX_COMPILER ${TC_PATH}${CROSS_COMPILE}g++ ) 
set( CMAKE_ASM_COMPILER ${TC_PATH}${CROSS_COMPILE}ar ) 

# specify the cross compiler. We force the compiler so that CMake doesn't
# attempt to build a simple test program as this will fail without us using
# the -nostartfiles option on the command line
CMAKE_FORCE_C_COMPILER( ${TC_PATH}${CROSS_COMPILE}gcc GNU)
CMAKE_FORCE_CXX_COMPILER( ${TC_PATH}${CROSS_COMPILE}g++  GNU)

# We must set the OBJCOPY setting into cache so that it's available to the
# whole project. Otherwise, this does not get set into the CACHE and therefore
# the build doesn't know what the OBJCOPY filepath is
set( CMAKE_OBJCOPY      ${TC_PATH}${CROSS_COMPILE}objcopy
    CACHE FILEPATH "The toolchain objcopy command " FORCE )

# Set the CMAKE C flags (which should also be used by the assembler!
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=neon" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=hard" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=armv7-a" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mtune=cortex-a8" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -funsafe-math-optimizations")

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" )
set( CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" )

set(BAREMETAL_PLATFORM ON)

find_program(CMAKE_AR NAMES "arm-none-gnueabi-ar")  
mark_as_advanced(CMAKE_AR)   
find_program(CMAKE_RANLIB NAMES "arm-none-gnueabi-ranlib")
mark_as_advanced(CMAKE_RANLIB)
