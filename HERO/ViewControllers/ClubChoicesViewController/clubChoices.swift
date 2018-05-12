//
//  clubChoices.swift
//  HERO
//
//  Created by Clifford Yin on 2/2/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

protocol ChooseClubDelegate {
    func chooseClub(chosenClub: String)
}

/* Code that manages displaying and integrating the community service types with the HERO posts */
class clubChoices: UITableViewController {

    var clubs = ["Animal Welfare", "Arts and Culture", "Children", "Community","Disaster Relief", "Economic Assistance","Education", "Environment", "Health", "Poverty Alleviation","STEM", "Social Action"]
    
    var delegate2: ChooseClubDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "club", for: indexPath) as? club
        cell?.configure(clubbed: clubs[indexPath.row])

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? club
        let cellText: String = (cell?.clubName.text)!
        delegate2.chooseClub(chosenClub: cellText)
        dismiss(animated: true, completion: nil)
    }

}
