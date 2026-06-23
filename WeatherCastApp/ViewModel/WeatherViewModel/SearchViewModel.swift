//
//  SearchViewModel.swift
//  WeatherCastApp
//
//  Created by shady ramadan on 23/06/2026.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var suggestions: [SearchResult] = []
    @Published var isSearching: Bool = false
    
    private let repository: WeatherRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    
    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
        setupDebounce()
    }
    
    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                self.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        searchTask?.cancel()
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmed.count >= 2 else {
            suggestions = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        searchTask = Task {
            do {
                let results = try await repository.searchCities(query: trimmed)
                if !Task.isCancelled {
                    self.suggestions = results
                }
            } catch {
                if !Task.isCancelled {
                    self.suggestions = []
                }
            }
            if !Task.isCancelled {
                self.isSearching = false
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        suggestions = []
        searchTask?.cancel()
    }
}
