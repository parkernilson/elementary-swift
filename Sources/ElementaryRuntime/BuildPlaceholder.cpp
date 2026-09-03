// This target exists only to expose a curated set of elem/*.h headers as
// public headers to other packages, via the default `include/` convention.
// It has no source files of its own to compile — but Xcode's build system
// errors on a static library with zero object files, so this placeholder
// translation unit exists purely to give it one. It intentionally has no
// dependency on anything under Vendor/, so it does not need to change if
// elementary is updated.
namespace ElementaryRuntimeShim
{
    void unused() {}
}
