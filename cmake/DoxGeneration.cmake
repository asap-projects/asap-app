# ~~~
# SPDX-License-Identifier: BSD-3-Clause

# ~~~
#        Copyright The Authors 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)
# ~~~


# --------------------------------------------------------------------------------------------------
# API Documentation
# --------------------------------------------------------------------------------------------------

# To avoid indiscriminately generating documentation for all modules in the project, including third
# party modules and stuff for which we don't want documentation to be generated, we provide here the
# basic tools to add doxygen capabilities to a module.
#
# To use in a specific CmakeLists.txt add the following:
#
# ~~~
#      asap_with_doxygen(
#        ${target}
#        "\"<Title>\""
#        "\"<Desscription>\""
#        "<List of directories to include>")
# ~~~
#
# Use 'make dox' to generate documentation. (not done by default)
#

include(FindDoxygen)

if(DOXYGEN_FOUND)
  message(STATUS "Doxygen package was found.")

  macro(_configure_doxyfile TARGET_NAME TARGET_TITLE TARGET_BRIEF TARGET_INPUT_PATH)
    if(EXISTS "${CMAKE_SOURCE_DIR}/doxygen/Doxyfile.in")
      set(DOXY_TARGET_OUTPUT_DIR "${TARGET_NAME}")
      set(DOXY_TARGET_ROOT_DIR "") # ${DOXTOSRCDIR} - set(DOXTOSRCDIR "../src")
      set(DOXY_TARGET_NAME "${TARGET_NAME}")
      set(DOXY_TARGET_TITLE "${TARGET_TITLE}")
      set(DOXY_TARGET_BRIEF "${TARGET_BRIEF}")
      set(DOXY_TARGET_INPUT_PATH "${TARGET_INPUT_PATH}")
      set(DOXY_COMPILER_PREDEFINED "${TARGET_COMPILER_DEFINES}")
      set(DOXY_TARGET_FILE_VERSION_FILTER "\"${PRINT_FILE_DATE_COMMAND_STR} \"")
      if(NOT EXISTS "${DOXYGEN_BUILD_DIR}/${DOXY_TARGET_OUTPUT_DIR}")
        file(MAKE_DIRECTORY "${DOXYGEN_BUILD_DIR}/${DOXY_TARGET_OUTPUT_DIR}")
      endif()
      configure_file("${CMAKE_SOURCE_DIR}/doxygen/Doxyfile.in"
                     "${DOXYGEN_BUILD_DIR}/${TARGET_NAME}_Doxyfile" @ONLY)
    else()
      message(STATUS "WARNING: The '${CMAKE_SOURCE_DIR}/doxygen/Doxyfile.in' file does not exist!")
    endif()
  endmacro()

  macro(_add_doxygen_target TARGET_NAME)
    add_custom_target(
      ${TARGET_NAME}_dox
      COMMAND ${CMAKE_COMMAND} -E remove -f "${TARGET_NAME}_Doxyfile.out"
      COMMAND ${CMAKE_COMMAND} -E copy "${TARGET_NAME}_Doxyfile" "${TARGET_NAME}_Doxyfile.out"
      COMMAND ${DOXYGEN_EXECUTABLE} "${TARGET_NAME}_Doxyfile.out"
      COMMAND ${CMAKE_COMMAND} -E remove -f "${TARGET_NAME}_Doxyfile.out"
      WORKING_DIRECTORY "${DOXYGEN_BUILD_DIR}"
      COMMENT "Generating doxygen documentation for \"${TARGET_NAME}\""
      VERBATIM)
    set_target_properties(${TARGET_NAME}_dox PROPERTIES EXCLUDE_FROM_ALL TRUE)
    add_dependencies(dox ${TARGET_NAME}_dox)
  endmacro()

  macro(asap_with_doxygen TARGET_NAME TARGET_TITLE TARGET_BRIEF TARGET_INPUT_PATH)
    # Substitute variables in the doxygen config file for the target
    _configure_doxyfile(${TARGET_NAME} ${TARGET_TITLE} ${TARGET_BRIEF} ${TARGET_INPUT_PATH})
    # Add the target as a dependency to the master dox target
    _add_doxygen_target(${TARGET_NAME})
  endmacro()

  # We'll make a special script to collect all doxygen warnings from submodules and print them at
  # the end of the doxygen run. This mwill make it easier to detect if there were doxygen warnings
  # in the project and eventually fail the build in a CI environment for example.

  set(COLLECT_WARNINGS_SCRIPT "${DOXYGEN_BUILD_DIR}/collect_warnings.cmake")
  # cmake-format: off
  file(WRITE "${COLLECT_WARNINGS_SCRIPT}" " \
  # Collect warnings from submodules into the consolidated warnings file\n \
  file(WRITE \"${DOXYGEN_BUILD_DIR}/${TARGET_NAME}/doxygen_warnings.txt\" \"\")\n \
  file(GLOB_RECURSE DOX_MODULES \"module_warnings.txt\")\n \
  foreach(MODULE \${DOX_MODULES})\n \
    message(\"  collecting doxygen warnings from \${MODULE}\")\n \
    file(READ \"\${MODULE}\" MODULE_WARNINGS)\n \
    file(APPEND \"${DOXYGEN_BUILD_DIR}/doxygen_warnings.txt\" \"\${MODULE_WARNINGS}\")\n \
  endforeach(MODULE)\n \
  file(READ \"${DOXYGEN_BUILD_DIR}/doxygen_warnings.txt\" ALL_WARNINGS)\n \
  string(COMPARE NOTEQUAL \"\${ALL_WARNINGS}\" \"\" DOXYGEN_HAD_WARNINGS)\n \
  if(DOXYGEN_HAD_WARNINGS)\n \
    # Print the warnings\n \
    message(\"\${ALL_WARNINGS}\")\n \
  endif(DOXYGEN_HAD_WARNINGS)\n")
  # cmake-format: on

  # The master doxygen target
  add_custom_target(dox)
  # We don't want it to be rebuilt everytime we build all. Need to explicitly request it to be
  # built.
  set_target_properties(dox PROPERTIES EXCLUDE_FROM_ALL TRUE)
  # Custom command to collect warnings and print them
  add_custom_command(
    TARGET dox
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -P "${COLLECT_WARNINGS_SCRIPT}"
    WORKING_DIRECTORY "${DOXYGEN_BUILD_DIR}"
    COMMENT "Running post-build command for dox")

else()
  message(STATUS "WARNING: Doxygen package is not available on this system!")

  macro(_configure_doxyfile)

  endmacro()

  macro(_add_doxygen_target)

  endmacro()

  macro(asap_with_doxygen)

  endmacro()
endif()
