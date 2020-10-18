//
//  KovidAPI.swift
//  Kovid
//
//  Created by Kristaps Grinbergs on 15/10/2020.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct KovidData: Decodable {
  let testsCount: Int
  let infectedCount: Int
  let deathCount: Int
  let recoveredCount: Int
  let updatedDate: Date
  
  var percentage: Double {
    Double(Double(infectedCount) / Double(testsCount)).rounded(toPlaces: 5)
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
        "total_tests_count": 378190,
        "total_infected_count": 3056,
        "total_death_count": 41,
        "total_recovered_count": 1329,
        "infected_tests_proportion": 0.81,
        "yesterday_tests_count": 4667,
        "yesterday_infected_count": 114,
        "yesterday_death_count": 0,
        "yesterday_recovered_count": 4,
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
  func getYesterdayData(_ completion: @escaping (KovidData) -> ()) {
    let url = URL(string: "https://apturicovid-files.spkc.gov.lv/stats/v1/covid-stats.json")!
    
    let config = URLSessionConfiguration.ephemeral
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)
    
    session.dataTask(with: url) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.customKovid)
        let kovidData = try! decoder.decode(KovidData.self, from: data)
        DispatchQueue.main.async {
          completion(kovidData)
        }
      }
    }.resume()
  }
}
