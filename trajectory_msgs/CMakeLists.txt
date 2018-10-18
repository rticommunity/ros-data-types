include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointTrajectory.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointTrajectoryPoint.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiDOFJointTrajectory.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiDOFJointTrajectoryPoint.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( trajectorylibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET trajectorylibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(trajectorylibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(trajectorylibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(trajectorylibrary 
    stdlibrary 
    geometrylibrary
)
