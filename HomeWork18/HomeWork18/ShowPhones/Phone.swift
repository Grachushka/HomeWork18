//
//  Phone.swift
//  HomeWork18
//
//  Created by Pavel Procenko on 10/09/2019.
//  Copyright © 2019 Pavel Procenko. All rights reserved.
//

import Foundation
import RealmSwift

class Phone: Object {
    
    @objc dynamic var name: String?
    let price: RealmOptional<Double> = RealmOptional()
}
