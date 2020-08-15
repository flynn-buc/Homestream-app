//
//  StringExtension.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation

extension String{
    static func pathAsURL (_ pathURL: Any) -> String{
       return "\(pathURL)".pathAsURL()
   }
    //Return path from string encoded as URL
     internal func pathAsURL() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}
