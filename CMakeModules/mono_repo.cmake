######### load_all_components  ############################
# find all components declared in source tree
# add only selected(and their dependencies) in CMakeCache.txt

# call it in CMakeLists.txt root source dir
###########################################################
macro(load_all_components)
    file( GLOB_RECURSE project_files    component.cmake )
    _load_component_list("${project_files}")
endmacro()

######### import  ########################################
# replacement of find_package for monorepo build system
# use it in your CMakeLists.txt to declare dependency to another
# component in the build tree
###########################################################
macro(import component)

    get_property(my_list_content GLOBAL PROPERTY IMPORTED_COMPONENTS)

    if( ${component} IN_LIST  my_list_content )
        #already imported
    else()
        if(EXISTS ${CMAKE_SOURCE_DIR}/${component})
            _register_component(${component} )
            #import
            add_subdirectory( ${CMAKE_SOURCE_DIR}/${component} ${CMAKE_BINARY_DIR}/${component} )
        else()
            message( FATAL_ERROR "cannot import component ${component} ; directory doesnt exist")
        endif()
    endif()
endmacro()

############### declare_component ###########################
# for each component, create a file named component.cmake
# add call this macro with the name of the target as
# argument
#############################################################
macro(declare_component component)

    message("declare component located: ${CMAKE_CURRENT_LIST_DIR}")

    option( all_${component}_enable "Enable ${component}" FALSE )
    if( ${all_${component}_enable} )
            import( ${component} )
    endif()

endmacro()

#______________________________________________________________________
#                       private implementation
#______________________________________________________________________

include(Map)

######### IMPORTED_COMPONENTS Global LIST ########
define_property(GLOBAL PROPERTY IMPORTED_COMPONENTS
    BRIEF_DOCS "Global list of components"
    FULL_DOCS "Global list of components")
# Initialize property
set_property(GLOBAL PROPERTY IMPORTED_COMPONENTS "")

############### private macro _register_component ################
macro(_register_component var)

    set_property(GLOBAL APPEND PROPERTY IMPORTED_COMPONENTS "${var}")
endmacro(_register_component)



###################################################
function(_print_message_if_no_component_selected)
    get_property(my_list_content GLOBAL PROPERTY IMPORTED_COMPONENTS)

    if(NOT my_list_content)
        message(FATAL_ERROR " no component selected; select any in CMakeCache.txt    ")
    endif()
endfunction()


macro(_load_component_list components)
    message("****** ${components}")
    foreach( project_file ${components} )
        include( ${project_file} )
    endforeach()
    _print_message_if_no_component_selected()
endmacro()

