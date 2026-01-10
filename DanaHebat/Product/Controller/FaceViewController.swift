//
//  FaceViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import BRPickerView
import TYAlertController
import Kingfisher

class FaceViewController: BaseViewController {
    
    var appTitle: String = ""
    
    var productID: String = ""
    
    var baseModel: BaseModel?
    
    private var camera: SystemCamera?
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = HttpViewModel()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "fc_d_i_image") : UIImage(named: "fc_e_n_image")
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        applyBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(600))
        applyBtn.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        return applyBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneListView: FaceListView = {
        let oneListView = FaceListView(frame: .zero)
        oneListView.cImageView.image = UIImage(named: "t_p_image")
        return oneListView
    }()
    
    lazy var twoListView: FaceListView = {
        let twoListView = FaceListView(frame: .zero)
        twoListView.cImageView.image = UIImage(named: "t_f_image")
        return twoListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: appTitle)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.backProductVc()
        }
        
        view.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(123.pix())
        }
        
        view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30.pix())
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(applyBtn.snp.top).offset(-10.pix())
        }
        
        scrollView.addSubview(oneListView)
        scrollView.addSubview(twoListView)
        
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(284.pix())
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(12.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(284.pix())
            make.bottom.equalToSuperview().offset(-30.pix())
        }
        
        Task {
            await self.getPersonalInfo()
        }
        
        oneListView.tapClickBlock = { [weak self] in
            guard let self = self, let baseModel = baseModel else { return }
            self.ocAlertView(with: baseModel)
        }
        
        twoListView.tapClickBlock = { [weak self] in
            guard let self = self, let baseModel = baseModel else { return }
            self.ocAlertView(with: baseModel)
        }
        
        applyBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self, let baseModel = baseModel else { return }
                let recombination = baseModel.potions?.newar?.recombination ?? ""
                let arisen = baseModel.potions?.newar?.arisen ?? ""
                if recombination.isEmpty || arisen.isEmpty {
                    self.ocAlertView(with: baseModel)
                }else {
                    self.backProductVc()
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension FaceViewController {
    
    private func getPersonalInfo() async {
        do {
            let parameters = ["will": productID]
            let model = try await viewModel.getPersonalDetailApi(parameters: parameters)
            if model.illness == 0 {
                self.baseModel = model
                self.configNameInfo(with: model)
            }
        } catch {
            
        }
    }
    
    private func configNameInfo(with model: BaseModel) {
        self.oneListView.nameLabel.text = model.potions?.newar?.harbored ?? ""
        self.twoListView.nameLabel.text = model.potions?.newar?.homologous ?? ""
        self.ocAlertView(with: model)
    }
    
}

extension FaceViewController {
    
    private func ocAlertView(with model: BaseModel) {
        let recombination = model.potions?.newar?.recombination ?? ""
        let arisen = model.potions?.newar?.arisen ?? ""
        if recombination.isEmpty {
            let photoView = CommonAlertView(frame: self.view.bounds)
            photoView.bgImageView.image = languageCode == "id" ? UIImage(named: "alt_end_p_image") : UIImage(named: "alt_en_p_image")
            let alertVc = TYAlertController(alert: photoView, preferredStyle: .alert)
            self.present(alertVc!, animated: true)
            photoView.leftBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            photoView.rightBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.camera = SystemCamera(
                        from: self,
                        position: .back
                    ) { [weak self] image in
                        self?.handleImage(image, type: "11")
                    }
                    self.camera?.present()
                }
            }
            return
        }
        
        self.oneListView.typeLabel.backgroundColor = UIColor.init(hexString: "#90FF38")
        self.oneListView.typeLabel.text = LanguageManager.localizedString(for: "Uploaded")
        
        self.oneListView.cImageView.kf.setImage(with: URL(string: recombination))
        
        if arisen.isEmpty {
            let photoView = CommonAlertView(frame: self.view.bounds)
            photoView.bgImageView.image = languageCode == "id" ? UIImage(named: "alt_end_f_image") : UIImage(named: "alt_en_f_image")
            let alertVc = TYAlertController(alert: photoView, preferredStyle: .alert)
            self.present(alertVc!, animated: true)
            photoView.leftBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            photoView.rightBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.dismiss(animated: true) {
                        self.camera = SystemCamera(
                            from: self,
                            position: .front
                        ) { [weak self] image in
                            self?.handleImage(image, type: "10")
                        }
                        self.camera?.present()
                    }
                }
            }
            return
        }
        self.twoListView.cImageView.kf.setImage(with: URL(string: arisen))
        self.twoListView.typeLabel.backgroundColor = UIColor.init(hexString: "#90FF38")
        self.twoListView.typeLabel.text = LanguageManager.localizedString(for: "Uploaded")
        
    }
    
    private func handleImage(_ image: UIImage, type: String) {
        if let data = image.jpegData(compressionQuality: 0.35) {
            Task {
                do {
                    let parameters = ["almost": type, "similarity": "1"]
                    let model = try await viewModel.uploadImageApi(parameters: parameters, data: data)
                    if model.illness == 0 {
                        let pearsoni = model.potions?.pearsoni ?? 0
                        if pearsoni == 1 {
                            self.alertNameViwe(with: model.potions?.sinicus ?? [])
                        }else {
                            await self.getPersonalInfo()
                        }
                    }else {
                        ToastManager.showMessage(model.mental ?? "")
                    }
                } catch {
                    
                }
            }
        }
    }
    
    private func alertNameViwe(with modelArray: [sinicusModel]) {
        let photoView = PersonalNameAlertView(frame: self.view.bounds)
        photoView.modelArray = modelArray
        let alertVc = TYAlertController(alert: photoView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        photoView.leftBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        photoView.rightBlock = { [weak self] in
            guard let self = self else { return }
            let crawl = photoView.oneListView.enterFiled.text ?? ""
            let similar = photoView.twoListView.enterFiled.text ?? ""
            let viruses = photoView.threeListView.enterFiled.text ?? ""
            let parameters = ["crawl": crawl,
                              "similar": similar,
                              "viruses": viruses,
                              "will": productID]
            Task {
                await self.saveNameInfo(with: parameters)
            }
        }
        
        photoView.timeBlock = { [weak self] time, timeView in
            guard let self = self else { return }
            self.tapTimeClick(with: time, timeView: timeView)
        }
    }
    
}

