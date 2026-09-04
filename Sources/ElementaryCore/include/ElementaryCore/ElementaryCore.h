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
// json.hpp: module.modulemap declares this file as an `umbrella header`,
// which makes it the module's one real parse entry point — every sibling
// header (Runtime.h, Renderer.h, ...) that also reaches json.hpp is still
// attributed to this same module rather than re-parsed into a second,
// independent copy wherever else it's `#include`d, so defining this once
// here is sufficient.
#define JSON_NO_IO 1

#include "ElementaryCore/lib/NodeUtils.h"
#include "ElementaryCore/GraphNode.h"
#include "ElementaryCore/Renderer.h"
#include "ElementaryCore/Runtime.h"
#include "ElementaryCore/Value.h"
#include "ElementaryCore/lib/Core.h"
#include "ElementaryCore/lib/Math.h"
#include "ElementaryCore/lib/Signals.h"
#include "ElementaryCore/lib/Envelopes.h"
#include "ElementaryCore/lib/Dynamics.h"
#include "ElementaryCore/lib/Filters.h"
#include "ElementaryCore/lib/Oscillators.h"
#include "ElementaryCore/lib/Mc.h"
