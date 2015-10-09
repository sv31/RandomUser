//
//  RandomUsers.swift
//  RandomUser
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import Foundation

class RandomUsers {
  
  var list: [RandomUser] = []

  func loadUsers (howMany: Int, reload: Bool = true) {

    if reload  {
      list = []
    }

    getInfoFromWeb(howMany)

  }

  private func getInfoFromWeb (howMany: Int) {

    let url = NSURL(string: String(format: "https://randomuser.me/api/?results=%d", howMany))
    let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    let session = NSURLSession(configuration: config)

    let dataTask = session.dataTaskWithURL(url!)
      { (data, response, error) in
        if error == nil {
          if let response = response as? NSHTTPURLResponse where response.statusCode == 200
            ,let data = data
            ,let dictionary = self.parseJSON(data) {
              self.parseDictionary(dictionary)
              dispatch_async(dispatch_get_main_queue()){
                 self.sendSuccessNotification()
              }
              return
          }
        }
        dispatch_async(dispatch_get_main_queue()){
          self.sendErrorNotification()
        }
     }
    dataTask.resume()
  }

  private func parseJSON (data: NSData) -> [String: AnyObject]? {
    do {
      return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
    }
    catch {
      print("JSON error: \(error)")
      return nil
    }
  }

  private func parseDictionary (dictionary: [String:AnyObject]) {

    guard let resultsJSON = dictionary["results"] as? [AnyObject] else {
      print ("Expected 'results' array")
      self.sendErrorNotification()
      return
    }

    for result in resultsJSON {
      
      guard let userJSON = result["user"] as? [String:AnyObject] else {
        print ("Expected 'user' dictionary")
        self.sendErrorNotification()
        return
      }

      guard let nameJSON = userJSON["name"] as? [String:AnyObject] else {
        print ("Expected 'name' dictionary")
        self.sendErrorNotification()
        return
      }

      guard let lastNameJSON = nameJSON["last"] as? String else {
        print ("Expected 'last' value")
        self.sendErrorNotification()
        return
      }
      
      let randomUser = RandomUser()
      
      randomUser.lastName = lastNameJSON
      randomUser.firstName = nameJSON["first"] as? String ?? ""
      randomUser.email = userJSON["email"] as? String ?? ""
      randomUser.phone = userJSON["phone"] as? String ?? ""
      randomUser.cell = userJSON["cell"] as? String ?? ""
      
      if let locationJSON = userJSON["location"] as? [String:AnyObject] {
       randomUser.street = locationJSON["street"] as? String ?? ""
       randomUser.city = locationJSON["city"] as? String ?? ""
       randomUser.state = locationJSON["state"] as? String ?? ""
       randomUser.zip = locationJSON["zip"] as? String ?? ""
      }
      
      if let pictureJSON = userJSON["picture"] as? [String:AnyObject] {
        randomUser.picture = pictureJSON["thumbnail"] as? String ?? ""
      }
      
      list.append(randomUser)
    }
    
    list.sortInPlace (<)
  }
  
  private func sendSuccessNotification () {
    let notification = NSNotification(name: "RandomeUsersReloaded", object: nil)
    NSNotificationCenter.defaultCenter().postNotification(notification)
  }
  
  private func sendErrorNotification () {
    let notification = NSNotification(name: "RandomeUsersReloadError", object: nil)
    NSNotificationCenter.defaultCenter().postNotification(notification)
  }


}