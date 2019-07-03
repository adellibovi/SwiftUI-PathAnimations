//
//  ContentView.swift
//  SwiftUI+PathAnimations
//
//  Created by Alfredo Delli Bovi on 6/30/19.
//  Copyright © 2019 Alfredo Delli Bovi. All rights reserved.
//

import SwiftUI
import SwiftUIPathAnimations

struct ContentView: View {
    @State var draggingPoint: CGPoint = .zero
    @State var isDragging: Bool = false
    @State var isOn: Bool = false
    @State var shouldShowCircle: Bool = true
    var body: some View {
        VStack {
        shape()
            .foregroundColor(Color.blue)
            .tapAction { withAnimation { self.isOn.toggle() } }
            .aspectRatio(1, contentMode: .fit)
            .gesture(DragGesture()
                .onChanged { result in
                    self.draggingPoint = result.location
                    self.isDragging = true
            }
            .onEnded { result in
                withAnimation(.spring()) {
                    self.isDragging = false
                }
            })
            Text(shouldShowCircle ? "Drag the edge of the circle" : "Tap the shape to morph into a different one")
            Spacer()
            Toggle("Show morphing circle", isOn: $shouldShowCircle)
        }
        .padding()

    }

    func shape() -> some View {
        func path(in rect: CGRect) -> Path {
            if shouldShowCircle {
                return MorphCircle(draggingPoint: draggingPoint, isDragging: isDragging).path(in: rect)
            } else {
                return isOn ? Circle().path(in: rect) : Path(roundedRect: rect, cornerRadius: 30)
            }
        }

        return GeometryReader { proxy -> AnyView in
            let rect = proxy.frame(in: CoordinateSpace.local)
            if self.shouldShowCircle {
                return AnyView(SimilarShape(path: path(in: rect)))
            } else {
                return AnyView(InterpolatedShape(path: path(in: rect)))
            }
        }
    }


}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
