include(ConnextDdsRosDdsTypes)

list(APPEND idl_files "${CMAKE_CURRENT_SOURCE_DIR}/MyCustomType.idl")

connextdds_generate_ros_dds_types(
    LANG <C|C++|C++11>
    OUTPUT_DIRECTORY <output directory>
    IDL_FILES ${idl_files}
    INCLUDE_DIRS <path/to/idldirectory>
)

add_executable (examplecustomtype
    <main_source>
    MyCustomType.cxx
    MyCustomTypeImpl.cxx
    MyCustomTypeImplPlugin.cxx
)

target_link_libraries(examplecustomtype 
    #${CONNEXTDDS_C_API_LIBRARIES_RELEASE_SHARED} # C
    #${CONNEXTDDS_CPP_API_LIBRARIES_RELEASE_SHARED} # C++
    ${CONNEXTDDS_CPP2_API_LIBRARIES_RELEASE_SHARED} # C++11
    ${CONNEXTDDS_EXTERNAL_LIBS}                     
    rosddstypes                                     
)

target_include_directories(examplecustomtype PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS}
    "<path/to/idltypedirectory>"
)

target_compile_definitions(examplecustomtype PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)
