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
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let bundleURL = Bundle.main.url(forResource: "index", withExtension: ".html", subdirectory: "build") {
            webView.loadFileURL(bundleURL, allowingReadAccessTo: bundleURL)
            
            let request = URLRequest(url: bundleURL)
            webView.load(request)

        } else {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}