//
//  ContentView.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import SwiftUI

struct WeatherView: View {
    var weatherType: WeatherType = .rain
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 16){
                Image(weatherType.backgroundpicture)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay{
                        VStack(alignment: .center){
                            Text("43°")
                                .font(.system(size: 64, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Text("\(weatherType.name)")
                                .font(.system(size: 32, weight: .regular, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                HStack {
                    TempretureView(labelName: "min", temperature: 25)
                    Spacer()
                    TempretureView(labelName: "Current", temperature: 25)
                    Spacer()
                    TempretureView(labelName: "max", temperature: 25)
                }.padding(.horizontal)
                
                Divider()
                    .frame(height: 2)
                    .overlay(.white)
                List (1 ..< 6){ _ in
                    DailyWeatherRow(dailyWeatherModel: DailyWeatherModel(name: "wednesday", temperature: 20, weathertype: .sunny))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }.listStyle(.plain)
                Spacer()
            }.background(weatherType.backgroundcolor)
                .ignoresSafeArea()
        }
    }
}

extension WeatherType {
    var backgroundcolor: Color {
        switch self {
        case .sunny:
            return .sunnyColor
        case .cloudy:
            return .cloudyColor
        case .rain:
            return .rainyColor
        }
    }
}

#Preview {
    WeatherView()
}

