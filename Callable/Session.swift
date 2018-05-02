//
//  SessionAdapter.swift
//  Callable
//
//  Created by suguru-kishimoto on 2018/05/02.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import Foundation

public protocol Session {
    func send(_ path: String, parameter: [String: Any]?, handler: @escaping (Data?, Error?) -> Void)
}
