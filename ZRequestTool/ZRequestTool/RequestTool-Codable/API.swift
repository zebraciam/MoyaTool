//
//  API.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/3.
//

import Foundation
import RxSwift
import Moya

enum API {

    case test
    case test1(_ userId: Int)
}

extension API: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://api.chinahandball.org.cn/")!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var path: String {
        switch self {
        case .test:
            return "handball_api/news/getHomeClass.do"
        case .test1:
            return ""
        }
    }
    
    var params: [String: Any] {
        var params: [String : Any] = [:]
        switch self {
        case .test:
            params = [:]
        case let .test1(userId):
            params = ["userId": userId]
        }
        return params
    }
    
    var method: Moya.Method {
        return .post
    }
    var task: Task {
        return .requestParameters(parameters: self.params, encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}

extension API {
    
    @discardableResult
    func sendRequest<Element: Decodable>(type: Element.Type, callBack: ((ResultModel<Element>) -> ())?) -> Disposable {
        return RequestProvider.rx.request(self).asObservable().mapModel(type, callBack: callBack)
    }
}
