//
//  RandomUserTests.swift
//  RandomUserTests
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import XCTest
@testable import RandomUser

class RandomUserTests: XCTestCase {
  
  var lastName = "van laarhoven"
  var firstName = "shanice"
  
  var street = "6215 wittevrouwensingel"
  var city = "enkhuizen"
  var state = "noord-holland"
  var zip = 52033
  
  var email = "shanice.van laarhoven@example.com"
  var phone = "(957)-880-2386"
  var cell = "(344)-071-7946"
  
  var picture = "https://randomuser.me/api/portraits/thumb/women/62.jpg"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_parseJSON() {
      
      let testBundle = NSBundle(forClass: self.dynamicType)
      let fileURL = testBundle.URLForResource("RandomUser", withExtension: "json")
      let users = RandomUsers()
      
      XCTAssertNotNil(fileURL)
      
      do {
        let jsonString =  try String(contentsOfURL: fileURL!, encoding: NSUTF8StringEncoding)
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) else {
         XCTFail("Wrong format for JSON file")
        return
        }
        
        guard let dictionary = users.parseJSON(data) else {
          XCTFail("Cannot convert JSON file to dictionary")
          return
        }
        
        
        users.parseDictionary(dictionary)
        
        XCTAssertEqual(users.list.count, 1 , "Number of users has to be 1")
        XCTAssertEqual(users.list[0].firstName, firstName, "last name has to be \(firstName)")
        XCTAssertEqual(users.list[0].lastName, lastName, "first name has to be \(lastName)")
         XCTAssertEqual(users.list[0].street, street, "street has to be \(street)")
         XCTAssertEqual(users.list[0].city, city, "city has to be \(city)")
         XCTAssertEqual(users.list[0].state, state, "state has to be \(state)")
         XCTAssertEqual(users.list[0].zip, zip, "zip has to be \(zip)")
         XCTAssertEqual(users.list[0].email, email, "eamil has to be \(email)")
         XCTAssertEqual(users.list[0].phone, phone, "phone has to be \(phone)")
         XCTAssertEqual(users.list[0].cell, cell, "cell has to be \(cell)")
         XCTAssertEqual(users.list[0].picture, picture, "picture has to be \(picture)")
        
      }
      catch {
        XCTFail("Cannot find JSON file")
      }
      
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
  
}
