//
//  Request.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/3.
//

import UIKit
import Moya
import RxSwift
import SwiftyJSON
import HandyJSON

/// 超时时长
fileprivate var requestTimeOut: Double = 30

/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
fileprivate let myEndpointClosure = { (target: API) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30 // 每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    
    return endpoint
}

fileprivate let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/// NetworkActivityPlugin插件用来监听网络请求
fileprivate let networkPlugin = HYNetworkPlugin()

let RequestProvider = MoyaProvider<API>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

//MARK: Decodable 解析
extension ObservableType where Element == Response {
    
    @discardableResult
    func mapModel<Element: Decodable>(_ type: Element.Type, callBack: ((ResultModel<Element>) -> ())?) -> Disposable {
                
        return flatMap { response -> Observable<ResultModel<Element>> in
            return Observable.just(
                ResultModel<Element>(resultJson: JSON(response.data))
            )
        }.subscribe({ (event) in
            switch event {
            case let .next(value):
                callBack?(value)
            case let .error(error):
                print(error)
            case .completed:
                break
            }
        })
    }
}

//MARK: 自定义插件
fileprivate class HYNetworkPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        if let tatget = target as? API {
            switch tatget {
            default: break
//                HYWindow.showLoading()
            }
        }
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if let tatget = target as? API {
            print("👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇")
            print(target.baseURL.absoluteString + target.path)
            print(tatget.params.hy_toUrlValue())
            print(tatget.params)
            switch result {
            case let .success(response):
                if let json = try? JSON(data: response.data) {
                    print(json)
                }
            case let .failure(error):
                print(error)
            }
            print("👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆")

            switch tatget {
            default:
                break
            }
            
        }
    }
}
