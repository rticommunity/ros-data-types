include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DiagnosticArray.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DiagnosticStatus.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/KeyValue.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/AddDiagnostics_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/AddDiagnostics_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SelfTest_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SelfTest_Response.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library(diagnosticlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET diagnosticlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(diagnosticlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(diagnosticlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(diagnosticlibrary 
    stdlibrary
)
