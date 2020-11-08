import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    try app.register(collection: AuthController())
    try app.register(collection: LinksController())
}
