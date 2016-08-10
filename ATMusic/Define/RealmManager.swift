//
//  RealmManager.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//
//import RealmSwift
//
//class RealmManager {
//    static let realm = try? Realm()
//
//    class func add(object: Object) {
//        do {
//            try realm?.write({
//                realm?.add(object)
//            })
//        } catch { }
//    }
//
//    class func delete(object: Object) {
//        do {
//            try realm?.write({
//                realm?.delete(object)
//            })
//        } catch { }
//    }
//
//    class func getAllTrack() -> Results<Track>? {
//        return realm?.objects(Track)
//    }
//}
