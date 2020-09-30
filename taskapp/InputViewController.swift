//
//  InputViewController.swift
//  taskapp
//
//  Created by 瀧本達也 on 2020/09/30.
//  Copyright © 2020 瀧本達也. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self .task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task:task)
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する
    func setNotification(task:Task){
        let content = UNMutableNotificationContent()
        
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        }else{
            content.title = task.title
        }
        
        if task.contents == ""{
            content.body = "(内容なし)"
        }else{
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）

        let request = UNNotificationRequest ( identifier:String (task.id), content: content,trigger: triger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add (request) {
            (error)in
            
            print (error ?? "ローカル通知登録 OK")
        }
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests {(requests: [UNNotificationRequest])in
            for request in requests {
                print("/---------------")
                               print(request)
                               print("---------------/")
            }
        
        }
    }
   

}//end
