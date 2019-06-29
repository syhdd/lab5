cmake_minimum_required (VERSION 3.3)
project (Exercise)

add_library(shared SHARED ../headers/block.h ../source/block.c)
add_library(static STATIC ../headers/block.h ../source/block.c)

add_executable(dynamic_block ../program.c)
add_executable(static_block ../program.c)

target_link_libraries(dynamic_block shared)
target_link_libraries(static_block static)
