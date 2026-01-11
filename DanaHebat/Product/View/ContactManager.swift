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
            title: "通讯录权限未开启",
            message: "请前往设置中开启通讯录权限",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
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
        
        let name = "\(contact.familyName)\(contact.givenName)"
        
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
                
                let name = "\(contact.familyName)\(contact.givenName)"
                
                list.append([
                    "purported": phones,
                    "crawl": name
                ])
            }
            
            result(list)
        }
    }
}
