include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Mesh.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MeshTriangle.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Plane.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/SolidPrimitive.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( shapelibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET shapelibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(shapelibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(shapelibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(shapelibrary 
    geometrylibrary
)