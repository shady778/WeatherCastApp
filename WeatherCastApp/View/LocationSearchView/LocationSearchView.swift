import SwiftUI

struct LocationSearchView: View {
    let hour: Int

    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""
    
    private let allCities: [CityWeather] = MockWeather.allCities

    private var filteredCities: [CityWeather] {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
            return allCities
        }
        return allCities.filter { $0.city.lowercased().contains(query.lowercased()) }
    }

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

                    TextField("Search city…", text: $query)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                        .tint(AppTheme.accent(hour: hour))

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
                    LazyVStack(spacing: 10) {
                        if filteredCities.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 44))
                                    .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                                Text("No cities found")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundStyle(AppTheme.secondaryText(hour: hour))
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(filteredCities) { city in
                                cityRow(city)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private func cityRow(_ city: CityWeather) -> some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 14) {
                WeatherIcon(sfSymbol: city.condition.sfSymbol, size: 28, hour: hour)

                VStack(alignment: .leading, spacing: 3) {
                    Text(city.city)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText(hour: hour))
                    Text(city.condition.label)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(AppTheme.secondaryText(hour: hour))
                }

                Spacer()

                Text("\(city.temperature)°")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: hour))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .glassCard(hour: hour, cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Search — Morning") {
    LocationSearchView(hour: 10)
}

#Preview("Search — Night") {
    LocationSearchView(hour: 21)
}
