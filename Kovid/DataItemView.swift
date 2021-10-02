//
//  DataItemView.swift
//  Kovid
//
//  Created by Kristaps Grinbergs on 02/10/2021.
//

import SwiftUI

struct DataItemView: View {
  let text: String
  let label: String
  let systemImage: String
  var foregroundColor: Color = .black
  
  var body: some View {
    GroupBox {
      Text(text)
    } label: {
      Label(label, systemImage: systemImage)
    }
    .groupBoxStyle(PlainGroupBoxStyle())
    .foregroundColor(foregroundColor)
  }
}

struct DataItemView_Previews: PreviewProvider {
  static var previews: some View {
    DataItemView(text: "15%", label: "Percentage", systemImage: "square.and.pencil", foregroundColor: .orange)
  }
}
