//
//  TempretureView.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//
import SwiftUI

struct TempretureView: View {
    var labelName: String
    var temperature: Int
    var body: some View {
        VStack (alignment: .center){
            Text("\(temperature)°")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.white)
            Text("\(labelName)")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    TempretureView(labelName: "min", temperature: 25)
}
