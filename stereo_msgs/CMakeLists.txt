include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DisparityImage.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( stereolibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET stereolibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(stereolibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(stereolibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(stereolibrary 
    sensorlibrary
)
