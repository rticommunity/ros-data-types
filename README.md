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
location, run `cmake` and specify the destination directory:
```bash
cmake .. -DCMAKE_INSTALL_PREFIX=/path/to/destination/installdirectory
```
After that, you can run `make install` to install the library in that location.

In addition, If you want to change the language of the library ( by default C++11 ) 
you can use the parameter `LANG`.That is:
```bash
cmake .. -DLANG=<C|C++|C++11>
```

## Using IDL ROS Types in Your Application

### Combining IDL ROS Types with Custom Types

You may use your own types combined with the types defined in this repository. 
If this is your choise you can obtain more information [here](example/README.md).
