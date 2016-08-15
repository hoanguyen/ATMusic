//
//  BaseVC.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/4/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

typealias AddFinished = () -> Void

class BaseVC: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configUI()
    }
    func loadData() { }
    func configUI() {
    }

    // Show actionsheet to add song into playlist
    func addSongIntoPlaylist(song: Song?) {
        guard let playlists = RealmManager.getAllPlayList() where playlists.count != 0 else {
            Alert.sharedInstance.showActionSheet(self, title: Strings.AddPlaylist, message: Strings.AddPlaylistMessage,
                options: nil) { (index, isCreate) in
                    if isCreate {
                        self.createNewPlaylist({
                            self.addSongIntoPlaylist(song)
                        })
                    }
            }
            return
        }
        var options = [String]()
        for item in playlists {
            options.append(item.name)
        }
        Alert.sharedInstance.showActionSheet(self, title: Strings.AddPlaylist, message: Strings.AddPlaylistMessage,
            options: options) { (index, isCreate) in
                if isCreate {
                    self.createNewPlaylist({
                        self.addSongIntoPlaylist(song)
                    })
                } else {
                    if let song = song, index = index {
                        if playlists[index].addSong(song) {
                            Alert.sharedInstance.showAlert(self, title: Strings.Success, message: Strings.AddSongSuccess.concat(song.songName))
                        } else {
                            Alert.sharedInstance.showAlert(self, title: Strings.Failure, message: Strings.ExistSong.concat(song.songName))
                        }
                    }
                }
        }
    }

    private func createNewPlaylist(finished: AddFinished) {
        Alert.sharedInstance.inputTextAlert(self, title: Strings.Create, message: Strings.CreateQuestion) { (text) in
            RealmManager.add(Playlist(name: text))
            finished()
        }
    }

}
