//
//  ZResponseInfo.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/3.
//

import UIKit
import SwiftyJSON
import HandyJSON

protocol ZResponseConfig: HandyJSON {
    
    /// 成功标识
    static var SuccessCode: String { get }

    /// 获取数据 key
    static var DataKey: String { get }

    /// 获取提示信息 key
    static var MessageKey: String { get }

    /// 获取结果码 key
    static var CodeKey: String { get }
}

extension ZResponseConfig {
    static func mapModel<Element: HandyJSON>(resultJson: JSON, type: Element.Type) -> ZResultModel<Element> {
                        
        let resultModel = ZResultModel<Element>()
        resultModel.result = type.deserialize(from: resultJson["data"].description)
        resultModel.resultJson = resultJson
        resultModel.data = resultJson[self.DataKey]
        if let codel = resultJson[self.CodeKey].string {
            resultModel.code = codel
            resultModel.isSuccess = codel == self.SuccessCode ? true : false
        }
        if let message = resultJson[self.MessageKey].string {
            resultModel.message = message
        }
        
        return resultModel
    }
    
    static func mapModelArrayFrom<Element: HandyJSON>(resultJson: JSON, type: [Element].Type) -> ZResultModel<[Element]> {
                        
        let resultModel = ZResultModel<[Element]>()
        
        if let result = type.deserialize(from: resultJson["data"].arrayObject) as? [Element] {
            resultModel.result = result
        }
        
        resultModel.resultJson = resultJson
        resultModel.data = resultJson[self.DataKey]
        if let codel = resultJson[self.CodeKey].string {
            resultModel.code = codel
            resultModel.isSuccess = codel == self.SuccessCode ? true : false
        }
        if let message = resultJson[self.MessageKey].string {
            resultModel.message = message
        }
        
        return resultModel
    }
}

extension Array: HandyJSON {}
