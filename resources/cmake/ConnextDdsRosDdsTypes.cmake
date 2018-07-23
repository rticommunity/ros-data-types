include(ConnextDdsCodegen)

macro(connextdds_generate_ros_dds_types)
    set(options UNBOUNDED)
    set(single_value_args LANG OUTPUT_DIRECTORY 
        OBJECT_LIBRARY_NAME SOURCES 
    )
    set(multi_value_args IDL_FILES INCLUDE_DIRS)

    cmake_parse_arguments(_ROS_TYPES
        "${options}"
        "${single_value_args}"
        "${multi_value_args}"
        ${ARGN}
    )

    foreach(file ${_ROS_TYPES_IDL_FILES})
        
        get_filename_component(file_path ${file} PATH)
        get_filename_component(output_subdir ${file_path} NAME)

        connextdds_rtiddsgen_run(
            LANG ${_ROS_TYPES_LANG}
            OUTPUT_DIRECTORY "${_ROS_TYPES_OUTPUT_DIRECTORY}/${output_subdir}"
            IDL_FILE ${file}
            INCLUDE_DIRS ${_ROS_TYPES_INCLUDE_DIRS}
            VAR generated_file
        )

        list(APPEND idl_list_source 
            ${generated_file_CXX11_SOURCES} 
            ${generated_file_CXX11_HEADERS}
        )

    endforeach()
    
endmacro()
