//
//  UIButtonRightImageExtension.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 9/6/20.
//

import Foundation
/// Move an image from the left side of a button to the right side, and move the text from right side to left side
extension UIButton {
  func imageToRight() {
      transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
  }
}
