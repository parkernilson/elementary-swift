internal import ElementaryCore

internal extension String? {
    func toOptString() -> ElementaryCore.OptString {
        return self.map { ElementaryCore.OptString(std.string($0)) } ?? ElementaryCore.OptString()
    }
}

internal extension Double? {
    func toOptDouble() -> ElementaryCore.OptDouble {
        return self.map { ElementaryCore.OptDouble($0) } ?? ElementaryCore.OptDouble()
    }
}

internal extension Bool? {
    func toOptBool() -> ElementaryCore.OptBool {
        return self.map { ElementaryCore.OptBool($0) } ?? ElementaryCore.OptBool()
    }
}
