//
//  DataItemView.swift
//  Kovid
//
//  Created by Kristaps Grinbergs on 02/10/2021.
//

import SwiftUI

extension View {
  @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
    if condition() {
      transform(self)
    } else {
      self
    }
  }
}

struct DataItemView: View {
  let text: String
  let label: String
  let systemImage: String
  var foregroundColor: Color?
  
  var body: some View {
    GroupBox {
      Text(text)
    } label: {
      Label(label, systemImage: systemImage)
    }
    .groupBoxStyle(PlainGroupBoxStyle())
    .if(foregroundColor != nil) { view in
      view.foregroundColor(foregroundColor!)
    }
  }
}

struct DataItemView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DataItemView(text: "15%", label: "Percentage", systemImage: "square.and.pencil", foregroundColor: .orange)
      
      DataItemView(text: "15%", label: "Percentage", systemImage: "square.and.pencil")
      
      DataItemView(text: "15%", label: "Percentage", systemImage: "square.and.pencil")
        .preferredColorScheme(.dark)
    }
  }
}
