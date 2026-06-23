import SwiftUI

struct MainDashboardView: View {
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())
    @State private var showSearch: Bool = false
    @State private var showSavedLocations: Bool = false
    @State private var selectedForecast: DailyForecast? = nil
    @State private var navigateToHourly: Bool = false
    
    @State private var cityWeather: CityWeather? = nil
    @State private var dailyForecasts: [DailyForecast] = []
    @State private var hourlyForecasts: [HourlyWeather] = []
    @State private var metrics: [WeatherMetric] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @State private var savedCities: [CityWeather] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background(hour: currentHour)
                    .ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(AppTheme.primaryText(hour: currentHour))
                } else if let city = cityWeather {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            topBar
                                .padding(.horizontal)
                                .padding(.top, 12)
                            
                            VStack(spacing: 6) {
                                Text(city.city)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppTheme.primaryText(hour: currentHour))
                                
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
                                
                                ForEach(dailyForecasts) { forecast in
                                    ForecastRow(forecast: forecast, hour: currentHour) {
                                        selectedForecast = forecast
                                        navigateToHourly = true
                                    }
                                    if forecast.id != dailyForecasts.last?.id {
                                        Divider()
                                            .background(AppTheme.glassBorder(hour: currentHour))
                                    }
                                }
                            }
                            .padding(18)
                            .glassCard(hour: currentHour)
                            .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                                ForEach(metrics) { metric in
                                    MetricCard(metric: metric, hour: currentHour)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else if let error = errorMessage {
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
                                await testDirectAPICall(cityName: cityWeather?.city ?? "Alexandria")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToHourly) {
                if let city = cityWeather, let selectedForecast = selectedForecast {
                    HourlyForecastView(city: city, selectedDay: selectedForecast, hourly: hourlyForecasts, hour: currentHour)
                }
            }
            .sheet(isPresented: $showSearch) {
                LocationSearchView(hour: currentHour) { selectedCity in
                    Task {
                        await testDirectAPICall(cityName: selectedCity)
                    }
                }
            }
            .sheet(isPresented: $showSavedLocations) {
                SavedLocationsView(hour: currentHour, savedLocations: savedCities) { selectedCity in
                    Task {
                        await testDirectAPICall(cityName: selectedCity)
                    }
                }
            }
            .task {
                await testDirectAPICall()
            }
        }
    }
    
    private func testDirectAPICall(cityName: String = "Alexandria") async {
        isLoading = true
        errorMessage = nil
        
        let service = WeatherService()
        do {
            let result = try await service.fetchWeather(for: cityName)
            self.cityWeather = result.cityWeather
            self.dailyForecasts = result.dailyForecast
            self.hourlyForecasts = result.hourlyForecast
            self.metrics = result.metrics
            
                    let freshCity = result.cityWeather
            if !savedCities.contains(where: { $0.city.lowercased() == freshCity.city.lowercased() }) {
                savedCities.append(freshCity)
            }
            
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
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
                Text(String(format: "%02d:00", currentHour))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(AppTheme.primaryText(hour: currentHour))
            }
            .frame(width: 70, height: 40)
            .glassCard(hour: currentHour, cornerRadius: 12)
        }
    }
}
