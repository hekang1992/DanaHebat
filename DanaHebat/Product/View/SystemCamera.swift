//
//  SystemCamera.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import AVFoundation

final class SystemCamera: NSObject {
    
    enum CameraPosition {
        case front
        case back
    }
    
    private weak var presentVC: UIViewController?
    private let picker = UIImagePickerController()
    private let position: CameraPosition
    private let imageBlock: (UIImage) -> Void
    
    init(from vc: UIViewController,
         position: CameraPosition,
         imageBlock: @escaping (UIImage) -> Void) {
        
        self.presentVC = vc
        self.position = position
        self.imageBlock = imageBlock
        super.init()
    }
    
    func present() {
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.setupPicker()
                self.presentVC?.present(self.picker, animated: true)
            } else {
                self.showPermissionAlert()
            }
        }
    }
    
    private func setupPicker() {
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        
        if UIImagePickerController.isCameraDeviceAvailable(.front),
           UIImagePickerController.isCameraDeviceAvailable(.rear) {
            picker.cameraDevice = (position == .front) ? .front : .rear
        }
    }
    
    private func checkCameraPermission(_ completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
}

extension SystemCamera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        if let compressed = compressImage(image, maxKB: 700) {
            imageBlock(compressed)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func compressImage(_ image: UIImage, maxKB: Int) -> UIImage? {
        let maxBytes = maxKB * 1024
        var quality: CGFloat = 0.7
        var data = image.jpegData(compressionQuality: quality)
        
        while let imageData = data,
              imageData.count > maxBytes,
              quality > 0.1 {
            quality -= 0.1
            data = image.jpegData(compressionQuality: quality)
        }
        
        guard let finalData = data else { return nil }
        return UIImage(data: finalData)
    }
}

extension SystemCamera {
    
    private func showPermissionAlert() {
        guard let vc = presentVC else { return }
        
        let alert = UIAlertController(
            title: "无法使用相机",
            message: "请在系统设置中开启相机权限",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        
        vc.present(alert, animated: true)
    }
    
}
