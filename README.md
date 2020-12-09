# MoyaTool
快速解析模型工具
Moya+RxSwift封装，请求直接返回Model/Array<Model>，支持HandyJSON/Codable，个人理解，仅供参考。

## Issues
如果使用过程中，有什么问题欢迎issues,或者添加qq:1916561555

## Swift5

Swift5 及以上版本

## Support

* 支持HandyJSON
* 支持Codable

## 示例
```swift
// HandyJSON
// 使用 Model 直接调用 Model.sendRequest / Array<Model>.sendRequest
[TestModel].sendRequest(ZNetworkApi.test) { (model) in
    if model.isSuccess {
        print(model.result.count)
    }
}
TestModel.sendRequest(ZNetworkApi.test) { (model) in
    if model.isSuccess {
        print(model.result!)
    }
}

// Codable
// 使用API调用,推荐这种方法
API.test.sendRequest(type: [Test1Model].self) { (model) in
    if model.isSuccess {
        print(model.result)
    }
}

API.test.sendRequest(type: Test1Model.self) { (model) in
    if model.isSuccess {
        print(model.result)
    }
}
```

## Example

示例代码见ViewController.swift
