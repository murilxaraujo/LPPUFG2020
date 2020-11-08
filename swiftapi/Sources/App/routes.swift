import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.post("create") { (req) -> String in
        return "URL curta"
    }
    
    app.post("auth") { (req) -> String in
        return "JWT"
    }
    
    app.get("list") { (req) -> String in
        return ""
    }
    
    app.patch("hide") { (req) -> String in
        return ""
    }
    
    app.get(":identificador") { (req) -> String in
        return ""
    }
}
