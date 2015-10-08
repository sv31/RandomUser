//
//  ViewController.swift
//  RandomUser
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import UIKit
import Contacts

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
    saveUserToContacts(randomUsers.list[0])
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

 // MARK: - Contacts

extension ListViewController {
  func presentPermissionErrorAlert() {
    dispatch_async(dispatch_get_main_queue()) {
      let alert = UIAlertController(title: "Could Not Save Contact", message: "How am I supposed to add the contact if you didn't give me permission?", preferredStyle: .Alert)
      let openSettingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { _ in
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
      })
      let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
      alert.addAction(openSettingsAction)
      alert.addAction(dismissAction)
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  func saveUserToContacts(randomUser: RandomUser) {
    
    let contactFormatter = CNContactFormatter()
    let contactName = contactFormatter.stringFromContact(randomUser.contactValue)!
    let predicateForMatchingName = CNContact.predicateForContactsMatchingName(contactName)
    let matchingContacts = try! CNContactStore().unifiedContactsMatchingPredicate(predicateForMatchingName, keysToFetch: [])
    guard matchingContacts.isEmpty else {
      dispatch_async(dispatch_get_main_queue()){
        let alert = UIAlertController(title:"\(randomUser.firstName.capitalizedString) \(randomUser.lastName.capitalizedString)  Already Exists", message:nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
      }
      return
    }
    
    let contact = randomUser.contactValue.mutableCopy() as! CNMutableContact
    let saveRequest = CNSaveRequest()
    saveRequest.addContact(contact, toContainerWithIdentifier: nil)
    do {
      let contactStore = CNContactStore()
      try contactStore.executeSaveRequest(saveRequest)
      // Show success alert
      dispatch_async(dispatch_get_main_queue()){
        let successAlert = UIAlertController(title: "Contact Saved", message: nil, preferredStyle: .Alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(successAlert, animated: true, completion: nil)
      }
    } catch {
      // Show failure alert
      dispatch_async(dispatch_get_main_queue()){
        let failureAlert = UIAlertController(title: "Could Not Save Contact", message: "An unknown error occurred", preferredStyle: .Alert)
        failureAlert.addAction(UIAlertAction(title:"OK", style: .Cancel, handler: nil))
        self.presentViewController(failureAlert, animated: true, completion: nil)
      }
    }
    
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
   //   cell.imageView?.image = UIImage(named: "Placeholder")
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
