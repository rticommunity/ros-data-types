include(ConnextDdsRosDdsTypes)

file(GLOB files "${CMAKE_CURRENT_SOURCE_DIR}/msg/*.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/msg"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)
