//
//  Database.swift
//  The Library
//
//  Created by Jacques Benzakein on 10/22/19.
//  Copyright © 2019 Q Technologies. All rights reserved.
//

import Foundation
class Database{
    static var library: [Book] = []
    
    static func saveToFile(str: String){
        let filename = getDocumentsDirectory().appendingPathComponent("database.json")
        
        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print("Writing \(str)")
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("filesavingerror")
        }
    }
    
    static func readFromFile() -> String{
        var ret = "Error"
        if let filepath = Bundle.main.path(forResource: "database", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print("Reading contents: \(contents)")
                ret = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            ret = "Not found"
        }
        return ret
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
