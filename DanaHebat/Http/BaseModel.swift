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
    var appeared: fiveModel?  // 保持为 fiveModel? 类型
    var yet: yetModel?
    var newar: newarModel?
    var pearsoni: Int?
    var sinicus: [sinicusModel]?
    var showed: [showedModel]?
    var coronavirus: [showedModel]?
    
    enum CodingKeys: String, CodingKey {
        case reports, being, migraines, increased, userInfo
        case certainly, off, stated, five, appeared, yet, newar
        case pearsoni, sinicus, showed, coronavirus
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        reports = try? container.decode(reportsModel?.self, forKey: .reports)
        being = try? container.decode(String?.self, forKey: .being)
        migraines = try? container.decode(String?.self, forKey: .migraines)
        increased = try? container.decode(String?.self, forKey: .increased)
        userInfo = try? container.decode(userInfoModel?.self, forKey: .userInfo)
        certainly = try? container.decode([certainlyModel]?.self, forKey: .certainly)
        off = try? container.decode(offModel?.self, forKey: .off)
        stated = try? container.decode(String?.self, forKey: .stated)
        five = try? container.decode([fiveModel]?.self, forKey: .five)
        yet = try? container.decode(yetModel?.self, forKey: .yet)
        newar = try? container.decode(newarModel?.self, forKey: .newar)
        pearsoni = try? container.decode(Int?.self, forKey: .pearsoni)
        sinicus = try? container.decode([sinicusModel]?.self, forKey: .sinicus)
        showed = try? container.decode([showedModel]?.self, forKey: .showed)
        coronavirus = try? container.decode([showedModel]?.self, forKey: .coronavirus)
        
        if let appearedValue = try? container.decode(fiveModel?.self, forKey: .appeared) {
            appeared = appearedValue
        } else if let _ = try? container.decode([fiveModel]?.self, forKey: .appeared) {
            appeared = nil
        } else {
            appeared = nil
        }
    }
}

class showedModel: Codable {
    var tightly: String?
    var infected: String?
    var illness: String?
    var analyses: String?
    var linked: [linkedModel]?
    var detected: Int?
    var orthoreoviruses: String?
    var market: String?
    var almost: String?
    
    var animal: String?
    var outbreak: String?
    var zoonosis: String?
    var health: String?
    var crawl: String?
    var possible: String?
    var causative: String?
    
    private enum CodingKeys: String, CodingKey {
        case tightly
        case infected
        case illness
        case analyses
        case linked
        case detected
        case orthoreoviruses
        case market
        case almost
        case animal
        case outbreak
        case zoonosis
        case health
        case crawl
        case possible
        case causative
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        crawl = try container.decodeIfPresent(String.self, forKey: .crawl)
        possible = try container.decodeIfPresent(String.self, forKey: .possible)
        causative = try container.decodeIfPresent(String.self, forKey: .causative)
        
        animal = try container.decodeIfPresent(String.self, forKey: .animal)
        outbreak = try container.decodeIfPresent(String.self, forKey: .outbreak)
        zoonosis = try container.decodeIfPresent(String.self, forKey: .zoonosis)
        health = try container.decodeIfPresent(String.self, forKey: .health)
        
        tightly = try container.decodeIfPresent(String.self, forKey: .tightly)
        infected = try container.decodeIfPresent(String.self, forKey: .infected)
        illness = try container.decodeIfPresent(String.self, forKey: .illness)
        analyses = try container.decodeIfPresent(String.self, forKey: .analyses)
        linked = try container.decodeIfPresent([linkedModel].self, forKey: .linked)
        detected = try container.decodeIfPresent(Int.self, forKey: .detected)
        orthoreoviruses = try container.decodeIfPresent(String.self, forKey: .orthoreoviruses)
        
        if let stringValue = try? container.decode(String.self, forKey: .market) {
            market = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .market) {
            market = String(intValue)
        } else {
            market = nil
        }
        
        if let stringValue = try? container.decode(String.self, forKey: .almost) {
            almost = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .almost) {
            almost = String(intValue)
        } else {
            almost = nil
        }
    }
    
}

class linkedModel: Codable {
    var crawl: String?
    var almost: String?
    
    private enum CodingKeys: String, CodingKey {
        case crawl
        case almost
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        crawl = try container.decodeIfPresent(String.self, forKey: .crawl)
        if let stringValue = try? container.decode(String.self, forKey: .almost) {
            almost = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .almost) {
            almost = String(intValue)
        } else {
            almost = nil
        }
    }
    
}

class sinicusModel: Codable {
    var virus: String?
    var positive: String?
    var illness: String?
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
    var asthma: String?
    var ecological: String?
    var hilli: [hilliModel]?
    var treat: String?
    var stoliczka: String?
    var rocky: String?
}

class hilliModel: Codable {
    var tightly: String?
    var trident: String?
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
    var harbored: String?
    var homologous: String?
    var recombination: String?
    var arisen: String?
    var philippines: String?
}

class fiveModel: Codable {
    var tightly: String?
    var infected: String?
    var identified: String?
    var contact: String?
    var gnaw: Int?
}
