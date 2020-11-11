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
        routes.get("list") { (req) -> EventLoopFuture<[[String: String]]> in
            let userid = try req.jwt.verify(as: JWTToken.self).subject.value
            let response = Link.query(on: req.db).filter(\.$user == userid).all().flatMap({ (links) -> EventLoopFuture<[[String: String]]> in
                let links = links.map { (link) -> [String: String] in
                    return [
                        "id": link.id?.uuidString ?? "",
                        "fullLink": link.fullLink,
                        "shortLink": link.short
                    ]
                }
                return req.eventLoop.makeSucceededFuture(links)
            })
            return response
        }
        
        routes.patch("hide") { (req) -> EventLoopFuture<HTTPResponseStatus> in
            let userid = try req.jwt.verify(as: JWTToken.self).subject.value
            let linkID = try req.content.get(String.self, at: "URLID")
            let response = Link.find(UUID(uuidString: linkID), on: req.db).flatMap({ (link) -> EventLoopFuture<HTTPResponseStatus> in
                guard let link = link else {
                    return req.eventLoop.makeFailedFuture(Abort(HTTPResponseStatus.notFound))
                }
                if link.user != userid {
                    return req.eventLoop.makeFailedFuture(Abort(HTTPResponseStatus.unauthorized))
                }
                link.hidden = true
                return link.save(on: req.db).flatMap { (_) -> EventLoopFuture<HTTPResponseStatus> in
                    return req.eventLoop.makeSucceededFuture(HTTPResponseStatus.ok)
                }
            })
            return response
        }
        
        routes.get(":identificador") { req -> EventLoopFuture<Response> in
            guard let short = req.parameters.get("identificador") else {
                throw Abort(HTTPResponseStatus.badRequest)
            }
            let response = Link.query(on: req.db).filter(\.$short == short).first().flatMap { (link) -> EventLoopFuture<Response> in
                if let link = link {
                    return req.eventLoop.makeSucceededFuture(req.redirect(to: link.fullLink, type: .normal))
                } else {
                    return req.eventLoop.makeFailedFuture(Abort(HTTPResponseStatus.notFound))
                }
            }
            return response
        }
        
        routes.post("create") { (req) -> EventLoopFuture<String> in
            let userid = try req.jwt.verify(as: JWTToken.self).subject.value
            let linkToShorten = try req.content.get(String.self, at: "URL")
            let link = Link(user: userid, fullLink: linkToShorten)
            let response = link.create(on: req.db).flatMap { (_) -> EventLoopFuture<String> in
                guard let id = link.id?.uuidString else {
                    return req.eventLoop.makeFailedFuture(Abort(HTTPResponseStatus.internalServerError))
                }
                return req.eventLoop.makeSucceededFuture(link.short)
            }
            return response
        }
    }
}
