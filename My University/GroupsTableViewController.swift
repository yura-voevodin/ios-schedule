//
//  GroupsTableViewController.swift
//  My University
//
//  Created by Yura Voevodin on 4/18/19.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UIKit

class GroupsTableViewController: SearchableTableViewController {
    
    // MARK: - Properties
    
    var university: UniversityEntity?
    private var dataSource: GroupsDataSource?
    
    // MARK: - Notificaion
    
    @IBOutlet weak var statusButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For notifications
        configureNotificationLabel()
        statusButton.customView = notificationLabel
        
        // Configure table
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        // Sear Bar and Search Results Controller
        configureSearchControllers()
        searchController.searchResultsUpdater = self
        
        if let university = university {
            // Loading groups
            dataSource = GroupsDataSource(university: university)
            tableView.dataSource = dataSource
            loadGroups()
        }
    }
    
    // MARK: - Groups
    
    private func loadGroups() {
        guard let dataSource = dataSource else { return }
        dataSource.performFetch()
        
        let groups = dataSource.fetchedResultsController?.fetchedObjects ?? []
        if groups.isEmpty {
            importGroups()
        } else {
            tableView.reloadData()
            refreshControl?.endRefreshing()
            showGroupsCount()
        }
    }
    
    func importGroups() {
        guard let dataSource = dataSource else { return }
        
        let text = NSLocalizedString("Loading groups ...", comment: "")
        showNotification(text: text)
        
        dataSource.importGroups { (error) in
            if let error = error {
                self.showNotification(text: error.localizedDescription)
            } else {
                self.hideNotification()
            }
            dataSource.performFetch()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.showGroupsCount()
        }
    }
    
    func showGroupsCount() {
        let groups = dataSource?.fetchedResultsController?.fetchedObjects ?? []
        let text = NSLocalizedString("groups", comment: "Count of groups")
        showNotification(text: "\(groups.count) " + text)
    }
    
    // MARK: - Pull to refresh
    
    @IBAction func refresh(_ sender: Any) {
        guard !searchController.isActive else {
            refreshControl?.endRefreshing()
            return
        }
        importGroups()
    }
    
    // MARK - Table delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .sectionBackgroundColor
            headerView.backgroundView = backgroundView
            headerView.textLabel?.textColor = UIColor.lightText
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "groupDetailed", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "groupDetailed":
            if let detailTableViewController = segue.destination as? GroupTableViewController {
                if searchController.isActive {
                    if let indexPath = resultsTableController.tableView.indexPathForSelectedRow {
                        let selectedGroup = resultsTableController.filteredGroups[safe: indexPath.row]
                        detailTableViewController.group = selectedGroup
                        detailTableViewController.groupID = selectedGroup?.id
                    }
                } else {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let selectedGroup = dataSource?.fetchedResultsController?.object(at: indexPath)
                        detailTableViewController.group = selectedGroup
                        detailTableViewController.groupID = selectedGroup?.id
                    }
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UISearchResultsUpdating

extension GroupsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Strip out all the leading and trailing spaces.
        guard let text = searchController.searchBar.text else { return }
        let searchString = text.trimmingCharacters(in: .whitespaces)
        
        // Name field matching.
        let nameExpression = NSExpression(forKeyPath: "name")
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let nameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: nameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
        
        // Update the filtered array based on the search text.
        guard let searchResults = dataSource?.fetchedResultsController?.fetchedObjects else { return }
        
        let filteredResults = searchResults.filter { nameSearchComparisonPredicate.evaluate(with: $0) }
        
        // Hand over the filtered results to our search results table.
        if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController {
            resultsController.filteredGroups = filteredResults
            resultsController.dataSourceType = .groups
            resultsController.tableView.reloadData()
        }
    }
}