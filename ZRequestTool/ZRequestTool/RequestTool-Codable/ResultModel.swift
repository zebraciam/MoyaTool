//
//  ResultModel.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/3.
//

import UIKit
import HandyJSON
import SwiftyJSON

struct ResultModel<Element: Decodable> {
    
    /// 模型
    var result: Element!
    
    /// 请求返回的json
    var resultJson: JSON!
    
    /// 请求数据
    var data: Any!
    
    /// 请求结果码
    var code: String!
    
    /// 请求提示信息
    var message: String!
    
    /// 是否请求成功
    var isSuccess: Bool!
    
    init(resultJson: JSON) {
        self.result = Element.deserialize(from: resultJson.description, designatedPath: RequestConfig.dataKey)
        self.resultJson = resultJson
        self.data = resultJson.dictionaryObject?[RequestConfig.dataKey]
        if let codel = resultJson[RequestConfig.codeKey].string {
            self.code = codel
            self.isSuccess = codel == RequestConfig.successCode ? true : false
        }
        if let message = resultJson[RequestConfig.messageKey].string {
            self.message = message
        }
    }
}
