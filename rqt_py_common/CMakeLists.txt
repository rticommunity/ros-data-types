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

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ArrayVal.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Val.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/AddTwoInts_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/AddTwoInts_Response.idl")

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
add_library( rqtpycommonlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET rqtpycommonlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(rqtpycommonlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(rqtpycommonlibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)


