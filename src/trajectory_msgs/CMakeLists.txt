include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointTrajectory.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointTrajectoryPoint.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiDOFJointTrajectory.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiDOFJointTrajectoryPoint.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

add_library( trajectorylibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET trajectorylibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(trajectorylibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(trajectorylibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(trajectorylibrary 
    stdlibrary 
    geometrylibrary
)
