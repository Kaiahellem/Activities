import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedActivity: Activity?
    
    let activities: [Activity]
    let selectedActivities: [Activity]
    
    @Environment(\.managedObjectContext) var viewContext
    
    init(selectedActivity: Activity?, activities: [Activity], selectedActivities: [Activity])  {
        self._selectedActivity = State(initialValue: selectedActivity)
        self.activities = activities
        self.selectedActivities = selectedActivities
    }
    
    var body: some View {
        VStack {
            Text(selectedActivity?.activity ?? "No activity selected")
            
            DatePicker("Select date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                
                Button("Save") {
                    savePerformedActivity()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5)
        .frame(height: 300)
    }
    
    func savePerformedActivity() {
        for activity in selectedActivities {
               let newPerformedActivity = PerformedActivity(context: viewContext)
               newPerformedActivity.name = activity.activity
               newPerformedActivity.date = selectedDate // Set the date for the performed activity
           }
        do {
            try viewContext.save()
            print("Activities saved to database.")
        } catch {
            print("Error saving performed activities: \(error.localizedDescription)")
        }
    }

}
