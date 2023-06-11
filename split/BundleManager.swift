//
//  FileManager.swift
//  split
//
//  Created by Konrad Heyen on 6/11/23.
//

import Foundation
import ZIPFoundation

class BundleManager {
    func downloadAndExtractPackage(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileManager = FileManager()
        
        URLSession.shared.downloadTask(with: url) { (tempURL, _, error) in
            guard let tempURL = tempURL else {
                completion(.failure(error ?? NSError(domain: "Download failed", code: 0, userInfo: nil)))
                return
            }
            
            let destinationURL = fileManager.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try fileManager.moveItem(at: tempURL, to: destinationURL)
                try self.extractZipFile(at: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func extractZipFile(at url: URL) throws {
        let fileManager = FileManager()
        let destinationURL = fileManager.temporaryDirectory
        
        try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        
        try fileManager.unzipItem(at: url, to: destinationURL)
    }
    
    func dowloadCats() {
        
        guard let url = URL(string: "https://gavinhamilton1.github.io/cats_v1.0.1.zip") else {
            print("Invalid URL")
            return
        }
        
        downloadAndExtractPackage(from: url) { result in
            switch result {
            case .success(let destinationURL):
                print("Package downloaded and extracted successfully at: \(destinationURL.path)")
                // Do further processing with the extracted package
                
            case .failure(let error):
                print("Error downloading and extracting package: \(error)")
                // Handle the error case
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
}
