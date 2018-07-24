include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Mesh.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MeshTriangle.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Plane.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/SolidPrimitive.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS ${source_dir}
)

add_library( shapelibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET shapelibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(shapelibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${binary_dir}
)

target_compile_definitions(shapelibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(shapelibrary 
    geometrylibrary
)
