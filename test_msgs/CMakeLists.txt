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

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BoundedArrayNested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BoundedArrayPrimitives.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Builtins.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DynamicArrayNested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DynamicArrayPrimitives.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DynamicArrayPrimitivesNested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Empty.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Nested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Primitives.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/StaticArrayNested.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/StaticArrayPrimitives.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Empty_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Empty_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Primitives_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Primitives_Response.idl")

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

add_library( testlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET testlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(testlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(testlibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(testlibrary 
    stdlibrary
)
