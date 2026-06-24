//
//  SplashView.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 24/06/2026.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isActive = false
    @State private var startIntro = false
    @State private var continuousAnimation = false
    @State private var exitAnimation = false
    
    var body: some View {
        if isActive {
            if hasCompletedOnboarding {
                MainDashboardView()
                    .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.05, green: 0.07, blue: 0.15), Color(red: 0.2, green: 0.1, blue: 0.3)],
                    startPoint: continuousAnimation ? .topLeading : .bottomTrailing,
                    endPoint: continuousAnimation ? .bottomTrailing : .topLeading
                )
                .hueRotation(.degrees(continuousAnimation ? 45 : 0))
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 160, height: 160)
                            .blur(radius: continuousAnimation ? 30 : 10)
                            .scaleEffect(continuousAnimation ? 1.2 : 0.8)
                        
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .blur(radius: continuousAnimation ? 20 : 5)
                            .scaleEffect(continuousAnimation ? 1.5 : 0.5)
                        
                        Image(systemName: "cloud.sun.bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .symbolRenderingMode(.multicolor)
                            .shadow(color: .cyan.opacity(0.6), radius: continuousAnimation ? 25 : 10, x: 0, y: continuousAnimation ? 15 : 5)
                            .offset(y: continuousAnimation ? -15 : 15)
                    }
                    .scaleEffect(startIntro ? 1.0 : 0.3)
                    .opacity(startIntro ? 1.0 : 0.0)
                    
                    VStack(spacing: 8) {
                        Text("Zenith")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .tracking(2)
                            .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text("Your Ultimate Sky Guide")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                            .tracking(1.5)
                            .textCase(.uppercase)
                    }
                    .opacity(startIntro ? 1.0 : 0.0)
                    .offset(y: startIntro ? 0 : 30)
                }
                .scaleEffect(exitAnimation ? 1.5 : 1.0)
                .opacity(exitAnimation ? 0.0 : 1.0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.9, dampingFraction: 0.6)) {
                    startIntro = true
                }
                
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    continuousAnimation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        exitAnimation = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}
