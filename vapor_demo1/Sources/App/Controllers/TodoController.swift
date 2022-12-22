import Vapor

final class TodoController {
    func list(req: Request) throws -> EventLoopFuture<View> {
            return Todo.query(on: req.db).all().flatMap { todos in
                let context = ["todos": todos]
                return req.view.render("todos", context)
            }
        }
    
    func create(req: Request) throws -> EventLoopFuture<Response> {
        let title = req.parameters.get("title")
        let todo = Todo(title: title ?? "Blank", completed: false)
        return todo.save(on: req.db).map {
            req.redirect(to: "/todos")
        }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.update(on: req.db).map { todo }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func add(req: Request) throws -> EventLoopFuture<View> {
            return req.view.render("add")
    }
}
