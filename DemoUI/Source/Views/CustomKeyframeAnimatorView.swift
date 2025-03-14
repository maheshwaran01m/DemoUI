//
//  CustomKeyframeAnimatorView.swift
//  DemoUI
//
//  Created by MAHESHWARAN on 14/03/25.
//

import SwiftUI

struct CustomKeyframeAnimatorView: View {
  
  @State private var isAnimating = true
  
  // MARK: - View
  
  var body: some View {
    VStack(spacing: .zero) {
      keyframeView
      groundView
      placeholderView
    }
  }
  
  // MARK: - Keyframe
  
  private var keyframeView: some View {
    KeyframeAnimator(
      initialValue: InitialAnimator(),
      repeating: isAnimating,
      content: { value in
        
        Text("❉")
          .font(.system(size: value.size))
          .rotationEffect(value.rotation, anchor: .center)
          .offset(value.offset)
          .scaleEffect(y: value.flatness, anchor: .bottom)
        
      }, keyframes: { value in
        
        // Width
        KeyframeTrack(\.offset.width) {
          LinearKeyframe(-100, duration: value.pause)
          LinearKeyframe(100, duration: value.jump)
          LinearKeyframe(100, duration: value.rest)
          LinearKeyframe(-100, duration: value.roll)
        }
        
        // Height Jump
        KeyframeTrack(\.offset.height) {
          LinearKeyframe(0, duration: value.pause)
          LinearKeyframe(-100, duration: value.jump/2, timingCurve: .circularEaseOut)
          LinearKeyframe(0, duration: value.jump/2, timingCurve: .circularEaseIn)
          LinearKeyframe(0, duration: value.rest)
        }
        
        // Rotation
        KeyframeTrack(\.rotation) {
          LinearKeyframe(.degrees(0), duration: value.pause)
          LinearKeyframe(.degrees(720), duration: value.jump)
          MoveKeyframe(.degrees(0))
          LinearKeyframe(.degrees(0), duration: value.rest)
          LinearKeyframe(.degrees(-720), duration: value.roll)
          MoveKeyframe(.degrees(0))
        }
        
        // Rolling back to Initial Position
        KeyframeTrack(\.flatness) {
          LinearKeyframe(0.8, duration: value.pause)
          LinearKeyframe(1.0, duration: value.pause)
          LinearKeyframe(1.0, duration: value.jump - value.pause)
        }
      })
  }
  
  struct InitialAnimator {
    
    var size: CGFloat = 50.0
    var offset: CGSize = CGSize(width: -100.0, height: 0)
    var rotation: Angle = .zero
    var flatness: CGFloat = 1.0
    
    // Default Values
    let pause: TimeInterval = 0.25
    let rest: TimeInterval = 0.25
    let jump: TimeInterval = 1.0
    let roll: TimeInterval = 2.0
  }
  
  // MARK: - GroundView
  
  private var groundView: some View {
    Rectangle()
      .fill(Color.gray)
      .frame(height: 1)
  }
  
  private var placeholderView: some View {
    Text("Keyframe Animator")
      .padding(.top, 30)
      .foregroundStyle(Color.gray)
  }
}

// MARK: - CustomKeyframeAnimatorView

struct CustomKeyframeAnimatorView_Previews: PreviewProvider {
  
  static var previews: some View {
    CustomKeyframeAnimatorView()
  }
}
