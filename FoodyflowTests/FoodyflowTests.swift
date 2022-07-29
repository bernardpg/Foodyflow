//
//  FoodyflowTests.swift
//  FoodyflowTests
//
//  Created by 曹珮綺 on 7/20/22.
//

import XCTest
@testable import Foodyflow

class FoodyflowTests: XCTestCase {
    
    var sut: WishListViewController!

    override func setUpWithError() throws {
    try super.setUpWithError()
    sut = WishListViewController()
      
    }

    override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete.
        // Check the results with assertions afterwards.
    }

   /* func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
    func testfoodCateAssociate() {
        
        // given
        // 傳啥都沒差 stub 拉屎
        // mock 假資料會影響結果
        let mockFood = FoodInfo(foodId: "", foodImages: "", foodCategory: "水果類", foodName: "banana",
                                foodWeightAmount: 1.0, foodWeightType: 3,
                                foodStatus: 1, expireDate: 123123, purchaseDate: 123123,
                                foodBrand: "", priceTracker: true,
                                additional: "", createdTime: 123123,
                                foodPurchasePlace: "")
        var mockFoods = sut.foodsInfo
        mockFoods.append(mockFood)

        // when
        sut.cateFilter(allFood: mockFoods, cates: sut.cate)

        // then
        XCTAssertEqual(sut.fruitsInfo.count, 1)

    }
    
    func apiTest(){
        
    }
    
    func testRetainCycle() {
        let viewController = RefrigeAllFoodViewController()
        
        assertNoMemoryLeak(viewController)
    }
    
    private func assertNoMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "⚠️potential RetainCycle ", file: file, line: line)
        }
    }
}
