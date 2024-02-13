//
//  niosLib.swift
//  Swift.NiOSDemo
//
//  Created by Apirak on 9/4/2565 BE.
//  Copyright © 2565 BE mac. All rights reserved.
//

 
//  Converted to Swift 5.6 by Swiftify v5.6.25394 - https://swiftify.com/
//import CCIDLib
import Foundation
import UIKit

class niosLib: NiOS {


    static   var _this:niosLib! = nil

    static func getNiOSLib() -> niosLib! {
        if _this==nil {
            _this = niosLib()
          
        }
        return _this
    }


    func writeBornItem(_ reader: String?) {
        //get the documents directory:
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).map(\.path)
        let documentsDirectory = paths[0]

        //make a file name to write the data to using the documents directory:
        let fileName = "\(documentsDirectory)/bornConfig.json"
        let content = String(format: "[{ \"bornitem\":  \"%@\" }]", reader as! CVarArg)

        //save content to the documents directory
        do {
            try content.write(
                toFile: fileName,
                atomically: false,
                encoding: .utf8)
        } catch {
        }
    }
    

    func readBornItem() -> String? {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).map(\.path)
        let documentsDirectory = paths[0]

        //make a file name to write the data to using the documents directory:
        let fileName = "\(documentsDirectory)/bornConfig.json"
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: fileName) {
                let error: Error? = nil
                let data = NSData(contentsOfFile: fileName) as Data?
                let arryJson =  try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: String]]
                let it = (arryJson[0]["bornitem"])  as String?
                return it

            }
            
            return nil
        } catch {
            
        }
        return  nil
    }
 
    

    
}
