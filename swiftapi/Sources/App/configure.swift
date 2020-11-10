import Vapor
import Fluent
import FluentPostgresDriver
import JWT

public func configure(_ app: Application) throws {
    app.databases.use(.postgres(
                        hostname: Environment.get("dbhost") ?? "localhost",
                        username: Environment.get("dbusername") ?? "lpp",
                        password: Environment.get("dbpassword") ?? "senha1234",
                        database: Environment.get("dbdatabase") ?? "links"),
                      as: .psql)
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateLinks())
    app.passwords.use(.bcrypt)
    app.jwt.signers.use(.hs256(key: "lppehmuitobom"))
    try routes(app)
}
