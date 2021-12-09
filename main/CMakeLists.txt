# ~~~
# SPDX-License-Identifier: BSD-3-Clause

# ~~~
#        Copyright The Authors 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)
# ~~~

# --------------------------------------------------------------------------------------------------
# Meta information about the this module
# --------------------------------------------------------------------------------------------------

asap_declare_module(
  MODULE_NAME
  "main"
  DESCRIPTION
  "Main module for the application program"
  GITHUB_REPO
  "https://github.com/asap-projects/asap-app"
  AUTHOR_MAINTAINER
  "Abdessattar Sassi"
  VERSION_MAJOR
  "1"
  VERSION_MINOR
  "0"
  VERSION_PATCH
  "0")

# ==================================================================================================
# Build instructions
# ==================================================================================================

# --------------------------------------------------------------------------------------------------
# Main module target
# --------------------------------------------------------------------------------------------------

# Hardcode `asap` in the module name as we do not want this prefix to change with the forked project
# name.
set(MODULE_TARGET_NAME "${META_PROJECT_NAME}")

asap_add_executable(
  ${MODULE_TARGET_NAME}
  WARNING
  SOURCES
  # Headers
  src/runner_base.h
  src/console_runner.h
  # Sources
  src/abstract_application.cpp
  src/detached_application.cpp
  src/runner_base.cpp
  src/console_runner.cpp
  src/main.cpp)

target_link_libraries(
  ${MODULE_TARGET_NAME}
  PRIVATE Microsoft.GSL::GSL
  PUBLIC ${META_PROJECT_NAME}::common ${META_PROJECT_NAME}::logging cxxopts)

target_include_directories(${MODULE_TARGET_NAME} PRIVATE ${CMAKE_BINARY_DIR}/include)
target_include_directories(${MODULE_TARGET_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

asap_add_sanitizers(${MODULE_TARGET_NAME})

# --------------------------------------------------------------------------------------------------
# Tests
# --------------------------------------------------------------------------------------------------

# if(OPTION_BUILD_TESTS) add_subdirectory(test) endif()

# --------------------------------------------------------------------------------------------------
# API Documentation
# --------------------------------------------------------------------------------------------------

asap_with_doxygen(
  ${META_PROJECT_NAME}_${META_MODULE_NAME} "\"Main Module\""
  "\"The main module for the application program.\""
  "${CMAKE_CURRENT_SOURCE_DIR}/src ${CMAKE_CURRENT_SOURCE_DIR}/include")

# asap_with_sphinx(${META_PROJECT_NAME}_${META_MODULE_NAME})

# ==================================================================================================
# Deployment instructions
# ==================================================================================================

#
# Deployment
#
# Executable
install(
  TARGETS ${MODULE_TARGET_NAME}
  RUNTIME DESTINATION ${INSTALL_BIN} COMPONENT programs
  BUNDLE DESTINATION ${INSTALL_BIN} COMPONENT programs)
