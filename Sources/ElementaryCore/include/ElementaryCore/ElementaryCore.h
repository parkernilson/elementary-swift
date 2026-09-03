//
//  ElementarySwift.swift
//  ElementarySwift
//
//  Created by Parker Nilson on 8/13/26.
//

#pragma once

// nlohmann/json's IO-based input adapters (FILE*/std::istream) use
// std::streambuf without directly including <streambuf>, relying on it
// being pulled in transitively via <istream>. That holds under plain
// textual compilation but not under Swift's modular Clang build of
// libc++, so disable the IO path entirely — we only ever parse/dump
// strings. Must be defined here, before any transitive include of
// json.hpp, since SwiftPM's module-map precompile step (used to expose
// this target's headers to Swift) does not inherit this target's
// cxxSettings defines.
#define JSON_NO_IO 1

#include "ElementaryCore/lib/NodeUtils.h"
#include "ElementaryCore/GraphNode.h"
#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"
#include "ElementaryCore/lib/Core.h"
#include "ElementaryCore/lib/Math.h"
#include "ElementaryCore/lib/Signals.h"
#include "ElementaryCore/lib/Envelopes.h"
#include "ElementaryCore/lib/Dynamics.h"
#include "ElementaryCore/lib/Filters.h"
#include "ElementaryCore/lib/Oscillators.h"
#include "ElementaryCore/lib/Mc.h"
