import Vapor
import Leaf

func routes(_ app: Application) throws {
    let todoController = TodoController()
    app.get("todos", use: todoController.listAll)
    app.post("todos", use: todoController.create)
    app.put("todos", ":todoID", use: todoController.update)
    app.delete("todos", ":todoID", use: todoController.delete)
    
    app.get { req async in
        "It works!"
    }
    
    app.get("login") { req -> EventLoopFuture<View> in
        return req.view.render("login")
    }
    
    app.post("login") { req -> Response in
        // Get the username and password from the request body
        let username = try req.content.get(String.self, at: "username")
        let password = try req.content.get(String.self, at: "password")
        // Validate the username and password
        if username == "user" && password == "password" {
            // Set a session cookie and redirect to the home page
            return req.redirect(to: "/todos")
        } else {
            // Redirect back to the login page with an error message
            return req.redirect(to: "/login?error=Invalid+username+or+password")
        }
    }
}
