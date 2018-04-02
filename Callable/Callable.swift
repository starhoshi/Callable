//
//  Callable.swift
//  Callable
//
//  Created by kensuke-hoshikawa on 2018/03/23.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import Foundation
import Result
import FirebaseFunctions

public enum CallableError: Error {
    /// Server threw an error or if the resulting promise was rejected.
    case function(Error)
    /// Decode failed
    case decode(Error)
    /// Both result and error exist, or nil
    case illegalCombination(HTTPSCallableResult?, Error?)
}

public protocol Callable {
    /// Callable response that have to extend Decodable
    associatedtype Response: Decodable

    /// The name of the Callable HTTPS trigger.
    var path: String { get }
    /// Parameters to pass to the trigger. Default is nil.
    var parameter: [String: Any]? { get }

    /// Decoder for HTTPSCallableResult. Default is `JSONDecoder()`.
    var jsonDecoder: JSONDecoder { get }

    /// Call Callable HTTPS trigger asynchronously.
    ///
    /// - Parameter completion: The block to call when the HTTPS request has completed.
    func call(completion: @escaping (Result<Response, CallableError>) -> Void)
}

public extension Callable {
    public var parameter: [String: Any]? {
        return nil
    }

    public var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }

    public func call(completion: @escaping (Result<Response, CallableError>) -> Void) {
        Functions.functions().httpsCallable(path)
            .call(parameter) { result, error in
                switch (result, error) {
                case (let result?, nil):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: result.data, options: [])
                        completion(.success(try self.jsonDecoder.decode(Response.self, from: data)))
                    } catch let error {
                        completion(.failure(.decode(error)))
                    }
                case (nil, let error?):
                    completion(.failure(.function(error)))
                default:
                    completion(.failure(.illegalCombination(result, error)))
                }
        }
    }
}
