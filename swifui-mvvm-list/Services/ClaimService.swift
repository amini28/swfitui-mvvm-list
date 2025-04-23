//
//  ClaimService.swift
//  swifui-mvvm-list
//
//  Created by Amini on 22/04/25.
//
import SwiftUI

class ClaimService: ClaimServiceProtocol {

    private let apiService: APIService

    init(session: URLSession = .shared) {
        self.apiService = APIService(session: session)
    }
    
    func fetchItems() async throws -> [Claim] {
        return try await apiService.request("https://jsonplaceholder.typicode.com/posts", type: [Claim].self)
    }
}
