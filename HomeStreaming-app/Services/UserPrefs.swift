//
//  UserPrefService.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/9/20.
//

import Foundation


final class UserPrefs{
    static let data = UserPrefs()
    private static let textSettings = "User Data"
    private static let switchSettings = "Switch Toggles"
    private let switchesData = UserDefaults.init(suiteName: switchSettings) // preferences from switches (on/off)
    private let userData = UserDefaults.init(suiteName: textSettings) // preferences from textfields (data)
}

//Public
extension UserPrefs{
    //Setters
    func set(_ data: Any, forSwitchKey key: UserDefaultKey){
        set(data, forKey: key, from: switchesData)
    }
    
    func set(_ data: Any, forTextKey key: UserDefaultKey){
        set(data, forKey: key, from: userData)
    }
    
    //SwitchGetters
    func bool(forSwitchKey key: UserDefaultKey) ->Bool?{
        return bool(forKey: key, from: switchesData)
    }
    
    //UserGetters
    func string(forTextKey key: UserDefaultKey) -> String?{
        return string(forKey: key, from: userData)
    }
    
    func bool(forTextKey key: UserDefaultKey) ->Bool?{
        return bool(forKey: key, from: userData)
    }
    
    func int(forTextKey key:UserDefaultKey) -> Int? {
        return int(forKey: key, from: userData)
    }
}


//Private
extension UserPrefs{
    //getters
    private func string(forKey key: UserDefaultKey, from pref: UserDefaults?) -> String?{
        return pref?.string(forKey: key.rawValue)
    }
    
    private func int(forKey key: UserDefaultKey, from pref: UserDefaults?) -> Int?{
        return pref?.integer(forKey: key.rawValue)
    }
    
    private func bool(forKey key: UserDefaultKey, from pref: UserDefaults?) -> Bool?{
        return pref?.bool(forKey: key.rawValue)
    }
    
    //setter
    private func set(_ data: Any, forKey key: UserDefaultKey, from pref: UserDefaults?){
        pref?.set(data, forKey: key.rawValue)
    }
}
