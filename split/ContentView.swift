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
                    Task {
                        do {
                            self.launcher = try await BM.buildLauncher()
                        } catch {
                            print("Failed to get launcher")
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
