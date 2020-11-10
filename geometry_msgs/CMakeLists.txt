# Copyright 2020 Real-Time Innovations 
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

include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Accel.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/AccelStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/AccelWithCovariance.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/AccelWithCovarianceStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Inertia.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InertiaStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Point.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Point32.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PointStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Polygon.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PolygonStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Pose.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Pose2D.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseArray.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseWithCovariance.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseWithCovarianceStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Quaternion.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/QuaternionStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Transform.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TransformStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Twist.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TwistStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TwistWithCovariance.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TwistWithCovarianceStamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Vector3.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Vector3Stamped.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Wrench.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/WrenchStamped.idl")

# for unbounded strings & sequences use -DUNBOUNDED_ALL on CMake cmdline
if(UNBOUNDED_ALL)
    set(extra_params UNBOUNDED)
endif()

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
    ${extra_params}
)

add_library( geometrymsgslibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET geometrymsgslibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(geometrymsgslibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(geometrymsgslibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(geometrymsgslibrary 
    stdmsgslibrary 
)
