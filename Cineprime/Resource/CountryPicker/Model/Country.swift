//
//  Country.swift
//  ezRecorder
//
//  Created by Kishan Kasundra on 08/07/20.
//  Copyright © 2020 ezdi. All rights reserved.
//

import Foundation

let country = Country()

class Country {
    
    var list : [CountryData] = [CountryData]()
    
    init() {
        
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? [[String:String]] {
                        
                    for obj in jsonResult {
                        let countryDataObj = CountryData(obj)
                        self.list.append(countryDataObj)
                    }
                  }
              } catch {
                   // handle error
              }
        }
    }
    
    func getDialCode(countryName: String) -> String {
        
        let tempArray = self.list.filter({$0.name == countryName})
        
        if tempArray.count > 0 {
            return tempArray[0].dial_code
        } else {
            return ""
        }
    }
    
}

class CountryData {
    var name = ""
    var dial_code = ""
    var code = ""
    
    init(_ data : [String: String])
    {
         name = data["name"] ?? ""
         dial_code = data["dial_code"] ?? ""
         code = data["code"] ?? ""
    }
}
