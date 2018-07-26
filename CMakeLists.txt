cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(ros-types VERSION 1.0.0)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/cmake")

find_package(RTIConnextDDS)

# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
include(GNUInstallDirs)

set (CMAKE_CXX_STANDARD 11)
set (top_level_binary_dir "${CMAKE_CURRENT_BINARY_DIR}/src/")
set (top_level_source_dir "${CMAKE_CURRENT_SOURCE_DIR}/src/")

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/diagnostic_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/gazebo_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/geometry_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/lifecycle_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/nav_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/pendulum_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/sensor_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/shape_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/std_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/stereo_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/test_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/tf2_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/trajectory_msgs")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/src/visualization_msgs")

add_library(rosddstypes MODULE 
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

target_link_libraries(rosddstypes 
    ${CONNEXTDDS_CPP2_API_LIBRARIES_RELEASE_SHARED}
    ${CONNEXTDDS_EXTERNAL_LIBS} 
)

target_include_directories(rosddstypes PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS} 
    "${CMAKE_CURRENT_BINARY_DIR}/src/"
)

target_compile_definitions(rosddstypes PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

# Layout. This works for all platforms:
#   * <prefix>/lib*/cmake/<PROJECT-NAME>
#   * <prefix>/lib*/
#   * <prefix>/include/
set(config_install_dir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

# Configuration
set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

# Include module with fuction 'write_basic_package_version_file'
include(CMakePackageConfigHelpers)

# Configure '<PROJECT-NAME>ConfigVersion.cmake'
# Use:
#   * PROJECT_VERSION
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

# Configure '<PROJECT-NAME>Config.cmake'
# Use variables:
#   * TARGETS_EXPORT_NAME
#   * PROJECT_NAME
configure_package_config_file(
    "resources/cmake/Config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${config_install_dir}"
)

install(TARGETS rosddstypes
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

install(
    FILES "${project_config}" "${version_config}"
    DESTINATION "${config_install_dir}"
)

install(
    EXPORT "${TARGETS_EXPORT_NAME}"
    NAMESPACE "${namespace}"
    DESTINATION "${config_install_dir}"
)
