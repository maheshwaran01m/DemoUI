//
//  CustomCoordinateSpaceView.swift
//  DemoUI
//
//  Created by MAHESHWARAN on 12/07/25.
//

import SwiftUI

struct CustomCoordinateSpaceView: View {
  
  @State private var space: CoordinateSpace = .local
  
  var body: some View {
    VStack {
      VStack {
        pickerView
        customView
      }
      .padding(20)
    }
    .border(.black)
    .animation(.easeInOut, value: space)
  }
  
  private var pickerView: some View {
    Picker("Offset", selection: $space) {
      
      Text("Local")
        .tag(CoordinateSpace.local)
      
      Text("CustomView")
        .tag(CoordinateSpace.named("CustomView"))
    }
    .buttonStyle(.bordered)
    .frame(width: 300)
  }
  
  private var customView: some View {
    VStack {
      GeometryReader { proxy in
        Rectangle()
          .fill(.red)
          .frame(width: 50, height: 50)
          .offset(offset(for: space, proxy: proxy))
      }
    }
    .frame(width: 200, height: 200)
    .border(.green)
    .padding(50)
    .border(.blue)
    .coordinateSpace(.named("CustomView"))
  }
  
  private func offset(for coordinateSpace: CoordinateSpace, proxy: GeometryProxy) -> CGSize {
    let frame = proxy.frame(in: space)
    
    return CGSize(width: -frame.origin.x, height: -frame.origin.y)
  }
}

#Preview {
  CustomCoordinateSpaceView()
}
