include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BoundedArrayNested.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BoundedArrayPrimitives.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Builtins.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DynamicArrayNested.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DynamicArrayPrimitives.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/DynamicArrayPrimitivesNested.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Empty.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Nested.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Primitives.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/StaticArrayNested.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/StaticArrayPrimitives.idl")

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Empty_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Empty_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Primitives_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Primitives_Response.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( testlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET testlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(testlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(testlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(testlibrary 
    stdlibrary
)
