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

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_Feedback.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_FeedbackMessage.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_GetResult_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_GetResult_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_Goal.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_Result.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_SendGoal_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/RotateAbsolute_SendGoal_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Color.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Pose.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Kill_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Kill_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetPen_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetPen_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Spawn_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Spawn_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/TeleportAbsolute_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/TeleportAbsolute_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/TeleportRelative_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/TeleportRelative_Response.idl")

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
add_library( turtlesimlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET turtlesimlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(turtlesimlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(turtlesimlibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

