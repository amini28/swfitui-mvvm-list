//
//  APIService.swift
//  swifui-mvvm-list
//
//  Created by Amini on 22/04/25.
//
import SwiftUI

enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let error): return "Network error: \(error.localizedDescription)"
        case .decodingFailed(let error): return "Decoding error: \(error.localizedDescription)"
        case .unknown: return "Something went wrong"
        }
    }
}

protocol APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: String, type: T.Type) async throws -> T
}

class APIService: APIServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: String, type: T.Type) async throws -> T {
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw APIError.decodingFailed(decodingError)
        } catch {
            throw APIError.requestFailed(error)
        }
    }
}
