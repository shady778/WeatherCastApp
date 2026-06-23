import SwiftUI

struct LocationSearchView: View {
    let hour: Int
    var onCitySelected: ((String) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @StateObject private var searchVM = SearchViewModel()

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
                
                // MARK: - Search Bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText(hour: hour))

                    TextField("Enter city name…", text: $searchVM.searchText)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                        .tint(AppTheme.accent(hour: hour))
                        .onSubmit {
                            submitSearch()
                        }

                    if searchVM.isSearching {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(AppTheme.accent(hour: hour))
                    }

                    if !searchVM.searchText.isEmpty {
                        Button {
                            searchVM.clearSearch()
                        } label: {
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

                // MARK: - Results
                ScrollView {
                    VStack(spacing: 10) {
                        if !searchVM.suggestions.isEmpty {
                            ForEach(searchVM.suggestions) { result in
                                Button {
                                    onCitySelected?(result.name)
                                    dismiss()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundStyle(AppTheme.accent(hour: hour))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(result.name)
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundStyle(AppTheme.primaryText(hour: hour))
                                            
                                            Text("\(result.region), \(result.country)")
                                                .font(.system(size: 13, design: .rounded))
                                                .foregroundStyle(AppTheme.secondaryText(hour: hour))
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(AppTheme.secondaryText(hour: hour))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .glassCard(hour: hour, cornerRadius: 16)
                                }
                                .buttonStyle(.plain)
                            }
                        } else if !searchVM.searchText.trimmingCharacters(in: .whitespaces).isEmpty && !searchVM.isSearching {
                            // User typed something, debounce finished, no results
                            if searchVM.searchText.count >= 2 {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 40))
                                        .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                                    Text("No cities found for \"\(searchVM.searchText)\"")
                                        .font(.system(size: 15, design: .rounded))
                                        .foregroundStyle(AppTheme.secondaryText(hour: hour))
                                }
                                .padding(.top, 40)
                            }
                        } else if searchVM.searchText.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                                Text("Type a city name to search")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(AppTheme.secondaryText(hour: hour))
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }

    private func submitSearch() {
        let cleanedQuery = searchVM.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanedQuery.isEmpty {
            onCitySelected?(cleanedQuery)
            dismiss()
        }
    }
}
