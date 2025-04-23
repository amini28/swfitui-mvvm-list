//
//  ListView.swift
//  swifui-mvvm-list
//
//  Created by Amini on 22/04/25.
//
import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    List(viewModel.filteredItems) { claim in
                        NavigationLink(destination: DetailView(claim: claim)) {
                            VStack(alignment: .leading) {
                                
                                Text("#\(claim.id)")
                                
                                Text(claim.title)
                                    .font(.title3)
                                    .bold()
                                
                                Text(claim.body)
                                    .font(.body)
                                    .lineLimit(2)
                            }
                        }
                        .accessibilityIdentifier("detailView_\(claim.id)")

                    }
                }
            }
            .navigationTitle("Claims")
            .searchable(text: $viewModel.searchText)
            .task {
                if viewModel.items.isEmpty {
                    await viewModel.fetchItems()
                }
            }
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                Button("Retry") { Task { await viewModel.fetchItems() } }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Something went wrong")
            }
        }
    }
}
