//
//  ContentView.swift
//  split
//
//  Created by Konrad Heyen on 6/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var launcher: Launcher?
    let BM = BundleManager()

    var body: some View {
        NavigationView {
            VStack {
                
                Button("Build Launcher") {
                    BM.buildLauncher { result in
                        switch result {
                        case .success(let launcher):
                            // Use the launcher object to build your launcher UI
                            self.launcher = launcher
                            print(launcher.menu)
                            print(launcher.apps)
                            
                        case .failure(let error):
                            // Handle the error case
                            print("Error building launcher: \(error)")
                        }
                    }
                }
                
                Button("Download All") {
                    Task {
                        await BM.downloadBundles(apps: launcher!.apps)
                    }
                }
                
                
                if let appList = self.launcher {
                    List {
                        ForEach(appList.menu, id: \.title) { menuItem in
                            NavigationLink(destination: WebView(app: appList.apps.first(where: {$0.id == menuItem.target})!), label: { Text(menuItem.title) })
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
