import SwiftUI

struct SavedLocationsView: View {
    let hour: Int
    let savedLocations: [CityWeather]
    var onCitySelected: ((String) -> Void)?
    var onDeleteCity: ((CityWeather) -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCity: CityWeather? = nil
    @State private var showingDeleteAlert = false
    @State private var cityToDelete: CityWeather? = nil

    var body: some View {
        ZStack {
            AppTheme.background(hour: hour)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Saved Locations")
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
                .padding(.bottom, 20)

                if savedLocations.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "mappin.slash")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.tertiaryText(hour: hour))
                        Text("No saved locations")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.secondaryText(hour: hour))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(savedLocations) { city in
                                HStack(spacing: 12) {
                                    SavedLocationCard(
                                        city: city,
                                        isCurrent: selectedCity == city,
                                        hour: hour
                                    ) {
                                        selectedCity = city
                                        onCitySelected?(city.city)
                                        dismiss()
                                    }
                                    
                                    Button {
                                        cityToDelete = city
                                        showingDeleteAlert = true
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 16))
                                            .foregroundStyle(.red)
                                            .frame(width: 44, height: 44)
                                            .glassCard(hour: hour, cornerRadius: 14)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .alert("Delete Location", isPresented: $showingDeleteAlert, presenting: cityToDelete) { city in
            Button("Delete", role: .destructive) {
                onDeleteCity?(city)
            }
            Button("Cancel", role: .cancel) {}
        } message: { city in
            Text("Are you sure you want to remove \(city.city) from your saved locations?")
        }
    }
}
