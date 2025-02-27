//
//  CharacterViewProtocol.swift
//  RMRealmMVP
//
//  Created by Ибрагим Габибли on 22.01.2025.
//

import Foundation

protocol CharacterViewProtocol: AnyObject {
    func updateCharacters(_ characters: [RealmCharacter])
    
    func showError(_ message: String)
}
