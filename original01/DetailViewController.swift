//
//  ListViewController.swift
//  CoreDataTableView20150625
//
//  Created by 井上航 on 2015/06/25.
//  Copyright (c) 2015年 Wataru.I. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIToolbarDelegate {
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var myImage: UIImageView! = nil
    @IBOutlet weak var textViewDetail: UITextView!
    @IBOutlet weak var textFieldTime: UITextField!
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!
    
    var name: String! = ""
    var time: String! = ""
    var pic: UIImage! = nil
    var detail: String! = ""
    var existingItem: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIDatePickerの設定
        myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: "changedDateEvent:", forControlEvents: UIControlEvents.ValueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        textFieldTime.inputView = myDatePicker
        myDatePicker.locale = NSLocale(localeIdentifier: "ja") //pickerの表示形式を日本に
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let toolBarBtn      = UIBarButtonItem(title: "完了", style: .Bordered, target: self, action: "tappedToolBarBtn:")
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .Bordered, target: self, action: "tappedToolBarBtnToday:")
        
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn, toolBarBtnToday]
        
        textFieldTime.inputAccessoryView = toolBar

        
        println("テスト。DetailViewControllerのsuper.viewDidLoad()開始")
        
        if (existingItem != nil) {
            println("テスト。if文：existingItem != nil")
            textFieldName.text = name
            textFieldTime.text = time
            myImage?.image = pic
            textViewDetail.text = detail
        } else { //existingItemが空だったら新規画面、
            println("テスト。else文")
            // TimeLabel入力欄の設定--------------------------------------------------------------------------------
            //textFieldTime.placeholder = dateToString(NSDate())
            textFieldTime.text        = dateToString(NSDate()) //初期入力
            // 枠を表示する.
            //textField.borderStyle = UITextBorderStyle.RoundedRect
            //textFieldTime.sizeToFit()
            //self.view.addSubview(textFieldTime)
            // TimeLabel入力欄の設定ここまで-----------------------------------------------------------
            self.pickImageFromCamera()
            self.pickImageFromLibrary()
        }
        //それ以外は既存の項目を表示
        // Do any additional setup after loading the view, typically from a nib.
        println("テスト。DetailViewControllerのsuper.viewDidLoad()完了")
    }
    
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        textFieldTime.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        myDatePicker.date = NSDate()
        changeLabelDate(NSDate())
    }

    //
    func changedDateEvent(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as UIDatePicker
        self.changeLabelDate(myDatePicker.date)
    }
    
    func changeLabelDate(date:NSDate) {
        textFieldTime.text = self.dateToString(date)
    }
    
    func dateToString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let comps: NSDateComponents = calender.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit|NSCalendarUnit.SecondCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        
        var date_formatter: NSDateFormatter = NSDateFormatter()
        var weekdays = ["", "日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "  yyyy/MM/dd (\(weekdays[comps.weekday])) HH:mm "
        
        return date_formatter.stringFromDate(date)
    }
    // UIDatePickerここまで--------------------------------------------------------------------------------------------

    
    @IBAction func saveTapped(sender: AnyObject) {
        println("テスト。DetailViewControllerのsaveTapped()開始")
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
        
        if (existingItem != nil) { //もしexistingItemがあったら
            println("テスト。if文：existingItem != nil")
            existingItem.setValue(textFieldName.text as String, forKey: "name")
            existingItem.setValue(textFieldTime.text as String, forKey: "recordTimeString")
            existingItem.setValue(myImage.image , forKey: "pic")
            existingItem.setValue(textViewDetail.text as String, forKey: "detail")
            
        } else {   // なかったら
            println("テスト。else文")
            var newItem = Model(entity: en!, insertIntoManagedObjectContext: contxt)
            newItem.name = textFieldName.text
            newItem.recordTimeString = textFieldTime.text
            //新規画面から写真選択をキャンセルしてSaveしようとするとしたの行でエラー
            newItem.pic = myImage.image!
            newItem.detail = textViewDetail.text
            
            println(newItem)
        }
        contxt.save(nil)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        println("テスト。DetailViewControllerのsaveTapped()完了")
    }
    @IBAction func cancelTapped(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    //写真選択-------------------------------------------------------------------------------------------------------
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            myImage?.image = image
            //画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
            //MainImageView?.contentMode = UIViewContentMode.ScaleAspectFit
            println(image)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //写真選択ここまで------------------------------------------------------------------------------------------------

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
