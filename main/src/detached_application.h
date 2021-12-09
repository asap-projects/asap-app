/*     SPDX-License-Identifier: BSD-3-Clause     */

//        Copyright The Authors 2021.
//    Distributed under the 3-Clause BSD License.
//    (See accompanying file LICENSE or copy at
//   https://opensource.org/licenses/BSD-3-Clause)

#pragma once

#include "abstract_application.h"

namespace asap {

class DetachedApplication final : public AbstractApplication {
public:
  /// Default constructor
  DetachedApplication() = default;

  /// Copy constructor (deleted)
  DetachedApplication(const DetachedApplication &) = delete;

  /// Assignment operator (deleted)
  auto operator=(const DetachedApplication &) -> DetachedApplication & = delete;

  /// Move constructor (deleted)
  DetachedApplication(DetachedApplication &&) = delete;

  /// Move assignment operator (deleted)
  auto operator=(DetachedApplication &&) -> DetachedApplication & = delete;

  ~DetachedApplication() override;

  void Init() override {
  }
  auto Run() -> bool override {
    return true;
  }
  void ShutDown() override {
  }
};

} // namespace asap
