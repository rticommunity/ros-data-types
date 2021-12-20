# ROS Data Types

This repository contains a rich set of ROS data types in
[OMG IDL](https://www.omg.org/spec/IDL) format. These types enable you to
create native DDS applications capable of interoperating with ROS 2
applications using the equivalent
[common interfaces](https://github.com/ros2/common_interfaces).

ROS data types are organized in different modules, including both
general-purpose types (e.g., `std_msgs`) and domain-specific types (e.g.,
`trajectory_msgs`).

```bash
ros-data-types/
├── diagnostic_msgs
├── gazebo_msgs
├── geometry_msgs
├── lifecycle_msgs
├── nav_msgs
├── pendulum_msgs
├── sensor_msgs
├── shape_msgs
├── std_msgs
├── stereo_msgs
├── test_msgs
├── tf2_msgs
├── trajectory_msgs
└── visualization_msgs
```

For more information on the original ROS 2 common interfaces, please refer to
this [repository](https://github.com/ros2/common_interfaces).

This repository also includes data type definitions for topics that are *ROS2 internal*, 
for supporting ROS2 parameters, actions, RCL and RMW, etc., thus enabling non-ROS2 
Connext DDS applications full access and interoperability with any ROS2 component, 
module, tool, visualizer, etc.


## Building ROS Type Library

The ROS Types repository repository provides a set of CMake files to generate
a library containing all the `TypeSupport` and `TypePlugin` classes
that are required to build DDS applications capable of sending ROS messages.

### Configuring CMake Project

To generate the library, first run `cmake` from a subfolder. This process will
create all the build constructs (e.g., Makefiles or Visual Studio solutions)
that are required to build the library.  
**Be sure to include the Connext DDS installation directory in your path before proceeding**
This can be added to the current command shell by using the `rtisetenv_<arch>` script 
included with Connext, such as:  

**Linux:**
```sh
~/rti_connext_dds-6.0.1/resource/scripts/rtisetenv_x64Linux4gcc7.3.0.bash
```

**Windows:**
```sh
"C:\Program Files\rti_connext_dds-6.0.1\resource\scripts\rtisetenv_x64Win64VS2017.bat"
```

Windows builds can also benefit from running the `vcvars<option>.bat` script before building,
such as `vcvarsall.bat`, to add Visual Studio to the PATH.


**Run CMake to generate the build files**
```bash
cd ros-data-types
mkdir build; cd build
cmake ..
```

**CMake Options**  
Optional arguments may be passed to CMake to control the build or correct errors, including:  


**ROS2 unbounded variables**  
ROS2 uses UNBOUNDED strings and sequences by default; this library can also be built to use
UNBOUNDED vars by passing the `-DUNBOUNDED_ALL=ON` switch on the command line, as in:
```sh
cmake -DUNBOUNDED_ALL=ON ..
``` 

**RTI Connext Target Type**  
If your RTI Connext installation includes support for multiple target platform types, a 
specific target may be specified by adding the `-DCONNEXTDDS_ARCH=<arch>` switch, where
`<arch>` is set to your desired build target, such as `x64Linux4gcc7.3.0`, `x64Win64VS2017`, etc. 


**Debug or Release Build**  
DEBUG build is enabled by default.  To build for RELEASE, use the parameter `CMAKE_BUILD_TYPE=Release`
definition as part of your `cmake` invocation, as in:
```sh
cmake -DCMAKE_BUILD_TYPE=Release ..
```

**Language**  
By default, the project will generate a type library for C++11. If you want to
generate a type library for a different language, use the the parameter `LANG`
as part of your `cmake` invocation:

```bash
cmake -DLANG=<C|C++|C++11> ..
```

These CMake arguments shall be combined into a single command line, as in:
```sh
cmake -DCMAKE_BUILD_TYPE=Release -DUNBOUNDED_ALL=ON ..
```


### Building the Type Library

Next, run the created build constructs. On **Unix**, that implies using GNU `make`:

```bash
make
```

On **Windows**, you will need to build the generated Visual Studio solution instead:

```sh
  msbuild ros-types.sln </Flags>
```
or:
```sh
  devenv ros-types.sln
```
to launch the Visual Studio IDE


### Installing the Type Library

If you want to copy the resulting library and header files to a different
location, run `cmake` and specify the destination directory:

```bash
cmake -DCMAKE_INSTALL_PREFIX=/path/to/installation/directory ..
```

After that, you can run `make install` to install the library in that location:

```bash
make install
```

## Using ROS Data Types in Your Application

In this section we explain how to use the ROS data types in defined in this
repository in the declaration of custom types.

### Defining a Custom Type

In this example we show how to define a custom type named `MyCustomType` that
combines native DDS types with types included in the ROS data type library.

#### Custom Type Definition

The IDL definition of `MyCustomType` is the following:

```cpp
// MyCustomType.idl
#include "trajectory_msgs/msg/JointTrajectory.idl"

struct MyCustomType {
    @key short object_id;
    trajectory_msgs::msg::JointTrajectory joint_trajectory;
};
```

Note that to use `trajectory_msgs::msg::JointTrajectory` in the definition of
our type, we must first include `trajectory_msgs/msg/JointTrajectory.idl`, which 
is the IDL file where the original type was defined.

#### Generating TypePlugin and TypeSupport Classes

To run the example, you must generate `TypePlugin` and `TypeSupport`
classes for the custom type. To do so, you can either use `rtiddsgen` directly
or -- if you are using CMake -- call the CMake macro 
`connextdds_generate_ros_dds_types` defined in
resources/cmake/ConnextDdsRosDdsTypes.cmake`.

##### Generating Code Using rtiddsgen

To generate the support files using `rtiddsgen` run:

```bash
rtiddsgen -language <C|C++|C++11> \
    MyCustomType.idl \
    -I/path/to/directory/ros/types/directory
    ...
```

Note that you will need to provide the path to the directory where you
installed the library; that is, the path to the parent directory of
`trajectory_msgs/msg/JointTrajectory.idl`.

##### Generating Code Using CMake Macro

To use the macro `connextdds_generate_ros_dds_types`, you will need to include
`ConnextDdsRosDdsTypes.cmake` from your CMake file:

```cmake
include(ConnextDdsRosDdsTypes)

# ...

connextdds_generate_ros_dds_types(
    LANG <C|C++|C++11>
    OUTPUT_DIRECTORY <output directory>
    IDL_FILES <list of files>
    INCLUDE_DIRS </path/to/directory/ros/types/directory>
)

# ...
```

Note that you will need to provide the path to the directory where you
installed the library; that is, the path to the parent directory of
`trajectory_msgs/msg/JointTrajectory.idl`.

#### Build Example Application

Once you have generated the `TypePlugin` and `TypeSupport` classes, you will
need to compile and link them into into your application. If you are using
CMake, simply add the generated header and source files to your library or
executable using `add_library()` or `add_executable()`. In addition, you will
need to link the application against the rosddstype library, which contains the
type plugin and support classes for the original ROS data types.
