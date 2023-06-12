//
//  FileManager.swift
//  split
//
//  Created by Konrad Heyen on 6/11/23.
//

import Foundation
import ZIPFoundation

class BundleManager {
    
    func downloadAndExtractPackage(from url: URL, to destinationURL: URL) async throws -> URL {
        let fileManager = FileManager.default
        
        let (tempURL, _) = try await URLSession.shared.download(from: url)
        
        try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        
        // Remove existing files in the destination folder
        let fileURLs = try fileManager.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        for fileURL in fileURLs {
            try fileManager.removeItem(at: fileURL)
        }
        
        try fileManager.unzipItem(at: tempURL, to: destinationURL)
        
        return destinationURL
    }
    
    private func extractZipFile(at url: URL, to destinationURL: URL) throws {
        let fileManager = FileManager.default
        
        try fileManager.unzipItem(at: url, to: destinationURL)
    }
    
    private func downloadBundle(app: AppItem) async throws -> URL {
        let defaultURL = "https://gavinhamilton1.github.io/"
        let path = defaultURL + app.bundle
        
        guard let url = URL(string: path) else {
            print("Invalid URL")
            throw NSError(domain: "Failed to build URL", code: 0)
        }
        
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("bundles").appendingPathComponent(app.id)
        
        do {
            let result = try await downloadAndExtractPackage(from: url, to: destinationURL)
            
            print("Package downloaded and extracted successfully at: \(destinationURL.path)")

            return result
        } catch {
            print("Error downloading and extracting package: \(error)")

            throw NSError(domain: "Failed to build URL", code: 0)
        }
    }
    
    func downloadBundles(apps: [AppItem]) async {
        for app in apps {
            do {
                let url = try await downloadBundle(app: app)
                print("\(app.id) at \(url)")
            } catch {
                print(":::::::::::::::Failed to Download \(app.bundle)")
            }
        }
    }
    
    func buildLauncher(completion: @escaping (Result<Launcher, Error>) -> Void) {
        guard let url = URL(string: "https://gavinhamilton1.github.io/appdefs.json") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let launcherData = try decoder.decode(AppDefs.self, from: data)
                completion(.success(launcherData.launcher))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getBundlePath(app: AppItem) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!.appendingPathComponent("bundles")
            .appendingPathComponent(app.id)
            .appendingPathComponent("index.html", conformingTo: .html)
    }
}
