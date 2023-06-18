import SwiftSyntax
import SwiftDiagnostics

protocol Diagnostics {
    var domain: String { get }
}

extension Diagnostics {
    func diagnostic(
        for node: Syntax,
        message: String,
        diagnosticID: String,
        severity: DiagnosticSeverity = .error,
        fixIts: [FixIt] = []
    ) -> Diagnostic {
        Diagnostic(
            node: node,
            message: DiagnosticMessage(
                message: message,
                diagnosticID: MessageID(domain: domain, id: diagnosticID),
                severity: severity),
            fixIts: fixIts
        )
    }

    func diagnostic(
        for node: SyntaxProtocol,
        message: String,
        diagnosticID: String,
        severity: DiagnosticSeverity = .error,
        fixIts: [FixIt] = []
    ) -> Diagnostic {
        diagnostic(
            for: Syntax(node),
            message: message,
            diagnosticID: diagnosticID,
            severity: severity,
            fixIts: fixIts
        )
    }
}

struct DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {
    let message: String
    let diagnosticID: MessageID
    let severity: DiagnosticSeverity
}
