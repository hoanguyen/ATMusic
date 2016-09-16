//
//  Strings.swift
//  ATMusic
//
//  Created by Nguyen Thanh Su on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation

class Strings {
    // MARK: - APIService strings
    static let BaseURLString = "https://api-v2.soundcloud.com"
    static let BaseDownloadString = "https://api.soundcloud.com"
    static let ClientID = "06c6514c5b35b1617db8c129f7420f02"

    // MARK: - Alert strings
    static let Warning = "Warning"
    static let Error = "Error"
    static let Confirm = "Confirm"
    static let Cancel = "Cancel"
    static let CanNotAddPlaylist = "Can not add new Playlist"
    static let PlaylistExist = "Sorry! Exist a playlist has this name."
    static let EmptyPlaylistName = "Sorry! Playlist could not empty."
    static let Yes = "Yes"
    static let CreateQuestion = "Do you want to create a new playlist?"
    static let Delete = "Do you want to delete it?"
    static let Create = "Create new Playlist"
    static let PlaylistNamePlaceHolder = "Playlist"
    static let AddPlaylist = "Add Playlist"
    static let AddPlaylistMessage = "Choose playlist you want to add in."
    static let ExistSong = "Sorry! This playlist exists that song: "
    static let Success = "Successful"
    static let AddSongSuccess = "Add successful the song: "
    static let Failure = "Failure"
    static let AddNew = "New Playlist"
    static let DeletePlaylistSuccess = "Delete playlist successful!"
    static let DeletePlaylistFailure = "Sorry, this playlist is playing!"
    static let DisconnectedNetwork = "No Internet, Please, check your network!"
    static let SongIsPlaying = "The song is playing!"
    static let DeleteError = "Can not delete"

    // MARK: - default duration
    static let DefaultDuration = "0"

    // MARK: - NSNotification
    static let NotificationDetailPlaylist = "detailPlaylist"
    static let NotificationDeletePlaylist = "deletePlaylist"
    static let NotiCellIndex = "cellIndex"
    static let NotiAddPlaylist = "addPlaylist"
    static let NotiDeleteSong = "deleteSong"
    static let NotiChangePlaylistName = "changeName"
    static let NotiReloadWhenAddNew = "reloadWhenAddNew"
    static let NotiCurrentPlaylistAtParentVC = "isCurrentPlaylistAtParentVC"

    // MARK: - static func
    static func getMusicStreamURL(id: Int?) -> NSURL? {
        guard let id = id else { return nil }
        return NSURL(string: BaseDownloadString + "/tracks/\(id)/stream?client_id=" + ClientID)
    }

    static let DetailPlayerVC = "DetailPlayerViewController"
    static let ImageSizeForThumbnail = "t500x500"
    static let LargeString = "large"

    static let Home = "Home"
    static let Chart = "Chart"
    static let Playlist = "Playlist"
    static let Trending = "Trending"
    static let Search = "Search"
    static let Top = "Top"
    static let Music = "Music"
    static let Audio = "Audio"
    static let Categories = "Categories"

    static let paternMatchString = "^(Playlist\\s[0-9]+)$"

    static let ZeroSong = "0 song"
    static let OneSong = "1 song"
    static let Songs = " songs"

    static let DeleteString = "Delete"
    static let Edit = "EDIT"
    static let Save = "SAVE"
    static let Start = "Start"
    static let Pause = "Pause"
    static let Resume = "Resume"
}
