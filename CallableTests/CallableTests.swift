//
//  CallableTests.swift
//  CallableTests
//
//  Created by kensuke-hoshikawa on 2018/03/23.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import XCTest
@testable import Callable

private func makeCallableError(details: [String: Any] = [:], code: Int = 0, description: String = "") -> NSError {
    return NSError(
        domain: "com.firebase.functions",
        code: code,
        userInfo: ["details": details, NSLocalizedDescriptionKey: description])
}

class CallableTests: XCTestCase {
    class MockSession: Session {
        let data: Data?
        let error: Error?
        init(data: Data? = nil, error: Error? = nil) {
            self.data = data
            self.error = error
        }

        func send(_ path: String, region: String? = nil, parameter: [String: Any]?, handler: @escaping (Data?, Error?) -> Void) {
            handler(data, error)
        }
    }

    struct TestRequest: Callable {
        struct Response: Decodable {
            let name: String
        }
        let path: String = "httpcallabletest"
    }

    func testSuccessMockSession() {
        let json = try! JSONSerialization.data(withJSONObject: ["name": "Mike"], options: [])
        let expectation = XCTestExpectation()
        TestRequest().call(MockSession(data: json)) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.name, "Mike")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFailureMockSession() {
        let error = makeCallableError(details: ["code": "foobar"])
        let expectation = XCTestExpectation()
        TestRequest().call(MockSession(error: error)) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                switch error {
                case .function(let functionError as NSError):
                    XCTAssertNotNil(functionError.userInfo["details"] as? [String: Any])
                    XCTAssertEqual((functionError.userInfo["details"] as? [String: Any])?["code"] as? String, "foobar")
                default:
                    XCTFail()
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
