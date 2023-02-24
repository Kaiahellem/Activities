import SwiftUI
import CoreData

struct ActivityData: Codable {
    let activity: String
    let participants: Int
    let price: Float
}

struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: []) var activities: FetchedResults<Activity>
    
    @State private var isLoading = false
    @State private var activity: Activity?
    @State private var isRegistering: Activity?
    @State private var selectedActivities: [Activity] = []
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Finding new activity...")
            } else if let activity = activity {
                VStack {
                    Text(activity.activity ?? "Unknown")
                        .font(.title)
                        .padding()
                    Text("Participants: \(activity.participants)")
                    Text("Price: \(activity.price, specifier: "%.2f")")
                    Spacer()
                    HStack {
                        Button("Find new activity") {
                            fetchActivity()
                        }
                        Button("Register as performed") {
                                            selectedActivities.append(activity)
                                            isRegistering = activity // Set the selected activity
                        }
                    }
                    .padding(.bottom)
                }
            } else {
                Button("Show activity") {
                    fetchActivity()
                }
            }
        }
        .padding()
        .sheet(item: $isRegistering) { selectedActivity in
                    RegisterView(selectedActivity: selectedActivity, activities: activities.map { $0 }, selectedActivities: selectedActivities)
        }
    }
    
    func fetchActivity() {
        isLoading = true
        
        // Set up URL and request
        let url = URL(string: "https://www.boredapi.com/api/activity")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: No data returned from API.")
                return
            }
            
            do {
                // Decode the JSON data
                let decoder = JSONDecoder()
                let activityData = try decoder.decode(ActivityData.self, from: data)
                
                // Create and save the Activity object in Core Data
                let newActivity = Activity(context: viewContext)
                newActivity.activity = activityData.activity
                newActivity.participants = Int16(activityData.participants)
                newActivity.price = activityData.price
                
                do {
                    try viewContext.save()
                    activity = newActivity
                } catch {
                    print("Error saving activity to Core Data: \(error.localizedDescription)")
                }
                
            } catch {
                print("Error decoding activity data: \(error.localizedDescription)")
            }
            
            isLoading = false
        }.resume()
    }
}

/*struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} */
