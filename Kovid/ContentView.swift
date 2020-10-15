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

struct ContentView: View {
  
  @ObservedObject var viewModel = ViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        Text("Cases:")
          .font(.title)
        Text(viewModel.kovidData.infectedCount.description)
          .font(.largeTitle)
          .foregroundColor(.orange)
      }
      
      HStack {
        Text("Deaths:")
          .font(.title)
        Text(viewModel.kovidData.deathCount.description)
          .font(.largeTitle)
          .foregroundColor(.red)
      }
      
      HStack {
        Text("Tested:")
          .font(.title)
        Text(viewModel.kovidData.testsCount.description)
          .font(.largeTitle)
      }
      
      HStack {
        Text("Recovered:")
          .font(.title)
        Text(viewModel.kovidData.recoveredCount.description)
          .font(.largeTitle)
          .foregroundColor(.green)
      }
      
      HStack {
        Text("Updated:")
          .font(.title)
        Text(viewModel.kovidData.updatedDateString.description)
          .font(.largeTitle)
      }
    }.onAppear {
      viewModel.fetchData()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
