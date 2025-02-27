//
//  CharacterPresenterProtocol.swift
//  RMRealmMVP
//
//  Created by Ибрагим Габибли on 22.01.2025.
//

import Foundation
import UIKit

protocol CharacterPresenterProtocol: AnyObject {
    func viewDidLoad()

    func fetchImageData(for characterId: Int) -> Data?
}
