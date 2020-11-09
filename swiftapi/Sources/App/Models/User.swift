//
//  User.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class User: Model {
    static var schema: String = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "passwordHash")
    var passwordHash: String
    
    init() {}
    
    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.passwordHash = password
    }
}
