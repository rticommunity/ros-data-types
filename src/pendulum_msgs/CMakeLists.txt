include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointCommand.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointState.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/RttestResults.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

add_library( pendulumlibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET pendulumlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(pendulumlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(pendulumlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(pendulumlibrary 
    stdlibrary
)
