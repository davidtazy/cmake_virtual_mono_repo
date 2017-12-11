# cmake_virtual_mono_repo
implementation of cppcon2015 David Sankel: Big Projects, and CMake, and Git, Oh My!
https://youtu.be/3eH4hMKl7XE

*One build will build the project and all dependencies.*
*Only required dependencies are built.*

recipe:

in the root CMakeLists.txt :
```cmake_minimum_required(VERSION 3.3)

project(monorepo)

###### add and load monorepo script ########
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules)
include(mono_repo)

load_all_components()
```

* for each CMakeLists.txt in your source tree
    * use import(__dependency__) for each dependency u need (before target_link_libraries(__target__ __dependency__) )
    * create a file named component.cmake
    * for each __target__ created in CMakeLists.txt
        * append "declare_target(__target__)"

open CMakeCache.txt
select any __all_XXX_enabled__
this will add target XXX in build tree and all its dependencies.
