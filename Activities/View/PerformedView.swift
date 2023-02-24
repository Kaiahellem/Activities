import SwiftUI

struct PerformedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PerformedActivity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PerformedActivity.date, ascending: true)]) var performedActivities: FetchedResults<PerformedActivity>
    
    var body: some View {
        NavigationView {
            List {
                Text("Number of activities performed: \(performedActivities.count)")
                ForEach(performedActivities, id: \.self) { performedActivity in
                    VStack(alignment: .leading) {
                        Text(performedActivity.name ?? "Unknown activity")
                            .font(.headline)
                        Text(dateFormatter.string(from: performedActivity.date ?? Date()))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Saved Activities")
        }
        .onAppear {
            debugPrint(performedActivities)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //formatter.timeStyle = .short
        return formatter
    }()
}

    
    
    struct PerformedView_Previews: PreviewProvider {
        static var previews: some View {
            PerformedView()
        }
    }

