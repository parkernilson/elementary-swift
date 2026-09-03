internal import ElementaryCore

internal extension String? {
    func toOptString() -> elemswift.lib.OptString {
        return self.map { elemswift.lib.OptString(std.string($0)) } ?? elemswift.lib.OptString()
    }
}

internal extension Double? {
    func toOptDouble() -> elemswift.lib.OptDouble {
        return self.map { elemswift.lib.OptDouble($0) } ?? elemswift.lib.OptDouble()
    }
}

internal extension Bool? {
    func toOptBool() -> elemswift.lib.OptBool {
        return self.map { elemswift.lib.OptBool($0) } ?? elemswift.lib.OptBool()
    }
}
