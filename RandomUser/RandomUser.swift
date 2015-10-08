//
//  RandomUser.swift
//  RandomUser
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import Foundation

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
  
}

func < (lhs: RandomUser, rhs: RandomUser) -> Bool {
  return lhs.lastName.localizedStandardCompare(rhs.lastName) == .OrderedAscending
}