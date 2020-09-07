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
typealias OnAPIStringResponse = (String) -> Void
typealias onRefreshSuccess = (String) -> Void
typealias genericClosure<T> = (T) -> Void
typealias OnGetTVShowSuccess = (TVShowData) -> Void

final class ClientService: NSObject{
    static let instance = ClientService()
    private var token: String?
    
    private let session = URLSession(configuration: .default)
    private var URL_BASE = "http://\(IP):\(port)"
    private var numTries = 0
    private let maxTries = 5 // used to attempt authentication up to 5 times
    
    private let queue = DispatchQueue(label: "ThreadSafeCollection.queue", attributes: .concurrent)
    
    private var isLocalIP = false
    
    private let patch_file_folder = "/patch-file-folder/"
    private let get_data_default = "/get-data/"
    private let refresh_all = "/refresh/"
    private let start_stream = "/start_stream/"
    private let get_favorites_default = "/get_favorites/"
    private let authenticate = "/authenticate/"
    private let ping =  "/ping/"
    private let get_tv_shows = "/get_tv_shows/"
    
    private let GET = "GET"
    private let POST = "POST"
    private let PATCH = "PATCH"
    
    override init(){
        super.init()
        updateAddress()
    }
    // Update address from settings
    func updateAddress(){
        isLocalIP = !isLocalIP
        guard let IP = UserPrefs.data.string(forTextKey: isLocalIP ? .localIP: .remoteIP) else{return}
        guard let port = UserPrefs.data.string(forTextKey: .port) else{return}
        print("updating ip to \(IP)")
        setCustomAddress(ip: IP, port: port)
    }
    // set custom address to be used for API Calls
    func setCustomAddress(ip: String, port: String){
        self.URL_BASE = "http://\(ip):\(port)"
    }
    
    private func tryAuthentication<T>(_ path: String, _ request: URLRequest, _ decodingObjectSuccess: T.Type, _ onSuccess: @escaping genericClosure<T>, _ onError: @escaping OnAPIStringResponse) where T: Codable {
        if (numTries >= maxTries){
            numTries = 0
            print("Authentication Error: Max tries reached")
            return
        }
        numTries += 1
        authenticateRetrieveToken { (token) in
            print("Token \(token) created")
            self.genericRequest(path: path, request: request, decodingObjectSuccess: decodingObjectSuccess, onSuccess: onSuccess, onError: onError)
            
        } onError: { (error) in
            print("Could not authenticate \(error)")
            onError(error)
        }
    }
    
