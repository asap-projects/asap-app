# ~~~
# SPDX-License-Identifier: BSD-3-Clause

# ~~~
#        Copyright The Authors 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)
# ~~~


include_guard(GLOBAL)

# --------------------------------------------------------------------------------------------------
# Set a common set of compile definitions
# --------------------------------------------------------------------------------------------------

function(asap_set_compile_definitions target)
  set(argOption)
  set(argSingle "")
  set(argMulti "ADD" "REMOVE")

  unset(x_WARNING)
  unset(x_ADD)
  unset(x_REMOVE)

  cmake_parse_arguments(x "${argOption}" "${argSingle}" "${argMulti}" ${ARGN})

  set(all_flags)

  list(APPEND all_flags "ASAP_CONTRACT_${OPTION_CONTRACT_MODE}")

  if(MSVC)
    list(APPEND all_flags "NOMINMAX" "WIN32_LEAN_AND_MEAN=1" "_WIN32_WINNT=0x0600")
  endif()

  if(x_REMOVE)
    foreach(flag ${x_REMOVE})
      list(FIND all_flags ${flag} found)
      if(found EQUAL -1)
        message(
          FATAL_ERROR
            "Compiler flag '${flag}' specified for removal is not part of the set of common
     compiler flags")
      endif()
    endforeach()
    list(REMOVE_ITEM all_flags ${x_REMOVE})
  endif()

  list(APPEND all_flags ${x_ADD})
  target_compile_definitions(${target} PRIVATE ${all_flags})

endfunction()
