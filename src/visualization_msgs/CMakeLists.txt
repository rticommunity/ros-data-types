include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ImageMarker.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InteractiveMarkerControl.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InteractiveMarkerFeedback.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InteractiveMarker.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InteractiveMarkerInit.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InteractiveMarkerPose.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InteractiveMarkerUpdate.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MarkerArray.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Marker.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MenuEntry.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( visualizationlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET visualizationlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(visualizationlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(visualizationlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(visualizationlibrary 
    stdlibrary 
    geometrylibrary
)
