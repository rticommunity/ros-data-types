include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DisparityImage.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

add_library( stereolibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET stereolibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(stereolibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(stereolibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(stereolibrary 
    sensorlibrary
)
