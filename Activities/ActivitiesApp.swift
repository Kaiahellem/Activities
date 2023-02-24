
import SwiftUI

@main
struct ActivitiesApp: App {
    @StateObject private var dataModel = DataModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataModel.container.viewContext)
        }
    }
}
