//
//  OMDBMovieListUITests.swift
//  OMDBMovieListUITests
//
//  Created by Mac on 22/07/24.
//

import XCTest

final class OMDBMovieListUITests1: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
import XCTest

class MovieTableViewTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testTableViewExists() {
        let tableView = app.tables["movieTableView"]
        XCTAssertTrue(tableView.exists, "Table view should exist")
    }
    
    func testTableViewCellDisplaysData() {
        let tableView = app.tables["movieTableView"]
        let cell = tableView.cells.element(boundBy: 0)
        
        // Wait for the cell to appear
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(cell.exists, "Cell should exist in the table view")
        
        // Verify cell content (e.g., title label)
        let titleLabel = cell.staticTexts["Inception"] // Replace with actual title
        XCTAssertTrue(titleLabel.exists, "Cell should contain title 'Inception'")
    }
    
    func testScrollingTableView() {
        let tableView = app.tables["movieTableView"]
        
        // Verify initial cells are present
        let initialCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(initialCell.exists, "Initial cell should be visible")
        
        // Scroll to the bottom
        tableView.swipeUp()
        
        // Verify that new cells appear as expected
        let newCell = tableView.cells.element(boundBy: 10) // Adjust index as needed
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: newCell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(newCell.exists, "New cell should be visible after scrolling")
    }
}
