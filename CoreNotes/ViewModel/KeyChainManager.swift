//
//  KeyChainManager.swift
//  CoreNotes
//
//  Created by Ariel on 6/4/24.
//

import Foundation
import Security


class KeyChainManager {
    

    func saveUserID(userID: String) -> Bool {
        guard let data = userID.data(using: .utf8) else { return false }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier!,
            kSecAttrAccount as String: "userID",
            kSecValueData as String: data
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getUserIDFromKeychain() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier!,
            kSecAttrAccount as String: "userID",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)
        
        guard status == errSecSuccess, let data = dataRef as? Data, let userID = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return userID
    }
}
