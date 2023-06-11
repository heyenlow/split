//
//  ContentView.swift
//  split
//
//  Created by Konrad Heyen on 6/8/23.
//

import SwiftUI

struct ContentView: View {
    let BM = BundleManager()
    var body: some View {
        NavigationView {
            VStack {
                Button("Download Cats") {
                    BM.dowloadCats()
                }
                
                Button("Build Launcher") {
                    BM.buildLauncher { result in
                        switch result {
                        case .success(let launcher):
                            // Use the launcher object to build your launcher UI
                            print(launcher.menu)
                            print(launcher.apps)
                            
                        case .failure(let error):
                            // Handle the error case
                            print("Error building launcher: \(error)")
                        }
                    }
                }
                
                List {
                    NavigationLink(destination: WebView(url: URL(string: "http://192.168.0.216:3000")!), label: { Text("Click Me")})
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
