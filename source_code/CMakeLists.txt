cmake_minimum_required(VERSION 3.12)
project(CUDAPipelineProject LANGUAGES CXX CUDA)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find CUDA (though CMake 3.12+ automatically handles CUDA)
find_package(CUDA REQUIRED)

# Set CUDA architectures (adjust based on your GPU)
set(CMAKE_CUDA_ARCHITECTURES "72" CACHE STRING "CUDA Architectures")

# Option for PRO build (default is OFF - LITE version)
option(PRO_BUILD "Build with full pipeline including subtraction" OFF)

# Define preprocessor macros based on build type
if(PRO_BUILD)
    add_definitions(-DCUDA_PRO)
    message(STATUS "Building CUDA_PRO version (full pipeline with subtraction)")
else()
    add_definitions(-DCUDA_LITE)
    message(STATUS "Building CUDA_LITE version (add and multiply only)")
endif()

# Include directories
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
include_directories(${INCLUDE_DIR})

# Source files for the library - ALWAYS include pipeline.cu
set(LIBRARY_SOURCES
    src/add.cu
    src/multiply.cu
    src/pipeline.cu  # THIS WAS MISSING!
)

# Conditionally add subtract source for PRO version
if(PRO_BUILD)
    list(APPEND LIBRARY_SOURCES src/subtract.cu)
endif()

# Create shared library (lib.so)
add_library(cudapipeline SHARED ${LIBRARY_SOURCES})
set_target_properties(cudapipeline PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
    PREFIX "lib"
    SUFFIX ".so"
)

# Main executable source
set(EXECUTABLE_SOURCES
    main.cu
)

# Create executable
add_executable(main ${EXECUTABLE_SOURCES})

# Link executable with the library
target_link_libraries(main cudapipeline)

# Set output directories
set_target_properties(main PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)

set_target_properties(cudapipeline PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)

# Print some information
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "CUDA architectures: ${CMAKE_CUDA_ARCHITECTURES}")
message(STATUS "PRO_BUILD: ${PRO_BUILD}")