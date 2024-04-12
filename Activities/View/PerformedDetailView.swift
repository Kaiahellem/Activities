import SwiftUI

struct PerformedDetailView: View {
    let performedActivity: PerformedActivity
    @State private var isShowingEmoji = false
    @State private var offsetY: CGFloat = -UIScreen.main.bounds.height
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            List{
                Text(performedActivity.name ?? "Unknown activity")
                    .font(.headline)
                Text(dateFormatter.string(from: performedActivity.date ?? Date()))
                    .foregroundColor(.secondary)
                Text("$\(performedActivity.price)")
            }
        }
        .navigationTitle("Details")
        .overlay(
            ZStack {
                if performedActivity.price == 0 {
                    Text("💯")
                        .offset(x: 0, y: offsetY)
                }
                if performedActivity.price > 0 {
                    Text("☑️")
                        .offset(x: 0, y: offsetY)
                }
            }
        )
        .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation (.easeInOut(duration: 3)
                        .repeatForever(autoreverses: false)){
                        isShowingEmoji = true
                        offsetY = UIScreen.main.bounds.height //to bottom
                }
            }
        }
    }
}
