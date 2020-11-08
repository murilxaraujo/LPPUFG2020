//
//  CreateUsers.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUsers: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("email", .string)
            .field("passwordHash", .string)
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
