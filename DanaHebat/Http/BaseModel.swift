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
    var off: offModel?
    var stated: String?
    var five: [fiveModel]?
    var appeared: fiveModel?
    var yet: yetModel?
}

class yetModel: Codable {
    var indicates: String?
    var ecological: String?
    var origins: String?
    var anthropologist: String?
    var chaerephon: String?
    var isolated: String?
    var plicata: String?
    var treat: String?
    var aselliscus: aselliscusModel?
    
    private enum CodingKeys: String, CodingKey {
        case indicates
        case ecological
        case origins
        case anthropologist
        case chaerephon
        case isolated
        case plicata
        case treat
        case aselliscus
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        indicates = try container.decodeIfPresent(String.self, forKey: .indicates)
        ecological = try container.decodeIfPresent(String.self, forKey: .ecological)
        origins = try container.decodeIfPresent(String.self, forKey: .origins)
        anthropologist = try container.decodeIfPresent(String.self, forKey: .anthropologist)
        chaerephon = try container.decodeIfPresent(String.self, forKey: .chaerephon)
        treat = try container.decodeIfPresent(String.self, forKey: .treat)
        aselliscus = try container.decodeIfPresent(aselliscusModel.self, forKey: .aselliscus)
        
        if let stringValue = try? container.decode(String.self, forKey: .isolated) {
            isolated = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .isolated) {
            isolated = String(intValue)
        } else {
            isolated = nil
        }
        
        if let stringValue = try? container.decode(String.self, forKey: .plicata) {
            plicata = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .plicata) {
            plicata = String(intValue)
        } else {
            plicata = nil
        }
    }
    
}

class aselliscusModel: Codable {
    var blasii: blasiiModel?
    var affinis: blasiiModel?
}

class blasiiModel: Codable {
    var tightly: String?
    var involved: String?
}

class offModel: Codable {
    var ready: String?
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
    var almost: String?
    var newar: [newarModel]?
    var stated: String?
    var off: String?
}

class newarModel: Codable {
    var anthropologist: Int?
    var ecological: String?
    var asthma: String?
    var treat: String?
    var flesh: String?
    var people: String?
    var northeast: String?
    var ao: String?
    var naga: String?
    var reported: String?
}

class fiveModel: Codable {
    var tightly: String?
    var infected: String?
    var identified: String?
    var contact: String?
    var gnaw: Int?
}
