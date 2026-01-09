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
}

class potionsModel: Codable {
    var reports: reportsModel?
}

class reportsModel: Codable {
    var anecdotal: String?
    var paralysis: String?
    var baldness: String?
    var treatment: String?
}
