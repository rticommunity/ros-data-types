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

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/GridCells.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MapMetaData.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/OccupancyGrid.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Odometry.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Path.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetMap_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetMap_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPlan_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPlan_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetMap_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetMap_Response.idl")

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

add_library( navmsgslibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET navmsgslibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(navmsgslibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(navmsgslibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(navmsgslibrary 
    stdmsgslibrary 
    geometrymsgslibrary
)
