import OSLog

extension Logger {
    static let repository = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "repository")
}

final class SignPoster: Sendable {
    private let logger: Logger
    private let signposter: OSSignposter
    
    init(logger: Logger) {
        self.logger = logger
        self.signposter = OSSignposter(logger: logger)
    }
    
    func measure<T>(_ action: @Sendable @autoclosure () async -> T, name: StaticString) async -> T {
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval(name, id: signpostID)
        let result = await action()
        signposter.endInterval(name, state)
        return result
    }

    func measure<T>(_ action: @Sendable @autoclosure () -> T, name: StaticString) -> T {
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval(name, id: signpostID)
        let result = action()
        signposter.endInterval(name, state)
        return result
    }
}
