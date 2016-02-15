//
//  MasterViewController.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import UIKit
import RealmSwift
import Bond

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var items = DataManager.shared.getItems()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        tableView.registerNib(UINib(nibName: EpisodeCell.reuseIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
        tableView.registerNib(UINib(nibName: DividerCell.reuseIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: DividerCell.reuseIdentifier)
        
        //Refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlPulled:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        //Watch for set being updated
        DataManager.shared.updatedSet.observe { [weak self] _ in
            self?.title = DataManager.shared.getSet()?.title ?? "Loading..."
            self?.items = DataManager.shared.getItems()
            self?.tableView.reloadData()
        }
        
        if DataManager.shared.getSet() == nil {
            APIManager.shared.getSet(uid: Constants.HomeUid)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlPulled(refreshControl: UIRefreshControl) {
        APIManager.shared.getSet(uid: Constants.HomeUid){ success in
            refreshControl.endRefreshing()
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        IGLog.log("Prepare \(segue)")
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.uid = items![indexPath.row].uid
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = items?.count ?? 0
        return count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = items![indexPath.row]
        if item.contentType == "divider" {
            return 30
        } else {
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: tableView)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = items![indexPath.row]
        var cell:UITableViewCell
        if item.contentType == "divider" {
            cell = tableView.dequeueReusableCellWithIdentifier(DividerCell.reuseIdentifier, forIndexPath: indexPath)
            (cell as! DividerCell).configureWithDivider(item)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(EpisodeCell.reuseIdentifier, forIndexPath: indexPath)
            (cell as! EpisodeCell).configureWithEpisode(item)
        }
        return cell
    }

}

