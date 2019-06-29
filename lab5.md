# CMake Tutorial
## Step 1
### Screenshot
![step1/step1.png](step1/step1.png)
## Step 2
### Screenshot
![step2/step2.png](step2/step2.png)
## Step 3
### CMakeLists.txt
Link: [step3/CMakeLists.txt](step3/CMakeLists.txt)
```cmake
add_library(MathFunctions mysqrt.cxx)
target_include_directories(MathFunctions
            INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
```
### Screenshot
![step3/step3.png](step3/step3.png)


## Step 4
### CMakeLists.txt
Link: [step4/CMakeLists.txt](step4/CMakeLists.txt)
```cmake
cmake_minimum_required(VERSION 3.3)
project(Tutorial)

set(CMAKE_CXX_STANDARD 14)

# should we use our own math functions
option(USE_MYMATH "Use tutorial provided math implementation" ON)

# the version number.
set(Tutorial_VERSION_MAJOR 1)
set(Tutorial_VERSION_MINOR 0)

set(CMAKE_INSTALL_PREFIX "./install")
# configure a header file to pass some of the CMake settings
# to the source code
configure_file(
  "${PROJECT_SOURCE_DIR}/TutorialConfig.h.in"
  "${PROJECT_BINARY_DIR}/TutorialConfig.h"
  )

# add the MathFunctions library?
if(USE_MYMATH)
  add_subdirectory(MathFunctions)
  list(APPEND EXTRA_LIBS MathFunctions)
endif(USE_MYMATH)

# add the executable
add_executable(Tutorial tutorial.cxx)

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )
install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h"
          DESTINATION include
          )


# enable testing
enable_testing()

# does the application run
add_test(NAME Runs COMMAND Tutorial 25)

# does the usage message work?
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number"
    )

# define a function to simplify adding tests
function(do_test target arg result)
add_test(NAME Comp${arg} COMMAND ${target} ${arg})
set_tests_properties(Comp${arg}
      PROPERTIES PASS_REGULAR_EXPRESSION ${result}
      )
endfunction(do_test)

# do a bunch of result based tests
do_test(Tutorial 25 "25 is 5")
do_test(Tutorial -25 "-25 is [-nan|♂|0]")
do_test(Tutorial 0.0001 "0.0001 is 0.01")
```

### MathFunctions/CMakeLists.txt
Link: [step4/MathFunctions/CMakeLists.txt](step4/MathFunctions/CMakeLists.txt)
```cmake
add_library(MathFunctions mysqrt.cxx)
# state that anybody linking to us needs to include the current source dir
# to find MathFunctions.h, while we don't.
target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          )
install (TARGETS MathFunctions DESTINATION bin)
install (FILES MathFunctions.h DESTINATION include)
```
### Screenshot
![step4/step4.png](step4/step4.png)


## Step 5
### CMakeLists.txt
Link: [step5/CMakeLists.txt](step5/CMakeLists.txt)
```cmake
cmake_minimum_required(VERSION 3.3)
project(Tutorial)

set(CMAKE_CXX_STANDARD 14)

# should we use our own math functions
option(USE_MYMATH "Use tutorial provided math implementation" ON)

# the version number.
set(Tutorial_VERSION_MAJOR 1)
set(Tutorial_VERSION_MINOR 0)

# configure a header file to pass some of the CMake settings
# to the source code
configure_file(
  "${PROJECT_SOURCE_DIR}/TutorialConfig.h.in"
  "${PROJECT_BINARY_DIR}/TutorialConfig.h"
  )

# does this system provide the log and exp functions?
include(CheckSymbolExists)
set(CMAKE_REQUIRED_LIBRARIES "m")
check_symbol_exists(log "math.h" HAVE_LOG)
check_symbol_exists(exp "math.h" HAVE_EXP)


# add the MathFunctions library?
if(USE_MYMATH)
  add_subdirectory(MathFunctions)
  list(APPEND EXTRA_LIBS MathFunctions)
endif()

# add the executable
add_executable(Tutorial tutorial.cxx)
target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )

# add the install targets
install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h"
  DESTINATION include
  )

# enable testing
enable_testing()

# does the application run
add_test(NAME Runs COMMAND Tutorial 25)

# does the usage message work?
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number"
  )

# define a function to simplify adding tests
function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result}
    )
endfunction(do_test)

# do a bunch of result based tests
do_test(Tutorial 4 "4 is 2")
do_test(Tutorial 9 "9 is 3")
do_test(Tutorial 5 "5 is 2.236")
do_test(Tutorial 7 "7 is 2.645")
do_test(Tutorial 25 "25 is 5")
do_test(Tutorial -25 "-25 is [-♂|♂|0]")
do_test(Tutorial 0.0001 "0.0001 is 0.01")

```
### MathFunctions/CMakeLists.txt
Link: [step5/MathFunctions/CMakeLists.txt](step5/MathFunctions/CMakeLists.txt)

