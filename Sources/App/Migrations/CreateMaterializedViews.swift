import Fluent
import SQLKit


struct CreateRecentPackages: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        guard let db = database as? SQLDatabase else {
            fatalError("Database must be an SQLDatabase ('as? SQLDatabase' must succeed)")
        }
        return db.raw(
            """
            CREATE MATERIALIZED VIEW IF NOT EXISTS recent_packages AS
            SELECT
              p.id,
              v.package_name,
              MAX(p.created_at) AS created_at
            FROM packages p
            JOIN versions v ON v.package_id = p.id
            WHERE v.package_name IS NOT NULL
            GROUP BY p.id, v.package_name
            ORDER BY MAX(p.created_at) DESC
            LIMIT 10
            """
        ).run()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        guard let db = database as? SQLDatabase else {
            fatalError("Database must be an SQLDatabase ('as? SQLDatabase' must succeed)")
        }
        return db.raw("DROP MATERIALIZED VIEW recent_packages").run()
    }
}


struct CreateRecentReleases: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        guard let db = database as? SQLDatabase else {
            fatalError("Database must be an SQLDatabase ('as? SQLDatabase' must succeed)")
        }
        return db.raw(
            """
            CREATE MATERIALIZED VIEW IF NOT EXISTS recent_releases AS
            SELECT
              package_id AS id,
              package_name,
              MAX(commit_date) AS released_at
            FROM versions
            WHERE commit_date IS NOT NULL
              AND package_name IS NOT NULL
              AND reference->>'tag' IS NOT NULL
            GROUP BY package_id, package_name
            ORDER BY MAX(commit_date) DESC
            LIMIT 10
            """
        ).run()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        guard let db = database as? SQLDatabase else {
            fatalError("Database must be an SQLDatabase ('as? SQLDatabase' must succeed)")
        }
        return db.raw("DROP MATERIALIZED VIEW recent_releases").run()
    }
}