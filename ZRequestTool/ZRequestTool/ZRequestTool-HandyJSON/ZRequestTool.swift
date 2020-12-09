//
//  ZRequestTool.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/2.
//

import UIKit
import RxSwift

protocol ZRequestTool: ZResponseConfig {
}

extension ZRequestTool {
    
    /// 单条数据请求
    @discardableResult
    static func sendRequest(_ target: ZNetworkApi, success: ((ZResultModel<Self>) -> ())?) -> Disposable {
        return ZRequest<Self>.request(target, success: success)
    }
}

extension Array where Element: ZResponseConfig {
    
    /// 多条数据请求
    @discardableResult
    static func sendRequest(_ target: ZNetworkApi, success: ((ZResultModel<[Element]>) -> ())?) -> Disposable {
        return ZRequest<Element>.requestArrayFrom(target, success: success)
    }
}

