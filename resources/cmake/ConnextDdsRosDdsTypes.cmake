include(ConnextDdsCodegen)

#[[

ConnextDdsAddTypeObjectLibrary
-----------------

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

``idl_list_source``
    The list with the lists of generated source files.

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
        
        get_filename_component(file_path ${file} PATH)
        get_filename_component(output_subdir ${file_path} NAME)

        connextdds_rtiddsgen_run(
            LANG ${_ROS_TYPES_LANG}
            OUTPUT_DIRECTORY "${_ROS_TYPES_OUTPUT_DIRECTORY}/${output_subdir}"
            IDL_FILE ${file}
            INCLUDE_DIRS ${_ROS_TYPES_INCLUDE_DIRS}
            UNBOUNDED
            VAR generated_file
        )

        list(APPEND idl_list_source 
            ${generated_file_${lang_var}_SOURCES}
            ${generated_file_${lang_var}_HEADERS} 
        )

    endforeach()
    
endmacro()
