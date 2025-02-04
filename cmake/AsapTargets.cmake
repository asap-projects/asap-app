# ~~~
# SPDX-License-Identifier: BSD-3-Clause

# ~~~
#        Copyright The Authors 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)
# ~~~

include(CMakePackageConfigHelpers)
include(common/SwiftTargets)
include(CompileDefinitions)

# --------------------------------------------------------------------------------------------------
# Meta information about the this module
# --------------------------------------------------------------------------------------------------

macro(asap_declare_module)
  set(options)
  set(oneValueArgs
      MODULE_NAME
      DESCRIPTION
      GITHUB_REPO
      AUTHOR_MAINTAINER
      VERSION_MAJOR
      VERSION_MINOR
      VERSION_PATCH)
  set(multiValueArgs)

  cmake_parse_arguments(x "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT DEFINED x_MODULE_NAME)
    message(FATAL_ERROR "Module name is required.")
    return()
  endif()
  if(NOT
     (DEFINED x_VERSION_MAJOR
      AND DEFINED x_VERSION_MINOR
      AND DEFINED x_VERSION_PATCH))
    message(
      FATAL_ERROR "PLease specify all of VERSION_MAJOR VERSION_MINOR VERSION_PATCH for the module.")
    return()
  endif()

  # cmake-format: off
  set(META_MODULE_NAME                "${x_MODULE_NAME}")
  set(META_MODULE_DESCRIPTION         "${x_DESCRIPTION}")
  set(META_MODULE_GITHUB_REPO         "${x_GITHUB_REPO}")
  set(META_MODULE_AUTHOR_MAINTAINER   "${x_AUTHOR_MAINTAINER}")
  set(META_MODULE_VERSION_MAJOR       "${x_VERSION_MAJOR}")
  set(META_MODULE_VERSION_MINOR       "${x_VERSION_MINOR}")
  set(META_MODULE_VERSION_PATCH       "${x_VERSION_PATCH}")
  set(META_MODULE_VERSION             "${META_MODULE_VERSION_MAJOR}.${META_MODULE_VERSION_MINOR}.${META_MODULE_VERSION_PATCH}")
  set(META_MODULE_NAME_VERSION        "${META_MODULE_PROJECT_NAME} v${META_MODULE_VERSION}")
  # cmake-format: on
  message("=> [module: ${META_PROJECT_NAME}/${META_MODULE_NAME} ${META_MODULE_VERSION}]")

endmacro()

# --------------------------------------------------------------------------------------------------
# CMake package config
# --------------------------------------------------------------------------------------------------

macro(_module_cmake_config_files)
  set(TARGETS_EXPORT_NAME "${MODULE_TARGET_NAME}Targets")

  # generate the config file that includes the exports
  configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${MODULE_TARGET_NAME}Config.cmake"
    INSTALL_DESTINATION "${ASAP_INSTALL_CMAKE}/${META_MODULE_NAME}"
    PATH_VARS META_MODULE_VERSION MODULE_TARGET_NAME)

  # generate the version file for the config file
  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${MODULE_TARGET_NAME}ConfigVersion.cmake"
    VERSION "${META_MODULE_VERSION}"
    COMPATIBILITY AnyNewerVersion)
endmacro()

# --------------------------------------------------------------------------------------------------
# Pkg-config file.
# --------------------------------------------------------------------------------------------------

macro(_module_pkgconfig_files)
  set(MODULE_PKGCONFIG_FILE ${MODULE_TARGET_NAME}.pc)
  get_target_property(TARGET_DEBUG_POSTFIX ${MODULE_TARGET_NAME} DEBUG_POSTFIX)
  set(MODULE_LINK_LIBS "-l${MODULE_TARGET_NAME}${TARGET_DEBUG_POSTFIX}")
  configure_file(config.pc.in ${CMAKE_CURRENT_BINARY_DIR}/${MODULE_PKGCONFIG_FILE} @ONLY)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${MODULE_PKGCONFIG_FILE}
          DESTINATION ${ASAP_INSTALL_PKGCONFIG})
endmacro()

macro(asap_add_library target)
  swift_add_library("${target}" ${ARGN})

  # We can refer to this target either with its standalone target name or with a project scoped name
  # (<project>::<module>) which we will alias to the target name.
  add_library("${META_PROJECT_NAME}::${META_MODULE_NAME}" ALIAS ${MODULE_TARGET_NAME})
  asap_set_compile_definitions(${target})

  set_target_properties(
    ${MODULE_TARGET_NAME}
    PROPERTIES FOLDER "Libraries"
               VERSION ${META_MODULE_VERSION}
               SOVERSION ${META_MODULE_VERSION_MAJOR}
               DEBUG_POSTFIX "d")

  # Generate export headers for the library
  asap_generate_export_headers(${MODULE_TARGET_NAME} ${META_MODULE_NAME})

  _module_cmake_config_files()
  _module_pkgconfig_files()
endmacro()

macro(asap_add_executable target)
  swift_add_executable("${target}" ${ARGN})
endmacro()

macro(asap_add_tool target)
  swift_add_tool("${target}" ${ARGN})
endmacro()

macro(asap_add_tool_library target)
  swift_add_tool_library("${target}" ${ARGN})
endmacro()

macro(asap_add_test_library target)
  swift_add_test_library("${target}" ${ARGN})
endmacro()
