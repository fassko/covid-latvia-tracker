//
//  Kovid_Widget.swift
//  Kovid Widget
//
//  Created by Kristaps Grinbergs on 14/10/2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> KovidEntry {
    KovidEntry(date: Date(), kovidData: .example)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (KovidEntry) -> ()) {
    let entry = KovidEntry(date: Date(), kovidData: KovidData.example)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
    
    KovidAPI().getYesterdayData { kovidData in
      let entry = KovidEntry(date: currentDate, kovidData: kovidData)
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
    }
  }
}

struct KovidEntry: TimelineEntry {
  let date: Date
  let kovidData: KovidData
}

struct Kovid_WidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack(spacing: 5) {
      VStack(alignment: .leading, spacing: 5) {
        HStack {
          Text("Cases:")
            .font(.body)
          Text(entry.kovidData.infectedCount.description)
            .font(.headline)
            .foregroundColor(.orange)
        }
        
        HStack {
          Text("Deaths:")
            .font(.body)
          Text(entry.kovidData.deathCount.description)
            .font(.headline)
            .foregroundColor(.red)
        }
        
        HStack {
          Text("Tested:")
            .font(.body)
          Text(entry.kovidData.testsCount.description)
            .font(.headline)
        }
        
        HStack {
          Text("Recovered:")
            .font(.body)
          Text(entry.kovidData.recoveredCount.description)
            .font(.headline)
            .foregroundColor(.green)
        }
      }
      
      Spacer()
      
      Text(entry.kovidData.updatedDateString)
        .font(.subheadline)
      
    }.padding()
  }
}

@main
struct Kovid_Widget: Widget {
  let kind: String = "Kovid_Widget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      Kovid_WidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct Kovid_Widget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Kovid_WidgetEntryView(entry: KovidEntry(date: Date(), kovidData: KovidData.example))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDevice("iPhone 11 Pro")
      
      Kovid_WidgetEntryView(entry: KovidEntry(date: Date(), kovidData: KovidData.example))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDevice("iPhone 11 Pro")
    }
  }
}
