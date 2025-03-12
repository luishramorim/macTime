//
//  ButtonStyles.swift
//  macTime
//
//  Created by Luis Amorim on 12/03/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(minWidth: 100, minHeight: 20)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 100, minHeight: 20)
            .font(.headline)
            .padding()
            .background(.tertiary)
            .foregroundColor(.accentColor)
            .cornerRadius(30)
    }
}

#Preview {
    TimerView()
}
