//
//  DataManager.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation

typealias onGetMessageDataSuccess = (MessageData) ->()
typealias onSuccess = (String)->()
typealias onError = onSuccess
protocol DataManager {
    func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError)
    func refresh()
    func load()
    }

class DefaultDataManager: DataManager{
    func get(onSuccess: @escaping onGetMessageDataSuccess, onError: @escaping onError) {
        ClientService.instance.get { (data) in
            onSuccess(data)
        } onError: { (error) in
            onError(error)
        }
    }
    
    
    func refresh(){
        ClientService.instance.refresh { (response) in
            print(response)
        } onError: { (error) in
            
        }

    }
    
    func load(){
        
    }
}
