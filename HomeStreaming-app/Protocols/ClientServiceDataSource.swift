//
//  ClientServiceDataSource.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation
typealias onSuccess = (Any)->()
typealias onError = onSuccess


// Defined getting and retrieving data from ClientDataSource
protocol ClientServiceDataSource{
    var dataManager: DataManager {get}
    func getData(onSuccess: @escaping onSuccess, onError: @escaping onError)
    func refresh(onSuccess: @escaping onSuccess, onError: @escaping onError)
}
