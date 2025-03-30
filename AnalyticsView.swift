import SwiftUI
import Charts

/// A simple model to hold grouped refill data.
struct RefillData: Identifiable {
    var id = UUID()
    var date: Date
    var count: Int
}

/// Extend ProgressManager to compute refill data grouped by day.
extension ProgressManager {
    var refillData: [RefillData] {
        // Group refillHistory by date (ignoring time components)
        let grouped = Dictionary(grouping: progress.refillHistory) { date -> Date in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            return Calendar.current.date(from: components)!
        }
        // Map into RefillData and sort by date
        return grouped.map { key, value in
            RefillData(date: key, count: value.count)
        }
        .sorted { $0.date < $1.date }
    }
}

struct AnalyticsView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        VStack {
            Text("Your Refill Analytics")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding()
            
            Chart {
                ForEach(progressManager.refillData) { data in
                    BarMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Refills", data.count)
                    )
                    .foregroundStyle(Color.keyColor)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month())
                }
            }
            .padding()
        }
        .navigationTitle("Analytics")
        .background(
            Image("AnalyticsBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))
        )
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView().environmentObject(ProgressManager())
    }
}


