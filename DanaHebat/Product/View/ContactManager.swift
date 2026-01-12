//
//  ContactManager.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import Contacts
import ContactsUI

typealias ContactResult = (_ result: [[String: String]]) -> Void
typealias SingleContactResult = (_ name: String, _ phone: String) -> Void

class ContactManager: NSObject {
    
    static let shared = ContactManager()
    private let store = CNContactStore()
    
    private var singleResult: SingleContactResult?
    
    func checkAuthorization(_ vc: UIViewController, completion: @escaping () -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized, .limited:
            completion()
            
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    granted ? completion() : self.showSettingAlert(vc)
                }
            }
            
        case .denied, .restricted:
            showSettingAlert(vc)
            
        @unknown default:
            break
        }
    }
    
    private func showSettingAlert(_ vc: UIViewController) {
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Permission Required"),
            message: LanguageManager.localizedString(for: "Contact permission is disabled. Please enable it in Settings to allow your loan application to be processed."),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .cancel))
        
        alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Go to settings"), style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        vc.present(alert, animated: true)
    }
}

extension ContactManager: CNContactPickerDelegate {
    
    func pickSingleContact(from vc: UIViewController,
                           result: @escaping SingleContactResult) {
        
        checkAuthorization(vc) {
            self.singleResult = result
            
            let picker = CNContactPickerViewController()
            picker.delegate = self
            picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
            vc.present(picker, animated: true)
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        
        let name = "\(contact.givenName) \(contact.familyName)"
        
        let phones = contact.phoneNumbers
            .map { $0.value.stringValue }
            .joined(separator: ",")
        
        singleResult?(name, phones)
    }
}

extension ContactManager {
    
    func fetchAllContacts(from vc: UIViewController,
                          result: @escaping ContactResult) {
        
        checkAuthorization(vc) {
            
            var list: [[String: String]] = []
            
            let keys: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor
            ]
            
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            try? self.store.enumerateContacts(with: request) { contact, _ in
                
                let phones = contact.phoneNumbers
                    .map { $0.value.stringValue }
                    .joined(separator: ",")
                
                guard !phones.isEmpty else { return }
                
                let name = "\(contact.givenName) \(contact.familyName)"
                
                list.append([
                    "purported": phones,
                    "crawl": name
                ])
            }
            
            result(list)
        }
    }
}
