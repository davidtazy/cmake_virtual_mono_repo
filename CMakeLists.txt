cmake_minimum_required(VERSION 3.3)

project(monorepo)


##### generate component.cmake files
# add this macro in your CMakeLists.txt root file
#macro(add_library name)
#        message("add_library ${name}")
#        _add_library(${name} "${ARGN}")
#        file(APPEND ${CMAKE_CURRENT_LIST_DIR}/component.cmake "declare_target(${name})\n")
#endmacro()


#macro(target_link_libraries name)
#    file(APPEND ${CMAKE_SOURCE_DIR}/target_list.csv "${CMAKE_CURRENT_LIST_DIR};${ARGN}\n")
#    _target_link_libraries(${name} "${ARGN}" )

#endmacro()

####generate file with all dependencies of each CMakeLists.txt
# add this macro in your CMakeLists.txt root file
#it is the entry point of import_components.py
#macro(target_link_libraries name)
#    file(APPEND ${CMAKE_SOURCE_DIR}/target_list.csv "${CMAKE_CURRENT_LIST_DIR};${ARGN}\n")
#    _target_link_libraries(${name} "${ARGN}" )

#endmacro()





###### add and load monorepo script ########
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules)
include(mono_repo)

load_all_components()
