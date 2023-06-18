import Foundation

struct DummyError: LocalizedError, Equatable {
    // swiftlint:disable identifier_name
    let id = UUID()

    var errorDescription: String? {
        id.uuidString
    }
}
