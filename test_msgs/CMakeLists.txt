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

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_Feedback.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_FeedbackMessage.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_GetResult_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_GetResult_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_Goal.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_Result.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_SendGoal_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/Fibonacci_SendGoal_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_Feedback.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_FeedbackMessage.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_GetResult_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_GetResult_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_Goal.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_Result.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_SendGoal_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/action/NestedMessage_SendGoal_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Arrays.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BasicTypes.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BoundedSequences.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Builtins.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Constants.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Defaults.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Empty.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiNested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Nested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Strings.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/UnboundedSequences.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/WStrings.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Arrays_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Arrays_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/BasicTypes_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/BasicTypes_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Empty_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Empty_Response.idl")



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

add_library( testmsgslibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET testmsgslibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(testmsgslibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(testmsgslibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(testmsgslibrary 
    builtininterfaceslibrary 
    uniqueidentifiermsgslibrary 
)
