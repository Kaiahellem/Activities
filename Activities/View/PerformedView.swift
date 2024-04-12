import SwiftUI

struct PerformedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PerformedActivity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PerformedActivity.date, ascending: false)]) var performedActivities: FetchedResults<PerformedActivity>
    
    @State private var selectedDate = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                Text("Number of activities performed: \(performedActivities.count)")
                ForEach(performedActivities, id: \.self) { performedActivity in
                    NavigationLink(destination: PerformedDetailView(performedActivity: performedActivity)) {
                        VStack(alignment: .leading) {
                            Text(performedActivity.name ?? "Unknown activity")
                                .font(.headline)
                            Text(dateFormatter.string(from: performedActivity.date ?? Date()))
                                .foregroundColor(.secondary)
                        }
                    }
                }
             }
            .navigationTitle("Performed Activities").frame( alignment: .center) 
        }
    }
}
    
    struct PerformedView_Previews: PreviewProvider {
        static var previews: some View {
            PerformedView()
        }
    }

