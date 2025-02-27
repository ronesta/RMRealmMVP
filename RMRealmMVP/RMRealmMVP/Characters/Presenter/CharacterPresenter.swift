//
//  CharacterPresenter.swift
//  RMRealmMVP
//
//  Created by Ибрагим Габибли on 22.01.2025.
//

import Foundation
import UIKit

final class CharacterPresenter: CharacterPresenterProtocol {
    private weak var view: CharacterViewProtocol?
    private let networkManager: NetworkManagerProtocol
    private let storageManager: StorageManagerProtocol

    private var characters = [RealmCharacter]()

    init(view: CharacterViewProtocol,
         networkManager: NetworkManagerProtocol,
         storageManager: StorageManagerProtocol
    ) {
        self.view = view
        self.networkManager = networkManager
        self.storageManager = storageManager
    }

    func viewDidLoad() {
        getCharacters()
    }

    private func getCharacters() {
        characters = storageManager.fetchCharacters()

        guard characters.isEmpty else {
            view?.updateCharacters(characters)
            return
        }

        networkManager.getCharacters { [weak self] result, error in
            guard let self else {
                return
            }

            if let error {
                print("Error getting characters: \(error)")
                return
            }

            guard let result else {
                print("No result returned.")
                return
            }

            var charactersToSave: [(character: Character, imageData: Data)] = []

            let group = DispatchGroup()

            result.forEach { res in
                group.enter()
                self.networkManager.loadImage(from: res.image) { data, error in
                    defer {
                        group.leave()
                    }

                    if let error {
                        print("Failed to load image: \(error)")
                        return
                    }

                    guard let data else {
                        print("No data for image")
                        return
                    }

                    charactersToSave.append((character: res, imageData: data))
                }
            }

            group.notify(queue: .main) { [weak self] in
                guard let self else {
                    return
                }
                self.storageManager.saveCharacters(charactersToSave)

                DispatchQueue.main.async {
                    self.characters = self.storageManager.fetchCharacters()
                    self.view?.updateCharacters(self.characters)
                }
            }
        }
    }

    func fetchImageData(for characterId: Int) -> Data? {
        storageManager.fetchImageData(forCharacterId: characterId)
    }
}
