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
    Task {
      do {
        self.kovidData = try await KovidAPI().getData()
      } catch {
        print("Error")
      }
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
    NavigationView {
      VStack {
        LazyVGrid(columns: [.init(), .init()]) {
          DataItemView(text: viewModel.kovidData.infectedCount.description,
                       label: "Cases",
                       systemImage: "square.and.pencil",
                       foregroundColor: .orange)
          
          DataItemView(text: viewModel.kovidData.deathCount.description,
                       label: "Deaths",
                       systemImage: "cross.circle.fill",
                       foregroundColor: .red)
          
          DataItemView(text: viewModel.kovidData.testsCount.description,
                       label: "Tested",
                       systemImage: "person.fill.questionmark")
          
          DataItemView(text: viewModel.kovidData.recoveredCount.description,
                       label: "Recovered",
                       systemImage: "person.fill.checkmark",
                       foregroundColor: .green)
          
          DataItemView(text: viewModel.kovidData.percentage.description,
                       label: "Percentage",
                       systemImage: "percent",
                       foregroundColor: .orange)
          
          DataItemView(text: viewModel.kovidData.updatedDateString,
                       label: "Updated",
                       systemImage: "calendar",
                       foregroundColor: .green)
        }
        .padding()
        
        Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: Button(action: {
        viewModel.fetchData()
      }, label: {
        Label("Refresh", systemImage: "arrow.clockwise")
      }))
    }
    .onAppear(perform: viewModel.fetchData)
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
      viewModel.fetchData()
    }
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