extension FaceViewController {
    
    private func tapTimeClick(with time: String?, timeView: CommonClickView) {
        let datePickerView = createDatePickerView()
        datePickerView.selectDate = parseDate(from: time)
        datePickerView.pickerStyle = createPickerStyle()
        
        datePickerView.resultBlock = { [weak self] selectDate, selectValue in
            self?.handleDateSelection(selectDate, timeView: timeView)
        }
        
        datePickerView.show()
    }
    
    private func createDatePickerView() -> BRDatePickerView {
        let datePickerView = BRDatePickerView()
        datePickerView.pickerMode = .YMD
        datePickerView.title = LanguageManager.localizedString(for: "Date Selection")
        return datePickerView
    }
    
    private func parseDate(from timeString: String?) -> Date {
        guard let timeString = timeString, !timeString.isEmpty else {
            return getDefaultDate()
        }
        
        let dateFormats = ["dd-MM-yyyy"]
        let dateFormatter = DateFormatter()
        
        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: timeString) {
                return date
            }
        }
        
        return getDefaultDate()
    }
    
    private func getDefaultDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: "25-12-1989") ?? Date()
    }
    
    private func createPickerStyle() -> BRPickerStyle {
        let customStyle = BRPickerStyle()
        customStyle.rowHeight = 45.pix()
        customStyle.language = "en"
        customStyle.doneBtnTitle = LanguageManager.localizedString(for: "OK")
        customStyle.cancelBtnTitle = LanguageManager.localizedString(for: "Cancel")
        customStyle.doneTextColor = UIColor(hexString: "#333333")
        customStyle.selectRowTextColor = UIColor(hexString: "#333333")
        customStyle.pickerTextFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        customStyle.selectRowTextFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return customStyle
    }
    
    private func handleDateSelection(_ selectedDate: Date?, timeView: CommonClickView) {
        guard let selectedDate = selectedDate else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let resultDateString = dateFormatter.string(from: selectedDate)
        timeView.enterFiled.text = resultDateString
    }
    
}

extension FaceViewController {
    
    private func saveNameInfo(with parameters: [String: String]) async {
        do {
            let model = try await viewModel.saveNameApi(parameters: parameters)
            if model.illness == 0 {
                self.dismiss(animated: true)
                await self.getPersonalInfo()
            }else {
                ToastManager.showMessage(model.mental ?? "")
            }
        } catch {
            
        }
    }
    
}
