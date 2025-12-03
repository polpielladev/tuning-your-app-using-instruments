import Foundation
import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [StorageSchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}
