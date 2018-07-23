include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/GridCells.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MapMetaData.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/OccupancyGrid.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Odometry.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Path.idl")

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetMap_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetMap_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPlan_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPlan_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetMap_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetMap_Response.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

add_library( navlibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET navlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(navlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(navlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(navlibrary 
    stdlibrary 
    geometrylibrary
)
