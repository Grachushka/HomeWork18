//
//  dataBaseRealmSwift.swift
//  HomeWork18
//
//  Created by Pavel Procenko on 10/09/2019.
//  Copyright © 2019 Pavel Procenko. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseRealmSwift {
    
    private lazy var realm = try! Realm()
    
    private init() {}

    static let shared = DataBaseRealmSwift()
    
    func getPhones() ->  Results<Phone>! {
        
       return realm.objects(Phone.self)
    }
    
    func addPhone(phone: Phone) {
        
        try! realm.write {
            realm.add(phone)
        }
    }
    
    func deletePhone(phone: Phone) {
        
        try! realm.write {
            realm.delete(phone)
        }
    }
    
    
    
}
