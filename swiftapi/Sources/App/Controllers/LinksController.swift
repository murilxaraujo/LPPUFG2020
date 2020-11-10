//
//  LinksController.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Vapor
import JWT
import Fluent
import FluentPostgresDriver

struct LinksController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("list") { (req) -> [[String: String]] in
            let userid = try req.jwt.verify(as: JWTToken.self).subject.value
            let linksCreatedByUser = try Link.query(on: req.db).filter(\.$user == userid).all().wait()
            let linksResponse = linksCreatedByUser.map { (link) -> [String: String] in
                return [
                    "id": link.id?.uuidString ?? "",
                    "fullLink": link.fullLink,
                    "shortLink": link.short
                ]
            }
            return linksResponse
        }
        
        routes.patch("hide") { (req) -> HTTPResponseStatus in
            let userid = try req.jwt.verify(as: JWTToken.self).subject.value
            let linkID = try req.content.get(String.self, at: "URLID")
            guard let link = try Link.find(UUID(uuidString: linkID), on: req.db).wait() else {
                throw Abort(HTTPResponseStatus.notFound)
            }
            if link.user != userid {
                throw Abort(HTTPResponseStatus.unauthorized)
            }
            link.hidden = true
            try link.save(on: req.db).wait()
            return HTTPResponseStatus.ok
        }
        
        routes.get(":identificador") { req -> Response in
            guard let short = req.parameters.get("identificador") else {
                throw Abort(HTTPResponseStatus.badRequest)
            }
            guard let link = try Link.query(on: req.db).filter(\.$short == short).first().wait()?.fullLink else {
                throw Abort(HTTPResponseStatus.notFound)
            }
            
            return req.redirect(to: link, type: .normal)
        }
        
        routes.post("create") { (req) -> String in
            let userid = try req.jwt.verify(as: JWTToken.self).subject.value
            let linkToShorten = try req.content.get(String.self, at: "URL")
            let link = Link(user: userid, fullLink: linkToShorten)
            try link.create(on: req.db).wait()
            guard let id = link.id?.uuidString else {
                throw Abort(HTTPResponseStatus.internalServerError)
            }
            return id
        }
    }
}
