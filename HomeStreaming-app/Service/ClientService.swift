//
//  ClientService.swift
//  HomeServer
//
//  Created by Jonathan Hirsch on 7/16/20.
//

import Foundation
import SocketIO

let IP = "Nissa.local"
let port = 3004

typealias OnAPISucess = (String) -> Void
typealias OnAPIFailure = (String) -> Void

class ClientService: NSObject{
    static let instance = ClientService()
    
    let URL_BASE = "http://\(IP):\(port)/hithere"
    let URL_ADD_TODO = "/hithere"
    
    
    let session = URLSession(configuration: .default)
    
    func getMessage(onSucess: @escaping OnAPISucess, onError: @escaping OnAPIFailure){
           let url = URL(string: "\(URL_BASE)")!
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
                        onSucess(response.message)
                           // handle success
                       } else {
                           let err = try JSONDecoder().decode(MessageData.self, from: data)
                           onError(err.message)
                       }
                   }catch{
                       onError("error: \(error.localizedDescription)")
                   }
               }
           }
           task.resume()
       }
}


