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
        let cellData = SettingsViewDataSource.instance
        sections = cellData.getRows()
        sectionNames = cellData.getSectionNames()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        
        menuItems = cellData.getMenuItems()

        self.clearsSelectionOnViewWillAppear = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
       
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
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
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettingsDetail"{
            
            if let indexPath = settingsTable.indexPathForSelectedRow{
                let section = sections[indexPath.section]
                let cellModel = section[indexPath.row]
                if let controller = (segue.destination as? UINavigationController)?.topViewController as? SettingsDetailVC{
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.menuItems = menuItems[indexPath.section][indexPath.row]
                    controller.navigationController?.title = cellModel.title
                }
            }
        }
    }
}
