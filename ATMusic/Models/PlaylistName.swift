//
//  PlaylistName.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 9/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import RealmSwift

class PlaylistName: Object {
    dynamic var id: Int = -1
    dynamic var name: String!
    dynamic var isUse: Bool = false

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(isUse: Bool) {
        self.init()
        id = getLastID() + 1
        name = Strings.PlaylistNamePlaceHolder + " \(id)"
        self.isUse = isUse
    }

    private func getLastID() -> Int {
        return RealmManager.getLastID(PlaylistName)?.id ?? (-1)
    }

    func setUsing(isUse: Bool) {
        RealmManager.setUsingForItem(self, isUse: isUse)
    }

    class func firstItemFree() -> PlaylistName {
        if let item = RealmManager.getFirstItemFree() {
            return item
        }
        let item = PlaylistName(isUse: false)
        RealmManager.add(item)
        return item
    }

    class func getItemWithName(name: String?) -> PlaylistName? {
        if let name = name {
            return RealmManager.getItemWithName(name)
        }
        return nil
    }
}
