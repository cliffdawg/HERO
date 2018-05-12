//
//  blockChoices.swift
//  HERO
//
//  Created by Clifford Yin on 5/16/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

protocol ChooseBlockDelegate {
    func chooseBlock(chosenBlock: String)
}

/* Code that handles the options that the user can take regarding blocking/reporting */
class blockChoices: UITableViewController {
    
    var blocks = ["Block Post", "Unblock All", "Report Post"]
    var delegate2: ChooseBlockDelegate!
    
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
        return blocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "block", for: indexPath) as? block
        cell?.configure(blocked: blocks[indexPath.row])
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as? block
        let cellText: String = (cell?.blockName.text)!
        delegate2.chooseBlock(chosenBlock: cellText)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;
    }
    
}
