/*     SPDX-License-Identifier: BSD-3-Clause     */

//        Copyright The Authors 2021.
//    Distributed under the 3-Clause BSD License.
//    (See accompanying file LICENSE or copy at
//   https://opensource.org/licenses/BSD-3-Clause)

#include <chrono>  // for sleep timeout
#include <csignal> // for signal handling
#include <cstdint>
#include <thread> // for access to this thread

#include "console_runner.h"

namespace {
// NOLINTNEXTLINE(cppcoreguidelines-avoid-non-const-global-variables)
volatile std::sig_atomic_t gSignalInterrupt_;

void SignalHandler(int signal) {
  gSignalInterrupt_ = signal;
}

constexpr std::int64_t SLEEP_WHEN_INACTIVE_MILLISECONDS = 200;

} // unnamed namespace

namespace asap {

ConsoleRunner::ConsoleRunner(AbstractApplication &app, RunnerBase::shutdown_function_type func)
    : RunnerBase(app, std::move(func)) {
}

void ConsoleRunner::Run() {
  // Register to handle the signals that indicate when the server should exit.
  // It is safe to register for the same signal multiple times in a program,
  // provided all registration for the specified signal is made through Asio.
  std::signal(SIGINT, SignalHandler);
  std::signal(SIGTERM, SignalHandler);

  // Initialize the app
  AppInit();

  // Main loop
  bool sleep_when_inactive = true;
  while (gSignalInterrupt_ == 0) {
    if (sleep_when_inactive) {
      std::this_thread::sleep_for(std::chrono::milliseconds(SLEEP_WHEN_INACTIVE_MILLISECONDS));
    }

    // Draw the Application
    sleep_when_inactive = AppRun();
  }
  ASLOG(info, "signal ({}) caught", gSignalInterrupt_);
  // Invoke the app shutdown
  AppShutDown();
  // Call the main shutdown function
  InvokeShutDownFunction();
}

} // namespace asap
