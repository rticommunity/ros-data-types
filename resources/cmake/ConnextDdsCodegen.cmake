# (c) 2017-2018 Copyright, Real-Time Innovations, Inc. All rights reserved.
# No duplications, whole or partial, manual or electronic, may be made
# without express written permission.  Any such copies, or revisions thereof,
# must display this notice unaltered.
# This code contains trade secrets of Real-Time Innovations, Inc.

#[[.rst:
.. _connextdds_codegen:

ConnextDdsCodegen
-----------------

CodeGen usage functions.


.. _connextdds_rtiddsgen_run:

Code generation
^^^^^^^^^^^^^^^

Generate a source files using RTI Codegen::

    connextdds_rtiddsgen_run(
        LANG <language>
        OUTPUT_DIRECTORY <dir>
        IDL_FILE <idl file path>
        [VAR variable]
        [TYPE_NAMES ... ]
        [NOT_REPLACE]
        [PACKAGE package]
        [DISABLE_PREPROCESSOR]
        [INCLUDE_DIRS ...]
        [DEFINES ...]
        [UNBOUNDED]
        [NO_TYPECODE]
        [IGNORE_ALIGNMENT]
        [USE42_ALIGNMENT]
        [OPTIMIZE_ALIGNMENT]
        [STL]
        [STANDALONE]
        [EXTRA_ARGS ...]
    )

This function calls ``codegen`` (rtiddsgen) to generates source files for the
language ``LANG`` passed as an argument to the function.

Arguments:

``IDL_FILE`` (mandatory)
    The IDL filename that will be used to generate code

``OUTPUT_DIRECTORY`` (mandatory)
    The directory where to put generated files

``LANG`` (mandatory)
    The language to generate source files for. Expected values are:
    C, C++, C++03, C++11, C++/CLI, C# and Java.

``TYPE_NAMES`` (mandatory for Java)
    A list of they IDL type names. Neede for the Java source file names.

``VAR``
    Use ``VAR`` as a prefix instead of using the IDL basename to name return
    values.

``NOT_REPLACE`` (optional)
    By default, we call ``codegen`` with the ``-replace`` argument, so every time
    the input IDL file has changed, we regenerate the source files. Passing this
    argument disables the flag.

``UNBOUNDED`` (optional)
    Generate type files with unbounded support (``-unboundedSupport``) flag.

``PACKAGE`` (optional)
    Specify the package name for Java source type files.

``IGNORE_ALIGNMENT`` (optional)
    Generate type files with -ignoreAlignment flag enabled

``USE42_ALIGNMENT`` (optional)
    Generate type files with 4.2 compatible alignment (``-use42eAlignment`` flag)

``OPTIMIZE_ALIGNMENT`` (optional)
    Generate code with optimized alignment

``NO_TYPECODE``  (optional)
    Do not generate TypeCode in generated files

``DISABLE_PREPROCESSOR`` (optional)
    Disable the use of a preprocessor in Codegen

``STL`` (optional)
    Use the STL types for C++.

``STANDALONE`` (optional)
    Generate typecode files independant to RTI Connext DDS libraries.

``INCLUDE_DIRS``  (optional)
    List of include directories passed to Codegen (-I flag)

``DEFINES``  (optional)
    List of definitions passed to Codegen as arguments (-D flag)

``EXTRA_ARGS``  (optional)
    Extra arguments added to the Codegen command line

Output values:
The language variable is sanitized according to :ref:`connextdds_sanitize_language`
for the variable name.

``<idl_basename>_<LANG>_SOURCES``
    The list of generated source files

``<idl_basename>_<LANG>_HEADERS``
    The list of generated header files, if apply

If ``VAR`` is passed as a parameter, the variable name will be named like this:

``<VAR>_<LANG>_SOURCES``
    The list of generated source files

``<VAR>_<LANG>_HEADERS``
    The list of generated header files, if apply


.. _connextdds_rtiddsgen_convert:

Convert
^^^^^^^
::

    connextdds_rtiddsgen_convert(
        INPUT inputFile
        FROM format
        TO format
        [VAR variable]
        [OUTPUT_DIRECTORY outputPath]
        [NOT_REPLACE]
        [INCLUDE_DIRS ...]
        [DEFINES ...]
        [EXTRA_ARGS ...]
        [DEPENDS ...]
    )

