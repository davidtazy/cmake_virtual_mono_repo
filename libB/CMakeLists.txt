cmake_minimum_required(VERSION 3.3)

project(libB)

add_library(libB libB.h libB.cpp)
target_include_directories(libB PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
