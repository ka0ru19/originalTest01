//
//  ListViewController.swift
//  CoreDataTableView20150625
//
//  Created by 井上航 on 2015/06/25.
//  Copyright (c) 2015年 Wataru.I. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIToolbarDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    private var textFieldName: UITextField!
    private var textFieldTime:UITextField!
    private var myImage: UIImageView!
    private var textViewDetail: UITextView!
    private var textFieldBirth: UITextField!
    
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!
    var birthDatePicker: UIDatePicker!
    
    var name: String! = ""
    var time: String! = ""
    var pic: UIImage! = nil
    var detail: String! = ""
    var birth: String! = ""
    var existingItem: NSManagedObject!
    
    let interval: CGFloat = 8 //アイテム配置のための間隔(px)の設定
    var textFieldIsEditing = false
    var textViewIsEditing = false
    var IsDatePickerEditing = false
    var IsBirthPickerEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let iphoneWidth:CGFloat  = self.view.bounds.width
        let iphoneHeight:CGFloat = self.view.frame.size.height
        
        var y: CGFloat = 64 //画面上端からツールバーの下端までの高さ＝64
        
        // textFieldNameを作成.
        y = y + interval
        textFieldName = UITextField(frame: CGRectMake(interval, y, iphoneWidth*3/5, 30))
        
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
        
        // タグをつける
        textFieldName.tag = 1
        
        textFieldName?.delegate = self  //追加
        
        // ViewにLabelを追加.
        self.view.addSubview(textFieldName)
        
        // textFieldBirthを作成ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー開始
        textFieldBirth = UITextField(frame: CGRectMake(interval+iphoneWidth*3/5+interval, y, iphoneWidth-iphoneWidth*3/5-interval*3, 30))
        //y = y + 30 //yに下端の値を代入しておく
        
        // 枠を丸くする.
        textFieldBirth.layer.masksToBounds = true
        
        // コーナーの半径.
        textFieldBirth.layer.cornerRadius = 6.0
        
        // Labelに文字を代入.
        textFieldBirth.text = ""
        
        // 未入力時の薄い文字を設定
        textFieldBirth.placeholder = "input Birthday here!"
        
        // 文字の色を黒にする.
        textFieldBirth.textColor = UIColor.blackColor()
        
        // 枠線の太さを設定する.
        textFieldBirth.layer.borderWidth = 0.6
        
        // フォントの設定をする.
        textFieldBirth.font = UIFont.systemFontOfSize(CGFloat(12))
        
        // Textを中央寄せにする.
        textFieldBirth.textAlignment = NSTextAlignment.Center
        
        // タグをつける
        textFieldBirth.tag = 5
        
        //textFieldBirth.addTarget(<#target: AnyObject?#>, action: <#Selector#>, forControlEvents: <#UIControlEvents#>)
        
        textFieldBirth?.delegate = self  //追加
        
        // ViewにLabelを追加.
        self.view.addSubview(textFieldBirth)

        
        // textFieldTimeを作成ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー開始
        textFieldTime = UITextField(frame: CGRectMake(interval+iphoneWidth*3/5, y+iphoneWidth*3/5+interval*2, iphoneWidth-iphoneWidth*3/5-interval*2, 30))
        y = y + 30 //yに下端の値を代入しておく
        
        // 枠を丸くする.
        textFieldTime.layer.masksToBounds = true
        
        // コーナーの半径.
        textFieldTime.layer.cornerRadius = 6.0
        
        // Labelに文字を代入.
        textFieldTime.text = ""
        
        // 未入力時の薄い文字を設定
        textFieldTime.placeholder = "input name here!"
        
        // 文字の色を黒にする.
        textFieldTime.textColor = UIColor.blackColor()
        
        // 枠線の太さを設定する.
        textFieldTime.layer.borderWidth = 0.0
        
        // フォントの設定をする.
        textFieldTime.font = UIFont.systemFontOfSize(CGFloat(10))
        
        // Textを中央寄せにする.
        textFieldTime.textAlignment = NSTextAlignment.Right
        
        // タグをつける
        textFieldTime.tag = 2
        
        textFieldTime?.delegate = self  //追加
        
        // ViewにLabelを追加.
        self.view.addSubview(textFieldTime)
        
        // UIImageViewを作成する.ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー開始
        
        // 表示する写真のサイズ：iPhone の横幅の長さの3/5倍を1辺とする正方形
        y = y + interval // 高さの算出, 30はLabelの高さ
        myImage = UIImageView(frame: CGRectMake(interval, y, iphoneWidth*3/5, iphoneWidth*3/5))
        y = y + iphoneWidth*3/5 //yに下端の値を代入しておく
        
        // 表示する画像を設定する.
        //let myImage = UIImage(named: "logo.png")
        
        // 画像をUIImageViewに設定する.
        myImage.image = nil
        
        myImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        myImage.layer.masksToBounds = true
        
        myImage.layer.cornerRadius = iphoneWidth*3/5/2
        
        // 画像の表示する座標を指定する.
        //myImage.layer.position = CGPoint(x: self.view.bounds.width/2, y: 200.0)
        
        // UIImageViewをViewに追加する.
        self.view.addSubview(myImage)
        // UIImageView ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー完了
        
        // TextView生成する.ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー開始
        y = y + interval //y= 64 +30 +2*it +iw*3/5 +it
        textViewDetail = UITextView(frame: CGRectMake(interval, y, iphoneWidth - 2 * interval, iphoneHeight-y-160)) //180は適当
        y = iphoneHeight - 160 //textViewの下端
        
        // 表示させるテキストを設定する.
        textViewDetail.text = ""
        
        // 角に丸みをつける.
        textViewDetail.layer.masksToBounds = true
        
        // 丸みのサイズを設定する.
        textViewDetail.layer.cornerRadius = 10.0
        
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
        
        // タグをつける
        textViewDetail.tag = 4
        
        textViewDetail?.delegate = self  //追加
        
        // TextViewをViewに追加する.
        self.view.addSubview(textViewDetail)
        
        // TextView ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー完了

        // UIDatePickerの設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー開始
        myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: "changedMyDateEvent:", forControlEvents: UIControlEvents.ValueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.DateAndTime //日付と時間
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
        
        // UIDatePickerの設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー完了
        
        // UIDatePickerの設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー開始
        birthDatePicker = UIDatePicker()
        birthDatePicker.addTarget(self, action: "changedBirthDateEvent:", forControlEvents: UIControlEvents.ValueChanged)
        birthDatePicker.datePickerMode = UIDatePickerMode.Date //日付
        textFieldBirth.inputView = birthDatePicker
        birthDatePicker.locale = NSLocale(localeIdentifier: "ja") //pickerの表示形式を日本に
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRectMake(0, iphoneHeight/6, iphoneWidth, 40.0))
        toolBar.layer.position = CGPoint(x: iphoneWidth/2, y: iphoneHeight-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let toolBarBtn2      = UIBarButtonItem(title: "完了", style: .Bordered, target: self, action: "tappedToolBarBtn:")
        let toolBarBtnToday2 = UIBarButtonItem(title: "現在", style: .Bordered, target: self, action: "tappedToolBarBtnToday:")
        
        toolBarBtn.tag = 2
        toolBar.items = [toolBarBtn2, toolBarBtnToday2]
        
        textFieldBirth.inputAccessoryView = toolBar
        // UIDatePickerの設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー完了
        
        if (existingItem != nil) {
            textFieldName.text = name
            textFieldTime.text = time
            myImage?.image = pic
            textViewDetail.text = detail
            textFieldBirth.text = birth
            
        } else { //existingItemが空だったら新規画面、
            // TimeLabel入力欄の設定-------------------------------------------------------------------------
            textFieldTime.text        = dateToMyString(NSDate()) //初期入力
            
            //写真の取得
            self.selectImageWayBtn()
        }
        //それ以外は既存の項目を表示
        // Do any additional setup after loading the view, typically from a nib.
        
        //範囲外タップで"onTap"からキーボードを格納
        let _singleTap = UITapGestureRecognizer(target: self, action: "onTap:")
        _singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(_singleTap)

    }
    
    // textFieldで改行が押されるとキーボードを収納
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    // textviewのキーボードの格納
    func onTap (recognizer:UIPanGestureRecognizer){
        textFieldName.resignFirstResponder()
        textFieldTime.resignFirstResponder()
        textViewDetail.resignFirstResponder()
        textFieldBirth.resignFirstResponder()
    }
    
    // textViewの表示位置の追随---------------------------------------------------------------------開始
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
//        if textField.tag == 5 {
//            selectBirthWay()
//        }
        
        if textField.tag == 2 {
            IsBirthPickerEditing = false
            IsDatePickerEditing  = true
        }
        if textField.tag == 5 {
            IsDatePickerEditing  = false
            IsBirthPickerEditing = true
        }
        
        textFieldIsEditing = true
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
        IsDatePickerEditing  = false
        IsBirthPickerEditing = false
        textFieldIsEditing = false
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        textViewIsEditing = true
        return true
    }

    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        return true
    }

    override func viewWillAppear(animated: Bool) {
        // Viewの表示時にキーボード表示・非表示を監視するObserverを登録する
        super.viewWillAppear(animated)
        if !textViewIsEditing {
            let notification = NSNotificationCenter.defaultCenter()
            notification.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            notification.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
            textViewIsEditing = false
            
        }
    }
    override func viewWillDisappear(animated: Bool) {
        // Viewの表示時にキーボード表示・非表示時を監視していたObserverを解放する
        super.viewWillDisappear(animated)
        if textViewIsEditing {
            let notification = NSNotificationCenter.defaultCenter()
            notification.removeObserver(self)
            notification.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            notification.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
            textViewIsEditing = false
        }
    }
    
    func keyboardWillShow(notification: NSNotification?) {
        // キーボード表示時の動作をここに記述する
        if textViewIsEditing {
            let rect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            let duration:NSTimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as Double
            UIView.animateWithDuration(duration, animations: {
                let transform = CGAffineTransformMakeTranslation(0, -rect.size.height + 160 - self.interval)
                self.view.transform = transform
                },completion:nil)
        } else {
            return
        }
    }
    func keyboardWillHide(notification: NSNotification?) {
        // キーボード消滅時の動作をここに記述する
        if textViewIsEditing {
            textViewIsEditing = false
            let duration = (notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as Double)
            UIView.animateWithDuration(duration, animations:{
                self.view.transform = CGAffineTransformIdentity
                },completion:nil)
        } else {
            return
        }
        
    }
    // textViewの表示位置の追随ここまで-------------------------------------------------------------------------------------

    
    // UIDatePickerここから----------------------------------------------------------------------------------------
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        textFieldTime.resignFirstResponder()
        textFieldBirth.resignFirstResponder()
    }
    
    // 「現在」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        if IsDatePickerEditing == true {
            myDatePicker.date = NSDate()
            self.changeMyLabelDate(NSDate())
        } else if IsBirthPickerEditing == true {
            birthDatePicker.date = NSDate()
            changeBirthLabelDate(NSDate())
        }
    }

    func changedMyDateEvent(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as UIDatePicker
        self.changeMyLabelDate(myDatePicker.date)
    }
    
    func changedBirthDateEvent(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as UIDatePicker
        self.changeBirthLabelDate(birthDatePicker.date)
    }
    
    func changeMyLabelDate(date:NSDate) {
        textFieldTime.text = self.dateToMyString(date)
    }
    
    func changeBirthLabelDate(date:NSDate) {
        textFieldBirth.text = self.dateToBirthString(date)
    }
    
    func dateToMyString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let comps: NSDateComponents = calender.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit|NSCalendarUnit.SecondCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        
        var date_formatter: NSDateFormatter = NSDateFormatter()
        var weekdays = ["", "日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = " 登録: yyyy/MM/dd (\(weekdays[comps.weekday])) HH:mm  "
        
        return date_formatter.stringFromDate(date)
    }
    
    func dateToBirthString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        
        var date_formatter: NSDateFormatter = NSDateFormatter()
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = " yyyy/MM/dd 生まれ"
        
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
    
    //誕生日の設定