Call rtiddsgen to convert the format of the type representation
(IDL, XML or XSD).

``INPUT`` (required):
    The path to the input file.

``FROM`` (required)
    The input format. Accepted values are ``IDL``, ``XML`` and ``XSD``.

``TO`` (required)
    The output format. Accepted values are ``IDL``, ``XML`` and ``XSD``.

``VAR`` (optional)
    The name of the variable to set the output file.

``OUTPUT_DIRECTORY`` (optional)
    The directory to save the output file.

``NOT_REPLACE`` (optional)
    By default the command will overwrite any existing file. Set this file to
    skip converting if the output exists.

``INCLUDE_DIRS`` (optional)
    Additional include directory for the codegen preprocessor.

``DEFINES`` (optional)
    Additional definitions for the codegen preprocessor.

``EXTRA_ARGS`` (optional)
    Additional flags for codegen.

``DEPENDS`` (optional)
    CMake dependencies for this command.


.. _connextdds_sanitize_language:

Sanitize Language
^^^^^^^^^^^^^^^^^
::

    connextdds_sanitize_language(
        LANG language
        VAR variable
    )

Get the sanitized version of the language to use in variable names. This output
is used by the CodeGen functions to create the default variable names. It will do
the following replacement:

* Replace ``+`` with ``X`` (i.e.: C++11 --> CXX11)
* Replace ``#`` with ``Sharp`` (i.e.: C# --> CSharp)
* Remove ``/`` (i.e.: C++/CLI --> CXXCLI)
#]]

include(CMakeParseArguments)
include(ConnextDdsArgumentChecks)

# If CONNEXTDDS_HOME or NDDSHOME are previously defined, assume CODEGEN is 
# there
if (CONNEXTDDS_DIR)
    set(CODEGEN_HOME ${CONNEXTDDS_DIR})
elseif(ENV{NDDSHOME})
    set(CODEGEN_HOME $ENV{NDDSHOME})
endif()

get_filename_component(JRE_BIN_DIR "${Java_JAVA_EXECUTABLE}" DIRECTORY)
set(JREHOME "${JRE_BIN_DIR}/../")

macro(_connextdds_codegen_find_codegen)
    if(WIN32)
        set(script_ext ".bat")
    else()
        set(script_ext "")
    endif()

    set(CODEGEN_PATH "${CODEGEN_HOME}/bin/rtiddsgen${script_ext}")

    # Get the absolute path to avoid problems during build time.
    # Otherwise the relative path will go into the module makefiles where
    # the working directory is different.
    get_filename_component(CODEGEN_PATH "${CODEGEN_PATH}"
        ABSOLUTE
        BASE_DIR "${CMAKE_BINARY_DIR}"
    )

    # Append the JRE we want to use
    set(CODEGEN_COMMAND
        "${CODEGEN_PATH}"
    )


    if(NOT CODEGEN_HOME)
        message(FATAL_ERROR
            "Missing CODEGEN_HOME variable. "
            "Cross-compiled platforms don't build rtiddsgen. Please compile "
            "rtiddsgen in a host platform and specify the CODEGEN_HOME variable "
            "to {host_binary_dir}/nddsgen.2.0 or to NDDSHOME."
        )
    elseif(NOT EXISTS "${CODEGEN_HOME}")
        message(FATAL_ERROR "CODEGEN_HOME dir doesn't exist: ${CODEGEN_HOME}")
    endif()
endmacro()

