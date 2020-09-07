//
//  DataManager.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation

typealias onGetMessageDataSuccess = (Any)->()
typealias onloadFileSuccess = (Any)->()

///Represents a manager to interface with Client Data service. Enables abstraction of data querying and updating based on the type desired
protocol DataManager {
    func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError)
    func refresh(onSuccess: @escaping onSuccess, onError: @escaping onError)
    func loadFile(file: File, onSuccess: @escaping onloadFileSuccess, onError: @escaping onError)
    func patch(data: Any)
    }

/// Default Manager, should be overriden to provide additional functionality (i.e. favorites)
class DefaultDataManager: DataManager{
    func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError) {
            ClientService.instance.get(){ (data) in
                onSuccess(data)
            } onError: { (error) in
                onError(error)
            }
        }
        
        func refresh(onSuccess: @escaping onSuccess, onError: @escaping onError){
            ClientService.instance.refresh { (response) in
                print(response)
                onSuccess(response)
            } onError: { (error) in
                onError(error)
            }
        }
        
        func loadFile(file: File, onSuccess: @escaping onloadFileSuccess, onError: @escaping onError) {
            ClientService.instance.play(file: file) { (serverFile) in
                onSuccess(serverFile)
            } onError: { (error) in
                onError(error)
            }
        }
        
        func patch(data: Any){
            if let file = data as? File{
                ClientService.instance.patch(file: file)
            }
            if let folder = data as? Folder{
                ClientService.instance.patch(folder: folder)
            }
        }
}

/// Represents a DataManager that will only retrieve favorites
class FavoritesDataManager: DefaultDataManager{
     override func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError) {
        ClientService.instance.getFavorites(onSuccess: onSuccess, onError: onError)
    }
}

typealias onGetTVShowSuccess = (TVShowData)->()
///Represents a Data manager for retrieving TV Shows specifically
class TVShowDataManager: DefaultDataManager{
    
     override func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError){
        ClientService.instance.getTVShowData(onSuccess: onSuccess, onError: onError);
    }
}

class TVShowFavoritesDataManager: TVShowDataManager{
    
    
}
