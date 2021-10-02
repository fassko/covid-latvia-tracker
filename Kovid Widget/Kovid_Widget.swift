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
    
    Task {
      let kovidData = try await KovidAPI().getData()
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

struct PlainGroupBoxStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      VStack(alignment: .center, spacing: 3) {
        configuration.label.font(.subheadline)
        configuration.content.font(Font.title3.bold())
      }
      .padding(3)
      Spacer()
    }
    .background(Color(.systemGroupedBackground))
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}

struct Kovid_WidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      Spacer()
      
      VStack(alignment: .center, spacing: 10) {
        GroupBox(label: Label("Cases", systemImage: "square.and.pencil")) {
            Text(entry.kovidData.infectedCount.description)
        }
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.orange)
        
        GroupBox(label: Label("Deaths", systemImage: "cross.circle.fill")) {
          Text(entry.kovidData.deathCount.description)
        }
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.red)
        
        Text(entry.kovidData.updatedDateString)
          .font(.caption2)
      }
      .padding()
      
      Spacer()
    }
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
      
      Kovid_WidgetEntryView(entry: KovidEntry(date: Date(), kovidData: KovidData.example))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDevice("iPhone 11 Pro")
        .preferredColorScheme(.dark)
        .environment(\.colorScheme, .dark)

      Kovid_WidgetEntryView(entry: KovidEntry(date: Date(), kovidData: KovidData.example))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDevice("iPhone 11 Pro")
        .preferredColorScheme(.dark)
        .environment(\.colorScheme, .dark)
    }
  }
}
