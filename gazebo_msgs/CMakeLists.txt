include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ContactsState.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ContactState.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/LinkState.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/LinkStates.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ModelState.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ModelStates.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ODEJointProperties.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ODEPhysics.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/msg/WorldState.idl")

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/ApplyBodyWrench_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/ApplyJointEffort_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Body_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Default_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/DeleteLight_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/DeleteModel_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetJointProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetJointProperties_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetLightProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetLightProperties_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetLinkProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetLinkProperties_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetLinkState_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetLinkState_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetModelProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetModelProperties_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetModelState_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetModelState_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetPhysicsProperties_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetWorldProperties_Response.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/Joint_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetJointProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetJointTrajectory_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetLightProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetLinkProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetLinkState_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetModelConfiguration_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetModelState_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetPhysicsProperties_Request.idl")
list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SpawnModel_Request.idl")

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( gazebolibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET gazebolibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(gazebolibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(gazebolibrary PRIVATE 
    ${CONNEXTDDS_COMPILE_DEFINITIONS}
)

add_dependencies(gazebolibrary 
    stdlibrary 
    geometrylibrary 
    trajectorylibrary
)
