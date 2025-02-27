//
//  CharacterTableViewDataSource.swift
//  RMRealmMVP
//
//  Created by Ибрагим Габибли on 22.01.2025.
//

import Foundation
import UIKit

final class CharacterTableViewDataSource: NSObject, CharacterDataSourceProtocol {
    var characters = [RealmCharacter]()
    private let presenter: CharacterPresenterProtocol

    init(presenter: CharacterPresenterProtocol) {
        self.presenter = presenter
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterTableViewCell.id,
            for: indexPath
        ) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = characters[indexPath.row]

        guard let imageData = presenter.fetchImageData(for: character.id),
              let image = UIImage(data: imageData) else {
            return cell
        }

        cell.configure(with: character, image: image)

        return cell
    }
}
