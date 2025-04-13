//
//  DailyWeatherRow.swift
//  WeatherApp
//
//  Created by Nermeen Tomoum on 12/04/2025.
//
import SwiftUI

struct DailyWeatherRow : View {
 var dailyWeatherModel: DailyWeatherModel
    
    var body: some View {
        HStack {
            Text("\(dailyWeatherModel.name)")
                .foregroundColor(.white)
            Spacer()
            Image(dailyWeatherModel.weathertype.iconName)
                .resizable()
                .frame(width: 30, height: 30)
            Spacer()
            Text("\(dailyWeatherModel.temperature)°")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    DailyWeatherRow(dailyWeatherModel: DailyWeatherModel(name: "wednesday", temperature: 20, weathertype: .cloudy)).background(Color.gray)
}

