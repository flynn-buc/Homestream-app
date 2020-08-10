//
//  SettingsDataBuilder.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/3/20.
//

import Foundation
import UIKit

final class SettingsViewDataSource{
    static let instance = SettingsViewDataSource()
    
    
    private var systemSection = [SettingsCellModel] ()
    private var streamingSection = [SettingsCellModel] ()
    private var SubtitleSection = [SettingsCellModel] ()
    
    /*
     Section 1: Network
     */
    
    private var sections = [[SettingsCellModel]]()
    private var sectionTitle = ["System", "Streaming"]
    
    
    private let network = SettingsCellModel(icon: UIImage(systemName: "wifi"), title: "Network")
    private let login = SettingsCellModel(icon: UIImage(systemName: "lock.fill"), title: "Login")
    
    private let video = SettingsCellModel(icon: UIImage(systemName: "film"), title: "Video")
    private let audio = SettingsCellModel(icon: UIImage(systemName: "speaker.wave.3"), title: "Audio")
    private let subtitle = SettingsCellModel(icon: UIImage(systemName: "captions.bubble"), title: "Subtitles")
    
  
    private var menuItems = [[[SettingsOptionCellModel]]]()
    
     private init(){
        systemSection = [network, login]
        streamingSection = [video, audio, subtitle]
        
        let networkItems = NetworkItems().getItems()
        let loginItems = LoginItems().getItems()
        let systemItems = [networkItems, loginItems]
        
        let audioItems = AudioItems().getItems()
        let videoItems = VideoItems().getItems()
        let subtitleItems = SubtitleItems().getItems()
        let streamingItems = [audioItems, videoItems, subtitleItems]
        
        menuItems = [systemItems, streamingItems]
        
        sections.append(systemSection)
        sections.append(streamingSection)
    }
    
    
    func getMenuItems() -> [[[SettingsOptionCellModel]]]{
        return menuItems
    }
    
    func getRows() -> [[SettingsCellModel]]{
        return sections
    }
    
    func getSectionNames()->[String]{
        return sectionTitle
    }
}

private class MenuItems{
    private var items = [SettingsOptionCellModel]()
    func getItems() ->[SettingsOptionCellModel]{
        return items
    }
    
    fileprivate init(items: [SettingsOptionCellModel]){
        self.items = items
    }
}

final private class NetworkItems: MenuItems{

    private let localIP = TextSettingsOptionCellModel(title: "Local Server IP:", key: .localIP)
    private let port = TextSettingsOptionCellModel(title: "Port:", key: .port)
    private let remoteAccess = SwitchSettingsOptionCellModel(title: "Enable Remote Access:", key: .enableRemoteAccess)
    private let remoteIP = TextSettingsOptionCellModel(title: "Remote Server IP:", key: .remoteIP, keyIfDisplayed: .enableRemoteAccess)
    
    init(){
        super.init(items: [localIP, port, remoteAccess, remoteIP])
    }
}

final private class LoginItems: MenuItems{

    private let useLoginItem = SwitchSettingsOptionCellModel(title: "Enable Authentication", key: .enableAuthentication)
    private let username = TextSettingsOptionCellModel(title: "Username: ", key: .username, keyIfDisplayed: .enableAuthentication)
    private let password = TextSettingsOptionCellModel(title: "Password: ", key: .password, keyIfDisplayed: .enableAuthentication)
     init(){
        super.init(items: [useLoginItem, username, password])
    }
}

final private class VideoItems: MenuItems{
     init(){
        super.init(items: [])
    }
}

final private class AudioItems: MenuItems{
     init(){
        super.init(items: [])
    }
}

final private class SubtitleItems: MenuItems{
     init(){
        super.init(items: [])
    }
}
