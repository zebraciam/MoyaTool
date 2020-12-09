//
//  ZResultModel.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/3.
//

import UIKit
import HandyJSON
import SwiftyJSON

class ZResultModel<Element: HandyJSON> {
    
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
}
