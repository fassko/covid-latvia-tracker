//
//  KovidAPI.swift
//  Kovid
//
//  Created by Kristaps Grinbergs on 15/10/2020.
//

import Foundation

struct KovidData: Decodable {
  let testsCount: Int
  let infectedCount: Int
  let deathCount: Int
  let recoveredCount: Int
  let updatedDate: Date
  
  var percentage: Double {
    (Double((Double(infectedCount) / Double(testsCount)) * 100 ).rounded(toPlaces: 5))
  }
  
  var updatedDateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    formatter.timeZone = TimeZone(identifier: "GMT+3")
    
    return formatter.string(from: updatedDate)
  }
  
  enum Keys: String, CodingKey {
    case testsCount = "yesterday_tests_count"
    case infectedCount = "yesterday_infected_count"
    case deathCount = "yesterday_death_count"
    case recoveredCount = "yesterday_recovered_count"
    case updatedDate = "updated_at"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    
    testsCount = try container.decode(Int.self, forKey: .testsCount)
    infectedCount = try container.decode(Int.self, forKey: .infectedCount)
    deathCount = try container.decode(Int.self, forKey: .deathCount)
    recoveredCount = try container.decode(Int.self, forKey: .recoveredCount)
    updatedDate = try container.decode(Date.self, forKey: .updatedDate)
  }
  
  static var example: KovidData {
    let data = """
      {
        "total_tests_count": 100,
        "total_infected_count": 2,
        "total_death_count": 3,
        "total_recovered_count": 500,
        "infected_tests_proportion": 20,
        "yesterday_tests_count": 500,
        "yesterday_infected_count": 2,
        "yesterday_death_count": 5,
        "yesterday_recovered_count": 5,
        "updated_at": "2020-10-15"
      }
    """.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.customKovid)
    return try! decoder.decode(Self.self, from: data)
  }
}

extension DateFormatter {
  static let customKovid: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(identifier: "GMT+3")
    return formatter
  }()
}

import Combine

struct KovidAPI {
  func getData() async throws -> KovidData {
    let url = URL(string: "https://apturicovid-files.spkc.gov.lv/stats/v1/covid-stats.json")!
    
    let config = URLSessionConfiguration.ephemeral
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)
    
    let (data, _) = try await session.data(from: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.customKovid)
    return try decoder.decode(KovidData.self, from: data)
  }
}
