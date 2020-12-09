//
//  ZRequest.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/3.
//

import Foundation
import RxSwift
import HandyJSON
import SwiftyJSON
import Moya

/// 单条数据请求
@discardableResult
func NetworkRequest<Element: ZResponseConfig>(_ target: ZNetworkApi, type: Element.Type, success: ((ZResultModel<Element>) -> ())?) -> Disposable {
    return provider
        .rx
        .request(target)
        .asObservable()
        .mapModel(type, success: success)
}

/// 多条数据请求
@discardableResult
func NetworkRequest<Element: ZResponseConfig>(_ target: ZNetworkApi, type: [Element].Type, success: ((ZResultModel<[Element]>) -> ())?) -> Disposable {
    return provider
        .rx
        .request(target)
        .asObservable()
        .mapModelArrarFrom(type, success: success)
}

class ZRequest<Element: ZResponseConfig> {
    
    static func request(_ target: ZNetworkApi, success: ((ZResultModel<Element>) -> ())?) -> Disposable {
        return provider.rx.request(target).asObservable().mapModel(Element.self, success: success)
    }
    
    static func requestArrayFrom(_ target: ZNetworkApi, success: ((ZResultModel<[Element]>) -> ())?) -> Disposable {
        return provider.rx.request(target).asObservable().mapModelArrarFrom([Element].self, success: success)
    }
}

/// 超时时长
fileprivate var requestTimeOut: Double = 30

/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
fileprivate let myEndpointClosure = { (target: ZNetworkApi) -> Endpoint in
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

fileprivate let provider = MoyaProvider<ZNetworkApi>(requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

//MARK: HandyJSON 解析
extension ObservableType where Element == Response {
    
    @discardableResult
    fileprivate func mapModel<Element: ZResponseConfig>(_ type: Element.Type, success: ((ZResultModel<Element>) -> ())? = nil) -> Disposable {
                
        return flatMap { response -> Observable<ZResultModel<Element>?> in
            return Observable.just(response.mapHandyJsonModel(type))
        }.subscribe(onNext: { (value) in
            if let value = value {
                success?(value)
            } else {
                print("model解析失败")
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
    }
    
    @discardableResult
    fileprivate func mapModelArrarFrom<Element: ZResponseConfig>(_ type: [Element].Type, success: ((ZResultModel<[Element]>) -> ())? = nil) -> Disposable {

        return flatMap { response -> Observable<ZResultModel<[Element]>?> in
            return Observable.just(response.mapHandyJsonModelArrayFrom(type))
        }.subscribe(onNext: { (value) in
            if let value = value {
                success?(value)
            } else {
                print("model解析失败")
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
    }
}

extension Response {
    fileprivate func mapHandyJsonModel<Element: ZResponseConfig>(_ type: Element.Type) -> ZResultModel<Element>? {
        
        do {
            let mapJson = try mapJSON()
            let responseInfo = Element.mapModel(resultJson: JSON(mapJson), type: type)
            return responseInfo
        } catch let error {
            print(error)
        }
        return nil
    }
    
    fileprivate func mapHandyJsonModelArrayFrom<Element: ZResponseConfig>(_ type: [Element].Type) -> ZResultModel<[Element]>? {

        do {
            let mapJson = try mapJSON()
            let responseInfo = Element.mapModelArrayFrom(resultJson: JSON(mapJson), type: type)
            return responseInfo
        } catch let error {
            print(error)
        }
        return nil
    }
}

//MARK: 自定义插件
fileprivate class HYNetworkPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        if let tatget = target as? ZNetworkApi {
            switch tatget {
            default: break
//                HYWindow.showLoading()
            }
        }
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if let tatget = target as? ZNetworkApi {
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

extension Dictionary {
    /// 字典 -> get 拼接参数
    ///
    /// - Returns: ?key=value&key1=value1...
    func hy_toUrlValue() -> String
    {
        var url: String = ""
        
        for (key, value) in self {
            
            if url.isEmpty {
                
                url += "?\(key)=\(value)"
                
            } else {
                
                url += "&\(key)=\(value)"
            }
        }
        
        return url
    }
}
