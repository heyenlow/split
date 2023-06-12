//
//  WebView.swift
//  split
//
//  Created by Konrad Heyen on 6/8/23.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let app: AppItem
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let BM = BundleManager()
        if app.type == "static" {
            let bundleURL = BM.getBundlePath(app: app)
            webView.loadFileURL(bundleURL, allowingReadAccessTo: bundleURL)
            let request = URLRequest(url: bundleURL)
            webView.load(request)
        } else {
            let removedHTTPS = app.bundle.dropFirst(8)
            if let url = URL(string: String(removedHTTPS)) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
}
