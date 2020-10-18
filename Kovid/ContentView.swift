//
//  ContentView.swift
//  Kovid
//
//  Created by Kristaps Grinbergs on 14/10/2020.
//

import SwiftUI

class ViewModel: ObservableObject {
  @Published var kovidData: KovidData = KovidData.example
  
  func fetchData() {
    KovidAPI().getYesterdayData {
      self.kovidData = $0
    }
  }
}

struct PlainGroupBoxStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      VStack(alignment: .center, spacing: 10) {
        configuration.label.font(.title3)
          .lineLimit(1)
          .minimumScaleFactor(0.03)
          .padding(5)
        configuration.content.font(Font.largeTitle.bold())
          .lineLimit(1)
          .minimumScaleFactor(0.03)
          .padding(.vertical, 5)
      }
      .padding(.vertical, 15)
      Spacer()
    }
    .frame(minHeight: 80, maxHeight: .infinity, alignment: .center)
    .background(Color(.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    
  }
}

struct ContentView: View {
  
  @ObservedObject var viewModel = ViewModel()
  
  var body: some View {
    VStack {
      Spacer()
      
      LazyVGrid(columns: [.init(), .init()]) {
        GroupBox(label: Label("Cases", systemImage: "square.and.pencil"), content: {
          Text(viewModel.kovidData.infectedCount.description)  
        })
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.orange)
        
        GroupBox(label: Label("Deaths", systemImage: "cross.circle.fill"), content: {
          Text(viewModel.kovidData.deathCount.description)
        })
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.red)
        
        GroupBox(label: Label("Tested", systemImage: "person.fill.questionmark"), content: {
          Text(viewModel.kovidData.testsCount.description)
        })
        .groupBoxStyle(PlainGroupBoxStyle())
        
        GroupBox(label: Label("Recovered", systemImage: "person.fill.checkmark"), content: {
          Text(viewModel.kovidData.recoveredCount.description)
        })
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.green)
        
        GroupBox(label: Label("Percentage", systemImage: "percent"), content: {
            Text(viewModel.kovidData.percentage.description)
        })
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.orange)
        
        GroupBox(label: Label("Updated", systemImage: "calendar"), content: {
          Text(viewModel.kovidData.updatedDateString)
        })
        .groupBoxStyle(PlainGroupBoxStyle())
        .foregroundColor(.green)
      }.padding()
      
      Spacer()
    }.onAppear(perform: {
      viewModel.fetchData()
    })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
      
      ContentView()
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 11 Pro")
        .environment(\.colorScheme, .dark)
      
      ContentView()
        .preferredColorScheme(.dark)
        .previewDevice("iPad Air (4th generation)")
        .environment(\.colorScheme, .dark)
    }
  }
}
