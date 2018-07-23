# ROS Types

This repository contains a set of widely-used ROS Messages in
[OMG IDL](https://www.omg.org/spec/IDL) format.

Message types are organized in modules that contain types ranging from general-purpose (e.g., `std_msgs`) to domain-specific types (e.g.,
`trajectory_msgs`).

## Building IDL ROS Types

This repository provides CMake scripts that enable you to create a library
containing all the necessary `TypeSupport` and `TypePlugin` classes for the
most well-known ROS Messages.

To generate the library, first run CMake on a `build` folder (i.e., we are
going to do an out-of-source build):

```bash
mkdir build; cd build
cmake ..
```

Next, run the created build scripts. On Unix, that implies using GNU `make`:

```bash
make
```

(On Windows, you will need to build the generated Visual Studio solution
instead.)

As a result of these commands, the generated build system will run `rtiddsgen`
to generate code, and the corresponding compiler to create the type library.

If you want to copy the resulting library and header files to a different
location, run `make install` and specify the destination directory:

```bash
make DESTDIR=/path/to/destination/directory install
```

## Using IDL ROS Types in Your Application

### Combining IDL ROS Types with Custom Types

You may combine the types defined in this repository with your own types in
custom IDL files.

First, include the IDL file containing the definition of the type you want to
use in your custom type (e.g., `trajectory_msgs::msg::JointTrajectory`):

```cpp
// MyCustomType.idl
#include "trajectory_msgs/msg/JointTrajectory.idl"

struct MyCustomType {
    // ...
    trajectory_msgs::msg::JointTrajectory joint_trajectory;
    // ...
};
```

Next, use `rtiddsgen` to generate `TypePlugin` and `TypeSupport` classes for
both your type, and all the types you use in your type definition. That is:

```bash
rtiddsgen -language <C|C++|Java> \
    MyCustomType.idl \
    trajectory_msgs/msg/JointTrajectory.idl \
    trajectory_msgs/msg/JointTrajectoryPoint.idl \
    std_msgs/msg/Duration.idl \
    ...
```

Finally, once you have generated all the `TypePlugin` and `TypeSupport`, you
will need to link them into your application. If you are using CMake, simply
use the generated header and source files as part of your library or executable
in your `add_library()` or `add_executable()` call.