# Helper function to determine the generated files based on the language
# Supported languages are: C C++ Java C++/CLI C++03 C++11 C#
function(_connextdds_codegen_get_generated_file_list)
    set(options STL STANDALONE)
    set(single_value_args VAR LANG IDL_BASENAME OUTPUT_DIR)
    set(multi_value_args TYPE_NAMES)
    cmake_parse_arguments(_CODEGEN
        "${options}"
        "${single_value_args}"
        "${multi_value_args}"
        ${ARGN}
    )

    set(path_base "${_CODEGEN_OUTPUT_DIR}/${_CODEGEN_IDL_BASENAME}")
    if("${_CODEGEN_LANG}" STREQUAL "C")
        set(sources "${path_base}.c")
        set(headers "${path_base}.h")
        if(NOT _CODEGEN_STANDALONE)
            list(APPEND sources "${path_base}Plugin.c" "${path_base}Support.c")
            list(APPEND headers "${path_base}Plugin.h" "${path_base}Support.h")
        endif()

        # Set in the parent scope
        set(${_CODEGEN_VAR}_SOURCES ${sources} PARENT_SCOPE)
        set(${_CODEGEN_VAR}_HEADERS ${headers} PARENT_SCOPE)

    elseif("${_CODEGEN_LANG}" STREQUAL "C++")
        set(sources "${path_base}.cxx")
        set(headers "${path_base}.h")
        if(NOT _CODEGEN_STANDALONE)
            list(APPEND sources "${path_base}Plugin.cxx" "${path_base}Support.cxx")
            list(APPEND headers "${path_base}Plugin.h" "${path_base}Support.h")
        endif()

        # Set in the parent scope
        set(${_CODEGEN_VAR}_SOURCES ${sources} PARENT_SCOPE)
        set(${_CODEGEN_VAR}_HEADERS ${headers} PARENT_SCOPE)

    elseif("${_CODEGEN_LANG}" STREQUAL "C#"
            OR "${_CODEGEN_LANG}" STREQUAL "C++/CLI")
        set(${_CODEGEN_VAR}_SOURCES
            "${path_base}.cpp"
            "${path_base}Plugin.cpp"
            "${path_base}Support.cpp"
            PARENT_SCOPE)
        set(${_CODEGEN_VAR}_HEADERS
            "${path_base}.h"
            "${path_base}Plugin.h"
            "${path_base}Support.h"
            PARENT_SCOPE)
    elseif("${_CODEGEN_LANG}" STREQUAL "C++03"
            OR "${_CODEGEN_LANG}" STREQUAL "C++11")
        if(_CODEGEN_STL)
            set(${_CODEGEN_VAR}_SOURCES
                "${path_base}.cxx"
                "${path_base}Plugin.cxx"
                PARENT_SCOPE)
            set(${_CODEGEN_VAR}_HEADERS
                "${path_base}.hpp"
                "${path_base}Plugin.hpp"
                PARENT_SCOPE)
        else()
            set(${_CODEGEN_VAR}_SOURCES
                "${path_base}.cxx"
                "${path_base}Impl.cxx"
                "${path_base}ImplPlugin.cxx"
                PARENT_SCOPE)
            set(${_CODEGEN_VAR}_HEADERS
                "${path_base}.hpp"
                "${path_base}Impl.h"
                "${path_base}ImplPlugin.h"
                PARENT_SCOPE)
        endif()
    elseif("${_CODEGEN_LANG}" STREQUAL "Java")
        # Java File names depends on struct names to generate files, not on
        # idl file name. IDL usually contains more than one structure so we
        # can't guess the source files if we don't know the structure names.
        if(NOT _CODEGEN_TYPE_NAMES)
            message(FATAL_ERROR "Generate Java types requires its names")
        endif()
        foreach(name ${_CODEGEN_TYPE_NAMES})
            set(${_CODEGEN_VAR}_SOURCES ${${_CODEGEN_VAR}_SOURCES}
                "${name}.java"
                "${name}DataReader.java"
                "${name}DataWriter.java"
                "${name}Seq.java"
                "${name}TypeCode.java"
                "${name}TypeSupport.java"
                PARENT_SCOPE
            )
        endforeach()
    else()
        message(FATAL_ERROR "Language ${_CODEGEN_LANG} is not supported")
    endif()
endfunction()

function(connextdds_sanitize_language)
    cmake_parse_arguments(_LANG "" "LANG;VAR" "" ${ARGN})
    connextdds_check_required_arguments(_LANG_LANG _LANG_VAR)

    # Replaces C++ by CXX and C# by CSharp. Removes / for C++/CLI
    string(TOUPPER ${_LANG_LANG} lang_var)
    string(REPLACE "+" "X" lang_var ${lang_var})
    string(REPLACE "/" "" lang_var ${lang_var})
    string(REPLACE "#" "Sharp" lang_var ${lang_var})

    # Define variable in the caller
    set(${_LANG_VAR} ${lang_var} PARENT_SCOPE)
endfunction()

