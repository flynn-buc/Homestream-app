//
//  SettingsController.swift
//  HomeStreaming-app
//
//  Created by Jonathan Hirsch on 8/3/20.
//

import UIKit

class SettingsTableVC: UITableViewController {
    private var sections = [[SettingsCellModel]] ()
    private var sectionNames = [String] ()
    private var menuItems = [[[SettingsOptionCellModel]]]()
    
    @IBOutlet var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        
        let cellData = SettingsViewDataSource.instance
        sections = cellData.getRows()
        sectionNames = cellData.getSectionNames()
        menuItems = cellData.getMenuItems() // get all menu Items

        self.clearsSelectionOnViewWillAppear = true // ensure selection is not kept between views
        
        // Display initial Detail view if device is iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            let initialIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition:UITableView.ScrollPosition.none)
            self.performSegue(withIdentifier: "showSettingsDetail", sender: initialIndexPath)
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                settingsTable.visibleCells.forEach { (cell) in
                    cell.accessoryType = .none
                }
            }
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionNames.count == sections.count{
            return sectionNames[section]
        }
        return "wrong"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell{
            let sectionNum = indexPath.section
            let rowNum = indexPath.row
            cell.updateView(cellModel: sections[sectionNum][rowNum])
            return cell
        }
        return SettingsCell()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false // make all cells uneditable
    }
    
    // Display detailVC for selected cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettingsDetail"{
            if let indexPath = settingsTable.indexPathForSelectedRow{
                let section = sections[indexPath.section]
                let cellModel = section[indexPath.row]
                if let controller = (segue.destination as? UINavigationController)?.topViewController as? SettingsDetailVC{
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.menuItems = menuItems[indexPath.section][indexPath.row]
                    controller.navigationItem.title = cellModel.title
                }
            }
        }
    }
}
