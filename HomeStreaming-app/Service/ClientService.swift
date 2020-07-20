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

typealias OnGetFoldersAndFilesSuccess = (MessageData) -> Void
typealias OnGetFileSuccess = (File) -> Void
typealias OnAPIFailure = (String) -> Void

class ClientService: NSObject{
    static let instance = ClientService()
    
    var URL_BASE = "http://\(IP):\(port)"
    let URL_ADD_TODO = "/"
    
    
    func setCustomAddress(ip: String, port: String){
        self.URL_BASE = "http://\(ip):\(port)"
    }
    
    let session = URLSession(configuration: .default)
    
    func get(foldersAndFilesAt path: String, onSuccess: @escaping OnGetFoldersAndFilesSuccess, onError: @escaping OnAPIFailure){
        
        let url = URL(string: "\(URL_BASE)\(path)/")!
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
                 
                        let response = try JSONDecoder().decode(File.self, from: data)
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
}
