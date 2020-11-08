//
//  LinksController.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Vapor
struct LinksController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("list") { (req) -> String in
            return ""
        }
        
        routes.patch("hide") { (req) -> String in
            return ""
        }
        
        routes.get(":identificador") { (req) -> String in
            return ""
        }
        
        routes.post("create") { (req) -> String in
            return "URL curta"
        }
    }
}