    private func genericRequest<T>(path: String, request: URLRequest, decodingObjectSuccess: T.Type, onSuccess: @escaping genericClosure<T>, onError: @escaping OnAPIStringResponse) where T: Codable{
        queue.async(flags: .barrier){
            if let innerToken = self.token{
                var requestToSend = request
                requestToSend.addValue("application/json", forHTTPHeaderField: "Content-Type")
                requestToSend.addValue("application/json", forHTTPHeaderField: "Accept")
                requestToSend.addValue(innerToken, forHTTPHeaderField: "Token")
                
                
                print("URL::: \(request.url!)") // print url Used
                let task = self.session.dataTask(with: requestToSend) { (data, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            onError("error there: cannot connect \(error.localizedDescription)")
                            return
                        }
                        guard let data = data, let response = response as? HTTPURLResponse else{
                            onError("Invalid Data or Response")
                            return}
                        
                        do{
                            if response.statusCode == 200{ // success
                                let response = try JSONDecoder().decode(decodingObjectSuccess, from: data)
                                onSuccess(response)
                            }else if response.statusCode == 401{
                                self.token = nil
                                print("error 401")
                                self.tryAuthentication(path, request, decodingObjectSuccess, onSuccess, onError)
                            } else { // non success
                                let err = try JSONDecoder().decode(APIStrMessageResponse.self, from: data)
                                onError("CONNECTION ERROR: \(err.message)")
                            }
                        }catch{
                            onError("error here: \(error)")
                        }
                    }
                }
                task.resume()
            }else{
                self.tryAuthentication(path, request, decodingObjectSuccess, onSuccess, onError)
            }
        }
    }
    
    // Generic call 'Get' call to server
    private func genericGet<T>(path: String, url: URL, decodingObjectSuccess: T.Type, onSuccess: @escaping genericClosure<T>, onError: @escaping OnAPIStringResponse) where T: Codable{
        var request = URLRequest(url: url)
        request.httpMethod = GET
        genericRequest(path: path, request: request, decodingObjectSuccess: decodingObjectSuccess, onSuccess: onSuccess, onError: onError)
    }
    
    // Server call to retrieve all data
    func get(foldersAndFilesAt path: String = defaultPath , onSuccess: @escaping OnGetFoldersAndFilesSuccess, onError: @escaping OnAPIStringResponse){
        let url = URL(string: "\(URL_BASE)\(path)/")!
        self.genericGet(path: "\(path)/" , url: url, decodingObjectSuccess: MessageData.self) { (success) in
            onSuccess(success)
        } onError: { (error) in
            print("Error in getFoldersAndFilesAt")
            onError(error)
        }
    }
    
    // Server call to initiate streaming for a single file
    func get(fileAt path: String, onSuccess: @escaping OnGetFileSuccess, onError: @escaping OnAPIStringResponse){
        let url = URL(string: "\(URL_BASE)\(path)")!
        self.genericGet(path: "\(path)/", url: url, decodingObjectSuccess: ServerFile.self) { (success) in
            onSuccess(success)
        } onError: { (error) in
            print("Error in fileAt")
            onError(error)
        }
    }
    
    //Server call to refresh data
    func refresh(onSuccess: @escaping OnAPIStringResponse, onError: @escaping OnAPIStringResponse){
        let url = URL(string: "\(URL_BASE)\(refresh_all)")!
        self.genericGet(path: "\(refresh_all)" ,url: url, decodingObjectSuccess: APIStrMessageResponse.self) { (success) in
            onSuccess(success.message)
        } onError: { (error) in
            print("Error in Refresh")
            onError(error)
        }
    }
    
    func getFavorites(onSuccess: @escaping OnGetTVShowSuccess, onError: @escaping OnAPIStringResponse){
        queue.async(flags: .barrier){
            let url = URL(string: "\(self.URL_BASE)\(self.get_favorites_default)")!
            self.genericGet(path: "\(self.get_favorites_default)", url: url, decodingObjectSuccess: TVShowData.self) { (success) in
                onSuccess(success)
            } onError: { (error) in
                print("Error in getFavorites")
                onError(error)
            }
        }
    }
    
    func getTVShowData(onSuccess: @escaping OnGetTVShowSuccess, onError: @escaping OnAPIStringResponse){
        let url = URL(string: "\(self.URL_BASE)\(self.get_tv_shows)")!
        self.genericGet(path: "\(self.get_tv_shows)", url: url, decodingObjectSuccess: TVShowData.self) { (success) in
            onSuccess(success)
        } onError: { (error) in
            print("Error in get tv shows")
            onError(error)
        }
    }
    
    
    /**
     Play specified file
     */
    func play(file: File, onSuccess: @escaping OnGetFileSuccess, onError: @escaping OnAPIStringResponse){
        let url = URL(string: "\(URL_BASE)\(start_stream)")!
        let fileDic = ["address": "\(URL_BASE)", "hash" : file.hash] as [String : Any]
        
        var request = URLRequest(url: url)
        
        request.httpMethod = POST
        guard let httpBody = getHTTPBody(dictionnary: fileDic) else{return}
        request.httpBody = httpBody
        
        self.genericRequest(path: "\(start_stream)", request: request, decodingObjectSuccess: ServerFile.self) { (response) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
    
    /**
     Authenticate to server with username & pw
     */
    func authenticateRetrieveToken(onSuccess: @escaping OnAPIStringResponse, onError: @escaping OnAPIStringResponse){
        print("Authenticating.....")
        let url = URL(string: "\(URL_BASE)\(authenticate)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let username = UserPrefs.data.string(forTextKey: .username) else{return}
        guard let password = UserPrefs.data.string(forTextKey: .password) else{return}
        
        
        guard let httpBody = getHTTPBody(dictionnary: ["username": username, "password": password]) else{return}
        request.httpBody = httpBody
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError("error there: cannot connect \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else{
                    print("Invalid Authenticate Request")
                    return
                }
                do{
                    if response.statusCode == 200{
                        let response = try JSONDecoder().decode(APITokenResponse.self, from: data)
                        print("Token Str: \(response.token)")
                        self.token = response.token
                        onSuccess(response.token)
                        if (!(UserPrefs.data.bool(forSwitchKey: .manualRemoteIP) ?? true)){
                            UserPrefs.data.set(response.ip, forTextKey: .remoteIP)
                        }
                    }else{
                        let err = try JSONDecoder().decode(APIStrMessageResponse.self, from: data)
                        print(err.message)
                        onError(err.message)
                    }
                }catch{
                    print("Error authentication: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    /**
     create an HTTP Boty from a dictionnary of with string keys
     */
    private func getHTTPBody(dictionnary: [String: Any]) -> Data?{
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionnary, options: .prettyPrinted)
        let parsedObject = try! JSONSerialization.jsonObject(with: jsonData!, options: .fragmentsAllowed)
        print(parsedObject)
        return try?JSONSerialization.data(withJSONObject: parsedObject, options: .fragmentsAllowed)
    }
    
    /**
     update specified file with speicified dictionnary for data
     */
    private func patch(data: [String:Any]){
        let url = URL(string: "\(self.URL_BASE)\(patch_file_folder)")!
        var request = URLRequest(url: url)
        request.httpMethod = PATCH
        guard let httpBody = getHTTPBody(dictionnary: data) else{return}
        request.httpBody = httpBody
        
        self.genericRequest(path: "\(patch_file_folder)", request: request, decodingObjectSuccess: APIStrMessageResponse.self) { (success) in
            print(success.message)
        } onError: { (error) in
            print(error)
        }
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
