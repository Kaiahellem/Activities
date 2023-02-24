import CoreData
import Foundation

class DataModel: ObservableObject{
    let container = NSPersistentContainer(name: "Activities")
    
    init() {
        container.loadPersistentStores {
            description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
