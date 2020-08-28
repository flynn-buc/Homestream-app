//
//  UICollectionViewExtension.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/15/20.
//

import Foundation
import Differ
extension UICollectionView{
    //Animate cell refresh
    func reloadChanges<T: Collection>(from old: T, to new: T, updateData: (()->Void) = {}) where T.Element: Equatable {
        self.animateItemChanges(oldData: old, newData: new, updateData: updateData)
        
    }
}
