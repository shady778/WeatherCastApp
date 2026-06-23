import SwiftUI

struct LocationSearchView: View {
    let hour: Int
    var onCitySelected: ((String) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""

    var body: some View {
        ZStack {
            AppTheme.background(hour: hour)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Search City")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText(hour: hour))

                    TextField("Enter city name…", text: $query)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                        .tint(AppTheme.accent(hour: hour))
                        .onSubmit {
                            submitSearch()
                        }

                    if !query.isEmpty {
                        Button { query = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 15))
                                .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .glassCard(hour: hour, cornerRadius: 14)
                .padding(.horizontal, 20)

                ScrollView {
                    VStack(spacing: 16) {
                        if !query.trimmingCharacters(in: .whitespaces).isEmpty {
                            Button {
                                submitSearch()
                            } label: {
                                HStack {
                                    Image(systemName: "cloud.sun.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(AppTheme.accent(hour: hour))
                                    
                                    Text("Get weather for \"\(query)\"")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(AppTheme.secondaryText(hour: hour))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .glassCard(hour: hour, cornerRadius: 16)
                            }
                            .buttonStyle(.plain)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                                Text("Type a city name above to search")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(AppTheme.secondaryText(hour: hour))
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
        }
    }

    private func submitSearch() {
        let cleanedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanedQuery.isEmpty {
            onCitySelected?(cleanedQuery)
            dismiss()
        }
    }
}
