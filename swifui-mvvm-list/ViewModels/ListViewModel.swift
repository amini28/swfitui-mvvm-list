//
//  ListViewModel.swift
//  swifui-mvvm-list
//
//  Created by Amini on 22/04/25.
//

import Foundation

public class ListViewModel: ObservableObject {
    @Published var items: [Claim] = []
    @Published var filteredItems: [Claim] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    
    @Published var searchText: String = "" {
        didSet { applyFilter() }
    }

    var service: ClaimServiceProtocol

    init(service: ClaimServiceProtocol = ClaimService()) {
        self.service = service
    }

    @MainActor
    func fetchItems() async {
        isLoading = true
        errorMessage = nil
        showErrorAlert = false

        do {
            items = try await service.fetchItems()
            applyFilter()
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? "Unexpected error"
            showErrorAlert = true
        }

        isLoading = false
    }

    private func applyFilter() {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.body.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
