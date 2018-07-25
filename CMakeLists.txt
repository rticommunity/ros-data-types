cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(ros-types)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/cmake")

find_package(RTIConnextDDS)

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

install(TARGETS rosddstypes DESTINATION lib)

# install(EXPORT rosddstypes-targets
#     NAMESPACE rosddstypes::
#     FILE rosddstypes-config.cmake
#     DESTINATION lib/cmake/rosddstypes)