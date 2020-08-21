//
//  DataManager.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation

typealias onGetMessageDataSuccess = (Any) ->()
typealias onloadFileSuccess = (Any) ->()
protocol DataManager {
    func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError)
    func refresh(onSuccess: @escaping onSuccess, onError: @escaping onError)
    func loadFile(file: File, onSuccess: @escaping onloadFileSuccess, onError: @escaping onError)
    func patch(data: Any)
    }

extension DataManager{
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

struct DefaultDataManager: DataManager{
    
}

struct FavoritesDataManager: DataManager{
        
     func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError) {
        print("I was called")
        ClientService.instance.getFavorites { (data) in
            onSuccess(data)
        } onError: { (error) in
            onError(error)
        }
    }
}
