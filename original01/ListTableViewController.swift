//
//  TableViewController.swift
//  CoreDataTableView20150625
//
//  Created by 井上航 on 2015/06/25.
//  Copyright (c) 2015年 Wataru.I. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    var mylist:Array<AnyObject> = []
//    
//    @IBOutlet weak var nameLabel: UILabel!        //tag 1
//    @IBOutlet weak var imageLabel: UIImageView!   //tag 2
//    @IBOutlet weak var dateLabel: UILabel!        //tag 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName:"List")
        
        mylist = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName:"List")
        
        mylist = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "update" {
            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var selectedItem: NSManagedObject = mylist[indexPath.row] as NSManagedObject
            let IVC: DetailViewController = segue.destinationViewController as DetailViewController
            
            IVC.name = selectedItem.valueForKey("name") as? String
            IVC.pic = selectedItem.valueForKey("pic") as? UIImage
            IVC.detail = selectedItem.valueForKey("detail") as? String
            IVC.existingItem = selectedItem
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //println("numberOfSectionsInTableView実行。返り値１")
        return 1
    }
    
    //指定されたセクション(section)のrowの数を戻り値として返す
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("指定されたセクション(section)のrowの数。戻り値\(mylist.count)")
        return mylist.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        
        let CellID : NSString = "Cell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell
        if let ip = indexPath {
            var data : NSManagedObject = mylist[ip.row] as NSManagedObject
            
            var nameText = data.valueForKeyPath("name") as String
            var picView = data.valueForKeyPath("pic") as? UIImage
            var detailText = data.valueForKeyPath("detail") as String
            
            var cellNameText = tableView.viewWithTag(1) as UILabel!
            cellNameText?.text = nameText
            
            var cellImg = tableView.viewWithTag(2) as UIImageView!
            cellImg?.image = picView
//            
//            cell.textLabel?.text = nameText
//            cell.detailTextLabel?.text = "\(nameText)さんの\(detailText)"
        }
        
//        var img = UIImage(named:"\(imgArray[indexPath.row])")
//        // Tag番号 1 で UIImageView インスタンスの生成
//        var imageView = tableView.viewWithTag(1) as UIImageView
//        imageView.image = img
//        
//        // Tag番号 2 で UILabel インスタンスの生成
//        // let label1 = tableView.viewWithTag(2) as UILabel
//        // label1.text = "No.\(indexPath.row + 1)"
//        var label1 = tableView.viewWithTag(2) as UILabel
//        label1.text = "No.\(label1Array[indexPath.row])"
        
        return cell
    }
    
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable
        return true
    }
    
    //編集モード
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = tableView {
                context.deleteObject(mylist[indexPath!.row] as NSManagedObject)
                mylist.removeAtIndex(indexPath!.row)
                tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
            var error: NSError? = nil
            if !context.save(&error) {
                abort()
            }
        }
    }
    
}