//
//  ZBaseModel.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/2.
//

import UIKit
import HandyJSON
import RxSwift
import SwiftyJSON

class ZBaseModel: ZRequestTool {
    static var SuccessCode: String = "0"
    static var DataKey: String = "data"
    static var MessageKey: String = "msg"
    static var CodeKey: String = "msgCode"
    
    required init() {}
}

class TestModel: ZBaseModel {
    var ncId: String = ""
    var ncName: String = ""
}
