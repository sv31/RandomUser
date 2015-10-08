//
//  ViewController.swift
//  RandomUser
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  
  var randomUsers = RandomUsers()
  var image: UIImage?
  
  var numberOfUsersToLoad = 10
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataReload:", name:"RandomeUsersReloaded", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataReloadError:", name:"RandomeUsersReloadError", object: nil)
    randomUsers.loadUsers(numberOfUsersToLoad)
    tableView.reloadData()
    
    self.navigationItem.setLeftBarButtonItem(createSaveButtonItem(), animated: true)
    self.navigationItem.setRightBarButtonItem(createRefreshButtonItem(), animated: true)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Something is wrong", message: "There was an error getting the random users. Please try again", preferredStyle: .Alert)
    
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
    // MARK: - buttons
  
  func createSaveButtonItem () -> UIBarButtonItem {
    let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonClicked")
    return saveBarButtonItem
  }
  
  func createRefreshButtonItem () -> UIBarButtonItem{
    let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshButtonClicked")
    return barButtonItem
  }
  
  func saveButtonClicked () {
    
  }
  
  func refreshButtonClicked () {
    randomUsers.loadUsers(numberOfUsersToLoad)
    image = nil
  }
  
}

extension ListViewController :  UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if (randomUsers.list[indexPath.row].isSelected) {
      randomUsers.list[indexPath.row].isSelected = false
    } else {
      randomUsers.list[indexPath.row].isSelected = true
    }
    image = tableView.cellForRowAtIndexPath(indexPath)?.imageView?.image
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
  }
 
}

extension ListViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return randomUsers.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell", forIndexPath: indexPath)
    cell.textLabel?.text = ComposeTitle(randomUsers.list[indexPath.row])
    cell.detailTextLabel?.text = ComposeDetail(randomUsers.list[indexPath.row])
    if image != nil {
      cell.imageView?.image = image
      image = nil
    } else {
      cell.imageView?.image = UIImage(named: "Placeholder")
      if let url = NSURL(string: randomUsers.list[indexPath.row].picture) {
       cell.imageView?.loadImageWithURL(url)
      }
    }
    if randomUsers.list[indexPath.row].isSelected {
      cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    } else {
      cell.accessoryType = UITableViewCellAccessoryType.None
    }
    return cell
  }
  
  func ComposeTitle(randomUser: RandomUser) -> String {
    let text = randomUser.firstName.capitalizedString + " " + randomUser.lastName.capitalizedString
    return text
  }
  
  func ComposeDetail(randomUser: RandomUser) -> String {
    let text = randomUser.email
    return text
  }
  
  @objc func dataReload (notification: NSNotification) {
    tableView.reloadData()
  }
  
  @objc func dataReloadError (notification: NSNotification) {
    showNetworkError()
  }
  
}
