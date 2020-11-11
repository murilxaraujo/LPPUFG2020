//
//  Link.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Link: Model {
    static let schema = "links"
    
    @ID
    var id: UUID?
    
    @Field(key: "user")
    var user: String
    
    @Field(key: "fullLink")
    var fullLink: String
    
    @Field(key: "hidden")
    var hidden: Bool
    
    @Field(key: "short")
    var short: String
    
    init() {}
    
    init(user: String, fullLink: String, id: UUID? = nil) {
        self.user = user
        self.fullLink = fullLink
        self.hidden = false
        self.short = Link.newShortKey()
        self.id = id
    }
    
    public static func newShortKey() -> String {
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = letters.length
            
            var randomString = ""
            
            for _ in 0 ..< 6 {
                let rand = Int.random(in: 0...len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            
            return randomString
        }
}
