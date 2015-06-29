//
//  ListViewController.swift
//  CoreDataTableView20150625
//
//  Created by 井上航 on 2015/06/25.
//  Copyright (c) 2015年 Wataru.I. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIToolbarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldTime: UITextField!
    private var textFieldName: UITextField!
    private var myImage: UIImageView!
    private var textViewDetail: UITextView!
    
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!
    
    var name: String! = ""
    var time: String! = ""
    var pic: UIImage! = nil
    var detail: String! = ""
    var existingItem: NSManagedObject!
    
    let interval: CGFloat = 8 //アイテム配置のための間隔の設定
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let iphoneWidth:CGFloat  = self.view.bounds.width
        let iphoneHeight:CGFloat = self.view.frame.size.height
        
        var y: CGFloat = 64 //画面上端からツールバーの下端までの高さ＝64
        
        // Labelを作成.
        y = y + interval
        textFieldName = UITextField(frame: CGRectMake(interval, y, iphoneWidth*3/5, 30))
        y = y + 30 //yに下端の値を代入しておく
        
        // 枠を丸くする.
        textFieldName.layer.masksToBounds = true
        
        // コーナーの半径.
        textFieldName.layer.cornerRadius = 6.0
        
        // Labelに文字を代入.
        textFieldName.text = ""
        
        // 未入力時の薄い文字を設定
        textFieldName.placeholder = "input name here!"
        
        // 文字の色を黒にする.
        textFieldName.textColor = UIColor.blackColor()
        
        // 枠線の太さを設定する.
        textFieldName.layer.borderWidth = 0.8

        // Textを中央寄せにする.
        textFieldName.textAlignment = NSTextAlignment.Center
        
        // ViewにLabelを追加.
        self.view.addSubview(textFieldName)
        
        textFieldName?.delegate = self  //追加
        
        // UIImageViewを作成する.ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        // 表示する写真のサイズ：iPhone の横幅の長さの3/5倍を1辺とする正方形
        y = y + interval // 高さの算出, 30はLabelの高さ
        myImage = UIImageView(frame: CGRectMake(interval, y, iphoneWidth*3/5, iphoneWidth*3/5))
        y = y + iphoneWidth*3/5 //yに下端の値を代入しておく
        
        // 表示する画像を設定する.
        //let myImage = UIImage(named: "logo.png")
        
        // 画像をUIImageViewに設定する.
        myImage.image = nil
        
        // 画像の表示する座標を指定する.
        //myImage.layer.position = CGPoint(x: self.view.bounds.width/2, y: 200.0)
        
        // UIImageViewをViewに追加する.
        self.view.addSubview(myImage)
        // UIImageView 完了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
        // TextView生成する.ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        y = y + interval
        textViewDetail = UITextView(frame: CGRectMake(interval, y, iphoneWidth - 2 * interval, 300)) //300は適当
        y = y + 300
        
        // 表示させるテキストを設定する.
        textViewDetail.text = ""
        
        // 角に丸みをつける.
        textViewDetail.layer.masksToBounds = true
        
        // 丸みのサイズを設定する.
        textViewDetail.layer.cornerRadius = 12.0
        
        // 枠線の太さを設定する.
        textViewDetail.layer.borderWidth = 0.5
        
        // フォントの設定をする.
        textViewDetail.font = UIFont.systemFontOfSize(CGFloat(13))
        
        // フォントの色の設定をする.
        textViewDetail.textColor = UIColor.blackColor()
        
        // 左詰めの設定をする.
        textViewDetail.textAlignment = NSTextAlignment.Left
        
        // リンク、日付などを自動的に検出してリンクに変換する.
        textViewDetail.dataDetectorTypes = UIDataDetectorTypes.All
        
        // 影の濃さを設定する.
        textViewDetail.layer.shadowOpacity = 0.5
        
        // 編集可能か否か
        textViewDetail.editable = true
        
        // TextViewをViewに追加する.
        self.view.addSubview(textViewDetail)
        // TextView 完了ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

        // UIDatePickerの設定
        myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: "changedDateEvent:", forControlEvents: UIControlEvents.ValueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        textFieldTime.inputView = myDatePicker
        myDatePicker.locale = NSLocale(localeIdentifier: "ja") //pickerの表示形式を日本に
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRectMake(0, iphoneHeight/6, iphoneWidth, 40.0))
        toolBar.layer.position = CGPoint(x: iphoneWidth/2, y: iphoneHeight-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let toolBarBtn      = UIBarButtonItem(title: "完了", style: .Bordered, target: self, action: "tappedToolBarBtn:")
        let toolBarBtnToday = UIBarButtonItem(title: "現在", style: .Bordered, target: self, action: "tappedToolBarBtnToday:")
        
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
            
            //写真の取得
            self.selectImageWayBtn()
            //self.pickImageFromCamera()
            //self.pickImageFromLibrary()
        }
        //それ以外は既存の項目を表示
        // Do any additional setup after loading the view, typically from a nib.
        println("テスト。DetailViewControllerのsuper.viewDidLoad()完了")
    }
    
    // textFieldで改行が押されるとキーボードを収納
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    // UIDatePickerここから----------------------------------------------------------------------------------------
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        textFieldTime.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        myDatePicker.date = NSDate()
        changeLabelDate(NSDate())
    }

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
    
    
    private func selectImageWayBtn() {
        let alertController = UIAlertController(title: "写真を追加", message: "どこから追加しますか？", preferredStyle: .Alert)
        let firstAction = UIAlertAction(title: "カメラ", style: .Default) {
            action in self.pickImageFromCamera()
        }
        let secondAction = UIAlertAction(title: "アルバム", style: .Default) {
            action in self.pickImageFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in return
        }
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        //For ipad And Univarsal Device
        alertController.popoverPresentationController?.sourceView = view as UIView
        alertController.popoverPresentationController?.sourceRect = CGRect(x: (self.view.frame.size.width/2), y: self.view.frame.size.height, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    
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
            if (myImage.image == nil) {
                let alertController = UIAlertController(title: "写真がありません", message: "「編集」から写真を選択してください", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alertController.addAction(defaultAction)
                
                //alertController.popoverPresentationController?.sourceView = view as UIView
                alertController.popoverPresentationController?.sourceRect = CGRect(x: (self.view.frame.size.width/2), y: self.view.frame.size.height, width: 0, height: 0)
                alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
                
                presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
            
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
