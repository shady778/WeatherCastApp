//
//  OnboardingView.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 24/06/2026.
//

import SwiftUI

struct OnboardingStep {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentTab = 0
    
    private let steps = [
        OnboardingStep(
            icon: "cloud.sun.bolt.fill",
            title: "Real-Time Sky Guide",
            description: "Get live weather updates with pinpoint accuracy for any city around the globe."
        ),
        OnboardingStep(
            icon: "calendar.badge.clock",
            title: "Advanced Forecasts",
            description: "Plan your days ahead with our detailed 3-day and hourly weather insights."
        ),
        OnboardingStep(
            icon: "bookmark.fill",
            title: "Saved Locations",
            description: "Keep track of your favorite cities and monitor their weather at a glance."
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.07, blue: 0.15), Color(red: 0.15, green: 0.18, blue: 0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasCompletedOnboarding = true
                        }
                    } label: {
                        Text("Skip")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .glassCard(hour: 20, cornerRadius: 12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                TabView(selection: $currentTab) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            ZStack {
                                Circle()
                                    .fill(Color.cyan.opacity(0.15))
                                    .frame(width: 200, height: 200)
                                    .blur(radius: 25)
                                
                                Image(systemName: steps[index].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .symbolRenderingMode(.multicolor)
                                    .shadow(color: .cyan.opacity(0.4), radius: 20)
                            }
                            
                            VStack(spacing: 12) {
                                Text(steps[index].title)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(steps[index].description)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                                    .lineSpacing(4)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Capsule()
                            .fill(currentTab == index ? Color.cyan : Color.white.opacity(0.2))
                            .frame(width: currentTab == index ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentTab)
                    }
                }
                .padding(.bottom, 32)
                
                Button {
                    if currentTab < steps.count - 1 {
                        withAnimation(.spring()) {
                            currentTab += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasCompletedOnboarding = true
                        }
                    }
                } label: {
                    Text(currentTab == steps.count - 1 ? "Get Started" : "Next")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.cyan, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}
