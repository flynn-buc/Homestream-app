//
//  VideoPlayerDelegate.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation

// Used to save timestamp from video player
protocol VideoPlayerDelegate {
    func saveTimestamp(timestamp: Int, hash: Int)
}
