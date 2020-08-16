//
//  DataManager.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation

typealias onGetMessageDataSuccess = (Any) ->()
typealias onloadFileSuccess = (Any) ->()
typealias onSuccess = (Any)->()
typealias onError = onSuccess
protocol DataManager {
    func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError)
    func refresh(onSuccess: @escaping onSuccess, onError: @escaping onError)
    func loadFile(file: File, onSuccess: @escaping onloadFileSuccess, onError: @escaping onError)
    }

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
}

class FavoritesDataManager: DefaultDataManager{
    
    override func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError) {
        ClientService.instance.getFavorites { (data) in
            
        } onError: { (error) in
            onError(error)
        }

    }
}
