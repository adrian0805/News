//
//  ActivityIndicator.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import SwiftUI

struct ActivityIndicator: View {
    @State var animate = false
    var style = StrokeStyle(lineWidth: 6, lineCap: .round)
    let orangeColor = Color.orange
    let orangeColorOpaque = Color.orange.opacity(0.5)

    init(lineWidth: CGFloat = 6) {
        style.lineWidth = lineWidth
    }
    var body: some View {
        ZStack {
            CircleView(animate: $animate, firstGradientColor: orangeColor, secondGradientColor: orangeColorOpaque, style: style)
        }.onAppear {
            self.animate.toggle()
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}

struct CircleView: View {
    @Binding var animate: Bool
    var firstGradientColor: Color
    var secondGradientColor: Color
    var style: StrokeStyle
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                AngularGradient(gradient: .init(colors: [firstGradientColor, secondGradientColor]), center: .center), style: style
            )
            .rotationEffect(Angle(degrees:  animate ? 360 : 0))
            .transition(.opacity)
            .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
    }
}
