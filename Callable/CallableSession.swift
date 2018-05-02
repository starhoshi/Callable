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

    public func send(_ path: String, parameter: [String : Any]?, handler: @escaping (Data?, Error?) -> Void) {
        Functions.functions().httpsCallable(path)
            .call(parameter) { result, error in
                if let result = result {
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
