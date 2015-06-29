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
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        println("テスト。ListTableViewControllerのsuper.viewDidLoad()完了")
    }
    
    override func viewDidAppear(animated: Bool) {        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
//        let sort:NSSortDescriptor = NSSortDescriptor(key: "recordTimeString", ascending: false)
        

        let freq: NSFetchRequest = NSFetchRequest(entityName: "List")
        
//        freq.predicate = nil
//        freq.sortDescriptors = [sort]
//        freq.returnsObjectsAsFaults = false
        
        mylist = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()
        
        println("テスト。viewDidAppear完了")
        
        
        // get coredata instances
        
//        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let context: NSManagedObjectContext? = appDel.managedObjectContext
//        let sort:NSSortDescriptor = NSSortDescriptor(key: "recordTime", ascending: false)
//        let predicate:NSPredicate? = NSPredicate(format: "%@ <= recordTime && recordTime <= %@", startDate!, lastDate!)
//        
//        let request = NSFetchRequest(entityName: "Record")
//        request.predicate = predicate
//        request.sortDescriptors = [sort]
//        request.returnsObjectsAsFaults = false
//        
//        // get an instance of NSFetchedResultsController
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
//        _fetchedResultsController = aFetchedResultsController
//        
//        var error: NSError? = nil
//        if !_fetchedResultsController!.performFetch(&error) {
//            abort()
//        }
//        return _fetchedResultsController!
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "update" {
            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var selectedItem: NSManagedObject = mylist[indexPath.row] as NSManagedObject
            let IVC: DetailViewController = segue.destinationViewController as DetailViewController
            
            IVC.name   = selectedItem.valueForKey("name") as String
            IVC.time   = selectedItem.valueForKey("recordTimeString") as String
            IVC.pic    = selectedItem.valueForKey("pic") as UIImage
            IVC.detail = selectedItem.valueForKey("detail") as String
            IVC.existingItem = selectedItem
            
            println("テスト。segue:update完了")
            println("テスト。name -> \(IVC.name), pic -> \(IVC.pic), detail -> \(IVC.detail)")
            
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
        
        // tableCell の ID で UITableViewCell のインスタンスを生成 cell deque
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as UITableViewCell
        
        if let ip = indexPath {
            var data : NSManagedObject = mylist[ip.row] as NSManagedObject
            
            var nameText = data.valueForKeyPath("name") as String
            var timeText = data.valueForKeyPath("recordTimeString") as String
            var picView = data.valueForKeyPath("pic") as UIImage
            //var detailText = data.valueForKeyPath("detail") as String
            
            var cellNameText = tableView.viewWithTag(1) as UILabel!
            cellNameText?.text = nameText
            
            var cellImg = tableView.viewWithTag(2) as UIImageView!
            cellImg?.image = picView
            
            var cellTime = tableView.viewWithTag(3) as UILabel!
            cellTime?.text = timeText
            
            println("テスト。ip.row=\(ip.row)")
            println("テスト。name-> \(nameText), img-> \(picView), time -> \(timeText)")
            println("テスト。name-> \(cell.textLabel?.text), img-> \(cellImg?.image), time -> \(cellTime?.text)")

        }
        
        
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