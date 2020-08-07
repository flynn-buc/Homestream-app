//
//  SettingsDataBuilder.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/3/20.
//

import Foundation
import UIKit
import CoreData

class SettingsViewDataSource{
    static let instance = SettingsViewDataSource()
    //private let config = UIImage.SymbolConfiguration(weight: .light)
    
    
    private var systemSection = [SettingsCellModel] ()
    private var streamingSection = [SettingsCellModel] ()
    private var SubtitleSection = [SettingsCellModel] ()
    
    /*
     Section 1:
     */
    
    
    private var sections = [[SettingsCellModel]]()
    private var sectionTitle = ["System", "Streaming"]
    
    
    
    private let connection = SettingsCellModel(icon: UIImage(systemName: "wifi"), title: "Network")
    private let login = SettingsCellModel(icon: UIImage(systemName: "lock.fill"), title: "Login")
    
    private let video = SettingsCellModel(icon: UIImage(systemName: "film"), title: "Video")
    private let audio = SettingsCellModel(icon: UIImage(systemName: "speaker.wave.3"), title: "Audio")
    private let subtitle = SettingsCellModel(icon: UIImage(systemName: "captions.bubble"), title: "Subtitles")
    
  
    
    
    private var menuItems = [[[SettingsOptionCellModel]]]()
    
     private init(){
        
        
        systemSection = [connection, login]
        
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






class Items{
    private var items = [SettingsOptionCellModel]()
    func getItems() ->[SettingsOptionCellModel]{
        return items
    }
    
    fileprivate init(items: [SettingsOptionCellModel]){
        self.items = items
    }
}




class NetworkItems: Items{

    private let localIP = TextSettingsOptionCellModel(title: "Local Server IP:", key: .localIP)
    private let port = TextSettingsOptionCellModel(title: "Port:", key: .port)
    private let remoteAccess = SwitchSettingsOptionCellModel(title: "Enable Remote Access:", key: .enableRemoteAccess)
    private let remoteIP = TextSettingsOptionCellModel(title: "Remote Server IP:", key: .remoteIP, keyIfDisplayed: .enableRemoteAccess)
    
     init(){

       // let preferences = UserPreferences(context: managedContext)
        super.init(items: [localIP, port, remoteAccess, remoteIP])
       
    }
}

class LoginItems: Items{

    private let useLoginItem = SwitchSettingsOptionCellModel(title: "Enable Authentication", key: .enableAuthentication)
    private let username = TextSettingsOptionCellModel(title: "Username: ", key: .username, keyIfDisplayed: .enableAuthentication)
    private let password = TextSettingsOptionCellModel(title: "Password: ", key: .password, keyIfDisplayed: .enableAuthentication)
     init(){
        super.init(items: [useLoginItem, username, password])
    }
}

class VideoItems: Items{
     init(){
        super.init(items: [])
    }
}

class AudioItems: Items{
     init(){
        super.init(items: [])
    }
}

class SubtitleItems: Items{
     init(){
        super.init(items: [])
    }
}
