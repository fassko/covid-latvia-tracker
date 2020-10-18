//
//  ContentView.swift
//  Kovid Apple Watch WatchKit Extension
//
//  Created by Kristaps Grinbergs on 16/10/2020.
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
      Spacer()
      
      HStack {
        Text("Cases:")
        Text(viewModel.kovidData.infectedCount.description)
          .foregroundColor(.orange)
          .font(.title3)
      }
      
      
      HStack {
        Text("Deaths:")
        Text(viewModel.kovidData.deathCount.description)
          .foregroundColor(.red)
          .font(.title3)
      }
      
      HStack {
        Text("Tested:")
        Text(viewModel.kovidData.testsCount.description)
          .font(.title3)
      }
      
      HStack {
        Text("Recovered:")
        Text(viewModel.kovidData.recoveredCount.description)
          .foregroundColor(.green)
          .font(.title3)
      }
      
      Divider()
      
      Text(viewModel.kovidData.updatedDateString.description)
        .font(.title3)
      
      Spacer()
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
