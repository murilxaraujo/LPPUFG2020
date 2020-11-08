import Vapor
import Fluent
import FluentPostgresDriver
// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.postgres(hostname: "localhost", username: "lpp", password: "senha1234", database: "links"), as: .psql)
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateLinks())
    try routes(app)
}
