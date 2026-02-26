//
//  Untitled.swift
//  DanaHebat
//
//  Created by hekang on 2026/2/26.
//

import Foundation

// https://id08-dc.oss-ap-southeast-5.aliyuncs.com/dana-hebat/dh.json
struct DataItem: Codable {
    let dh: String
}

typealias DataArray = [DataItem]

func fetchJSON(from urlString: String) async throws -> [DataItem] {
    guard let url = URL(string: urlString) else {
        throw NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL-"])
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw NSError(domain: "HTTPError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Network-"])
    }
    
    do {
        let decoder = JSONDecoder()
        let result = try decoder.decode([DataItem].self, from: data)
        return result
    } catch {
        throw error
    }
}
