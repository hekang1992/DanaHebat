//
//  HttpViewModel.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import Toast_Swift

class HttpViewModel {
    
    /// launch
    func launchApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.get(
                url: "/relateder/kg",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    /// guide
    func uploadIDFAApi(parameters: [String: Any]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/sealed",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    
    /// login
    func codeApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/company",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func voiceCodeApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/pharmaceutical",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func loginApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/illness",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    /// home
    
    /// order
    
    /// center
    func centerMineApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.get(
                url: "/relateder/medicinal",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func outMineApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.get(
                url: "/relateder/mental",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func deleteMineApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/tightly",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    /// product
    
}

class ToastManager {
    static func showMessage(_ message: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.makeToast(message, duration: 3.0, position: .center)
    }
}
