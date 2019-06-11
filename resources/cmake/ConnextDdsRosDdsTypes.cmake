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

include(ConnextDdsCodegen)

#[[

ConnextDdsRosDdsType
-----------------

.. connextdds_generate_ros_dds_types:

Generate types using connextdds_rtiddsgen_run to generate the code of the idl file::

    connextdds_generate_ros_dds_types(
        LANG <language>
        OUTPUT_DIRECTORY <dir>
        IDL_FILE <idl file path>
        [INCLUDE_DIRS ...]
        [UNBOUNDED]
    )

Input parameters:

``IDL_FILE`` (mandatory)
    The IDL filename that will be used to generate code

``OUTPUT_DIRECTORY`` (mandatory)
    The directory where to put generated files

``LANG`` (mandatory)
    The language to generate source files for. Expected values are:
    C, C++, C++03, C++11, C++/CLI, C# and Java.

``INCLUDE_DIRS`` (optional)
    List of include directories passed to Codegen (-I flag)

``UNBOUNDED`` (optional)
    Generate type files with unbounded support (``-unboundedSupport``) flag.

Output parameters:

``<OBJECT_LIBRARY_NAME>``
    The object library that was generated 

Output values:
The language variable is sanitized according to :ref:`connextdds_sanitize_language`
for the variable name.

``generated_file_list``
    The list with the lists of generated source and headers files.


.. connextdds_sanitize_library_language:

Sanitize Language
^^^^^^^^^^^^^^^^^

    connextdds_sanitize_library_language(
        LANG language
        VAR variable
    )

Get the sanitized version of the language to use in library names. It will do
the following replacement:

* Replace ``+`` with ``P`` (i.e.: C++ --> CPP)
* Replace ``11`` with ``2`` (i.e.: C++11 --> CPP2)

#]]

macro(connextdds_generate_ros_dds_types)
    set(options UNBOUNDED)
    set(single_value_args LANG OUTPUT_DIRECTORY)
    set(multi_value_args IDL_FILES INCLUDE_DIRS)

    cmake_parse_arguments(_ROS_TYPES
        "${options}"
        "${single_value_args}"
        "${multi_value_args}"
        ${ARGN}
    )

    connextdds_sanitize_language(LANG ${_ROS_TYPES_LANG} VAR lang_var)

    foreach(file ${_ROS_TYPES_IDL_FILES})
        # Obtain first the path to the IDL file
        get_filename_component(idl_path ${file} PATH)
        get_filename_component(idl_dir_name ${idl_path} NAME)

        # Then, obtain the module_path (e.g., visualization_msgs)
        get_filename_component(module_path ${idl_path} PATH)
        get_filename_component(module_name ${module_path} NAME)

        # Set unbounded 
        set(unbounded "")
        if(_ROS_TYPES_UNBOUNDED)
            set(unbounded "UNBOUNDED")
        endif()

        set(namespace "")
        if(${_ROS_TYPES_LANG} STREQUAL "C++")
            set(namespace "NAMESPACE")
        endif()

        connextdds_rtiddsgen_run(
            LANG ${_ROS_TYPES_LANG}
            OUTPUT_DIRECTORY "${_ROS_TYPES_OUTPUT_DIRECTORY}/${idl_dir_name}"
            IDL_FILE ${file}
            INCLUDE_DIRS ${_ROS_TYPES_INCLUDE_DIRS}
            ${unbounded}
            ${namespace}
            STL
            VAR generated_file
        )

        list(APPEND generated_file_list 
            ${generated_file_${lang_var}_SOURCES}
            ${generated_file_${lang_var}_HEADERS}
        )
                    
        # Add generated header files to the list of files that will be
        # installed
        install(FILES ${generated_file_${lang_var}_HEADERS}             
            DESTINATION "${CMAKE_INSTALL_PREFIX}/include/${module_name}/${idl_dir_name}"
        )

    endforeach()
    
endmacro()

function(connextdds_sanitize_library_language)
    cmake_parse_arguments(_LANG "" "LANG;VAR" "" ${ARGN})
    connextdds_check_required_arguments(_LANG_LANG _LANG_VAR)

    # Replaces C++ by CPP, C++1 by CPP2 
    string(TOUPPER ${_LANG_LANG} lang_var)
    string(REPLACE "+" "P" lang_var ${lang_var})
    string(REPLACE "11" "2" lang_var ${lang_var})

    # Define variable in the caller
    set(${_LANG_VAR} ${lang_var} PARENT_SCOPE)
endfunction()
