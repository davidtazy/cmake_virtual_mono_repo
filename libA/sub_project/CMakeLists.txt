cmake_minimum_required(VERSION 3.3)

project(libAA)

add_library(libAA libAA.h libAA.cpp)
target_include_directories(libAA PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

