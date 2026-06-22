import SwiftUI
 
struct MainDashboardView: View {
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())
   @State private var showSearch: Bool = false
    @State private var showSavedLocations: Bool = false
    @State private var selectedForecast: DailyForecast? = nil
    @State private var navigateToHourly: Bool = false
 
    private let city = MockWeather.cairo
    private let forecasts = MockWeather.threeDayForecast
    private let hourly = MockWeather.todayHourly
    private let metrics = MockWeather.metrics
 
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background(hour: currentHour)
                    .ignoresSafeArea()
 
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
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
 
                            Text("H:\(city.high)°   L:\(city.low)°")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(AppTheme.tertiaryText(hour: currentHour))
 
                            WeatherIcon(sfSymbol: city.condition.sfSymbol, size: 64, hour: currentHour)
                                .padding(.top, 8)
                        }
                        .padding(.top, 10)
 
                        VStack(alignment: .leading, spacing: 16) {
                            Text("3-DAY FORECAST")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .tracking(1.5)
                                .foregroundStyle(AppTheme.secondaryText(hour: currentHour))
 
                            VStack(spacing: 12) {
                                ForEach(Array(forecasts.enumerated()), id: \.element.id) { idx, forecast in
                                    ForecastRow(forecast: forecast, hour: currentHour) {
                                        selectedForecast = forecast
                                        navigateToHourly = true
                                    }
 
                                    if idx < forecasts.count - 1 {
                                        Divider().overlay(AppTheme.glassBorder(hour: currentHour))
                                    }
                                }
                            }
                        }
                        .padding(18)
                        .glassCard(hour: currentHour)
                        .padding(.horizontal)
 
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(metrics) { metric in
                                MetricCard(metric: metric, hour: currentHour)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToHourly) {
                if let forecast = selectedForecast {
                    HourlyForecastView(
                        city: city,
                        selectedDay: forecast,
                        hourly: hourly,
                        hour: currentHour
                    )
                }
            }
            .sheet(isPresented: $showSearch) {
                LocationSearchView(hour: currentHour)
            }
            .sheet(isPresented: $showSavedLocations) {
                SavedLocationsView(hour: currentHour)
            }
        }
    }
 
    private var topBar: some View {
        HStack {
            Button {
                showSavedLocations = true
            } label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 18, weight: .medium))
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
 
extension MainDashboardView {
    init(currentHour: Int) {
        _currentHour = State(initialValue: currentHour)
    }
}
 
#Preview("Morning") {
    MainDashboardView(currentHour: 12)
}
 
#Preview("Night") {
    MainDashboardView(currentHour: 21)
}
