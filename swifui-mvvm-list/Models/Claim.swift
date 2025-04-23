//
//  Claim.swift
//  swifui-mvvm-list
//
//  Created by Amini on 22/04/25.
//
import SwiftUI

public struct Claim: Identifiable, Codable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String

    public init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

