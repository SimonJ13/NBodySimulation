cmake_minimum_required(VERSION 3.20)

# ------------------------------
# Project Setup
# ------------------------------
project(NBodySimulation VERSION 1.0 LANGUAGES CXX)

# Use C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ------------------------------
# Source Files
# ------------------------------
# Include all .cpp files in src/ and common/ so linker errors are avoided
file(GLOB_RECURSE SOURCES
    src/cpu/*.cpp
    src/gpu/*.cpp       # optional if you have GPU sources
    common/*.cpp
)

# ------------------------------
# Executable
# ------------------------------
add_executable(nbody_cpu
    src/cpu/cpu_simulation.cpp
    src/common/init.cpp       # <--- include this explicitly
)

# ------------------------------
# Include directories
# ------------------------------
target_include_directories(nbody_cpu PRIVATE
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/common
)

# ------------------------------
# Output folder
# ------------------------------
# All executables go to <project-root>/bin/<Config>
set_target_properties(nbody_cpu PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin/$<CONFIG>"
)

# ------------------------------
# Compiler Warnings
# ------------------------------
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(nbody_cpu PRIVATE -Wall -Wextra -Wpedantic)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    target_compile_options(nbody_cpu PRIVATE /W4 /permissive-)
endif()

# ------------------------------
# Default build type
# ------------------------------
# If user did not specify, default to Release
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to Release by default")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the build type" FORCE)
endif()
