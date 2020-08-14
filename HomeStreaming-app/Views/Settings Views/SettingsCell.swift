//
//  SettingsCell.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/3/20.
//

import UIKit

class SettingsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // set data in Settings cell with appropriate icon and title
    func updateView(cellModel: SettingsCellModel){
        self.textLabel?.text = cellModel.title
        self.imageView?.image = cellModel.icon
    }

}
