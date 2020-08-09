//
//  ClientService.swift
//  HomeServer
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import Foundation
import SocketIO

let IP = "nissa.local"
let port = 3004
let defaultPath = "/get-data"

typealias OnGetFoldersAndFilesSuccess = (MessageData) -> Void
typealias OnGetFileSuccess = (ServerFile) -> Void
typealias OnAPIFailure = (String) -> Void
typealias onRefreshSuccess = (String) -> Void

class ClientService: NSObject{
    static let instance = ClientService()
    
    var URL_BASE = "http://\(IP):\(port)"
    
    
    
    override init(){
        super.init()
        updateAddress()
    }
    
    
    func updateAddress(){
        if let userData = UserDefaults.init(suiteName: "User Data"){
            guard let IP = userData.string(forKey: UserDefaultKey.localIP.rawValue) else{return}
            guard let port = userData.string(forKey: UserDefaultKey.port.rawValue) else{return}
            setCustomAddress(ip: IP, port: port)
        }
    }
    
    func setCustomAddress(ip: String, port: String){
        self.URL_BASE = "http://\(ip):\(port)"
    }
    
    let session = URLSession(configuration: .default)
    
    func get(foldersAndFilesAt path: String? = defaultPath , onSuccess: @escaping OnGetFoldersAndFilesSuccess, onError: @escaping OnAPIFailure){
        
        let url = URL(string: "\(URL_BASE)\(path!)/")!
        print("URL::: \(url.absoluteString)")
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    
                    onError("error: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    onError("Invalid Data or Response")
                    return}
                
                do{
                    if response.statusCode == 200{
                        let response = try JSONDecoder().decode(MessageData.self, from: data)
                        onSuccess(response)
                        // handle success
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }catch{
                    onError("error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func get(fileAt path: String, onSuccess: @escaping OnGetFileSuccess, onError: @escaping OnAPIFailure){
        
        let url = URL(string: "\(URL_BASE)\(path)")!
        print("URL::: \(url.absoluteString)")
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    
                    onError("error there: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    onError("Invalid Data or Response")
                    return}
                
                do{
                    if response.statusCode == 200{
                        
                        let response = try JSONDecoder().decode(ServerFile.self, from: data)
                        onSuccess(response)
                        // handle success
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }catch{
                    onError("error here: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func refresh(onSuccess: @escaping OnAPIFailure, onError: @escaping OnAPIFailure){
        
        let url = URL(string: "\(URL_BASE)/Refresh/")!
        print("URL::: \(url.absoluteString)")
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    
                    onError("error there: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    onError("Invalid Data or Response")
                    return}
                
                do{
                    if response.statusCode == 200{
                        
                        let response = try JSONDecoder().decode(APIError.self, from: data)
                        onSuccess(response.message)
                        // handle success
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }catch{
                    onError("error here: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
