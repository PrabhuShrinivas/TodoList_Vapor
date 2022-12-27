import Vapor
import NIO

final class TodoController {
    func create(req: Request) throws -> EventLoopFuture<Response> {
        let title = try req.content.get(String.self, at: "title")
        print(title)
        let todo = Todo(title: title, completed: false)
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
    
    func listAll(req: Request) throws -> EventLoopFuture<[Todo]> {
            return Todo.query(on: req.db).all()
    }
}
