import SwiftData
import SwiftUI

protocol DomainModelConvertible {
    associatedtype DomainModel: Sendable, Identifiable where DomainModel.ID == String
    
    init(from domainModel: DomainModel)

    func toDomainModel() -> DomainModel
    func update(from domainModel: DomainModel)
}

protocol StorageEntity: PersistentModel, DomainModelConvertible where ID == String {}

@ModelActor
actor SwiftDataManager<Entity: StorageEntity> {
    func get(with id: String? = nil) async throws -> [Entity.DomainModel] {
        var predicate: Predicate<Entity>? = nil
        if let id {
            predicate = #Predicate<Entity> {
                $0.id == id
            }
        }
        var descriptor = FetchDescriptor<Entity>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        let results = try modelContext.fetch(descriptor)
        
        return results.map { $0.toDomainModel() }
    }
    
    func create(_ domainModel: Entity.DomainModel) async throws -> Entity.DomainModel {
        let entity = Entity(from: domainModel)
        modelContext.insert(entity)
        try modelContext.saveIfNeeded()
        
        return entity.toDomainModel()
    }
    
    func delete(_ domainModel: Entity.DomainModel) async throws {
        let id = domainModel.id
        let predicate = #Predicate<Entity> {
            $0.id == id
        }
        var descriptor = FetchDescriptor<Entity>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        let results = try modelContext.fetch(descriptor)
        
        guard let entity = results.first else {
            return
        }
        
        modelContext.delete(entity)
        try modelContext.saveIfNeeded()
    }
    
    func update(_ domainModel: Entity.DomainModel) async throws -> Entity.DomainModel? {
        var descriptor = FetchDescriptor<Entity>()
        descriptor.fetchLimit = 1
        let results = try modelContext.fetch(descriptor)

        guard let entity = results.first else {
            return nil
        }
        
        entity.update(from: domainModel)

        try modelContext.saveIfNeeded()

        return entity.toDomainModel()
    }
}

fileprivate extension ModelContext {
    func saveIfNeeded() throws {
        guard hasChanges else { return }

        try save()
    }
}
