/*     SPDX-License-Identifier: BSD-3-Clause     */

//        Copyright The Authors 2021.
//    Distributed under the 3-Clause BSD License.
//    (See accompanying file LICENSE or copy at
//   https://opensource.org/licenses/BSD-3-Clause)

#pragma once

#include <logging/logging.h>

namespace asap {

class AbstractApplication : public asap::logging::Loggable<AbstractApplication> {
public:
  /// Default constructor
  AbstractApplication() = default;

  /// Copy constructor (deleted)
  AbstractApplication(const AbstractApplication &) = delete;

  /// Assignment operator (deleted)
  auto operator=(const AbstractApplication &) -> AbstractApplication & = delete;

  /// Move constructor (deleted)
  AbstractApplication(AbstractApplication &&) = delete;

  /// Move assignment operator (deleted)
  auto operator=(AbstractApplication &&) -> AbstractApplication & = delete;

  /// Destructor
  virtual ~AbstractApplication();

  virtual void Init() = 0;
  virtual auto Run() -> bool = 0;
  virtual void ShutDown() = 0;

  static const char *const LOGGER_NAME;
};

} // namespace asap
