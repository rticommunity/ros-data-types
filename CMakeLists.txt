# Copyright 2018 Real-Time Innovations 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#     http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 

cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(ros-types VERSION 1.0.0)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/cmake")

find_package(RTIConnextDDS)
include(CMakePackageConfigHelpers)
include(ConnextDdsRosDdsTypes)

if (NOT LANG)
    set(LANG "C++11")
endif()

set (top_level_binary_dir "${CMAKE_CURRENT_BINARY_DIR}/")
set (top_level_source_dir "${CMAKE_CURRENT_SOURCE_DIR}/")

connextdds_sanitize_library_language(LANG ${LANG} VAR lang_var)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/diagnostic_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/gazebo_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/geometry_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/lifecycle_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/nav_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/pendulum_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/sensor_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/shape_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/std_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/stereo_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/test_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/tf2_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/trajectory_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/visualization_msgs")

add_library(RosDataTypes
    $<TARGET_OBJECTS:diagnosticlibrary>
    $<TARGET_OBJECTS:gazebolibrary>
    $<TARGET_OBJECTS:geometrylibrary>
    $<TARGET_OBJECTS:lifecyclelibrary>
    $<TARGET_OBJECTS:navlibrary>
    $<TARGET_OBJECTS:pendulumlibrary>
    $<TARGET_OBJECTS:sensorlibrary>
    $<TARGET_OBJECTS:shapelibrary>
    $<TARGET_OBJECTS:stdlibrary>
    $<TARGET_OBJECTS:stereolibrary>
    $<TARGET_OBJECTS:testlibrary>
    $<TARGET_OBJECTS:tf2library>
    $<TARGET_OBJECTS:trajectorylibrary>
    $<TARGET_OBJECTS:visualizationlibrary>
)

target_link_libraries(RosDataTypes 
    ${CONNEXTDDS_${lang_var}_API_LIBRARIES_RELEASE_SHARED}
    ${CONNEXTDDS_EXTERNAL_LIBS} 
)

target_include_directories(RosDataTypes PUBLIC 
    ${CONNEXTDDS_INCLUDE_DIRS} 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/>
)

target_compile_definitions(RosDataTypes PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

# Set configuration variables
set(version_config 
    "${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config 
    "${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")

# Write configuration version file
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

# Create a config file of the library
configure_package_config_file(
    "resources/cmake/Config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}"
)

# Install target
install(TARGETS RosDataTypes
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
    RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin"
    INCLUDES DESTINATION "${CMAKE_INSTALL_PREFIX}/include"
)

# Install config files
install(
    FILES "${project_config}" "${version_config}"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}"
)

install(
    EXPORT "${TARGETS_EXPORT_NAME}"
    NAMESPACE "${PROJECT_NAME}::"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}"
)