//    private func selectBirthWay(){
//        let alertController = UIAlertController(title: "誕生日を編集", message: nil, preferredStyle: .Alert)
//        let firstAction = UIAlertAction(title: "誕生日を入力", style: .Default) {
//            action in self.textFieldBirth.inputView = self.birthDatePicker
//        }
//        let secondAction = UIAlertAction(title: "誕生年のみを入力", style: .Default) {
//            action in self.pickImageFromLibrary()
//        }
//        let thirdAction = UIAlertAction(title: "誕生日不明", style: .Default) {
//            action in self.textFieldBirth.text = "誕生日不明"
//        }
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
//            action in return
//        }
//        
//        alertController.addAction(firstAction)
//        alertController.addAction(secondAction)
//        alertController.addAction(thirdAction)
//        alertController.addAction(cancelAction)
//        
//        //For ipad And Univarsal Device
//        alertController.popoverPresentationController?.sourceView = view as UIView
//        alertController.popoverPresentationController?.sourceRect = CGRect(x: (self.view.frame.size.width/2), y: self.view.frame.size.height, width: 0, height: 0)
//        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
//        
//        presentViewController(alertController, animated: true, completion: nil)
//    }

    
    @IBAction func saveTapped(sender: AnyObject) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
        
        if (existingItem != nil) { //もしexistingItemがあったら
            existingItem.setValue(textFieldName.text as String, forKey: "name")
            existingItem.setValue(textFieldTime.text as String, forKey: "recordTimeString")
            existingItem.setValue(myImage.image , forKey: "pic")
            existingItem.setValue(textViewDetail.text as String, forKey: "detail")
            existingItem.setValue(textFieldBirth.text as String, forKey: "birthday")

            
        } else {   // なかったら
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
            //新規画面から写真選択をキャンセルしてSaveしようとするとしたの行でエラー:解決済み
            newItem.pic = myImage.image!
            newItem.detail = textViewDetail.text
            newItem.birthday = textFieldBirth.text
            
            println(newItem)
        }
        contxt.save(nil)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func cancelTapped(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    @IBAction func editTapped(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "何を編集しますか", message: nil /*"どこから追加しますか？",*/ , preferredStyle: .ActionSheet)
//        let firstAction = UIAlertAction(title: "設定", style: .Default) {
//            action in self.pickImageFromCamera()
//        }
        let secondAction = UIAlertAction(title: "写真を変更", style: .Default) {
            action in self.selectImageWayBtn()
        }
        let thirdAction = UIAlertAction(title: "誕生日リセット", style: .Default) {
            action in self.textFieldBirth.text = "誕生日未設定"
            }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
            action in return
        }
        
//        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        
        //For ipad And Univarsal Device
        alertController.popoverPresentationController?.sourceView = view as UIView
        alertController.popoverPresentationController?.sourceRect = CGRect(x: (self.view.frame.size.width/2), y: self.view.frame.size.height, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    //写真選択-------------------------------------------------------------------------------------------------------
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.allowsEditing = true
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.allowsEditing = true
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
