cmake_minimum_required(VERSION 3.3.2)
project (ptcdemo)

if(DEFINED ENV{NDDSHOME})
  set(NDDSHOME $ENV{NDDSHOME})
else()
  message(FATAL_ERROR "NDDSHOME (env var) is not set")
endif()

if(DEFINED ENV{ROS_DATA_TYPES_DIR})
  set(ROS_DATA_TYPES_DIR $ENV{ROS_DATA_TYPES_DIR})
else()
  message(FATAL_ERROR "ROS_DATA_TYPES_DIR (env var) is not set")
endif()

set(CMAKE_MODULE_PATH ${NDDSHOME}/resource/cmake)

find_package(RTIConnextDDS EXACT "6.0.1" REQUIRED)

find_library(ROS_IDL_LIBRARY NAMES RosDataTypes HINTS "${ROS_DATA_TYPES_DIR}/install/lib")

# - Point to the source dirs and files ----------
include_directories(${ROS_DATA_TYPES_DIR}/install/include ${CONNEXTDDS_INCLUDE_DIRS})

# - Executables to build ----------------------------------------------------------------------------
add_executable(ptc_demo 
  src/ptc_demo.cxx 
)
target_link_libraries(ptc_demo PUBLIC RTIConnextDDS::cpp2_api ${ROS_IDL_LIBRARY})
