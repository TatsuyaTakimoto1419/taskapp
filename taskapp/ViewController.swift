//
//  ViewController.swift
//  taskapp
//
//  Created by 瀧本達也 on 2020/09/30.
//  Copyright © 2020 瀧本達也. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //再利用可能なCellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       
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
    
    
    func tableview (_ tableView: UITableView,commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPaht:IndexPath){
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate  = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }


}

