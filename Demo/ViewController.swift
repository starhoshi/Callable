//
//  ViewController.swift
//  Demo
//
//  Created by kensuke-hoshikawa on 2018/03/23.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sample = Sample(name: "Jobs")
        sample.call { result in
            switch result {
            case .success(let resonse):
                print(resonse)
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct SampleResponse: Decodable {
    let name: String
}

struct Sample: Callable {
    typealias Response = SampleResponse
    let name: String

    init(name: String) {
        self.name = name
    }

    var path: String {
        return "httpcallable"
    }

    var parameter: [String: Any]? {
        return ["name": name]
    }
}

