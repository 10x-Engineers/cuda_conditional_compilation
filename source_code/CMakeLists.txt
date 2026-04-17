cmake_minimum_required(VERSION 3.12)
project(CUDAPipelineProject LANGUAGES CXX CUDA)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find CUDA (though CMake 3.12+ automatically handles CUDA)
find_package(CUDA REQUIRED)

# Set CUDA architectures (adjust based on your GPU)
set(CMAKE_CUDA_ARCHITECTURES "72" CACHE STRING "CUDA Architectures")

# Include directories
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
include_directories(${INCLUDE_DIR})

# Source files for the library
set(LIBRARY_SOURCES
    src/add.cu
    src/subtract.cu
    src/multiply.cu
    src/pipeline.cu
)

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