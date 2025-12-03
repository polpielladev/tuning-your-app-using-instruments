import Observation
import SwiftData

@Observable @MainActor final class ProfileViewModel {
    var isEditingProfile = false
    var tempProfile = ProfileModel.empty
    var profile = ProfileModel.empty
    var isSaving = false

    let dataAccess: SwiftDataManager<StorageProfile>

    init() {
        self.dataAccess = SwiftDataManager<StorageProfile>(modelContainer: ModelContainer.local)

        Task {
            if let profile = try? await dataAccess.get().first {
                self.profile = profile
            }
        }
    }

    public func confirm() async {
        isSaving = true
        defer { isSaving = false }
        do {
            let currentProfiles = try await dataAccess.get()

            if currentProfiles.isEmpty {
                _ = try await dataAccess.create(profile)
            } else {
                _ = try await dataAccess.update(profile)
            }
            profile = tempProfile
            isEditingProfile = false
        } catch {}
    }
}
