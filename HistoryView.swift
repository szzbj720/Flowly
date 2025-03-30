import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(progressManager.progress.refillHistory, id: \.self) { date in
                    Text(date, style: .date)
                        .font(.body)
                }
            }
            .navigationTitle("Refill History")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(ProgressManager())
    }
}

