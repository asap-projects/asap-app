/*     SPDX-License-Identifier: BSD-3-Clause     */

//        Copyright The Authors 2021.
//    Distributed under the 3-Clause BSD License.
//    (See accompanying file LICENSE or copy at
//   https://opensource.org/licenses/BSD-3-Clause)

#pragma once

#include <runner_base.h>

namespace asap {

class ConsoleRunner : public RunnerBase {
public:
  ConsoleRunner(AbstractApplication &app, shutdown_function_type func);

  /// Copy constructor (deleted)
  ConsoleRunner(const ConsoleRunner &) = delete;

  /// Move constructor (deleted)
  ConsoleRunner(ConsoleRunner &&) = delete;

  /// Assignment operator (deleted)
  auto operator=(const ConsoleRunner &) -> ConsoleRunner & = delete;

  /// Move assignment operator (deleted)
  auto operator=(ConsoleRunner &&) -> ConsoleRunner & = delete;

  /// Destructor
  ~ConsoleRunner() override = default;

  void Run() override;

private:
};

} // namespace asap
