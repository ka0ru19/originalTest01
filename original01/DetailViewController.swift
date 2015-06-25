//
//  ListViewController.swift
//  CoreDataTableView20150625
//
//  Created by 井上航 on 2015/06/25.
//  Copyright (c) 2015年 Wataru.I. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var myImage: UIImageView! = nil
//    @IBOutlet weak var textFieldPic: UITextField!
    @IBOutlet weak var textViewDetail: UITextView!
    
    //@IBOutlet weak var textFieldDate: UITextField!
    
    var name: String! = ""
    var pic: UIImage! = nil
    var detail: String! = ""
    var existingItem: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (existingItem != nil) {
            textFieldName.text = name
            myImage?.image = pic
            textViewDetail.text = detail
        } else { //existingItemが空だったら新規画面、
            self.pickImageFromCamera()
            self.pickImageFromLibrary()
        }
        //それ以外は既存の項目を表示
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
        
        if (existingItem != nil) { //もしexistingItemがあったら
            
            existingItem.setValue(textFieldName.text as String, forKey: "name")
            existingItem.setValue(myImage.image , forKey: "pic")
            existingItem.setValue(textViewDetail.text as String, forKey: "detail")
            
        } else {   // なかったら
            
            var newItem = Model(entity: en!, insertIntoManagedObjectContext: contxt)
            newItem.name = textFieldName.text
            //新規画面から写真選択をキャンセルしてSaveしようとするとしたの行でエラー
            newItem.pic = myImage.image!
            newItem.detail = textViewDetail.text
            
            println(newItem)
        }
        contxt.save(nil)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    @IBAction func cancelTapped(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
