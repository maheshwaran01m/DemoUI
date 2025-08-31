//
//  CustomTimeLineView.swift
//  DemoUI
//
//  Created by MAHESHWARAN on 31/08/25.
//

import SwiftUI

struct CustomTimeLineView: View {
  
  var body: some View {
    TabView {
      CustomClockView()
      CustomTimerView()
    }
    .tabViewStyle(.page)
    .indexViewStyle(.page(backgroundDisplayMode: .always))
  }
}

extension CustomTimeLineView {
  
  // MARK: - Clock
  
  struct CustomClockView: View {
    
    var body: some View {
      TimelineView(.animation) { context in
        
        let date = context.date
        let calender = Calendar.current
        
        let seconds = Double(calender.component(.second, from: date))
        let minutes = Double(calender.component(.minute, from: date))
        let hours = Double(calender.component(.hour, from: date))
        
        let secondAngle = Angle.degrees(seconds * 6)
        let minuteAngle = Angle.degrees(minutes * 6)
        let hourAngle = Angle.degrees((hours * 30) + (minutes * 0.5))
        
        ZStack {
          
          Circle()
            .stroke(lineWidth: 4)
            .frame(width: 200, height: 200)
          
          // hour
          Rectangle()
            .fill(.primary)
            .frame(width: 4, height: 60)
            .offset(y: -30)
            .rotationEffect(hourAngle)
          
          // minute
          Rectangle()
            .fill(.primary)
            .frame(width: 3, height: 80)
            .offset(y: -40)
            .rotationEffect(minuteAngle)
          
          // second
          Rectangle()
            .fill(.red)
            .frame(width: 2, height: 90)
            .offset(y: -45)
            .rotationEffect(secondAngle)
          
          Circle()
            .fill(.primary)
            .frame(width: 10, height: 10)
        }
//        .animation(.smooth, value: secondAngle)
      }
    }
  }
}

extension CustomTimeLineView {
  
  // MARK: - Timer
  
  struct CustomTimerView: View {
    
    var body: some View {
      VStack(spacing: 20) {
        timeLineView
        playButton
      }
    }
    
    @State private var pauseAnimation = false

    private var timeLineView: some View {
      TimelineView(.animation(minimumInterval: 1, paused: pauseAnimation)) { context in
        Text("Date: \(context.date.description)")
        
        let seconds = Calendar.current.component(.second, from: context.date)
        Text(seconds.description)
        Rectangle()
          .frame(width: seconds < 10 ? 50 : seconds < 30 ? 200 : 400,
                 height: 100)
          .animation(.bouncy, value: seconds)
      }
    }
    
    private var playButton: some View {
      Button(pauseAnimation ? "Play" : "Pause") {
        pauseAnimation.toggle()
      }
      .buttonStyle(.borderedProminent)
    }
  }
}

struct CustomTimeLineView_Previews: PreviewProvider {
  static var previews: some View {
    CustomTimeLineView()
  }
}
