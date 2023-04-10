import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // localhost:8080/ -> It works!
    app.get { req async in
        "It works!"
    }

    // localhost:8080/hello -> Hello, world!
    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    // localhost:8080/leoho/vapor -> Hello Vapor!
    app.get("leoho", "vapor") { req async in
        "Hello Vapor!"
    }
    
    // localhost:8080/user/<user's name>
    // Ex：localhost:8080/user/leoho -> Hello User：leoho!
    app.get("user", ":name") { req async -> String in
        let username = req.parameters.get("name")
        return "Hello User：\(username!)!"
    }
    
    // localhost:8080/user/<user's name>/profile
    // Ex：localhost:8080/user/leoho/profile -> Hello User：leoho!
    // Ex：localhost:8080/user/david/profile -> Hello User：david!
    app.get("user", ":name", "profile") { req async -> String in
        let username = req.parameters.get("name")
        return "Hello User：\(username!)!"
    }
    
    // localhost:8080/user/<user's name>/profiles
    // Ex：localhost:8080/user/leoho/profiles -> Hello Any User：leoho!
    // Ex：localhost:8080/user/david/profiles -> Hello Any User：david!
    app.get("user", "*", "profiles") { req async -> String in
        let username = req.parameters.get("name")
        return "Hello Any User：\(username!)!"
    }
    
    // localhost:8080/users/<any parameters>...
    // Ex：localhost:8080/users/leoho
    // Ex：localhost:8080/users/leoho/david
    // Ex：localhost:8080/users/leoho/david/test
    app.get("users", "**") { req async -> String in
        return "Hello Any Users!"
    }
    
    // localhost:8080/num/<int value>
    // Ex：localhost:8080/num/516918 -> 516918 is number
    app.get("num", ":x") { req async throws -> String in
        guard let number = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "\(number) is number"
    }
    
    // localhost:8080/value/<any parameters>
    // Ex：localhost:8080/value/foo -> Hello foo!
    // Ex：localhost:8080/value/foo/bar -> Hello foo bar!
    // Ex：localhost:8080/value/foo/bar/www -> Hello foo bar www!
    app.get("value", "**") { req async -> String in
        let value = req.parameters.getCatchall().joined(separator: " ")
        return "Hello \(value)!"
    }
    
    app.group("stores") { stores in
        
        // localhost:8080/stores/originalTransactionId/<originalTransactionId parameters>
        // Ex：localhost:8080/stores/originalTransactionId/111 -> originalTransactionId：111
        stores.get("originalTransactionId", ":id") { req async throws -> String in
            guard let originalTransactionId = req.parameters.get("id") else {
                throw Abort(.badRequest)
            }
            return "originalTransactionId：\(originalTransactionId)"
        }
    }
    
    try app.register(collection: TodoController())
}
