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

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/action_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/action_tutorials_interfaces")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/actionlib_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/builtin_interfaces")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/composition_interfaces")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/diagnostic_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/example_interfaces")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/gazebo_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/geometry_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/lgsvl_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/libstatistics_collector")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/lifecycle_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/logging_demo")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/map_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/move_base_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/nav_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/pendulum_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/rcl_interfaces")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/rclcpp")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/rmw_dds_common")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/rosgraph_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/rosidl_generator_py")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/rqt_py_common")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/sensor_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/shape_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/statistics_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/std_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/std_srvs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/stereo_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/test_communication")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/test_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/test_rclcpp")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/tf2_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/trajectory_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/turtlesim")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/unique_identifier_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/visualization_msgs")

add_library(RosDataTypes
    $<TARGET_OBJECTS:actionmsgslibrary>
    $<TARGET_OBJECTS:actiontutorialsinterfaceslibrary>
    $<TARGET_OBJECTS:actionlibmsgslibrary>
    $<TARGET_OBJECTS:builtininterfaceslibrary>
    $<TARGET_OBJECTS:compositioninterfaceslibrary>
    $<TARGET_OBJECTS:diagnosticmsgslibrary>
    $<TARGET_OBJECTS:exampleinterfaceslibrary>
    $<TARGET_OBJECTS:gazebomsgslibrary>
    $<TARGET_OBJECTS:geometrymsgslibrary>
    $<TARGET_OBJECTS:lgsvlmsgslibrary>
    $<TARGET_OBJECTS:libstatisticscollectorlibrary>
    $<TARGET_OBJECTS:lifecyclemsgslibrary>
    $<TARGET_OBJECTS:loggingdemolibrary>
    $<TARGET_OBJECTS:mapmsgslibrary>
    $<TARGET_OBJECTS:movebasemsgslibrary>
    $<TARGET_OBJECTS:navmsgslibrary>
    $<TARGET_OBJECTS:pendulummsgslibrary>
    $<TARGET_OBJECTS:rclinterfaceslibrary>
    $<TARGET_OBJECTS:rclcpplibrary>
    $<TARGET_OBJECTS:rmwddscommonlibrary>
    $<TARGET_OBJECTS:rosgraphmsgslibrary>
    $<TARGET_OBJECTS:rosidlgeneratorpylibrary>
    $<TARGET_OBJECTS:rqtpycommonlibrary>
    $<TARGET_OBJECTS:sensormsgslibrary>
    $<TARGET_OBJECTS:shapemsgslibrary>
    $<TARGET_OBJECTS:statisticsmsgslibrary>
    $<TARGET_OBJECTS:stdmsgslibrary>
    $<TARGET_OBJECTS:stdsrvslibrary>
    $<TARGET_OBJECTS:stereomsgslibrary>
    $<TARGET_OBJECTS:testcommunicationlibrary>
    $<TARGET_OBJECTS:testmsgslibrary>
    $<TARGET_OBJECTS:testrclcpplibrary>
    $<TARGET_OBJECTS:tf2msgslibrary>
    $<TARGET_OBJECTS:trajectorymsgslibrary>
    $<TARGET_OBJECTS:turtlesimlibrary>
    $<TARGET_OBJECTS:uniqueidentifiermsgslibrary>
    $<TARGET_OBJECTS:visualizationmsgslibrary>    
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
