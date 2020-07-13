//
//  ContentView.swift
//  SwiftUITips004
//
//  Created by Lazy Yuuuuu on 2020/7/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            createText()
        }
        .font(.system(size: 60))
    }
    func createText() -> some View {
        let text = Text("Hello world!")
            .foregroundColor(.blue)
            .border(Color.yellow, width: 1)
            .padding(.all, 20)
        return text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
