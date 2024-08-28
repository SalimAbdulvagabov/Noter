//
//  FoldersService.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 25.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Combine
import Foundation

final class FoldersService {

    // MARK: - Private properties 

    private let networkProvider: INetworkProvider
    private let dataBaseManager: DatabaseManagerProtocol
    private lazy var notesService: NotesService = DependecyContainer.shared.service.notes

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(
        networkProvider: INetworkProvider,
        dataBaseManager: DatabaseManagerProtocol
    ) {
        self.networkProvider = networkProvider
        self.dataBaseManager = dataBaseManager
    }

    // MARK: - Internal funcs

    func saveFolders(_ folders: [FolderModel]) {
        let folders = folders.filter {$0 != allNotesFolder()}
        folders.enumerated().forEach { index, folder in
            saveFolder(.init(id: folder.id,
                             name: folder.name,
                             position: index + 1,
                             enable: folder.enable,
                             count: folder.count))
        }
    }

    func getFolders() -> [FolderModel] {
        var allFolders: [FolderModel] = [allNotesFolder()]
        let objects: [FolderDataBaseObject] = dataBaseManager.load(filter: nil)
        allFolders.append(contentsOf: objects.map({ .init(
            id: $0.uuid,
            name: $0.name,
            position: $0.position,
            enable: $0.enable,
            count: $0.count)}))

        return allFolders.sorted { $0.position < $1.position }
    }

    func saveFolder(_ folder: FolderModel) {
        let dataBaseModel = FolderDataBaseObject(folder)
        deleteFolder(folder, withNotes: false)
        dataBaseManager.save(dataBaseModel, shouldUpdate: false)
    }

    func deleteFolder(_ folder: FolderModel, withNotes: Bool) {
        let deleteObjects: [FolderDataBaseObject] = dataBaseManager.load { object in
            object.uuid.uppercased() == folder.id.uppercased()
        }

        if withNotes {
            notesService.getNoutes()
                .filter { $0.folderID?.uppercased() == folder.id.uppercased() }
                .forEach { notesService.deleteNoute($0) }
        }

        dataBaseManager.delete(deleteObjects)
    }

    func getCurrentFolder() -> FolderModel {
        guard let id = UserDefaults.standard.value(forKey: UserDefaultsKeys.currentFolder.rawValue) as? String else {
            return allNotesFolder()
        }

        let objects: [FolderDataBaseObject] = dataBaseManager.load { object in
            object.uuid.uppercased() == id.uppercased()
        }

        if let object = objects.first {
            return .init(id: object.uuid,
                         name: object.name,
                         position: object.position,
                         enable: object.enable,
                         count: object.count)
        }

        saveCurrentFolder(allNotesFolder().id)

        return allNotesFolder()
    }

    func saveCurrentFolder(_ id: String) {
        UserDefaults.standard.setValue(id, forKey: UserDefaultsKeys.currentFolder.rawValue)
    }

    func updateNotesCountInFolder() {
        let folders = getFolders().filter { $0.id != allNotesFolder().id }
        let notes = notesService.getNoutes()

        folders.forEach { folder in
            let count = notes.filter { $0.folderID?.uppercased() == folder.id.uppercased() }.count
            if folder.count != count {
                saveFolder(.init(
                    id: folder.id,
                    name: folder.name,
                    position: folder.position,
                    enable: folder.enable,
                    count: count
                ))
            }
        }
    }

    func synchronize() {
        let folders = getFolders()
        let publishers: [AnyPublisher<StatusModel, RequestError>] = folders.map { folder in
            let request = FoldersApi.update(folder: folder)
            return networkProvider.request(ofType: StatusModel.self, to: request)
        }

        Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
            .sink { _ in } receiveValue: { _ in }
            .store(in: &self.subscriptions)

        networkProvider.request(ofType: [FolderModel].self, to: FoldersApi.load)
            .sink { _ in } receiveValue: { [weak self] values in
                guard let self = self else { return }
                var publishers: [AnyPublisher<StatusModel, RequestError>] = []
                let ids = folders.map {$0.id.uppercased()}

                values.forEach { folder in
                    if !ids.contains(folder.id.uppercased()) {
                        let request = FoldersApi.delete(id: folder.id)
                        publishers.append(self.networkProvider.request(ofType: StatusModel.self, to: request))
                    }
                }

                Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
                    .sink { _ in } receiveValue: { _ in }
                    .store(in: &self.subscriptions)

            }
            .store(in: &self.subscriptions)
    }

    func loadFolders(loadCompletion: @escaping((Bool) -> Void)) {
        networkProvider.request(ofType: [FolderModel].self, to: FoldersApi.load).sink { completion in
            switch completion {
            case .failure:
                loadCompletion(false)
            case .finished:
                return
            }
        } receiveValue: { values in
            self.saveFolders(values)
            loadCompletion(true)

        }.store(in: &subscriptions)

    }

    // MARK: - Private funcs

    private func allNotesFolder() -> FolderModel {
        let notesCount = notesService.getNoutes().count
        return .init(id: "all", name: Localized.notes(), position: 0, enable: true, count: notesCount)
    }

    private func saveOnServer(_ model: FolderModel) {
        guard model != allNotesFolder() else {
            return
        }
        let request = FoldersApi.update(folder: model)
        networkProvider.request(ofType: StatusModel.self, to: request)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &subscriptions)
    }

    private func deleteFromServer(_ model: FolderModel) {
        let request = FoldersApi.delete(id: model.id)
        networkProvider.request(ofType: StatusModel.self, to: request)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &subscriptions)
    }
}
