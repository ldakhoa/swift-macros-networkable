import SwiftSyntax
import SwiftSyntaxMacros
import Foundation
import SwiftDiagnostics

public class MethodMacro: PeerMacro {
    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] where Context : MacroExpansionContext, Declaration : DeclSyntaxProtocol {
        let method = node.attributeName.description
        print("Method macro: \(method)")

        return []
    }
}
