#pragma once

// Forwarding header, not a symlink or a copy: the real file is vendored in
// the Vendor/elementary git submodule. Forwarding from here
// (rather than exposing that directory as a whole) lets ElementaryRuntime's
// public header set stay small and self-contained, so SwiftPM's
// auto-generated Clang module for it doesn't have to independently compile
// every header under Vendor/elementary/runtime/elem — some of which (e.g.
// elem/builtins/helpers/ValueHelpers.h) have unrelated broken includes.
#include "../../../../Vendor/elementary/runtime/elem/GraphNode.h"
