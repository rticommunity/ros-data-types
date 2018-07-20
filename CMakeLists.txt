cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(ros-types)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/cmake")

find_package(RTIConnextDDS)

set (CMAKE_CXX_STANDARD 11)

set(some_file "some/dir/sub/some_file.h")

get_filename_component(a_dir "${some_file}" PATH)
get_filename_component(a_last_dir "${a_dir}" NAME)
get_filename_component(a_second_dir "${a_dir}" PATH)
get_filename_component(a_second_last_dir "${a_second_dir}" NAME)

message("a_last_dir = ${a_last_dir}")
message("a_second_last_dir = ${a_second_last_dir}")

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

# message(${idl_list_source})
add_library(rosddstypes MODULE 
    $<TARGET_OBJECTS:diagnosticlibrary>
    $<TARGET_OBJECTS:stdlibrary>
    # ${idl_list_source}
)

target_link_libraries(rosddstypes 
    ${CONNEXTDDS_CPP2_API_LIBRARIES_RELEASE_SHARED}
    ${CONNEXTDDS_EXTERNAL_LIBS} 
)

target_include_directories(rosddstypes PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS} 
    ${CMAKE_CURRENT_BINARY_DIR}
    "${CMAKE_CURRENT_BINARY_DIR}/src/"
)

target_compile_definitions(rosddstypes PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)
