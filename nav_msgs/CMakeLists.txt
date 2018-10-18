include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/GridCells.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MapMetaData.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/OccupancyGrid.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Odometry.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Path.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetMap_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetMap_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPlan_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPlan_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetMap_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetMap_Response.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( navlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET navlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(navlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(navlibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(navlibrary 
    stdlibrary 
    geometrylibrary
)
