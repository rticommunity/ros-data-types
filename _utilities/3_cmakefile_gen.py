# 3_cmakefile_gen.py - helper to create CMakeLists.txt files
#  for directory tree of IDL files, to build as merged typesupport static library
# Started 2020Nov09 Neil Puthuff

import sys
import os

file_header = '''# Copyright 2020 Real-Time Innovations 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#     http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 

include(ConnextDdsRosDdsTypes)
'''

file_midblock = '''
# for unbounded strings & sequences use -DUNBOUNDED_ALL on CMake cmdline
if(UNBOUNDED_ALL)
    set(extra_params UNBOUNDED)
endif()

connextdds_generate_ros_dds_types(
    LANG ${LANG}
    OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    IDL_FILES ${idl_files}
    INCLUDE_DIRS ${top_level_source_dir}
    ${extra_params}
)
'''

cmake_file_opened = False
cmake_libname = ""

# walk along the provided paths, searching for IDL files
for root, dirs, files in os.walk(sys.argv[1]):
  
  # if dirs are listed, prepare to create a CMakeLists.txt file
  if len(dirs) > 0:
    # there are subdirs; this might be the place to put a CMakeLists.txt file
    # if a CMakeLists.txt file is already opened, finish it
    if cmake_file_opened == True:
      # write remainder of file, then close it.
      f_cmake.write("{}".format(file_midblock))
      f_cmake.write("add_library( {} OBJECT\n    ".format(cmake_libname) + "${generated_file_list}\n)\n\n")
      f_cmake.write("set_property(TARGET {} PROPERTY \n    POSITION_INDEPENDENT_CODE ON\n)\n\n".format(cmake_libname))
      f_cmake.write("target_include_directories({} PRIVATE \n    ".format(cmake_libname) + "${CONNEXTDDS_INCLUDE_DIRS}\n    ${top_level_binary_dir}\n)\n\n")
      f_cmake.write("target_compile_definitions({} PRIVATE \n    ".format(cmake_libname) + "${CONNEXTDDS_COMPILE_DEFINITIONS}\n)\n\n")
      f_cmake.write("add_dependencies({} \n    stdlibrary \n)\n".format(cmake_libname))
      
      f_cmake.close()
      cmake_file_opened = False
      
    cmake_file_root = root

  # check for IDL files in this dir
  if len(files) > 0:
    for fcand in files:
      if fcand.endswith('.idl'):
        if cmake_file_opened == False:
          # open file, init with header and such, make libname
          f_cmake = open('{}/CMakeLists.txt'.format(cmake_file_root), "w")
          f_cmake.write("{}\n".format(file_header))
          cmake_file_opened = True
          # create libname for this directory
          cmake_libname = cmake_file_root.strip(".").strip("/").strip("\\").replace("_", "") + "library"
          print("CMakeLists.txt file in {} for {}".format(cmake_file_root, cmake_libname))
        
        # add IDL file to CMakeList.txt file
        myDir = os.path.split(root)
        f_cmake.write("list(APPEND idl_files \"${CMAKE_CURRENT_SOURCE_DIR}/" + "{}/{}\")\n".format(myDir[1] ,fcand))
        


if cmake_file_opened == True:
  # write remainder of file, then close it.
  f_cmake.write("{}".format(file_midblock))
  f_cmake.write("add_library( {} OBJECT\n    ".format(cmake_libname) + "${generated_file_list}\n)\n\n")
  f_cmake.write("set_property(TARGET {} PROPERTY \n    POSITION_INDEPENDENT_CODE ON\n)\n\n".format(cmake_libname))
  f_cmake.write("target_include_directories({} PRIVATE \n    ".format(cmake_libname) + "${CONNEXTDDS_INCLUDE_DIRS}\n    ${top_level_binary_dir}\n)\n\n")
  f_cmake.write("target_compile_definitions({} PRIVATE \n    ".format(cmake_libname) + "${CONNEXTDDS_COMPILE_DEFINITIONS}\n)\n\n")
  f_cmake.write("add_dependencies({} \n    stdlibrary \n)\n".format(cmake_libname))
  f_cmake.close()
  cmake_file_opened = False

  