//
//  BackgroundImage.swift
//  OverManTodos
//
//  Created by 김종희 on 2023/07/07.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("overman-background")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
            .offset(x: -100)
            
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
