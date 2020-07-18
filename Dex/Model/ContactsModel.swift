//
//  ContactModel.swift
//  Dex
//
//  Created by Arpit Bansal on 7/18/20.
//

import Foundation
import Contacts
import CryptoKit

struct ContactsModel {
    
    func fetchContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]

        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        print(allContainers.count)
        
        var contacts: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                contacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return contacts
    }
    
    func hashContactIdentifier(withIdentifier id: String) -> String {
        let hashedContactIdDigest = SHA256.hash(data: id.data(using: .utf8)!)
        let hashedContactId = hashedContactIdDigest.map { String(format: "%02hhx", $0) }.joined()
        
        return hashedContactId
    }
}
