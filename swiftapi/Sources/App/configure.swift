import Vapor
import Fluent
import FluentPostgresDriver
import JWT

public func configure(_ app: Application) throws {
    app.databases.use(.postgres(
                        hostname: Environment.get("DBHOST") ?? "localhost",
                        username: Environment.get("DBUSERNAME") ?? "lpp",
                        password: Environment.get("DBPASSWORD") ?? "senha1234",
                        database: Environment.get("DBDATABASE") ?? "links"),
                      as: .psql)
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateLinks())
    app.passwords.use(.bcrypt)
    app.jwt.signers.use(.hs256(key: "lppehmuitobom"))
    try app.autoMigrate().wait()
    try routes(app)
}
