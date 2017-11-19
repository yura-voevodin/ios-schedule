//
//  SearchResultsTableViewController.swift
//  Schedule
//
//  Created by Yura Voevodin on 16.11.17.
//  Copyright © 2017 Yura Voevodin. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var filteredGroups: [GroupEntity] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.reuseIdentifier, for: indexPath) as! SearchResultsTableViewCell
        
        let group = filteredGroups[indexPath.row]
        cell.textLabel?.text = group.name
        
        return cell
    }
}
