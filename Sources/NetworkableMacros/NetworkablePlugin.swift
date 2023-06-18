import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct NetworkablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MethodMacro.self,
    ]
}
