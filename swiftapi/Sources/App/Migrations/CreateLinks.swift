//
//  CreateLinks.swift
//  
//
//  Created by Murilo Araujo on 08/11/20.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateLinks: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("links")
            .id()
            .field("user", .string)
            .field("fullLink", .string)
            .field("hidden", .bool)
            .field("short", .string)
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("links").delete()
    }
}
