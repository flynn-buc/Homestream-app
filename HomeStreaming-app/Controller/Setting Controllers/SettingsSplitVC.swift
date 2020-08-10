//
//  SettingsSplitVC.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/4/20.
//

import UIKit

class SettingsSplitVC: UISplitViewController, UISplitViewControllerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
    }
    
    //Display master view on IOS, not Detail View
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
