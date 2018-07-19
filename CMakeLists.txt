cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(ros-types)

set(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/cmake")

find_package(RTIConnextDDS)

set (CMAKE_CXX_STANDARD 11)

include(ConnextDdsCodegen)

file(GLOB directories "${CMAKE_SOURCE_DIR}/src/*")
foreach(dir ${directories})
    IF(IS_DIRECTORY ${dir})

        get_filename_component(dir_name ${dir} NAME)

        file(GLOB subdirectories "${dir}/*")
        foreach(subdir ${subdirectories})
            IF(IS_DIRECTORY ${subdir})
                
                get_filename_component(subdir_name ${subdir} NAME)

                set(output_directory "${CMAKE_CURRENT_BINARY_DIR}/src/${dir_name}/${subdir_name}/")

                file(GLOB files "${subdir}/*.idl")
                foreach(file ${files})
                        message(${file})

                        connextdds_rtiddsgen_run(
                            LANG C++11
                            OUTPUT_DIRECTORY ${output_directory}
                            IDL_FILE ${file}
                            INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/src/"
                        )

                        get_filename_component(filename ${file} NAME_WE)
                        list(APPEND idl_list ${${filename}_CXX11_SOURCES}) 

                endforeach()


            ENDIF()
        endforeach()

    ENDIF()
endforeach()

add_library(rosddstypes MODULE 
    ${idl_list}
)

target_link_libraries(DdsIdl 
    ${CONNEXTDDS_CPP2_API_LIBRARIES_RELEASE_SHARED}
    ${CONNEXTDDS_EXTERNAL_LIBS} 
)

target_include_directories(DdsIdl PRIVATE 
    ${CONNEXTDDS_INCLUDE_DIRS} 
    ${CMAKE_CURRENT_BINARY_DIR}
    "${CMAKE_CURRENT_BINARY_DIR}/src/"
)

target_compile_definitions(DdsIdl PRIVATE 
    ${CONNEXTDDS_DEFINITIONS}
)
