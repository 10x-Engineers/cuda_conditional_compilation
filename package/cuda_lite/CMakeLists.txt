cmake_minimum_required(VERSION 3.12)
project(CUDAPipelineProject LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Address the Warning: Set CUDA Architecture
# Change "72" to your specific GPU architecture if known
set(CMAKE_CUDA_ARCHITECTURES "72") 

# 2. Define include directory
include_directories(${CMAKE_SOURCE_DIR}/include)

# 3. Import the shared library
add_library(cudapipeline SHARED IMPORTED)
set_target_properties(cudapipeline PROPERTIES
    IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/libcudapipeline.so"
)

# 4. Create executable
add_executable(main main.cu)
target_link_libraries(main cudapipeline)

# 5. FIX THE RUNTIME ISSUE (RPATH)
# This tells the executable to look in the directory where the .so is located
set_target_properties(main PROPERTIES
    BUILD_WITH_INSTALL_RPATH TRUE
    INSTALL_RPATH "${CMAKE_SOURCE_DIR}"
)