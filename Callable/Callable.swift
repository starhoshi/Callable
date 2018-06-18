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
    case illegalCombination(Data?, Error?)

    case resultDataIsNull
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
    func call(_ session: Session, completion: @escaping (Result<Response, CallableError>) -> Void)
}

public extension Callable {
    public var parameter: [String: Any]? {
        return nil
    }

    public var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }

    public func call(_ session: Session = CallableSession.shared, completion: @escaping (Result<Response, CallableError>) -> Void) {
        session.send(path, parameter: parameter) { data, error in
            switch (data, error) {
            case (let data?, nil):
                do {
                    completion(.success(try self.jsonDecoder.decode(Response.self, from: data)))
                } catch let error {
                    completion(.failure(.decode(error)))
                }
            case (nil, let error?):
                completion(.failure(.function(error)))
            default:
                completion(.failure(.illegalCombination(data, error)))
            }

        }
    }
}
