//
//  NetworkApi.swift
//  TennisTrainingCoach
//
//  Created by Zebra on 2020/8/31.
//  Copyright © 2020 Zebra. All rights reserved.
//

import UIKit
import Moya

enum ZNetworkApi {
    case test
}

extension ZNetworkApi: TargetType {
    
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
        }
    }
    
    var params: [String: Any] {
        var params: [String : Any] = [:]
        switch self {
        case .test:
            break
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
