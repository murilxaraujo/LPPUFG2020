//
//  AuthController.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Vapor
import Fluent
import FluentPostgresDriver

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("auth") { (req) -> String in
            let userEmail: String? = try? req.content.get(String.self, at: "email")
            let userPassword: String? = try? req.content.get("password")
            
            let user = try req.db.query(User.self).filter(\.$email == userEmail ?? "").first().wait()
            
            if let user = user {
                if user.passwordHash == userPassword
            } else {
                
            }
            
            return "JWT"
        }
    }
}
