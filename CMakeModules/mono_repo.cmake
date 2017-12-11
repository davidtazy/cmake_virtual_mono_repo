######### load_all_components  ################################
# find all components declared in source tree                 #
# add only selected(and their dependencies) in CMakeCache.txt #
# call it in CMakeLists.txt root source dir                   #
###############################################################
macro(load_all_components)
    file( GLOB_RECURSE project_files    component.cmake )
    _load_component_list("${project_files}")
endmacro()

######### import  ########################################
# replacement of find_package for monorepo build system
# use it in your CMakeLists.txt to declare dependency to another
# component in the build tree
# arg component should refer to a target created with add_executable or add_library
###########################################################
macro(import component)

    #import once
    if(NOT TARGET ${component})

        mcl_map(GET FOUND_COMPONENTS ${component} component_dir)

        if(component_dir)
            add_subdirectory( ${CMAKE_SOURCE_DIR}/${component_dir} ${CMAKE_BINARY_DIR}/${component_dir} )
            if(NOT TARGET ${component})
                message( FATAL_ERROR "import(${component}) failed\n ${CMAKE_SOURCE_DIR}/${component_dir}/CMakeLists.txt did not created target ${component} ; ")
            endif()
        else()
            message( FATAL_ERROR "cannot import component ${component} not found, you need to declare it")
        endif()
    endif()

endmacro()

############### declare_target ###########################
# for each target u want to depend to, create a file named component.cmake
# and call this macro
# arg component should refer to a target created with add_executable or add_library
# in the CMakeLists.txt sibling file
#############################################################
macro(declare_target component)

    file(RELATIVE_PATH buildDirRelFilePath "${CMAKE_SOURCE_DIR}" "${CMAKE_CURRENT_LIST_DIR}")

    # register component in the FOUND_COMPONENTS map
    mcl_map(SET FOUND_COMPONENTS "${component}" ${buildDirRelFilePath})

    # init CMakeCache.txt to let user select ${component}
    option( all_${component}_enable "Enable ${component}" FALSE )

    if( ${all_${component}_enable} )
        list(APPEND COMPONENTS_TO_IMPORT ${component} )
    endif()

endmacro()

#______________________________________________________________________
#                       private implementation
#______________________________________________________________________

include(_Map)

### global variables
mcl_map(MAKE FOUND_COMPONENTS GLOBAL)
set( COMPONENTS_TO_IMPORT "")


###################################################
function(_print_message_if_no_component_selected)

    if(NOT COMPONENTS_TO_IMPORT)
        message(FATAL_ERROR " no component selected; select any all_XXX_enabled in CMakeCache.txt    ")
    endif()
endfunction()


macro(_load_component_list components)

    # first pass :
    # fill FOUND_COMPONENTS map
    # fill COMPONENTS_TO_IMPORT list
    foreach( project_file ${components} )
        include( ${project_file} )
    endforeach()

    #todo change strategy: import all components if none selected
    _print_message_if_no_component_selected()

    # second pass:
    # import selected components and its dependancies
    foreach( component ${COMPONENTS_TO_IMPORT} )
        import( ${component} )
    endforeach()
endmacro()

