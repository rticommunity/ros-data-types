include(ConnextDdsRosDdsTypes)

file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/msg/*.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/msg"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/srv/*.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/srv"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

# set(idl_list ${idl_list} PARENT_SCOPE)

add_library( diagnosticlibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET diagnosticlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(diagnosticlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(diagnosticlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(diagnosticlibrary stdlibrary)
