import Foundation

/// An ad-hoc network layer built on `URLSession` to perform an HTTP request.
public protocol NetworkableSession {
    /// Retrieves the contents that is specified by an HTTP request asynchronously.
    /// - Parameters:
    ///   - request: A type that abstracts an HTTP request.
    ///   - resultQueue: A queue on which the promise will be fulfilled.
    ///   - decoder: An object decodes the data to result from JSON objects.
    ///   - completionHandler: The completion handler to be fulfilled with a result represents either a success or a failure.
    /// - Returns: An URL session task that returns downloaded data directly to the app in memory.
    @discardableResult
    func dataTask<T>(
        for request: Request,
        resultQueue: DispatchQueue?,
        decoder: JSONDecoder,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask? where T: Decodable

    /// Retrieves the contents that is specified by an HTTP request asynchronously.
    /// - Parameters:
    ///   - request: A type that abstracts an HTTP request.
    ///   - decoder: An object decodes the data to result from JSON objects.
    /// - Returns: The decoded data.
    func data<T>(
        for request: Request,
        decoder: JSONDecoder
    ) async throws -> T where T: Decodable
}
