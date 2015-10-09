//
//  RandomUser.swift
//  RandomUser
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import Foundation
import Contacts
import UIKit

class RandomUser {
  var lastName = ""
  var firstName = ""
  
  var street = ""
  var city = ""
  var state = ""
  var zip = ""
  
  var email = ""
  var phone = ""
  var cell = ""
  
  var picture = ""
  
  var isSelected = false
  var isSaved = false
  
  var image: UIImage? = nil
  
}

func < (lhs: RandomUser, rhs: RandomUser) -> Bool {
  return lhs.lastName.localizedStandardCompare(rhs.lastName) == .OrderedAscending
}

extension RandomUser {
  
  var contactValue : CNContact {

    let contact = CNMutableContact()
    
    contact.givenName = firstName.capitalizedString
    contact.familyName = lastName.capitalizedString
    contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phone)),
      CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: cell))]
      
    contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email)]
      
    let address = CNMutablePostalAddress ()
      
    address.street = street
    address.city  = city
    address.state = state
    address.postalCode = zip
      
    contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: address)]
      
    //  CNPostalAddress
  
//    if let profilePicture = profilePicture {
//      let imageData = UIImageJPEGRepresentation(profilePicture, 1)
//      contact.imageData = imageData
//    }
//  
    return contact.copy() as! CNContact
  }
}
  
  extension RandomUser {
    
    func getImage () {
      print("getImage")
      let session = NSURLSession.sharedSession()
      print ("\(picture)")
      if let url = NSURL(string: picture) {
        let downloadTask = session.downloadTaskWithURL(url)
        { url, response,  error in
            if error == nil, let url = url,
              data = NSData(contentsOfURL: url),
              image = UIImage(data: data) {
                dispatch_sync(dispatch_get_main_queue()) {
                 self.image = image
                }
             }
        }
        downloadTask.resume()
      }
    }
    
}
  