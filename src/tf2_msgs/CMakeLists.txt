include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TF2Error.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TFMessage.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/FrameGraph_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/FrameGraph_Response.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( tf2library OBJECT
    ${generated_file_list}
)

set_property(TARGET tf2library PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(tf2library PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(tf2library PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(tf2library 
    geometrylibrary
)
