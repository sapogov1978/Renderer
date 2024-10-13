# Minimum CMake version
cmake_minimum_required(VERSION 3.10)

# Project name
project(renderer)

# C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Collect all cpp files
file(GLOB_RECURSE SOURCES "renderer/src/*.cpp")

# Add executable
add_executable(renderer ${SOURCES})

# Setting up output directories for intermediate and binary files
set(OUTPUT_DIR "${CMAKE_SOURCE_DIR}/bin/${PROJECT_NAME}/${CMAKE_SYSTEM_NAME}")
set(INTERMEDIATE_DIR "${CMAKE_SOURCE_DIR}/bin-int/${PROJECT_NAME}/${CMAKE_SYSTEM_NAME}")

# Set directories for each configuration type
function(set_output_directories config)
    set_target_properties(renderer PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY_${config} "${INTERMEDIATE_DIR}/${config}"
        LIBRARY_OUTPUT_DIRECTORY_${config} "${INTERMEDIATE_DIR}/${config}"
        RUNTIME_OUTPUT_DIRECTORY_${config} "${OUTPUT_DIR}/${config}"
    )
endfunction()

# Apply output directory settings
set_output_directories(Debug)
set_output_directories(Release)

# Include directory
target_include_directories(renderer PRIVATE renderer/src)

add_custom_command(
    TARGET renderer POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
    "${CMAKE_BINARY_DIR}/renderer.sln"
    "${CMAKE_SOURCE_DIR}/renderer.sln"
    COMMENT "Copying solution file to root directory"
)
