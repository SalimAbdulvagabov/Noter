//
//  NotesService.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//
import Combine
import Alamofire
import WidgetKit

final class NotesService {

    // MARK: - Private properties

    private let networkProvider: INetworkProvider
    private let dataBaseManager: DatabaseManagerProtocol
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(networkProvider: INetworkProvider,
         dataBaseManager: DatabaseManagerProtocol) {
        self.networkProvider = networkProvider
        self.dataBaseManager = dataBaseManager
    }

    // MARK: - Internal funcs

    func saveNoute(_ note: NoteModel) {
        let request = NotesApi.update(note: note)
        networkProvider.request(ofType: StatusModel.self, to: request)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &subscriptions)

        let noteBaseModel = NoteDataBaseObject(note)
        dataBaseManager.save(noteBaseModel, shouldUpdate: false)

        WidgetCenter.shared.reloadAllTimelines()
    }

    func updateNote(_ note: NoteModel) {
        let request = NotesApi.update(note: note)
        networkProvider.request(ofType: StatusModel.self, to: request)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &subscriptions)

        deleteNoute(note, withFromBack: false)
        dataBaseManager.save(NoteDataBaseObject(note), shouldUpdate: false)
    }

    func deleteNoute(_ note: NoteModel, withFromBack: Bool = true) {
        if withFromBack {
            deleteFromBack(id: note.id)
        }
        let result: [NoteDataBaseObject] = dataBaseManager.load { object in
            object.uuid.uppercased() == note.id.uppercased()
        }
        dataBaseManager.delete(result)

        WidgetCenter.shared.reloadAllTimelines()
    }

    func getNoutes() -> [NoteModel] {
        let notes: [NoteDataBaseObject] = dataBaseManager.load(filter: nil)
        return notes.map { $0.convertToNoute() }.sorted { (first, second) -> Bool in
            return first.date.timeIntervalSince1970 > second.date.timeIntervalSince1970
        }
    }

    func loadNotes(loadCompletion: @escaping((Bool) -> Void)) {
        networkProvider.request(ofType: [NoteModel].self, to: NotesApi.load).sink { completion in
            switch completion {
            case .failure:
                loadCompletion(false)
            case .finished:
                return
            }
        } receiveValue: { values in
            values.forEach {
                self.saveNoute($0)
            }
            loadCompletion(true)

        }.store(in: &subscriptions)

    }

    func synchronize() {
        let publishers: [AnyPublisher<StatusModel, RequestError>] = getNoutes().map { note in
            let request = NotesApi.update(note: note)
            return networkProvider.request(ofType: StatusModel.self, to: request)
        }

        Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
            .sink { _ in } receiveValue: { _ in }
            .store(in: &self.subscriptions)

        networkProvider.request(ofType: [NoteModel].self, to: NotesApi.load)
            .sink { _ in } receiveValue: { [weak self] values in
                guard let self = self else { return }
                var publishers: [AnyPublisher<StatusModel, RequestError>] = []
                let ids = self.getNoutes().map {$0.id.uppercased()}

                values.forEach { note in
                    if !ids.contains(note.id.uppercased()) {
                        let request = NotesApi.delete(id: note.id)
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

        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: - Private funcs

    private func deleteFromBack(id: String) {
        let request = NotesApi.delete(id: id)
        networkProvider.request(ofType: StatusModel.self, to: request)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &subscriptions)
    }
}
