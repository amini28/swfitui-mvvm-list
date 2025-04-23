//
//  swifui_mvvm_listTests.swift
//  swifui-mvvm-listTests
//
//  Created by Amini on 22/04/25.
//

import XCTest
@testable import swifui_mvvm_list

final class swifui_mvvm_listTests: XCTestCase {
    
    class MockClaimService: ClaimServiceProtocol {
        var mockData: [Claim] = [
            Claim(userId: 1, id: 1, title: "Mock Title", body: "Mock body detail")
        ]
        
        var shouldFail = false

        func fetchItems() async throws -> [Claim] {
            if shouldFail {
                throw APIError.requestFailed(NSError(domain: "Test", code: -1))
            }
            return mockData
        }
    }
    
    func testFetchItemsSuccess() async {
        let mockClaims = [
            Claim(userId: 1, id: 1, title: "Mock Title 1", body: "Mock Body 1"),
            Claim(userId: 2, id: 2, title: "Mock Title 2", body: "Mock Body 2")
        ]
        let mockService = MockClaimService()
        mockService.mockData = mockClaims
        let viewModel = ListViewModel(service: mockService)

        await viewModel.fetchItems()

        XCTAssertEqual(viewModel.items.count, 2)
        XCTAssertEqual(viewModel.filteredItems.count, 2)
        XCTAssertFalse(viewModel.showErrorAlert)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchItemsFailure() async {
        let mockService = MockClaimService()
        mockService.shouldFail = true
        let viewModel = ListViewModel(service: mockService)

        await viewModel.fetchItems()

        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.items.isEmpty)
    }

    func testFiltering() async {
        
        let mockClaims = [
            Claim(userId: 1, id: 1, title: "Apple", body: "Fruit"),
            Claim(userId: 2, id: 2, title: "Banana", body: "Yellow fruit"),
            Claim(userId: 3, id: 3, title: "Carrot", body: "Vegetable")
        ]
        let mockService = MockClaimService()
        mockService.mockData = mockClaims
        let viewModel = ListViewModel(service: mockService)

        await viewModel.fetchItems()

        viewModel.searchText = "fruit"
        XCTAssertEqual(viewModel.filteredItems.count, 2)

        viewModel.searchText = "Banana"
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems.first?.title, "Banana")

        viewModel.searchText = "xyz"
        XCTAssertTrue(viewModel.filteredItems.isEmpty)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
            
}
