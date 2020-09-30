//
//  ViewController.swift
//  taskapp
//
//  Created by 瀧本達也 on 2020/09/30.
//  Copyright © 2020 瀧本達也. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    // DB内のタスクが格納されるリスト。
      // 日付の近い順でソート：昇順
      // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm() .objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate  = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //再利用可能なCellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        
        return cell
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
  
       // セルが削除が可能なことを伝えるメソッド

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        
        return .delete
        
    }
    
    
    func tableview (_ tableView: UITableView,commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath:IndexPath){
        
        if editingStyle == .delete{
            //削除するタスクを取得する
            
            let task = self.taskArray[indexPath.row]
            // ローカル通知をキャンセルする
                let center = UNUserNotificationCenter.current()
                       center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[ indexPath.row])
                tableView.deleteRows(at: [ indexPath], with: .fade)
                
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                          for request in requests {
                              print("/---------------")
                              print(request)
                              print("---------------/")
                          }
                      }

            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController: InputViewController = segue.destination as!  InputViewController
        
        if segue.identifier == "cellSegue"{
            
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            
        }else{
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
  


}

