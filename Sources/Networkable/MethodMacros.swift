/// Requests a representation of the specified resource. Requests using GET should only retrieve data.
@attached(peer)
public macro GET(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Asks for a response identical to that of a GET request, but without the response body.
@attached(peer)
public macro HEAD(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Submit an entity to the specified resource
@attached(peer)
public macro POST(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Replaces all current representations of the target resource with the request payload.
@attached(peer)
public macro PUT(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Deletes the specified resource.
@attached(peer)
public macro DELETE(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Establishes a tunnel to the server identified by the target resource.
@attached(peer)
public macro CONNECT(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Describe the communication options for the target resource.
@attached(peer)
public macro OPTIONS(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Performs a message loop-back test along the path to the target resource.
@attached(peer)
public macro TRACE(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")

/// Apply partial modifications to a resource.
@attached(peer)
public macro PATCH(_ path: String = "") = #externalMacro(module: "NetworkableMacros", type: "MethodMacro")