```cmake
add_library(MathFunctions mysqrt.cxx)

# state that anybody linking to us needs to include the current source dir
# to find MathFunctions.h, while we don't.
target_include_directories(MathFunctions
          INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
          PRIVATE ${Tutorial_BINARY_DIR}
          )

install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)

```

### Screenshot
![step5/step5.png](step5/step5.png)

# Lab Example

## My Makefile (Mac OSX)
Link: [Makefile](Makefile)
```make
all: static_block dynamic_block 
program.o: ../program.c
	cc -c ../program.c -o program.o
libblock.a: libblock.o
	ar qc libblock.a libblock.o
libblock.o: ../source/block.c
	cc -c ../source/block.c -o libblock.o
static_block: program.o libblock.a
	cc program.o libblock.a -o static_block
dylibblock.o: ../source/block.c
	cc -fPIC -c ../source/block.c -o dylibblock.o
dylibblock.dylib: dylibblock.o
	cc -shared -o dylibblock.dylib dylibblock.o
dynamic_block: program.o dylibblock.dylib
	cc program.o dylibblock.dylib -o dynamic_block -Wl,-rpath .
```

## CMakeLists.txt
Link: [CMakeLists.txt](CMakeLists.txt)

```cmake
cmake_minimum_required(VERSION 3.0)
project(Block)
# Dynamic
add_library(dylibblock SHARED ../headers/block.h ../source/block.c)
add_executable(dynamic_block ../program.c)
target_link_libraries(dynamic_block dylibblock)
#Static
add_library(libblock STATIC ../headers/block.h ../source/block.c)
add_executable(static_block ../program.c)
target_link_libraries(static_block libblock)
```

## CMake Makefile
Link: [CMakeMakefile](CMakeMakefile)

