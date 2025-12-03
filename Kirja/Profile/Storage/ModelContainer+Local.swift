import SwiftData

extension ModelContainer {
    static let local: ModelContainer = {
        let schema = Schema(versionedSchema: CurrentSchema.self)
        let localConfig = ModelConfiguration(
            groupContainer: .automatic,
            cloudKitDatabase: .none
        )
        
        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: MigrationPlan.self,
                configurations: localConfig
            )
        } catch {
            return try! ModelContainer(
                for: schema,
                configurations: localConfig
            )
        }
    }()
}
