import SwiftUI

struct OnboardingStep {
    let icon: String
    let title: String
    let description: String
    let accent: Color
}

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentTab = 0

    private let steps = [
        OnboardingStep(
            icon: "cloud.sun.bolt.fill",
            title: "Real-Time Sky Guide",
            description: "Get live weather updates with pinpoint accuracy for any city around the globe.",
            accent: Color(red: 0.36, green: 0.69, blue: 1.0)
        ),
        OnboardingStep(
            icon: "calendar.badge.clock",
            title: "Advanced Forecasts",
            description: "Plan your days ahead with our detailed 3-day and hourly weather insights.",
            accent: Color(red: 0.58, green: 0.51, blue: 1.0)
        ),
        OnboardingStep(
            icon: "bookmark.fill",
            title: "Saved Locations",
            description: "Keep track of your favorite cities and monitor their weather at a glance.",
            accent: Color(red: 1.0, green: 0.72, blue: 0.35)
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.05, blue: 0.11),
                    Color(red: 0.07, green: 0.09, blue: 0.19),
                    Color(red: 0.10, green: 0.12, blue: 0.24)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(steps[currentTab].accent.opacity(0.18))
                .frame(width: 420, height: 420)
                .blur(radius: 90)
                .offset(x: 120, y: -260)
                .animation(.easeInOut(duration: 0.6), value: currentTab)

            Circle()
                .fill(steps[currentTab].accent.opacity(0.10))
                .frame(width: 360, height: 360)
                .blur(radius: 80)
                .offset(x: -140, y: 280)
                .animation(.easeInOut(duration: 0.6), value: currentTab)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            hasCompletedOnboarding = true
                        }
                    } label: {
                        Text("Skip")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.55))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.06))
                                    .overlay(
                                        Capsule()
                                            .stroke(.white.opacity(0.10), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                TabView(selection: $currentTab) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 36) {
                            ZStack {
                                Circle()
                                    .fill(steps[index].accent.opacity(0.16))
                                    .frame(width: 210, height: 210)
                                    .blur(radius: 30)

                                Circle()
                                    .stroke(steps[index].accent.opacity(0.25), lineWidth: 1)
                                    .frame(width: 168, height: 168)

                                Circle()
                                    .fill(.white.opacity(0.05))
                                    .frame(width: 148, height: 148)
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.12), lineWidth: 1)
                                    )

                                Image(systemName: steps[index].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                                    .symbolRenderingMode(.multicolor)
                                    .shadow(color: steps[index].accent.opacity(0.5), radius: 16)
                            }
                            .padding(.top, 28)

                            VStack(spacing: 14) {
                                Text(steps[index].title)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)

                                Text(steps[index].description)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.55))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 36)
                                    .lineSpacing(5)
                            }

                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Capsule()
                            .fill(currentTab == index ? steps[currentTab].accent : Color.white.opacity(0.16))
                            .frame(width: currentTab == index ? 28 : 8, height: 8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentTab)
                    }
                }
                .padding(.bottom, 36)

                Button {
                    if currentTab < steps.count - 1 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            currentTab += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            hasCompletedOnboarding = true
                        }
                    }
                } label: {
                    Text(currentTab == steps.count - 1 ? "Get Started" : "Next")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.85)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: steps[currentTab].accent.opacity(0.35), radius: 18, x: 0, y: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentTab)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
