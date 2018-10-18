include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointCommand.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointState.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/RttestResults.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( pendulumlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET pendulumlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(pendulumlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(pendulumlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(pendulumlibrary 
    stdlibrary
)
