include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/State.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Transition.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TransitionDescription.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TransitionEvent.idl")

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/ChangeState_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/ChangeState_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableStates_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableStates_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableTransitions_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetAvailableTransitions_Response.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetState_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/GetState_Response.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

add_library( lifecyclelibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET lifecyclelibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(lifecyclelibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(lifecyclelibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)
