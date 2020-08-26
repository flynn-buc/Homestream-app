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
typealias genericClosure<T> = (T) -> Void

final class ClientService: NSObject{
    static let instance = ClientService()
    var token: String?
    
    let session = URLSession(configuration: .default)
    var URL_BASE = "http://\(IP):\(port)"
    
    override init(){
        super.init()
        updateAddress()
    }
    // Update address from settings
    func updateAddress(){
        if let userData = UserDefaults.init(suiteName: "User Data"){
            guard let IP = userData.string(forKey: UserDefaultKey.localIP.rawValue) else{return}
            guard let port = userData.string(forKey: UserDefaultKey.port.rawValue) else{return}
            setCustomAddress(ip: IP, port: port)
        }
    }
    // set custom address to be used for API Calls
    func setCustomAddress(ip: String, port: String){
        self.URL_BASE = "http://\(ip):\(port)"
    }
    
    // Generic call 'Get' call to server
    private func genericGet<T>(url: URL, decodingObjectSuccess: T.Type, onSuccess: @escaping genericClosure<T>, onError: @escaping OnAPIFailure) where T: Codable{
        
        if let token = token {
            print("Token before sending: \(token)")
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(token, forHTTPHeaderField: "token")
            
            
            print("URL::: \(url.absoluteString)") // print url Used
            let task = session.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        onError("error there: \(error.localizedDescription)")
                        return
                    }
                    guard let data = data, let response = response as? HTTPURLResponse else{
                        onError("Invalid Data or Response")
                        return}
                    
                    do{
                        if response.statusCode == 200{ // success
                            let response = try JSONDecoder().decode(decodingObjectSuccess, from: data)
                            onSuccess(response)
                        } else { // non success
                            let err = try JSONDecoder().decode(APIError.self, from: data)
                            onError(err.message)
                        }
                    }catch{
                        onError("error here: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }else{
            authenticateRetrieveToken { (response) in
                self.genericGet(url: url, decodingObjectSuccess: decodingObjectSuccess, onSuccess: onSuccess, onError: onError)
                print("Token: \(response)")
            }
        }
    }
    
    // Server call to retrieve all data
    func get(foldersAndFilesAt path: String? = defaultPath , onSuccess: @escaping OnGetFoldersAndFilesSuccess, onError: @escaping OnAPIFailure){
        let url = URL(string: "\(URL_BASE)\(path!)/")!
        genericGet(url: url, decodingObjectSuccess: MessageData.self) { (success) in
            onSuccess(success)
        } onError: { (error) in
            print("Error in getFoldersAndFilesAt")
            onError(error)
        }
    }
    
    // Server call to initiate streaming for a single file
    func get(fileAt path: String, onSuccess: @escaping OnGetFileSuccess, onError: @escaping OnAPIFailure){
        let url = URL(string: "\(URL_BASE)\(path)")!
        genericGet(url: url, decodingObjectSuccess: ServerFile.self) { (success) in
            onSuccess(success)
        } onError: { (error) in
            print("Error in fileAt")
            onError(error)
        }
    }
    
    //Server call to refresh data
    func refresh(onSuccess: @escaping OnAPIFailure, onError: @escaping OnAPIFailure){
        let url = URL(string: "\(URL_BASE)/Refresh/")!
        genericGet(url: url, decodingObjectSuccess: APIError.self) { (success) in
            onSuccess(success.message)
        } onError: { (error) in
            print("Error in Refresh")
            onError(error)
        }
    }
    
    func getFavorites(onSuccess: @escaping OnGetFoldersAndFilesSuccess, onError: @escaping OnAPIFailure){
        let url = URL(string: "\(URL_BASE)/Get_favorites/")!
        genericGet(url: url, decodingObjectSuccess: MessageData.self) { (success) in
            onSuccess(success)
        } onError: { (error) in
            print("Error in getFoldersAndFilesAt")
            onError(error)
        }
    }
    
    
    
    func play(file: File, onSuccess: @escaping OnGetFileSuccess, onError: @escaping OnAPIFailure){
        let url = URL(string: "\(URL_BASE)/start_stream/")!
        let fileDic = ["address": "\(URL_BASE)", "hash" : file.hash] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token!, forHTTPHeaderField: "token")
        guard let httpBody = getHTTPBody(dictionnary: fileDic) else{return}
        request.httpBody = httpBody
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError("error there: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    onError("Invalid Data or Response")
                    return}
                
                do{
                    if response.statusCode == 200{ // success
                        let response = try JSONDecoder().decode(ServerFile.self, from: data)
                        onSuccess(response)
                    } else { // non success
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
    
    func authenticateRetrieveToken(onSuccess: @escaping OnAPIFailure){
        print("Authenticating.....")
        let url = URL(string: "\(URL_BASE)/Authenticate/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let username = UserPrefs.data.string(forTextKey: .username) else{return}
        guard let password = UserPrefs.data.string(forTextKey: .password) else{return}
        
        
        guard let httpBody = getHTTPBody(dictionnary: ["username": username, "password": password]) else{return}
        request.httpBody = httpBody
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("error authenticate: \(error.localizedDescription)")
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    print("Invalid Authenticate Request")
                    return
                }
                do{
                    if response.statusCode == 200{
                        let response = try JSONDecoder().decode(APIError.self, from: data)
                        print("Token Str: \(response.message)")
                        self.token = response.message
                        onSuccess(response.message)
                    }else{
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        print(err.message)
                    }
                }catch{
                    print("Error authentication: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    private func getHTTPBody(dictionnary: [String: Any]) -> Data?{
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionnary, options: .prettyPrinted)
        let parsedObject = try! JSONSerialization.jsonObject(with: jsonData!, options: .fragmentsAllowed)
        print(parsedObject)
        return try?JSONSerialization.data(withJSONObject: parsedObject, options: .fragmentsAllowed)
    }
    
    private func patch(data: [String:Any]){
        let url = URL(string: "\(URL_BASE)/Patch-file-folder/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = getHTTPBody(dictionnary: data) else{return}
        request.httpBody = httpBody
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error there: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    print("Invalid Data or Response")
                    return}
                
                do{
                    if response.statusCode == 200{ // success
                        let response = try JSONDecoder().decode(APIError.self, from: data)
                        print(response.message)
                    } else { // non success
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        print(err.message)
                    }
                }catch{
                    print("error here: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    
    func patch(folder: Folder){
        let data = ["type": "folder" ,"name":folder.name, "hash": folder.hash, "isFavorite": folder.isFavorite] as [String : Any]
        patch(data: data)
    }
    
    func patch(file: File){
        let data = ["type": "file" ,"name":file.name, "hash": file.hash, "isFavorite": file.isFavorite, "playbackPosition": file.playbackPosition] as [String : Any]
        
        patch(data: data)
    }
}
