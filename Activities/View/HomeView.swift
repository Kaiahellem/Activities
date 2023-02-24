import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            TabView {
                ActivityView()
                    .tabItem {
                        Label("New Activity", systemImage: "plus.square")
                    }
                
                PerformedView()
                    .tabItem {
                        Label("Performed Activities", systemImage: "list.bullet")
                    }
                    
            }
            .navigationBarTitle("Activity", displayMode: .inline)
        }
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
