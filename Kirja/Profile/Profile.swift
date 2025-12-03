import SwiftUI
import Foundation
import SwiftData

public struct ProfileModel: Sendable, Identifiable {
    public var id: String
    public var photo: Data?
    public var name: String

    public init(id: String, photo: Data?, name: String) {
        self.id = id
        self.photo = photo
        self.name = name
    }

    public static let empty: ProfileModel = ProfileModel(id: UUID().uuidString, photo: nil, name: "You")
}


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

struct Profile: View {
    @State private var viewModel = ProfileViewModel()
    @FocusState private var isFocused

    var body: some View {
        NavigationStack {
            VStack {
                ProfilePicture(profile: viewModel.isEditingProfile ? $viewModel.tempProfile : $viewModel.profile, isEditable: viewModel.isEditingProfile)

                if viewModel.isEditingProfile {
                    TextField("Name", text: $viewModel.tempProfile.name)
                        .font(.largeTitle)
                        .focused($isFocused)
                        .textContentType(.givenName)
                        .onSubmit {
                            Task {
                                await viewModel.confirm()
                            }
                        }
                        .opacity(viewModel.isEditingProfile ? 1 : 0)
                } else {
                    Text(viewModel.profile.name)
                        .font(.largeTitle)
                        .opacity(viewModel.isEditingProfile ? 0 : 1)
                }

                Spacer()
            }
            .frame(maxWidth: 440)
            .multilineTextAlignment(.center)
            .toolbar {
                if viewModel.isEditingProfile {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { viewModel.isEditingProfile.toggle() }) {
                            Image(systemName: "xmark")
                        }
                    }
                }

                if viewModel.isEditingProfile {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) {
                            Task {
                                await viewModel.confirm()
                            }
                        } label: {
                            if viewModel.isSaving {
                                ProgressView()
                            } else {
                                Image(systemName: "checkmark")
                            }
                        }
                        .tint(.accentColor)
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.isEditingProfile.toggle()
                            viewModel.tempProfile = viewModel.profile
                            isFocused = viewModel.isEditingProfile
                        }) {
                            Image(systemName: viewModel.isEditingProfile ? "checkmark" : "pencil")
                        }
                    }
                }
            }
            .padding()
        }
    }
}
