import Foundation

/// An ad-hoc network layer that is built on URLSession to perform an HTTP request.
public final class NetworkSession: NetworkableSession {
    // MARK: - Dpendencies

    /// A type can build an URL load request that is independent of protocol or URL scheme.
    let requestBuilder: URLRequestBuilder

    /// A list of middlewares that will perform side effects whenever a request is sent or a response is received.
    let middlewares: [Middleware]

    /// An object that coordinates a group of related, network data-transfer tasks.
    let session: URLSession

    // MARK: - Init

    /// Initiates an ad-hoc network layer that is built on URLSession to perform an HTTP request.
    /// - Parameters:
    ///   - requestBuilder: A type can build an URL load request that is independent of protocol or URL scheme.
    ///   - middlewares: A list of middlewares that will perform side effects whenever a request is sent or a response is received.
    ///   - session: An object that coordinates a group of related, network data-transfer tasks.
    public init(
        requestBuilder: URLRequestBuilder = URLRequestBuilder(),
        middlewares: [Middleware] = [],
        session: URLSession = .shared
    ) {
        self.requestBuilder = requestBuilder
        self.middlewares = middlewares
        self.session = session
    }

    // MARK: - NetworkableSession

    // MARK: Completion Handler

    public func dataTask<T>(
        for request: Request,
        resultQueue: DispatchQueue? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask? where T : Decodable {
        // Makes a data task
        dataTask(for: request) { (data: Result<Data, Error>) in
            // Makes a result of data decoding
            let result = data.flatMap { (data: Data) -> Result<T, Error> in
                Result {
                    try decoder.decode(T.self, from: data)
                }
            }
            // Verifies the result queue is some
            guard let resultQueue else {
                // Dispatches the result on the current queue
                return completionHandler(result)
            }
            // Dispatches the result on the result queue
            resultQueue.async {
                completionHandler(result)
            }
        }
    }

    // MARK: Async

    public func data<T>(
        for request: Request,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T where T : Decodable {
        // Makes an URL load request
        let data = try await data(for: request) as Data
        // Decodes the data to result type
        let result = try decoder.decode(T.self, from: data)
        // Returns the result
        return result
    }

    // MARK: - Helpers

    /// Makes an URL load request that is independent of protocol or URL scheme from a model.
    ///
    /// It will invoke the middlewares to perform side effects leading the final result.
    ///
    /// - Parameters:
    ///   - request: A type that abstracts an HTTP request.
    ///   - middlewares: A list of middlewares that will perform side effects whenever a request is sent or a response is received.
    /// - Returns: An URL load request that is independent of protocol or URL scheme.
    private func makeRequest(
        of request: Request,
        middlewares: [Middleware]
    ) throws -> URLRequest {
        let request = try requestBuilder.build(request: request)
        return try middlewares.reduce(request) { (partialResult: URLRequest, middleware: Middleware) in
            try middleware.prepare(request: partialResult)
        }
    }

    private func dataTask(
        for request: Request,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask? {
        do {
            // Makes an url load request
            let request = try makeRequest(of: request, middlewares: middlewares)
            // Makes a data task
            let result = session.dataTask(with: request) { [middlewares] (data: Data?, response: URLResponse?, error: Error?) in
                // Verifies whether an error occurred
                if let error {
                    // Notifies middlewares
                    middlewares.didReceive(error: error, of: request)
                    // Fulfills the completionHandler with error
                    return completionHandler(.failure(error))
                }
                // Make the result of request loading.
                let result = Result<Data, Error> {
                    // Makes sure the data is some or empty instead of none
                    let data = data ?? Data()
                    // Verifies the response is some
                    guard let response else { return data }
                    // Notifies middlewares
                    try middlewares.forEach {
                        try $0.didReceive(response: response, data: data)
                    }
                    // Return the data
                    return data
                }
                // Fulfills the completionHandler with result
                completionHandler(result)
            }
            // Notifies middlewares
            middlewares.willSend(request: request)

            return result
        } catch {
            // Returns the result
            return nil
        }
    }

    private func data(for request: Request) async throws -> Data {
        // Makes an url load request
        let request = try makeRequest(of: request, middlewares: middlewares)
        // Make a flag to indicate whether it should notify the middlewares about some errors.
        var shouldForwardError = true

        do {
            // Notifies middlewares
            middlewares.willSend(request: request)
            // Loads the request
            let (data, response) = try await session.data(for: request)
            // Avoids notifying middlewares about any possible errors below
            shouldForwardError = false
            // Notifies middlewars
            try middlewares.didReceive(response: response, data: data)
            // Returns the result
            return data
        } catch {
            // Verifies whether it should notifies middlewares about an error
            guard shouldForwardError else { throw error }
            // Notifies middlewars
            middlewares.didReceive(error: error, of: request)
            // Returns the result
            throw error
        }
    }
}
