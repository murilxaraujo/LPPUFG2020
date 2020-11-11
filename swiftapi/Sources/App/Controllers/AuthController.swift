//
//  AuthController.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Vapor
import Fluent
import FluentPostgresDriver
import JWT

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("auth") { (req) -> EventLoopFuture<String> in
            let userEmail: String = try req.content.get(String.self, at: "email")
            let userPassword: String = try req.content.get(String.self, at:"password")
            let response = req.db.query(User.self).filter(\.$email == userEmail).first().flatMap { (user) -> EventLoopFuture<String> in
                if let user = user {
                    var authenticated: Bool!
                    do {
                        authenticated = try req.password.verify(userPassword, created: user.passwordHash)
                    } catch let e {
                        return req.eventLoop.makeFailedFuture(e)
                    }
                    if authenticated {
                        guard let subject = user.id?.uuidString else {
                            return req.eventLoop.makeFailedFuture(Abort(HTTPResponseStatus.internalServerError))
                        }
                        let payload = JWTToken(subject: SubjectClaim(stringLiteral: subject), expiration: .init(value: .distantFuture))
                        var signedPayload: String!
                        do {
                            signedPayload = try req.jwt.sign(payload)
                        } catch let e {
                            return req.eventLoop.makeFailedFuture(e)
                        }
                        return req.eventLoop.makeSucceededFuture(signedPayload)
                    } else {
                        return req.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "Invalid Credentials"))
                    }
                } else {
                    var paswordHash: String!
                    do {
                        paswordHash = try req.password.hash(userPassword)
                    } catch let e {
                        return req.eventLoop.makeFailedFuture(e)
                    }
                    let user = User(email: userEmail, password: paswordHash)

                    let payload = user.create(on: req.db).flatMapThrowing { (_) throws -> String in
                        guard let uid = user.id?.uuidString else {
                            throw Abort(HTTPResponseStatus.internalServerError)
                        }
                        let payload = JWTToken(subject: SubjectClaim(stringLiteral: uid), expiration: .init(value: .distantFuture))
                        return try req.jwt.sign(payload)
                    }
                    return payload
                }
            }
            return response
        }
    }
}
