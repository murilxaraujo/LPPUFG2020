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
            
            let response = req.db.query(User.self).filter(\.$email == userEmail).first().flatMapThrowing { (user) -> String in
                if let user = user {
                    let authenticated = try req.password.verify(userPassword, created: user.passwordHash)
                    if authenticated {
                        guard let subject = user.id?.uuidString else {
                            throw Abort(HTTPResponseStatus.internalServerError)
                        }
                        let payload = JWTToken(subject: SubjectClaim(stringLiteral: subject), expiration: .init(value: .distantFuture))
                        return try req.jwt.sign(payload)
                    } else {
                        throw Abort(.unauthorized, reason: "Invalid Credentials")
                    }
                } else {
                    let passwordHash = try req.password.hash(userPassword)
                    let user = User(email: userEmail, password: passwordHash)
                    let futureUser = user.create(on: req.db).flatMapThrowing { (_) -> String in
                        guard let uid = user.id?.uuidString else {
                            throw Abort(HTTPResponseStatus.internalServerError)
                            
                        }
                        let payload = JWTToken(subject: SubjectClaim(stringLiteral: uid), expiration: .init(value: .distantFuture))
                        return try req.jwt.sign(payload)
                    }
                    return try futureUser.wait()
                }
            }
            return response
        }
    }
}
