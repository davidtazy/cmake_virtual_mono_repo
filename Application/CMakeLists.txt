cmake_minimum_required(VERSION 3.2)

project(Application)

import(libA)

add_executable(Application main.cpp)
target_link_libraries(Application libA )
