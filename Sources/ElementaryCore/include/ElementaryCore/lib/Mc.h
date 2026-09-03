#pragma once

#include "Core.h"
#include "NodeUtils.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Mc.h"

namespace ElementaryCore {

// Multichannel ("mc.*") variants of the single-channel node constructors in
// Core.h. Each returns one NodeRepr per channel (via unpack) instead of a
// single NodeReprSPtr, and is named with an "mc" prefix here to avoid
// overloading the single-channel names by Props type alone.

struct MCSampleProps {
    OptString key;
    std::string path;
    OptString mode;
    OptDouble startOffset;
    OptDouble stopOffset;
    OptDouble playbackRate;
};

inline MCSampleProps mcSampleProps(OptString key, std::string path, OptString mode, OptDouble startOffset, OptDouble stopOffset, OptDouble playbackRate) {
    return MCSampleProps{std::move(key), std::move(path), std::move(mode), std::move(startOffset), std::move(stopOffset), std::move(playbackRate)};
}

NodeReprSPtrVector mcSample(MCSampleProps props, double channels, ElemNodeArg gate) {
    elem::lib::MCSampleProps coreProps{
        std::move(props.key), std::move(props.path), std::move(props.mode),
        std::move(props.startOffset), std::move(props.stopOffset), std::move(props.playbackRate)
    };
    auto nodes = elem::lib::sample(std::move(coreProps), channels, std::move(gate.value));
    NodeReprSPtrVector result;
    result.reserve(nodes.size());
    for (auto &node : nodes) {
        result.push_back(std::move(node));
    }
    return result;
}

struct MCSampleSeqProps {
    OptString key;
    std::string path;
    ValueTimeSeqStepVector seq;
    double duration;
};

inline MCSampleSeqProps mcSampleSeqProps(OptString key, std::string path, ValueTimeSeqStepVector seq, double duration) {
    return MCSampleSeqProps{std::move(key), std::move(path), std::move(seq), duration};
}

NodeReprSPtrVector mcSampleSeq(MCSampleSeqProps props, double channels, ElemNodeArg time) {
    std::vector<elem::lib::ValueTimeSeqStep> coreSeq;
    coreSeq.reserve(props.seq.size());
    for (auto &step : props.seq) {
        coreSeq.push_back(elem::lib::ValueTimeSeqStep{step.value, step.time});
    }
    elem::lib::MCSampleSeqProps coreProps{std::move(props.key), std::move(props.path), std::move(coreSeq), props.duration};
    auto nodes = elem::lib::sampleseq(std::move(coreProps), channels, std::move(time.value));
    NodeReprSPtrVector result;
    result.reserve(nodes.size());
    for (auto &node : nodes) {
        result.push_back(std::move(node));
    }
    return result;
}

struct MCSampleSeq2Props {
    OptString key;
    std::string path;
    ValueTimeSeqStepVector seq;
    double duration;
    OptDouble stretch;
    OptDouble shift;
};

inline MCSampleSeq2Props mcSampleSeq2Props(OptString key, std::string path, ValueTimeSeqStepVector seq, double duration, OptDouble stretch, OptDouble shift) {
    return MCSampleSeq2Props{std::move(key), std::move(path), std::move(seq), duration, std::move(stretch), std::move(shift)};
}

NodeReprSPtrVector mcSampleSeq2(MCSampleSeq2Props props, double channels, ElemNodeArg time) {
    std::vector<elem::lib::ValueTimeSeqStep> coreSeq;
    coreSeq.reserve(props.seq.size());
    for (auto &step : props.seq) {
        coreSeq.push_back(elem::lib::ValueTimeSeqStep{step.value, step.time});
    }
    elem::lib::MCSampleSeq2Props coreProps{
        std::move(props.key), std::move(props.path), std::move(coreSeq),
        props.duration, std::move(props.stretch), std::move(props.shift)
    };
    auto nodes = elem::lib::sampleseq2(std::move(coreProps), channels, std::move(time.value));
    NodeReprSPtrVector result;
    result.reserve(nodes.size());
    for (auto &node : nodes) {
        result.push_back(std::move(node));
    }
    return result;
}

struct MCTableProps {
    OptString key;
    std::string path;
};

inline MCTableProps mcTableProps(OptString key, std::string path) {
    return MCTableProps{std::move(key), std::move(path)};
}

NodeReprSPtrVector mcTable(MCTableProps props, double channels, ElemNodeArg t) {
    elem::lib::MCTableProps coreProps{std::move(props.key), std::move(props.path)};
    auto nodes = elem::lib::table(std::move(coreProps), channels, std::move(t.value));
    NodeReprSPtrVector result;
    result.reserve(nodes.size());
    for (auto &node : nodes) {
        result.push_back(std::move(node));
    }
    return result;
}

struct MCCaptureProps {
    OptString name;
};

inline MCCaptureProps mcCaptureProps(OptString name) {
    return MCCaptureProps{std::move(name)};
}

NodeReprSPtrVector mcCapture(MCCaptureProps props, double channels, ElemNodeArg g, ElemNodeArgVector args) {
    elem::lib::MCCaptureProps coreProps{std::move(props.name)};
    std::vector<elem::lib::ElemNode> coreArgs;
    coreArgs.reserve(args.size());
    for (auto &arg : args) {
        coreArgs.push_back(std::move(arg.value));
    }
    auto nodes = elem::lib::capture(std::move(coreProps), channels, std::move(g.value), std::move(coreArgs));
    NodeReprSPtrVector result;
    result.reserve(nodes.size());
    for (auto &node : nodes) {
        result.push_back(std::move(node));
    }
    return result;
}
}
