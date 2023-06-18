import SwiftDiagnostics
import SwiftSyntax

struct MethodDiagnostics: Diagnostics {
    var domain: String {
        "HTTPMethod"
    }

    private let method: String

    init(_ method: String) {
        self.method = method
    }

    enum DiagnosticType: String {
        case asyncAndThrowsRequired

        var message: String {
            switch self {
            case .asyncAndThrowsRequired:
                return " requires async and throws"
            }
        }
    }
}
