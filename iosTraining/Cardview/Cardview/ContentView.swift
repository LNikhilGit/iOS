//
//  ContentView.swift
//  Cardview
//
//  Created by Nikhil Lalam on 11/22/23.
//

import SwiftUI


struct ContentView: View {
    let List = ["🍏","🍓","🍉","🍇","🫐","🥥","🥦","🧄"]
    var body: some View {
        HStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
            ForEach(List, id: \.self) { List in
                            CardView(content: "\(List)")
                        }
        }
        .padding()
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    @State var colorvalue = true
    var content: String = ""
    var body: some View {
        ZStack{
            let baseCard = RoundedRectangle(cornerRadius: 10)
            if(colorvalue){
                baseCard
                baseCard.fill(.white)
                baseCard.strokeBorder(style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/)
                Text("\(content)").font(.largeTitle)
            }
            else{
                baseCard.fill(.orange)
                Text("\(content)").font(.largeTitle)
            }
        }.onTapGesture {
            colorvalue.toggle()
        }
    }
}

#Preview {
    ContentView()
}
