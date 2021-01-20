//
//  File.swift
//  
//
//  Created by Murilo Araujo on 19/01/21.
//

import Foundation

class CSVProcessor {
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
}
