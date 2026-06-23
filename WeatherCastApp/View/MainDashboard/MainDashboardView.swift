import SwiftUI
import SwiftData

struct MainDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showSearch: Bool = false
    @State private var showSavedLocations: Bool = false
    @State private var selectedForecast: DailyForecast? = nil
    @State private var navigateToHourly: Bool = false
    
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    private var currentHour: Int {
        viewModel.cityWeather?.localHour ?? Calendar.current.component(.hour, from: Date())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background(hour: currentHour)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(AppTheme.primaryText(hour: currentHour))
                } else if let city = viewModel.cityWeather {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            topBar
                                .padding(.horizontal)
                                .padding(.top, 12)
                            
                            VStack(spacing: 6) {
                                HStack(spacing: 10) {
                                    Text(city.city)
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundStyle(AppTheme.primaryText(hour: currentHour))
                                    
                                    Button {
                                        viewModel.toggleSaveCurrentCity()
                                    } label: {
                                        Image(systemName: viewModel.isCurrentCitySaved ? "bookmark.fill" : "bookmark")
                                            .font(.system(size: 24))
                                            .foregroundStyle(AppTheme.accent(hour: currentHour))
                                    }
                                }
                                
                                Text("\(city.temperature)°")
                                    .font(.system(size: 90, weight: .thin, design: .rounded))
                                    .foregroundStyle(AppTheme.primaryText(hour: currentHour))
                                
                                Text(city.condition.label)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
                                
                                Text("H:\(city.high)°  L:\(city.low)°")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
                                
                                WeatherIcon(sfSymbol: city.condition.sfSymbol, size: 70, hour: currentHour)
                                    .padding(.top, 8)
                            }
                            
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(AppTheme.accent(hour: currentHour))
                                    Text("3-DAY FORECAST")
                                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                                        .tracking(1.2)
                                        .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
                                }
                                
                                ForEach(viewModel.dailyForecasts) { forecast in
                                    ForecastRow(forecast: forecast, hour: currentHour) {
                                        selectedForecast = forecast
                                        navigateToHourly = true
                                    }
                                    if forecast.id != viewModel.dailyForecasts.last?.id {
                                        Divider()
                                            .background(AppTheme.glassBorder(hour: currentHour))
                                    }
                                }
                            }
                            .padding(18)
                            .glassCard(hour: currentHour)
                            .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                                ForEach(viewModel.metrics) { metric in
                                    MetricCard(metric: metric, hour: currentHour)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.red)
                        Text(error)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(AppTheme.primaryText(hour: currentHour))
                        Button("Retry") {
                            Task {
                                await fetchForCurrentLocation()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToHourly) {
                if let city = viewModel.cityWeather, let selectedForecast = selectedForecast {
                    HourlyForecastView(city: city, selectedDay: selectedForecast, hourly: viewModel.hourlyForecasts, hour: currentHour)
                }
            }
            .sheet(isPresented: $showSearch) {
                LocationSearchView(hour: currentHour) { selectedCity in
                    Task {
                        await viewModel.fetchWeather(for: selectedCity)
                    }
                }
            }
            .sheet(isPresented: $showSavedLocations) {
                SavedLocationsView(
                    hour: currentHour,
                    savedLocations: viewModel.savedCities,
                    onCitySelected: { selectedCity in
                        Task {
                            await viewModel.fetchWeather(for: selectedCity)
                        }
                    },
                    onDeleteCity: {
                        cityToDelete in
                        viewModel.deleteCity(cityToDelete)
                    }
                )
            }
            .task {
                viewModel.setupContext(modelContext)
                if viewModel.cityWeather == nil {
                    locationManager.requestPermission()
                }
            }
            .onReceive(locationManager.$userLatitude.combineLatest(locationManager.$userLongitude)) { lat, lon in
                guard let lat, let lon, viewModel.cityWeather == nil, !viewModel.isLoading else { return }
                Task {
                    await viewModel.fetchWeatherForLocation(lat: lat, lon: lon)
                }
            }
            .onReceive(locationManager.$authorizationStatus) { status in
                if status == .denied || status == .restricted {
                    if viewModel.cityWeather == nil && !viewModel.isLoading {
                        Task {
                            await viewModel.fetchWeather(for: "Alexandria")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func fetchForCurrentLocation() async {
        if let lat = locationManager.userLatitude, let lon = locationManager.userLongitude {
            await viewModel.fetchWeatherForLocation(lat: lat, lon: lon)
        } else {
            await viewModel.fetchWeather(for: viewModel.cityWeather?.city ?? "Alexandria")
        }
    }
    
    private var topBar: some View {
        HStack {
            Button {
                showSavedLocations = true
            } label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText(hour: currentHour))
                    .frame(width: 40, height: 40)
                    .glassCard(hour: currentHour, cornerRadius: 12)
            }
            
            Spacer()
            
            // Current location button
            Button {
                Task {
                    locationManager.requestLocation()
                    // Small delay to let location update arrive
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    await fetchForCurrentLocation()
                }
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.accent(hour: currentHour))
                    .frame(width: 40, height: 40)
                    .glassCard(hour: currentHour, cornerRadius: 12)
            }
            
            Spacer()
            
            Button {
                showSearch = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                    Text("Search city…")
                        .font(.system(size: 14, design: .rounded))
                }
                .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .glassCard(hour: currentHour, cornerRadius: 14)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: AppTheme.isMorning(hour: currentHour) ? "sun.max.fill" : "moon.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 15))
                Text(viewModel.cityWeather?.formattedLocalTime ?? "00:00")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: currentHour))
            }
            .frame(width: 70, height: 40)
            .glassCard(hour: currentHour, cornerRadius: 12)
        }
    }
}
