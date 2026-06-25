//
//  GIFBackgroundView.swift
//  WeatherCastApp
//
//  Plays an animated GIF from the app bundle as a looping
//  full-screen background. Uses WKWebView since SwiftUI has
//  no native GIF support — no third-party library required.
//
//  Usage:
//    GIFBackgroundView(gifName: "morning_sky")
//        .ignoresSafeArea()
//
//  Setup:
//    1. Add morning_sky.gif and evening_sky.gif to the project
//       (drag into the project navigator, NOT into Assets.xcassets)
//    2. Check "Copy items if needed" and confirm your app target
//       is checked under Target Membership
//

import SwiftUI
import WebKit

struct GIFBackgroundView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .clear

        loadGIF(into: webView)
        context.coordinator.lastLoadedGIFName = gifName

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // FIX: SwiftUI calls updateUIView on every re-render of the
        // parent view (any @Published change ticking, navigation,
        // sheet presentation, etc). Reloading the HTML every single
        // time restarts the GIF mid-frame and can briefly leave
        // WKWebView showing a blank/white page during the reload.
        // Only reload when the GIF name has actually changed
        // (morning -> evening).
        guard context.coordinator.lastLoadedGIFName != gifName else { return }

        loadGIF(into: webView)
        context.coordinator.lastLoadedGIFName = gifName
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var lastLoadedGIFName: String?
    }

    private func loadGIF(into webView: WKWebView) {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }

        let base64 = data.base64EncodedString()
        let html = """
        <html>
        <head>
            <style>
                html, body {
                    margin: 0;
                    padding: 0;
                    background: transparent;
                    overflow: hidden;
                    height: 100%;
                }
                img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }
            </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(base64)" />
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}


struct DynamicSkyBackground: View {
    let hour: Int

    var body: some View {
        GIFBackgroundView(gifName: AppTheme.isMorning(hour: hour) ? "morning_sky" : "evening_sky")
            .ignoresSafeArea()
    }
}

#Preview("Morning GIF") {
    DynamicSkyBackground(hour: 12)
}

#Preview("Evening GIF") {
    DynamicSkyBackground(hour: 21)
}
