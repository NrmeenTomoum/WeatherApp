//
//  ContentView.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//

import SwiftUI

struct WeatherView: View {
    var viewModel: WeatherViewModel = .init()
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 16){
                Image(viewModel.weatherType.backgroundpicture)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay{
                        VStack(alignment: .center){
                            Text("\(viewModel.currenttemp)°")
                                .font(.system(size: 64, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Text("\(viewModel.weatherType.name)")
                                .font(.system(size: 32, weight: .regular, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                HStack {
                    TempretureView(labelName: "min", temperature: viewModel.mintemp)
                    Spacer()
                    TempretureView(labelName: "Current", temperature: viewModel.currenttemp)
                    Spacer()
                    TempretureView(labelName: "max", temperature: viewModel.maxtemp)
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
            }.background(viewModel.weatherType.backgroundcolor)
                .ignoresSafeArea()
        }.onAppear(){
            self.viewModel.fetchWeather()
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
        case .none:
            return .black
        }
    }
}

#Preview {
    WeatherView(viewModel: .init())
}

