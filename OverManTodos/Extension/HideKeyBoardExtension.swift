//
//  HideKeyBoardExtension.swift
//  OverManTodos
//
//  Created by 김종희 on 2023/07/07.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyBoadrd() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
