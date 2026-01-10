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
    func homeApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.get(
                url: "/relateder/potions",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func enterApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/being",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    
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
    func productDetailApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/reports",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func getPersonalDetailApi(parameters: [String: Any]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/anecdotal",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func uploadImageApi(parameters: [String: String], data: Data) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.uploadImage(url: "/relateder/paralysis", imageData: data, parameters: parameters, responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func saveNameApi(parameters: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/baldness",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func getPersonalApi(parameters: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/treatment",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func savePersonalApi(parameters: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/purported",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func getWorkApi(parameters: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/migraines",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
    func saveWorkApi(parameters: [String: String]) async throws -> BaseModel {
        
        LoadingIndicator.show()
        
        defer {
            LoadingIndicator.hide()
        }
        
        do {
            let model: BaseModel = try await NetworkManager.shared.postMultipartForm(
                url: "/relateder/explanation",
                parameters: parameters,
                responseType: BaseModel.self)
            return model
        } catch {
            throw error
        }
    }
    
}

class ToastManager {
    static func showMessage(_ message: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.makeToast(message, duration: 3.0, position: .center)
    }
}
