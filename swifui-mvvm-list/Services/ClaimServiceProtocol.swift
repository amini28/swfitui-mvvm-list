//
//  ClaimServiceProtocol.swift
//  swifui-mvvm-list
//
//  Created by Amini on 23/04/25.
//
import Foundation
import SwiftUI

public protocol ClaimServiceProtocol {
    func fetchItems() async throws -> [Claim]
}
