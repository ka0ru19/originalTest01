//
//  Model.swift
//  original01
//
//  Created by 井上航 on 2015/06/25.
//  Copyright (c) 2015年 Wataru.I. All rights reserved.
//

import UIKit
import CoreData

class Model: NSManagedObject {
   
    @NSManaged var name: String
    @NSManaged var pic: UIImage
    @NSManaged var detail: String
    
    
}