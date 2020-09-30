//
//  Task.swift
//  taskapp
//
//  Created by 瀧本達也 on 2020/09/30.
//  Copyright © 2020 瀧本達也. All rights reserved.
//

import UIKit
import RealmSwift

class Task: Object{
    
    
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    
    // タイトル
    
    @objc dynamic var title = ""
    
    
    // 内容
    
    @objc dynamic var contents = ""
    
    
    // 日時
    
    @objc dynamic var date = Date()

    // id をプライマリーキーとして設定

    override static func primaryKey() -> String? {
        return "id"
    }
}
