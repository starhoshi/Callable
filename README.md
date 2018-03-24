# Callable

![](https://cocoapod-badges.herokuapp.com/v/Callable/badge.png)
![](https://cocoapod-badges.herokuapp.com/p/Callable/badge.png)
[![Build Status](https://travis-ci.org/starhoshi/Callable.svg?branch=master)](https://travis-ci.org/starhoshi/Callable)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Type-safe [Firebase HTTPS Callable Functions](https://firebase.google.com/docs/functions/callable) client using Decodable.

# Installation

```
pod 'Callable'
```

# Usage

## Define endpoint and Response

You need to define `Response` extend `Decodable`.

* path
    * name The name of the Callable HTTPS trigger.
* parameter
    * data Parameters to pass to the trigger.

```swift
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
```

## Call endpoint

If the request succeeds, `Response` type will be returned.

* CallableError
    * function(Error)
        * server threw an error or if the resulting promise was rejected.
    * decode(Error) 
        * decode failed
    * illegalCombination(Any?, Error?)
        * both result and error exist, or nil

```swift
let sample = Sample(name: "Jobs")
sample.call { result in
    switch result {
    case .success(let resonse):
        print(resonse)
    case .failure(let error):
        print(error)
    }
}
```
