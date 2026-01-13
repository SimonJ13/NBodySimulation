cmake_minimum_required(VERSION 3.20)

project(NBodySimulation
    VERSION 1.0
    LANGUAGES CXX CUDA
)

# -------------------------------------------------
# Language standards
# -------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

# -------------------------------------------------
# Common library (shared CPU/GPU code)
# -------------------------------------------------
file(GLOB_RECURSE NBODY_COMMON_SOURCES
    ${PROJECT_SOURCE_DIR}/src/common/*.cpp
)

add_library(nbody_common STATIC ${NBODY_COMMON_SOURCES})

target_include_directories(nbody_common PUBLIC
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/src/common
)

if (MSVC)
    target_compile_options(nbody_common PRIVATE /W4 /permissive-)
else()
    target_compile_options(nbody_common PRIVATE -Wall -Wextra -Wpedantic)
endif()

# -------------------------------------------------
# CPU executable
# -------------------------------------------------
file(GLOB_RECURSE NBODY_CPU_SOURCES
    ${PROJECT_SOURCE_DIR}/src/cpu/*.cpp
)

add_executable(nbody_cpu ${NBODY_CPU_SOURCES})

target_link_libraries(nbody_cpu PRIVATE nbody_common)

set_target_properties(nbody_cpu PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin/$<CONFIG>"
)

if (MSVC)
    target_compile_options(nbody_cpu PRIVATE /W4 /permissive-)
else()
    target_compile_options(nbody_cpu PRIVATE -Wall -Wextra -Wpedantic)
endif()

# -------------------------------------------------
# GPU executable
# -------------------------------------------------
set(NBODY_GPU_SOURCES
    ${PROJECT_SOURCE_DIR}/src/gpu/main_gpu.cu
    ${PROJECT_SOURCE_DIR}/src/gpu/nbody_cuda.cu
)

add_executable(nbody_gpu ${NBODY_GPU_SOURCES})

target_include_directories(nbody_gpu PRIVATE
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/src/common
    ${PROJECT_SOURCE_DIR}/src/gpu
)

target_link_libraries(nbody_gpu PRIVATE nbody_common)

set_target_properties(nbody_gpu PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
    CUDA_ARCHITECTURES 75
    RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin/$<CONFIG>"
)

# ---- Compiler flags (language-aware) ----
if (MSVC)
    # C++ only
    target_compile_options(nbody_gpu PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:/W4 /permissive->
    )

    # CUDA → forward MSVC flags correctly
    target_compile_options(nbody_gpu PRIVATE
        $<$<COMPILE_LANGUAGE:CUDA>:-Xcompiler=/W4,-permissive->
    )
else()
    target_compile_options(nbody_gpu PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-Wall -Wextra -Wpedantic>
    )
endif()

# -------------------------------------------------
# Default build type (single-config generators)
# -------------------------------------------------
if (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()
