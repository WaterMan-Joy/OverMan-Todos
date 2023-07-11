//
//  OverManTodosWidget.swift
//  OverManTodosWidget
//
//  Created by 김종희 on 2023/07/11.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct OverManTodosWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    var fontStyle: Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote, design: .rounded)
        }
        else {
            return .system(.headline, design: .rounded)
        }
    }

    var body: some View {
//        Text(entry.date, style: .time)
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                Image("logo")
                    .resizable()
                    .frame(width: widgetFamily != .systemSmall ? 65 : 36, height: widgetFamily != .systemSmall ? 65 : 36)
                    .cornerRadius(10)
                    .offset(x: (geometry.size.width / 2) - 20, y: (geometry.size.height / -2) + 20)
                    .padding(.top, widgetFamily != .systemSmall ? 40 : 12)
                    .padding(.trailing, widgetFamily != .systemSmall ? 40 : 12)
                
                HStack {
                    Text("Just Do It")
                        .foregroundColor(.pink)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.white)
                        .cornerRadius(5)
                    if widgetFamily != .systemSmall {
                    Spacer()
                    Text(entry.date, style: .time)
                            .foregroundColor(.pink)
                            .font(fontStyle)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(.white)
                            .cornerRadius(5)
                    }
                }
                .padding()
                .offset(y: (geometry.size.height / 2) - 30)
            }
        }
    }
}


struct OverManTodosWidget: Widget {
    let kind: String = "OverManTodosWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OverManTodosWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Over Tasks")
        .description("This is an Over Tasks App.")
    }
}

struct OverManTodosWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OverManTodosWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            OverManTodosWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            OverManTodosWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
        }
    }
}
