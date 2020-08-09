//
//  UserDefaultKey.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/5/20.
//

/*
 Provides keys to be used when saving data to file. Does not define which file the data will be saved in
 */



import Foundation
enum UserDefaultKey: String{
    case localIP = "localIP"
    case remoteIP = "remoteIP"
    case port = "port"
    case enableRemoteAccess = "enableRemoteAccess"
    case enableAuthentication = "enableAuthentication"
    case username = "username"
    case password = "password"
    
    
}
