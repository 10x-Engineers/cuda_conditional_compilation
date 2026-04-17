cmake_minimum_required(VERSION 3.12)
project(CUDAPipelineProject LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Architecture fix for warnings (Match this to your library build)
set(CMAKE_CUDA_ARCHITECTURES "72")

# 2. Add the PRO_BUILD option (Default is OFF to match your original logic)
option(PRO_BUILD "Build with full pipeline including subtraction" OFF)

# 3. Create an IMPORTED library target
add_library(cudapipeline SHARED IMPORTED)
set_target_properties(cudapipeline PROPERTIES
    IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/libcudapipeline.so"
)

# 4. Create the main executable
add_executable(main main.cu)

# 5. Handle Header Logic based on the PRO_BUILD flag
if(PRO_BUILD)
    target_compile_definitions(main PRIVATE CUDA_PRO)
    message(STATUS "Configuring for CUDA_PRO (Header will include Subtraction)")
else()
    target_compile_definitions(main PRIVATE CUDA_LITE)
    message(STATUS "Configuring for CUDA_LITE (Header will exclude Subtraction)")
endif()

# 6. Link and Include
target_include_directories(main PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(main cudapipeline)

# 7. RPATH fix (So the binary finds the .so file)
set_target_properties(main PROPERTIES
    BUILD_WITH_INSTALL_RPATH TRUE
    INSTALL_RPATH "${CMAKE_SOURCE_DIR}"
)