//
//  BaseModel.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

class BaseModel: Codable {
    var illness: Int?
    var mental: String?
    var potions: potionsModel?
    
    enum CodingKeys: String, CodingKey {
        case illness
        case mental
        case potions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        illness = try container.decodeIfPresent(Int.self, forKey: .illness)
        mental = try container.decodeIfPresent(String.self, forKey: .mental)
        if let model = try? container.decode(potionsModel.self, forKey: .potions) {
            potions = model
        } else if let _ = try? container.decode([potionsModel].self, forKey: .potions) {
            potions = nil
        } else {
            potions = nil
        }
    }
}

class potionsModel: Codable {
    var reports: reportsModel?
    var being: String?
    var migraines: String?
    var increased: String?
    var userInfo: userInfoModel?
    var certainly: [certainlyModel]?
}

class reportsModel: Codable {
    var anecdotal: String?
    var paralysis: String?
    var baldness: String?
    var treatment: String?
}

class userInfoModel: Codable {
    var purported: String?
}

class certainlyModel: Codable {
    var tightly: String?
    var stated: String?
    var off: String?
}
