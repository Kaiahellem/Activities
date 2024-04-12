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
                .font(.title)
         
            DatePicker("Select date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.wheel)
            
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
    }
    
    func savePerformedActivity() {
        guard let selectedActivity = selectedActivity else {
            return
        }
        
        let newPerformedActivity = PerformedActivity(context: viewContext)
        newPerformedActivity.name = selectedActivity.activity
        newPerformedActivity.date = selectedDate
        newPerformedActivity.price = selectedActivity.price
        
        do {
            try viewContext.save()
            print("Activity saved to database.")
        } catch {
            print("Error saving performed activity: \(error.localizedDescription)")
        }
    }
}
