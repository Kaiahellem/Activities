import SwiftUI
import CoreData

struct ActivityData: Codable {
    let activity: String
    let participants: Int
    let price: Float
    let type: String
    let key: String
    let accessibility: Float
    
}

struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: []) var activities: FetchedResults<Activity>
    
    @State private var isLoading = false
    @State private var activity: Activity?
    @State private var isRegistering: Activity?
    @State private var selectedActivities: [Activity] = []
    @State private var numberOfParticipants: Int?
    @State private var isNumberOfParticipantsValid = true
    @State private var numberOfParticipantsString = ""
    
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
                    Text("Accessibility: \(activity.accessibility, specifier: "%.2f")")
                    Text("Type: \(activity.type ?? "Unknown")")
                    Text("Key: \(activity.key ?? "Unknown")")
                   
                    Spacer(minLength: 100)
                    
                    VStack {
                        Button("Find new activity") {
                            fetchActivity(numberOfParticipants: numberOfParticipants)
                        }
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(9)
                        
                        
                        TextField("Number of participants", text: $numberOfParticipantsString)
                            .frame(width: 200, height: 50)
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.blue)
                            .border(isNumberOfParticipantsValid || numberOfParticipantsString.isEmpty ? Color.blue : Color.red)
                            .cornerRadius(9)
                            .onChange(of: numberOfParticipantsString) { newValue in
                                if newValue.isEmpty {
                                      // Reset error state if field is empty
                                      isNumberOfParticipantsValid = true
                                      numberOfParticipants = nil
                                  } else if let participants = Int(newValue) {
                                      if participants <= 0 || participants > 100 {
                                          isNumberOfParticipantsValid = false
                                      } else {
                                          isNumberOfParticipantsValid = true
                                          numberOfParticipants = participants
                                      }
                                  } else {
                                      numberOfParticipants = nil
                                  }
                              }
                        
                        
                        if !isNumberOfParticipantsValid {
                            Text("Invalid number of participants. Please enter a number between 1 and 100.")
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        Button("Register as performed") {
                            selectedActivities.append(activity)
                            isRegistering = activity //Sets the selected activityy
                        }
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(9)
                    }
                    .padding(.bottom)
                }
            } else {
                Button("Show activity") {
                    fetchActivity()
                }
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(9)
            }
        }
        .padding()
        .sheet(item: $isRegistering) { selectedActivity in
            RegisterView(selectedActivity: selectedActivity, activities: activities.map { $0 }, selectedActivities: selectedActivities)
        }
    }
    
    func fetchActivity(numberOfParticipants: Int? = nil) {
        isLoading = true
        
        // Set up URL and request
        var components = URLComponents(string: "https://www.boredapi.com/api/activity")!
        components.queryItems = numberOfParticipants != nil ? [URLQueryItem(name: "participants", value: String(numberOfParticipants!))] : nil

        print(components)
        
        let url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Request
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
                newActivity.type = activityData.type
                newActivity.key = activityData.key
                newActivity.accessibility = activityData.accessibility
                
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

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
