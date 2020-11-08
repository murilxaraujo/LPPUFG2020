//
//  AuthController.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("auth") { (req) -> String in
            return "JWT"
        }
    }
}
