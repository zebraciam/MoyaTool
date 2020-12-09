//
//  ViewController.swift
//  ZRequestTool
//
//  Created by Zebra on 2020/12/2.
//

import UIKit
import HandyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
}
