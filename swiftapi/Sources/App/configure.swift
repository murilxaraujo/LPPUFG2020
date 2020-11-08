import Vapor
import Fluent
import FluentPostgresDriver
// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.postgres(hostname: "localhost:5432", username: "lpp", password: "senha1234", database: "links"), as: .psql)
    try routes(app)
}
