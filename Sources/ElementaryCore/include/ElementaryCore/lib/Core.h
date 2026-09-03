#pragma once

#include <optional>
#include <string>

#include "NodeUtils.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Core.h"
#include "../../../../../Vendor/elementary/runtime/elem/lib/Oscillators.h"

// TODO: add ::lib to this namespace probably
namespace ElementaryCore {

NodeReprSPtr sr() {
    return elem::lib::sr();
}

NodeReprSPtr time() {
    return elem::lib::time();
}

NodeReprSPtr counter(ElemNodeArg gate) {
    return elem::lib::counter(std::move(gate.value));
}

NodeReprSPtr accum(ElemNodeArg xn, ElemNodeArg reset) {
    return elem::lib::accum(std::move(xn.value), std::move(reset.value));
}

NodeReprSPtr phasor(ElemNodeArg rate) {
    return elem::lib::phasor(std::move(rate.value));
}

NodeReprSPtr syncphasor(ElemNodeArg rate, ElemNodeArg reset) {
    return elem::lib::syncphasor(std::move(rate.value), std::move(reset.value));
}

NodeReprSPtr latch(ElemNodeArg t, ElemNodeArg x) {
    return elem::lib::latch(std::move(t.value), std::move(x.value));
}

NodeReprSPtr cycle(ElemNodeArg rate) {
    return elem::lib::cycle(std::move(rate.value));
}

struct MaxHoldProps {
    OptString key;
    OptDouble hold;
};

inline MaxHoldProps maxHoldProps(OptString key, OptDouble hold) {
    return MaxHoldProps{std::move(key), std::move(hold)};
}

NodeReprSPtr maxhold(MaxHoldProps props, ElemNodeArg x, ElemNodeArg reset) {
    elem::lib::MaxHoldProps coreProps{std::move(props.key), std::move(props.hold)};
    return elem::lib::maxhold(std::move(coreProps), std::move(x.value), std::move(reset.value));
}

NodeReprSPtr pole(ElemNodeArg p, ElemNodeArg x) {
    return elem::lib::pole(std::move(p.value), std::move(x.value));
}

NodeReprSPtr env(ElemNodeArg atkPole, ElemNodeArg relPole, ElemNodeArg x) {
    return elem::lib::env(std::move(atkPole.value), std::move(relPole.value), std::move(x.value));
}

NodeReprSPtr z(ElemNodeArg x) {
    return elem::lib::z(std::move(x.value));
}

NodeReprSPtr prewarp(ElemNodeArg fc) {
    return elem::lib::prewarp(std::move(fc.value));
}

NodeReprSPtr biquad(ElemNodeArg b0, ElemNodeArg b1, ElemNodeArg b2, ElemNodeArg a1, ElemNodeArg a2, ElemNodeArg x) {
    return elem::lib::biquad(
        std::move(b0.value), std::move(b1.value), std::move(b2.value),
        std::move(a1.value), std::move(a2.value), std::move(x.value)
    );
}

// --- Family B: props with only optional scalar fields ---

struct OnceProps {
    OptString key;
    OptBool arm;
};

inline OnceProps onceProps(OptString key, OptBool arm) {
    return OnceProps{std::move(key), std::move(arm)};
}

NodeReprSPtr once(OnceProps props, ElemNodeArg x) {
    elem::lib::OnceProps coreProps{std::move(props.key), std::move(props.arm)};
    return elem::lib::once(std::move(coreProps), std::move(x.value));
}

struct RandProps {
    OptString key;
    OptDouble seed;
};

inline RandProps randProps(OptString key, OptDouble seed) {
    return RandProps{std::move(key), std::move(seed)};
}

NodeReprSPtr rand(RandProps props) {
    elem::lib::RandProps coreProps{std::move(props.key), std::move(props.seed)};
    return elem::lib::rand(std::move(coreProps));
}

struct MetroProps {
    OptString key;
    OptString name;
    OptDouble interval;
};

inline MetroProps metroProps(OptString key, OptString name, OptDouble interval) {
    return MetroProps{std::move(key), std::move(name), std::move(interval)};
}

NodeReprSPtr metro(MetroProps props) {
    elem::lib::MetroProps coreProps{std::move(props.key), std::move(props.name), std::move(props.interval)};
    return elem::lib::metro(std::move(coreProps));
}

struct MM1PProps {
    OptString key;
    OptString mode;
};

inline MM1PProps mm1pProps(OptString key, OptString mode) {
    return MM1PProps{std::move(key), std::move(mode)};
}

NodeReprSPtr mm1p(MM1PProps props, ElemNodeArg fc, ElemNodeArg x) {
    elem::lib::MM1PProps coreProps{std::move(props.key), std::move(props.mode)};
    return elem::lib::mm1p(std::move(coreProps), std::move(fc.value), std::move(x.value));
}

struct SVFProps {
    OptString key;
    OptString mode;
};

inline SVFProps svfProps(OptString key, OptString mode) {
    return SVFProps{std::move(key), std::move(mode)};
}

NodeReprSPtr svf(SVFProps props, ElemNodeArg fc, ElemNodeArg q, ElemNodeArg x) {
    elem::lib::SVFProps coreProps{std::move(props.key), std::move(props.mode)};
    return elem::lib::svf(std::move(coreProps), std::move(fc.value), std::move(q.value), std::move(x.value));
}

struct SVFShelfProps {
    OptString key;
    OptString mode;
};

inline SVFShelfProps svfShelfProps(OptString key, OptString mode) {
    return SVFShelfProps{std::move(key), std::move(mode)};
}

NodeReprSPtr svfshelf(SVFShelfProps props, ElemNodeArg fc, ElemNodeArg q, ElemNodeArg gainDecibels, ElemNodeArg x) {
    elem::lib::SVFShelfProps coreProps{std::move(props.key), std::move(props.mode)};
    return elem::lib::svfshelf(std::move(coreProps), std::move(fc.value), std::move(q.value), std::move(gainDecibels.value), std::move(x.value));
}

struct MeterProps {
    OptString key;
    OptString name;
};

inline MeterProps meterProps(OptString key, OptString name) {
    return MeterProps{std::move(key), std::move(name)};
}

NodeReprSPtr meter(MeterProps props, ElemNodeArg x) {
    elem::lib::MeterProps coreProps{std::move(props.key), std::move(props.name)};
    return elem::lib::meter(std::move(coreProps), std::move(x.value));
}

struct SnapshotProps {
    OptString key;
    OptString name;
};

inline SnapshotProps snapshotProps(OptString key, OptString name) {
    return SnapshotProps{std::move(key), std::move(name)};
}

NodeReprSPtr snapshot(SnapshotProps props, ElemNodeArg trigger, ElemNodeArg x) {
    elem::lib::SnapshotProps coreProps{std::move(props.key), std::move(props.name)};
    return elem::lib::snapshot(std::move(coreProps), std::move(trigger.value), std::move(x.value));
}

struct FFTProps {
    OptString key;
    OptString name;
    OptDouble size;
};

inline FFTProps fftProps(OptString key, OptString name, OptDouble size) {
    return FFTProps{std::move(key), std::move(name), std::move(size)};
}

NodeReprSPtr fft(FFTProps props, ElemNodeArg x) {
    elem::lib::FFTProps coreProps{std::move(props.key), std::move(props.name), std::move(props.size)};
    return elem::lib::fft(std::move(coreProps), std::move(x.value));
}

struct CaptureProps {
    OptString key;
};

inline CaptureProps captureProps(OptString key) {
    return CaptureProps{std::move(key)};
}

NodeReprSPtr capture(CaptureProps props, ElemNodeArg g, ElemNodeArg x) {
    elem::lib::CaptureProps coreProps{std::move(props.key)};
    return elem::lib::capture(std::move(coreProps), std::move(g.value), std::move(x.value));
}

// --- Family C: props with a Required<string>/Required<js::Number> field ---
// Required fields have no default in the vendor type, so the shim mirrors
// them as plain (non-optional) fields instead of Opt* aliases.

struct SampleProps {
    OptString key;
    std::string path;
    OptString mode;
    OptDouble startOffset;
    OptDouble stopOffset;
};

inline SampleProps sampleProps(OptString key, std::string path, OptString mode, OptDouble startOffset, OptDouble stopOffset) {
    return SampleProps{std::move(key), std::move(path), std::move(mode), std::move(startOffset), std::move(stopOffset)};
}

NodeReprSPtr sample(SampleProps props, ElemNodeArg trigger, ElemNodeArg rate) {
    elem::lib::SampleProps coreProps{std::move(props.key), std::move(props.path), std::move(props.mode), std::move(props.startOffset), std::move(props.stopOffset)};
    return elem::lib::sample(std::move(coreProps), std::move(trigger.value), std::move(rate.value));
}

struct TableProps {
    OptString key;
    std::string path;
};

inline TableProps tableProps(OptString key, std::string path) {
    return TableProps{std::move(key), std::move(path)};
}

NodeReprSPtr table(TableProps props, ElemNodeArg t) {
    elem::lib::TableProps coreProps{std::move(props.key), std::move(props.path)};
    return elem::lib::table(std::move(coreProps), std::move(t.value));
}

struct ConvolveProps {
    OptString key;
    std::string path;
};

inline ConvolveProps convolveProps(OptString key, std::string path) {
    return ConvolveProps{std::move(key), std::move(path)};
}

NodeReprSPtr convolve(ConvolveProps props, ElemNodeArg x) {
    elem::lib::ConvolveProps coreProps{std::move(props.key), std::move(props.path)};
    return elem::lib::convolve(std::move(coreProps), std::move(x.value));
}

struct TapProps {
    OptString key;
    std::string name;
};

inline TapProps tapProps(OptString key, std::string name) {
    return TapProps{std::move(key), std::move(name)};
}

NodeReprSPtr tapIn(TapProps props) {
    elem::lib::TapProps coreProps{std::move(props.key), std::move(props.name)};
    return elem::lib::tapIn(std::move(coreProps));
}

NodeReprSPtr tapOut(TapProps props, ElemNodeArg x) {
    elem::lib::TapProps coreProps{std::move(props.key), std::move(props.name)};
    return elem::lib::tapOut(std::move(coreProps), std::move(x.value));
}

struct DelayProps {
    OptString key;
    double size;
};

inline DelayProps delayProps(OptString key, double size) {
    return DelayProps{std::move(key), size};
}

NodeReprSPtr delay(DelayProps props, ElemNodeArg len, ElemNodeArg fb, ElemNodeArg x) {
    elem::lib::DelayProps coreProps{std::move(props.key), props.size};
    return elem::lib::delay(std::move(coreProps), std::move(len.value), std::move(fb.value), std::move(x.value));
}

struct SDelayProps {
    OptString key;
    double size;
};

inline SDelayProps sdelayProps(OptString key, double size) {
    return SDelayProps{std::move(key), size};
}

NodeReprSPtr sdelay(SDelayProps props, ElemNodeArg x) {
    elem::lib::SDelayProps coreProps{std::move(props.key), props.size};
    return elem::lib::sdelay(std::move(coreProps), std::move(x.value));
}

// --- Family D: props with a Required<js::Array>, i.e. a raw array of values ---
// elem::js::Array is already Swift-constructible (see Value.swift), so no new
// wrapper type is needed here - the field is typed directly as elem::js::Array.

struct SeqProps {
    OptString key;
    elem::js::Array seq;
    OptDouble offset;
    OptBool hold;
    OptBool loop;
};

inline SeqProps seqProps(OptString key, elem::js::Array seq, OptDouble offset, OptBool hold, OptBool loop) {
    return SeqProps{std::move(key), std::move(seq), std::move(offset), std::move(hold), std::move(loop)};
}

NodeReprSPtr seq(SeqProps props, ElemNodeArg trigger, ElemNodeArg reset) {
    elem::lib::SeqProps coreProps{std::move(props.key), std::move(props.seq), std::move(props.offset), std::move(props.hold), std::move(props.loop)};
    return elem::lib::seq(std::move(coreProps), std::move(trigger.value), std::move(reset.value));
}

NodeReprSPtr seq2(SeqProps props, ElemNodeArg trigger, ElemNodeArg reset) {
    elem::lib::SeqProps coreProps{std::move(props.key), std::move(props.seq), std::move(props.offset), std::move(props.hold), std::move(props.loop)};
    return elem::lib::seq2(std::move(coreProps), std::move(trigger.value), std::move(reset.value));
}

// --- Family E: props with a Required<std::vector<Step-struct>> ---
// The vendor Step structs (SparSeqStep, ValueTimeSeqStep) declare their
// fields as Required<js::Number>; the shim mirrors them with plain doubles
// and lets Required<T>'s implicit single-arg constructor do the conversion
// back at the call boundary.

struct SparSeqStep {
    double value;
    double tickTime;
};

inline SparSeqStep sparSeqStep(double value, double tickTime) {
    return SparSeqStep{value, tickTime};
}

using SparSeqStepVector = std::vector<SparSeqStep>;

// --- Family F: props with a variant field (SparSeqLoop = variant<bool, js::Array>) ---
// Same wrapper shape as ElemNodeArg above, just for a different variant.

using SparSeqLoop = elem::lib::SparSeqLoop;

struct SparSeqLoopArg {
    SparSeqLoop value;
    SparSeqLoopArg(bool b) : value(b) {}
    SparSeqLoopArg(elem::js::Array arr) : value(std::move(arr)) {}
};

using OptSparSeqLoopArg = std::optional<SparSeqLoopArg>;

struct SparSeqProps {
    OptString key;
    SparSeqStepVector seq;
    OptDouble offset;
    OptSparSeqLoopArg loop;
    OptDouble interpolate;
    OptDouble tickInterval;
};

inline SparSeqProps sparSeqProps(OptString key, SparSeqStepVector seq, OptDouble offset, OptSparSeqLoopArg loop, OptDouble interpolate, OptDouble tickInterval) {
    return SparSeqProps{std::move(key), std::move(seq), std::move(offset), std::move(loop), std::move(interpolate), std::move(tickInterval)};
}

NodeReprSPtr sparseq(SparSeqProps props, ElemNodeArg trigger, ElemNodeArg reset) {
    std::vector<elem::lib::SparSeqStep> coreSeq;
    coreSeq.reserve(props.seq.size());
    for (auto &step : props.seq) {
        coreSeq.push_back(elem::lib::SparSeqStep{step.value, step.tickTime});
    }
    std::optional<elem::lib::SparSeqLoop> coreLoop;
    if (props.loop.has_value()) {
        coreLoop = props.loop->value;
    }
    elem::lib::SparSeqProps coreProps{
        std::move(props.key), std::move(coreSeq), std::move(props.offset),
        std::move(coreLoop), std::move(props.interpolate), std::move(props.tickInterval)
    };
    return elem::lib::sparseq(std::move(coreProps), std::move(trigger.value), std::move(reset.value));
}

struct ValueTimeSeqStep {
    double value;
    double time;
};

inline ValueTimeSeqStep valueTimeSeqStep(double value, double time) {
    return ValueTimeSeqStep{value, time};
}

using ValueTimeSeqStepVector = std::vector<ValueTimeSeqStep>;

struct SparSeq2Props {
    OptString key;
    ValueTimeSeqStepVector seq;
};

inline SparSeq2Props sparSeq2Props(OptString key, ValueTimeSeqStepVector seq) {
    return SparSeq2Props{std::move(key), std::move(seq)};
}

NodeReprSPtr sparseq2(SparSeq2Props props, ElemNodeArg time) {
    std::vector<elem::lib::ValueTimeSeqStep> coreSeq;
    coreSeq.reserve(props.seq.size());
    for (auto &step : props.seq) {
        coreSeq.push_back(elem::lib::ValueTimeSeqStep{step.value, step.time});
    }
    elem::lib::SparSeq2Props coreProps{std::move(props.key), std::move(coreSeq)};
    return elem::lib::sparseq2(std::move(coreProps), std::move(time.value));
}

struct SampleSeqProps {
    OptString key;
    std::string path;
    ValueTimeSeqStepVector seq;
    double duration;
};

inline SampleSeqProps sampleSeqProps(OptString key, std::string path, ValueTimeSeqStepVector seq, double duration) {
    return SampleSeqProps{std::move(key), std::move(path), std::move(seq), duration};
}

NodeReprSPtr sampleseq(SampleSeqProps props, ElemNodeArg time) {
    std::vector<elem::lib::ValueTimeSeqStep> coreSeq;
    coreSeq.reserve(props.seq.size());
    for (auto &step : props.seq) {
        coreSeq.push_back(elem::lib::ValueTimeSeqStep{step.value, step.time});
    }
    elem::lib::SampleSeqProps coreProps{std::move(props.key), std::move(props.path), std::move(coreSeq), props.duration};
    return elem::lib::sampleseq(std::move(coreProps), std::move(time.value));
}

struct SampleSeq2Props {
    OptString key;
    std::string path;
    ValueTimeSeqStepVector seq;
    double duration;
    OptDouble stretch;
    OptDouble shift;
};

inline SampleSeq2Props sampleSeq2Props(OptString key, std::string path, ValueTimeSeqStepVector seq, double duration, OptDouble stretch, OptDouble shift) {
    return SampleSeq2Props{std::move(key), std::move(path), std::move(seq), duration, std::move(stretch), std::move(shift)};
}

NodeReprSPtr sampleseq2(SampleSeq2Props props, ElemNodeArg time) {
    std::vector<elem::lib::ValueTimeSeqStep> coreSeq;
    coreSeq.reserve(props.seq.size());
    for (auto &step : props.seq) {
        coreSeq.push_back(elem::lib::ValueTimeSeqStep{step.value, step.time});
    }
    elem::lib::SampleSeq2Props coreProps{std::move(props.key), std::move(props.path), std::move(coreSeq), props.duration, std::move(props.stretch), std::move(props.shift)};
    return elem::lib::sampleseq2(std::move(coreProps), std::move(time.value));
}

// --- Family G: props + a variadic std::vector<ElemNode> of children ---

struct ScopeProps {
    OptString key;
    OptString name;
    OptDouble size;
    OptDouble channels;
};

inline ScopeProps scopeProps(OptString key, OptString name, OptDouble size, OptDouble channels) {
    return ScopeProps{std::move(key), std::move(name), std::move(size), std::move(channels)};
}

NodeReprSPtr scope(ScopeProps props, ElemNodeArgVector children) {
    elem::lib::ScopeProps coreProps{std::move(props.key), std::move(props.name), std::move(props.size), std::move(props.channels)};
    std::vector<elem::lib::ElemNode> coreChildren;
    coreChildren.reserve(children.size());
    for (auto &child : children) {
        coreChildren.push_back(std::move(child.value));
    }
    return elem::lib::scope(std::move(coreProps), std::move(coreChildren));
}
}
