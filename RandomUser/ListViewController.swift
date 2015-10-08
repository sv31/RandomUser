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
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataReload:", name:"RandomeUsersReloaded", object: nil)
  //  tableView.estimatedSectionHeaderHeight = 0
   // tableView.estimatedRowHeight = 200.0
    randomUsers.loadUsers(10)
    tableView.reloadData()
    
    // NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ListViewController :  UITableViewDelegate {
 
}

extension ListViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return randomUsers.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell", forIndexPath: indexPath)
    cell.textLabel?.text = ComposeTitle(randomUsers.list[indexPath.row])
    cell.detailTextLabel?.text = ComposeDetail(randomUsers.list[indexPath.row])
    cell.imageView?.image = UIImage(named: "Placeholder")
    if let url = NSURL(string: randomUsers.list[indexPath.row].picture) {
     cell.imageView?.loadImageWithURL(url)
    }
    return cell
  }
  
  func ComposeTitle(randomUser: RandomUser) -> String {
    let text = randomUser.firstName.capitalizedString + " " + randomUser.lastName.capitalizedString
    return text
  }
  
  func ComposeDetail(randomUser: RandomUser) -> String {
    let text = randomUser.email // + " T: " + randomUser.cell
    return text
  }
  
  @objc func dataReload (notification: NSNotification) {
    tableView.reloadData()
  }
  
}
