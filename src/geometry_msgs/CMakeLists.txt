include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Accel.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/AccelStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/AccelWithCovariance.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/AccelWithCovarianceStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Inertia.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/InertiaStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Point32.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Point.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PointStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Polygon.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PolygonStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Pose2D.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseArray.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Pose.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseWithCovariance.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PoseWithCovarianceStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Quaternion.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/QuaternionStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Transform.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TransformStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Twist.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TwistStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TwistWithCovariance.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TwistWithCovarianceStamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Vector3.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Vector3Stamped.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Wrench.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/WrenchStamped.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
)

add_library( geometrylibrary OBJECT
    ${idl_list_source}
)

set_property(TARGET geometrylibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(geometrylibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "${CMAKE_BINARY_DIR}/src/"
)

target_compile_definitions(geometrylibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(geometrylibrary 
    stdlibrary
)
