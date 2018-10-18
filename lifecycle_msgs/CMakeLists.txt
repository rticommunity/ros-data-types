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

include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/State.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Transition.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TransitionDescription.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TransitionEvent.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/ChangeState_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/ChangeState_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableStates_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableStates_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableTransitions_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableTransitions_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetState_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetState_Response.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library(lifecyclelibrary OBJECT ${generated_file_list})

set_property(TARGET lifecyclelibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(lifecyclelibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(lifecyclelibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)
