include(ConnextDdsRosDdsTypes)

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/BatteryState.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/CameraInfo.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/ChannelFloat32.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/CompressedImage.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/FluidPressure.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Illuminance.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Image.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Imu.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JointState.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JoyFeedbackArray.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/JoyFeedback.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Joy.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/LaserEcho.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/LaserScan.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MagneticField.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiDOFJointState.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/MultiEchoLaserScan.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/NavSatFix.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/NavSatStatus.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PointCloud2.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PointCloud.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/PointField.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Range.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/RegionOfInterest.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/RelativeHumidity.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/Temperature.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/msg/TimeReference.idl")

list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetCameraInfo_Request.idl")
list(APPEND files "${CMAKE_CURRENT_SOURCE_DIR}/srv/SetCameraInfo_Response.idl")

connextdds_generate_ros_dds_types(
    LANG "C++11"
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${files}
    INCLUDE_DIRS ${top_level_source_dir}
)

add_library( sensorlibrary OBJECT
    ${generated_file_list}
)

set_property(TARGET sensorlibrary PROPERTY 
    POSITION_INDEPENDENT_CODE ON
)

target_include_directories(sensorlibrary PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    ${top_level_binary_dir}
)

target_compile_definitions(sensorlibrary PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)

add_dependencies(sensorlibrary 
    stdlibrary 
    geometrylibrary
)
