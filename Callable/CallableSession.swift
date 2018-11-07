//
//  CallableSessionAdapter.swift
//  Callable
//
//  Created by suguru-kishimoto on 2018/05/02.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import Foundation
import FirebaseFunctions

public class CallableSession: Session {
    public static let shared = CallableSession()

    private init() {
    }

    public func send(_ path: String, region: String? = nil, parameter: [String : Any]?, handler: @escaping (Data?, Error?) -> Void) {
        let function = region.map { Functions.functions(region: $0) } ?? Functions.functions()
        function.httpsCallable(path)
            .call(parameter) { result, error in
                if let result = result {
                    if result.data is NSNull {
                        handler(nil, CallableError.resultDataIsNull)
                        return
                    }
                    do {
                        let data = try JSONSerialization.data(withJSONObject: result.data, options: [])
                        handler(data, error)
                    } catch let error {
                        handler(nil, error)
                    }
                } else {
                    handler(nil, error)
                }
        }
    }
}
