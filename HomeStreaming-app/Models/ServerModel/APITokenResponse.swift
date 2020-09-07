//
//  APITokenResponse.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/26/20.
//

import Foundation

//Get token response from server to authenticate
struct APITokenResponse: Codable{
    let ip: String
    let token: String
}
