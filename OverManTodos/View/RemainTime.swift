//
//  CurrentTime.swift
//  OverManTodos
//
//  Created by 김종희 on 2023/07/10.
//

import SwiftUI
import Combine

struct RemainTime: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    
    let date = Date()
    @State var timeRemaining: Int = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds - hours*3600) / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
    
    func calcRemain() {
        let dateComponent = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hourSecond = (dateComponent.hour! * 60) * 60
        let minuteSecond = dateComponent.minute! * 60
        let secondSecond = dateComponent.second!
        let currentTotalSecond = hourSecond + minuteSecond + secondSecond
        let remainSeconds = 86400 - currentTotalSecond
        self.timeRemaining = remainSeconds
        }
    
//    func calcRemain2() {
//        let calendar = Calendar.current
//        let dateComponent = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
//        let hourSecond = (dateComponent.hour! * 60) * 60
//        let minuteSecond = dateComponent.minute! * 60
//        let secondSecond = dateComponent.second!
//        let currentTotalSecond = hourSecond + minuteSecond + secondSecond
//        let targetTime : Date = calendar.date(byAdding: .second, value: 86400 - currentTotalSecond, to: date, wrappingComponents: false) ?? Date()
//        let remainSeconds = Int(targetTime.timeIntervalSince(date))
//        self.timeRemaining = remainSeconds
//    }
    
    var body: some View {
        VStack {
            Text("남은 시간")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.pink)
                .padding(.top, 10)
            Text(convertSecondsToTime(timeInSeconds:timeRemaining))
                .font(.system(size: 50, weight: .bold, design: .rounded))
//                .foregroundColor(isDarkMode ? .white : .black)
                .foregroundColor(.pink)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            print(timeRemaining)
                            timeRemaining -= 1
                        }
                    }
                    .onAppear(){
                        calcRemain()
                    }
        }
        .padding(.horizontal, 20)
        .background(isDarkMode ? .black : .white)
        .opacity(0.7)
        .cornerRadius(10)
    }
}

struct RemainTime_Previews: PreviewProvider {
    static var previews: some View {
        RemainTime()
    }
}
