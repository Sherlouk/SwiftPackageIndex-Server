import Fluent
import Vapor


extension API {
    
    struct PackageController {
        func index(req: Request) throws -> EventLoopFuture<[Package]> {
            return Package.query(on: req.db).all()
        }
        
        func create(req: Request) throws -> EventLoopFuture<Package> {
            let pkg = try req.content.decode(Package.self)
            return pkg.save(on: req.db).map { pkg }
        }
        
        func get(req: Request) throws -> EventLoopFuture<Package> {
            return Package.find(req.parameters.get("id"), on: req.db)
                .unwrap(or: Abort(.notFound))
        }
        
        func replace(req: Request) throws -> EventLoopFuture<HTTPStatus> {
            let pkg = try req.content.decode(Package.self)
            return Package.find(req.parameters.get("id"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { _ in pkg.save(on: req.db) }
                .transform(to: .ok)
        }
        
        func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
            return Package.find(req.parameters.get("id"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { $0.delete(on: req.db) }
                .transform(to: .ok)
        }
        
        func trigger(req: Request) throws -> EventLoopFuture<HTTPStatus> {
            guard
                let owner = req.parameters.get("owner"),
                let repository = req.parameters.get("repository")
            else {
                return req.eventLoop.future(error: Abort(.notFound))
            }
            let dto = try req.content.decode(PostBuildTriggerDTO.self)
            return Package.query(on: req.db, owner: owner, repository: repository)
                .flatMap { pkg in
                    [App.Version.Kind.release, .preRelease, .defaultBranch]
                        .compactMap { pkg.latestVersion(for: $0)?.id }
                        .map {
                            Build.trigger(database: req.db,
                                          client: req.client,
                                          platform: dto.platform,
                                          swiftVersion: dto.swiftVersion,
                                          versionId: $0)
                        }
                        .flatten(on: req.eventLoop)
                        .map { statuses in
                            statuses.allSatisfy { $0 == .created || $0 == .ok }
                                ? .ok : .badRequest
                        }
                }
        }
        
        func run(req: Request) throws -> EventLoopFuture<Command.Response> {
            let cmd = req.parameters.get("command")
                .flatMap(Command.init(rawValue:))
            let limit = req.query[Int.self, at: "limit"] ?? 10
            switch cmd {
                case .reconcile:
                    return try reconcile(client: req.client, database: req.db)
                        .flatMap {
                            Package.query(on: req.db).count()
                                .map { Command.Response.init(status: "ok", rows: $0) }
                        }
                case .ingest:
                    return ingest(application: req.application, limit: limit)
                        .map {
                            Command.Response(status: "ok", rows: limit)
                        }
                case .analyze:
                    return analyze(application: req.application, limit: limit)
                        .map {
                            Command.Response(status: "ok", rows: limit)
                        }
                case .none:
                    return req.eventLoop.makeFailedFuture(Abort(.notFound))
            }
        }


        func badge(req: Request) throws -> EventLoopFuture<Package.Badge> {
            guard
                let owner = req.parameters.get("owner"),
                let repository = req.parameters.get("repository")
            else {
                return req.eventLoop.future(error: Abort(.notFound))
            }
            guard
                let badgeType = req.query[String.self, at: "type"]
                    .flatMap(Package.BadgeType.init(rawValue:))
            else {
                return req.eventLoop.future(error: Abort(.badRequest,
                                                         reason: "missing or invalid type parameter"))
            }

            return Package.query(on: req.db, owner: owner, repository: repository)
                .map { $0.badge(badgeType: badgeType) }
        }

    }
}


extension API.PackageController {
    enum Command: String {
        case reconcile
        case ingest
        case analyze
        
        struct Response: Content {
            var status: String
            var rows: Int
        }
    }
}