```make
# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Default target executed when no arguments are given to make.
default_target: all

.PHONY : default_target

# Allow only one "make -f Makefile2" at a time, but pass parallelism.
.NOTPARALLEL:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CMake.app/Contents/bin/cmake

# The command to remove a file.
RM = /Applications/CMake.app/Contents/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/maoyuwang/Desktop/Lab-Example/build

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/maoyuwang/Desktop/Lab-Example/build

#=============================================================================
# Targets provided globally by CMake.

# Special rule for the target rebuild_cache
rebuild_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake to regenerate build system..."
	/Applications/CMake.app/Contents/bin/cmake -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : rebuild_cache

# Special rule for the target rebuild_cache
rebuild_cache/fast: rebuild_cache

.PHONY : rebuild_cache/fast

# Special rule for the target edit_cache
edit_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake cache editor..."
	/Applications/CMake.app/Contents/bin/ccmake -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : edit_cache

# Special rule for the target edit_cache
edit_cache/fast: edit_cache

.PHONY : edit_cache/fast

# The main all target
all: cmake_check_build_system
	$(CMAKE_COMMAND) -E cmake_progress_start /Users/maoyuwang/Desktop/Lab-Example/build/CMakeFiles /Users/maoyuwang/Desktop/Lab-Example/build/CMakeFiles/progress.marks
	$(MAKE) -f CMakeFiles/Makefile2 all
	$(CMAKE_COMMAND) -E cmake_progress_start /Users/maoyuwang/Desktop/Lab-Example/build/CMakeFiles 0
.PHONY : all

# The main clean target
clean:
	$(MAKE) -f CMakeFiles/Makefile2 clean
.PHONY : clean

# The main clean target
clean/fast: clean

.PHONY : clean/fast

# Prepare targets for installation.
preinstall: all
	$(MAKE) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall

# Prepare targets for installation.
preinstall/fast:
	$(MAKE) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall/fast

# clear depends
depend:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 1
.PHONY : depend

#=============================================================================
# Target rules for targets named dynamic_block

# Build rule for target.
dynamic_block: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 dynamic_block
.PHONY : dynamic_block

# fast build rule for target.
dynamic_block/fast:
	$(MAKE) -f CMakeFiles/dynamic_block.dir/build.make CMakeFiles/dynamic_block.dir/build
.PHONY : dynamic_block/fast

#=============================================================================
# Target rules for targets named static_block

# Build rule for target.
static_block: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 static_block
.PHONY : static_block

# fast build rule for target.
static_block/fast:
	$(MAKE) -f CMakeFiles/static_block.dir/build.make CMakeFiles/static_block.dir/build
.PHONY : static_block/fast

#=============================================================================
# Target rules for targets named libblock

# Build rule for target.
libblock: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 libblock
.PHONY : libblock

# fast build rule for target.
libblock/fast:
	$(MAKE) -f CMakeFiles/libblock.dir/build.make CMakeFiles/libblock.dir/build
.PHONY : libblock/fast

#=============================================================================
# Target rules for targets named dylibblock

# Build rule for target.
dylibblock: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 dylibblock
.PHONY : dylibblock

# fast build rule for target.
dylibblock/fast:
	$(MAKE) -f CMakeFiles/dylibblock.dir/build.make CMakeFiles/dylibblock.dir/build
.PHONY : dylibblock/fast

Users/maoyuwang/Desktop/Lab-Example/program.o: Users/maoyuwang/Desktop/Lab-Example/program.c.o

.PHONY : Users/maoyuwang/Desktop/Lab-Example/program.o

# target to build an object file
Users/maoyuwang/Desktop/Lab-Example/program.c.o:
	$(MAKE) -f CMakeFiles/dynamic_block.dir/build.make CMakeFiles/dynamic_block.dir/Users/maoyuwang/Desktop/Lab-Example/program.c.o
	$(MAKE) -f CMakeFiles/static_block.dir/build.make CMakeFiles/static_block.dir/Users/maoyuwang/Desktop/Lab-Example/program.c.o
.PHONY : Users/maoyuwang/Desktop/Lab-Example/program.c.o

Users/maoyuwang/Desktop/Lab-Example/program.i: Users/maoyuwang/Desktop/Lab-Example/program.c.i

.PHONY : Users/maoyuwang/Desktop/Lab-Example/program.i

# target to preprocess a source file
Users/maoyuwang/Desktop/Lab-Example/program.c.i:
	$(MAKE) -f CMakeFiles/dynamic_block.dir/build.make CMakeFiles/dynamic_block.dir/Users/maoyuwang/Desktop/Lab-Example/program.c.i
	$(MAKE) -f CMakeFiles/static_block.dir/build.make CMakeFiles/static_block.dir/Users/maoyuwang/Desktop/Lab-Example/program.c.i
.PHONY : Users/maoyuwang/Desktop/Lab-Example/program.c.i

Users/maoyuwang/Desktop/Lab-Example/program.s: Users/maoyuwang/Desktop/Lab-Example/program.c.s

.PHONY : Users/maoyuwang/Desktop/Lab-Example/program.s

# target to generate assembly for a file
Users/maoyuwang/Desktop/Lab-Example/program.c.s:
	$(MAKE) -f CMakeFiles/dynamic_block.dir/build.make CMakeFiles/dynamic_block.dir/Users/maoyuwang/Desktop/Lab-Example/program.c.s
	$(MAKE) -f CMakeFiles/static_block.dir/build.make CMakeFiles/static_block.dir/Users/maoyuwang/Desktop/Lab-Example/program.c.s
.PHONY : Users/maoyuwang/Desktop/Lab-Example/program.c.s

Users/maoyuwang/Desktop/Lab-Example/source/block.o: Users/maoyuwang/Desktop/Lab-Example/source/block.c.o

.PHONY : Users/maoyuwang/Desktop/Lab-Example/source/block.o

# target to build an object file
Users/maoyuwang/Desktop/Lab-Example/source/block.c.o:
	$(MAKE) -f CMakeFiles/libblock.dir/build.make CMakeFiles/libblock.dir/Users/maoyuwang/Desktop/Lab-Example/source/block.c.o
	$(MAKE) -f CMakeFiles/dylibblock.dir/build.make CMakeFiles/dylibblock.dir/Users/maoyuwang/Desktop/Lab-Example/source/block.c.o
.PHONY : Users/maoyuwang/Desktop/Lab-Example/source/block.c.o

Users/maoyuwang/Desktop/Lab-Example/source/block.i: Users/maoyuwang/Desktop/Lab-Example/source/block.c.i

.PHONY : Users/maoyuwang/Desktop/Lab-Example/source/block.i

# target to preprocess a source file
Users/maoyuwang/Desktop/Lab-Example/source/block.c.i:
	$(MAKE) -f CMakeFiles/libblock.dir/build.make CMakeFiles/libblock.dir/Users/maoyuwang/Desktop/Lab-Example/source/block.c.i
	$(MAKE) -f CMakeFiles/dylibblock.dir/build.make CMakeFiles/dylibblock.dir/Users/maoyuwang/Desktop/Lab-Example/source/block.c.i
.PHONY : Users/maoyuwang/Desktop/Lab-Example/source/block.c.i

Users/maoyuwang/Desktop/Lab-Example/source/block.s: Users/maoyuwang/Desktop/Lab-Example/source/block.c.s

.PHONY : Users/maoyuwang/Desktop/Lab-Example/source/block.s

# target to generate assembly for a file
Users/maoyuwang/Desktop/Lab-Example/source/block.c.s:
	$(MAKE) -f CMakeFiles/libblock.dir/build.make CMakeFiles/libblock.dir/Users/maoyuwang/Desktop/Lab-Example/source/block.c.s
	$(MAKE) -f CMakeFiles/dylibblock.dir/build.make CMakeFiles/dylibblock.dir/Users/maoyuwang/Desktop/Lab-Example/source/block.c.s
.PHONY : Users/maoyuwang/Desktop/Lab-Example/source/block.c.s

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if の target is provided)"
	@echo "... clean"
	@echo "... depend"
	@echo "... rebuild_cache"
	@echo "... edit_cache"
	@echo "... dynamic_block"
	@echo "... static_block"
	@echo "... libblock"
	@echo "... dylibblock"
	@echo "... Users/maoyuwang/Desktop/Lab-Example/program.o"
	@echo "... Users/maoyuwang/Desktop/Lab-Example/program.i"
	@echo "... Users/maoyuwang/Desktop/Lab-Example/program.s"
	@echo "... Users/maoyuwang/Desktop/Lab-Example/source/block.o"
	@echo "... Users/maoyuwang/Desktop/Lab-Example/source/block.i"
	@echo "... Users/maoyuwang/Desktop/Lab-Example/source/block.s"
.PHONY : help



#=============================================================================
# Special targets to cleanup operation of make.

# Special rule to run CMake to check the build system integrity.
# の rule that depends on this can have commands that come from listfiles
# because they might be regenerated.
cmake_check_build_system:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 0
.PHONY : cmake_check_build_system

```

## File size between two executables

| Filename | Size (Bytes) |
| --- | --- |
| dynamic_block | 8448 |
| static_block | 8528 |

## Running Results
### dynamic_block
![dynamic_block.png](dynamic_block.png)

### static_block
![static_block.png](static_block.png)


