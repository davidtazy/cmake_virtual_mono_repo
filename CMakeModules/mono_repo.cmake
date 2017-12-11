

include(Map)

######### IMPORTED_COMPONENTS Global LIST ########
define_property(GLOBAL PROPERTY IMPORTED_COMPONENTS
    BRIEF_DOCS "Global list of components"
    FULL_DOCS "Global list of components")
# Initialize property
set_property(GLOBAL PROPERTY IMPORTED_COMPONENTS "")

############### private macro register_component ################
macro(register_component var)

    set_property(GLOBAL APPEND PROPERTY IMPORTED_COMPONENTS "${var}")
endmacro(register_component)

###################################################
function(print_message_if_no_component_selected)
    get_property(my_list_content GLOBAL PROPERTY IMPORTED_COMPONENTS)

    if(NOT my_list_content)
        message(FATAL_ERROR " no component selected; select any in CMakeCache.txt    ")
    endif()
endfunction()

######### import  ########################################
# replacement of find_package for monorepo build system
###########################################################
macro(import component)

    get_property(my_list_content GLOBAL PROPERTY IMPORTED_COMPONENTS)

    if( ${component} IN_LIST  my_list_content )
        #already imported
    else()
        if(EXISTS ${CMAKE_SOURCE_DIR}/${component})
            register_component(${component} )
            #import
            add_subdirectory( ${CMAKE_SOURCE_DIR}/${component} ${CMAKE_BINARY_DIR}/${component} )
        else()
            message( FATAL_ERROR "cannot import component ${component} ; directory doesnt exist")
        endif()
    endif()
endmacro()

macro(declare_component component)

    message("declare component located: ${CMAKE_CURRENT_LIST_DIR}")

    option( all_${component}_enable "Enable ${component}" FALSE )
    if( ${all_${component}_enable} )
            import( ${component} )
    endif()

endmacro()



##########################################################################
##### find all component.cmake in first level subdirectories##############
file( GLOB project_files
        ${CMAKE_CURRENT_SOURCE_DIR}/*/component.cmake
)

#########################################################
##### find all component.cmake in all tree ##############
#file( GLOB_RECURSE project_files    component.cmake )

message("/////////////////////\n ${project_files} \n//////////////////////\n")

foreach( project_file ${project_files} )
        include( ${project_file} )
endforeach()
print_message_if_no_component_selected()


MACRO(INSERT_INTO_MAP _KEY _VALUE)
  SET("MyMap_${_KEY}" "${_VALUE}")
ENDMACRO(INSERT_INTO_MAP)

SET(MyKey "foo")
SET(MyValue "bar")
#INSERT_INTO_MAP("${MyKey}" "${MyValue}")
