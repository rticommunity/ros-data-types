# Combining IDL ROS Types with Custom Types

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

Next, you need to generate `TypePlugin` and `TypeSupport` classes for your type. 
You have two options to do it, using `rtiddsgen` or in the case that you use 
CMake you can also use the macro 
`connextdds_generate_ros_dds_types`.

#### Using rtiddsgen

In this option, you need to use the tool `rtiddsgen` to generate the mentioned 
classes for your type. That is:

```bash
rtiddsgen -language <C|C++|C++11> \
    MyCustomType.idl \
    -I /path/to/directory/idldirectory
    ...
```

#### Using macro 
In this option, you need to call the macro `connextdds_generate_ros_dds_types` 
to generate the mentioned classes for your type. That is:

```
include(ConnextDdsRosDdsTypes)

....

connextdds_generate_ros_dds_types(
    LANG <C|C++|C++11>
    OUTPUT_DIRECTORY <output directory>
    IDL_FILES <list of files>
    INCLUDE_DIRS </path/to/idldirectory>
)

....
```

Finally, once you have generated the `TypePlugin` and `TypeSupport`, you
will need to link them into your application. If you are using CMake, simply
use the generated header and source files as part of your library or executable
in your `add_library()` or `add_executable()` call. In addition, you need to 
add in the command `target_include_directories` the directory that 
contains all the `TypePlugin` and `TypeSupport` of the library.
Finally, you have to link your library or executable against the rosddstype library. 
You can see an example of CMakeLists [here](CMakeLists.txt).