function(connextdds_rtiddsgen_run)
    set(options
        NOT_REPLACE UNBOUNDED IGNORE_ALIGNMENT USE42_ALIGNMENT
        OPTIMIZE_ALIGNMENT NO_TYPECODE DISABLE_PREPROCESSOR STL STANDALONE
        NAMESPACE
    )
    set(single_value_args LANG OUTPUT_DIRECTORY IDL_FILE VAR PACKAGE)
    set(multi_value_args TYPE_NAMES INCLUDE_DIRS DEFINES EXTRA_ARGS)
    cmake_parse_arguments(_CODEGEN
        "${options}"
        "${single_value_args}"
        "${multi_value_args}"
        ${ARGN}
    )
    connextdds_check_required_arguments(
        _CODEGEN_IDL_FILE
        _CODEGEN_LANG
        _CODEGEN_OUTPUT_DIRECTORY
    )

    _connextdds_codegen_find_codegen()

    file(MAKE_DIRECTORY "${_CODEGEN_OUTPUT_DIRECTORY}")
    get_filename_component(idl_basename "${_CODEGEN_IDL_FILE}" NAME_WE)

    set(list_extra_args)
    if(_CODEGEN_STL)
        list(APPEND list_extra_args STL)
    endif()
    if(_CODEGEN_STANDALONE)
        list(APPEND list_extra_args STANDALONE)
    endif()

    _connextdds_codegen_get_generated_file_list(
        VAR IDL
        IDL_BASENAME ${idl_basename}
        LANG ${_CODEGEN_LANG}
        OUTPUT_DIR "${_CODEGEN_OUTPUT_DIRECTORY}"
        TYPE_NAMES ${_CODEGEN_TYPE_NAMES}
        ${list_extra_args}
    )

    set(include_dirs)
    foreach(dir ${_CODEGEN_INCLUDE_DIRS})
        list(APPEND include_dirs -I "${dir}")
    endforeach()

    set(defines)
    foreach(def ${_CODEGEN_DEFINES})
        list(APPEND defines -D${def})
    endforeach()

    # Create the extra / optional arguments
    set(extra_flags "${_CODEGEN_EXTRA_ARGS}")
    if(_CODEGEN_IGNORE_ALIGNMENT)
        list(APPEND extra_flags "-ignoreAlignment")
    endif()

    if(_CODEGEN_STL)
        list(APPEND extra_flags "-stl")
    endif()

    if(_CODEGEN_USE42_ALIGNMENT)
        list(APPEND extra_flags "-use42eAlignment")
    endif()

    if(_CODEGEN_OPTIMIZE_ALIGNMENT)
        list(APPEND extra_flags "-optimizeAlignment")
    endif()

    if(_CODEGEN_NO_TYPECODE OR _CODEGEN_STANDALONE)
        list(APPEND extra_flags "-noTypeCode")
    endif()

    if(_CODEGEN_UNBOUNDED)
        list(APPEND extra_flags "-unboundedSupport")
    endif()

    if(_CODEGEN_NAMESPACE)
        list(APPEND extra_flags "-namespace")
    endif()


    if(_CODEGEN_DISABLE_PREPROCESSOR)
        list(APPEND extra_flags "-ppDisable")
    endif()

    if(_CODEGEN_PACKAGE)
        list(APPEND extra_flags "-package" "${_CODEGEN_PACKAGE}")
    endif()

    # By default we overwrite all the generated files
    if(NOT _CODEGEN_NOT_REPLACE)
        list(APPEND extra_flags "-replace")
    endif()

    # Call CodeGen
    add_custom_command(
        OUTPUT
            ${IDL_SOURCES}
            ${IDL_HEADERS}
        VERBATIM
        COMMAND
            ${CMAKE_COMMAND} -E make_directory ${_CODEGEN_OUTPUT_DIRECTORY}
        COMMAND
            ${CODEGEN_COMMAND}
                ${include_dirs} ${defines}
                ${extra_flags}
                -language ${_CODEGEN_LANG}
                -d ${_CODEGEN_OUTPUT_DIRECTORY}
                ${_CODEGEN_IDL_FILE}
        DEPENDS
            "${_CODEGEN_IDL_FILE}"
            ${CODEGEN_DEPENDS}
    )

    # Get the name of the language variables (i.e.: C++/CLI -> CXXCLI).
    connextdds_sanitize_language(LANG ${_CODEGEN_LANG} VAR lang_var)

    if(_CODEGEN_VAR)
        set(var_prefix "${_CODEGEN_VAR}")
    else()
        set(var_prefix "${idl_basename}")
    endif()

    # Exports the files generated by codegen
    set(${var_prefix}_${lang_var}_SOURCES ${IDL_SOURCES} PARENT_SCOPE)
    set(${var_prefix}_${lang_var}_HEADERS ${IDL_HEADERS} PARENT_SCOPE)
