cmake_minimum_required(VERSION 3.3)

project(libA)

import(libB)

add_library(libA libA.h libA.cpp)
target_link_libraries(libA libB)
target_include_directories(libA PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

