# ROS Data Types

This repository contains a rich set of ROS data types in
[OMG IDL](https://www.omg.org/spec/IDL) format. These types enable you to
create native DDS applications capable of interoperating with ROS 2
applications using equivalent message types.

ROS data types are organized in different modules, and include both
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

Moreover, the repository includes examples that describe how to use the ROS
data types in a DDS applications. You will find these examples under the
`examples` folder.

```bash
ros-data-types/
├── examples
```

## Building ROS Type Library

The ROS Types repository repository provides a set of CMake files to generate
a library containing all the `TypeSupport` and `TypePlugin` classes
that are required to build DDS applications capable of sending ROS messages.

### Configuring CMake Project

To generate the library, first run `cmake` from a subfolder. This process will
create all the build constructs (e.g., Makefiles or Visual Studio solutions)
that are required to build the library.

```bash
cd ros-data-types
mkdir build; cd build
cmake ..
```

By default, the project will generate a type library for C++11. If you want to
generate a type library for a different language, use the the parameter `LANG`
as part of your `cmake` invocation:

```bash
cmake -DLANG=<C|C++|C++11> ..
```

### Building Type Library

Next, run the created build constructs. On Unix, that implies using GNU `make`:

```bash
make
```

(On Windows, you will need to build the generated Visual Studio solution
instead.)

### Installing Type Library

If you want to copy the resulting library and header files to a different
location, run `cmake` and specify the destination directory:

```bash
cmake -DCMAKE_INSTALL_PREFIX=/path/to/installation/directory ..
```

After that, you can run `make install` to install the library in that location:

```bash
make install
```