endfunction()

function(connextdds_rtiddsgen_convert)
    set(options NOT_REPLACE)
    set(single_args VAR FROM TO INPUT OUTPUT_DIRECTORY)
    set(multi_args INCLUDE_DIRS DEFINES EXTRA_ARGS DEPENDS)
    cmake_parse_arguments(_CODEGEN "${options}" "${single_args}" "${multi_args}" ${ARGN})
    connextdds_check_required_arguments(_CODEGEN_INPUT _CODEGEN_FROM _CODEGEN_TO)

    _connextdds_codegen_find_codegen()

    # Build the conversion related arguments
    if(_CODEGEN_FROM STREQUAL "IDL")
        set(input_arg -inputIdl "${_CODEGEN_INPUT}")
    elseif(_CODEGEN_FROM STREQUAL "XML")
        set(input_arg -inputXml "${_CODEGEN_INPUT}")
    elseif(_CODEGEN_FROM STREQUAL "XSD")
        set(input_arg -inputXsd "${_CODEGEN_INPUT}")
    else()
        message(FATAL_ERROR "Invalid FROM type: ${_CODEGEN_FROM}")
    endif()

    set(output_ext)
    if(_CODEGEN_TO STREQUAL "IDL")
        set(output_arg "-convertToIdl")
        set(output_ext "idl")
    elseif(_CODEGEN_TO STREQUAL "XML")
        set(output_arg "-convertToXml")
        set(output_ext "xml")
    elseif(_CODEGEN_TO STREQUAL "XSD")
        set(output_arg "-convertToXsd")
        set(output_ext "xsd")
    else()
        message(FATAL_ERROR "Invalid TO type: ${_CODEGEN_TO}")
    endif()

    # Build the preprocessor arguments
    set(include_dirs)
    foreach(dir ${_CODEGEN_INCLUDE_DIRS})
        list(APPEND include_dirs -I "${dir}")
    endforeach()

    set(defines)
    foreach(def ${_CODEGEN_DEFINES})
        list(APPEND defines -D${def})
    endforeach()

    # Build the optional arguments
    set(optional_args ${_CODEGEN_EXTRA_ARGS})
    if(NOT _CODEGEN_NOT_REPLACE)
        list(APPEND optional_args "-replace")
    endif()

    # Set the output directory
    # We create the directory at run-time in case it was deleted.
    set(output_dir)
    if(_CODEGEN_OUTPUT_DIRECTORY)
        set(output_dir "${_CODEGEN_OUTPUT_DIRECTORY}")
    else()
        get_filename_component(output_dir "${_CODEGEN_INPUT}" DIRECTORY)
    endif()

    # Define the output file in the variable
    get_filename_component(input_name "${_CODEGEN_INPUT}" NAME_WE)
    set(output_file "${output_dir}/${input_name}.${output_ext}")
    if(_CODEGEN_VAR)
        set(${_CODEGEN_VAR} "${output_file}" PARENT_SCOPE)
    endif()

    # Run CodeGen
    add_custom_command(
        OUTPUT
            "${output_file}"
        VERBATIM
        COMMENT "Generting from ${_CODEGEN_FROM}: ${output_file}"
        COMMAND
            ${CMAKE_COMMAND} -E make_directory ${output_dir}
        COMMAND
            ${CODEGEN_COMMAND}
                ${input_arg} ${output_arg}
                ${include_dirs} ${defines}
                -d ${output_dir}
                ${optional_args}
        DEPENDS
            ${CODEGEN_DEPENDS}
            "${_CODEGEN_INPUT}"
            ${_CODEGEN_DEPENDS}
    )
endfunction()
