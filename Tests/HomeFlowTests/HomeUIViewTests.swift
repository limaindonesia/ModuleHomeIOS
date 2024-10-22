//
//  HomeUIViewTests.swift
//
//
//  Created by Ilham Prabawa on 20/07/24.
//

/*import XCTest
@testable import HomeFlow
import AprodhitKit
import Alamofire
import GnDKit
import SwiftUI
import ViewInspector

final class HomeUIViewTests: XCTestCase {

  func test_viewAppear_andShouldHaveLoginText() async {
    //given
    let homeStore = await HomeStore(repository: MockHomeRepository(),
                                    onlineAdvocateNavigator: MockNavigator())

    //when
    let homeView = HomeUIView(store: homeStore)
    let textView = await homeView.getLoginViewWithText()

    //then
    XCTAssertNotNil(textView)

  }

  func test_viewAppear_andShouldHaveListOfOnlineAdvocates() async {
    //given
    let homeStore = await HomeStore(repository: MockHomeRepository(),
                                    onlineAdvocateNavigator: MockNavigator())

    //when
    let homeView = HomeUIView(store: homeStore)
    await homeStore.fetchOnlineAdvocates()

    let textView = await homeView.getListOnlinedAdvocates()
    let button = await homeView.getSeeAllButton()

    //then
    XCTAssertNotNil(textView)
    XCTAssertNotNil(button)

  }

  func test_viewAppear_shouldHaveGridCategory() async {
    //given
    let homeStore = await HomeStore(repository: MockHomeRepository(),
                                    onlineAdvocateNavigator: MockNavigator())

    //when
    let homeView = HomeUIView(store: homeStore)

    let gridView = await homeView.getGridCategory()

    //then
    XCTAssertNotNil(gridView)
  }

  func test_viewAppear_shouldHaveSearchAdvocate_textField() async {
    //given
    let homeStore = await HomeStore(repository: MockHomeRepository(),
                                    onlineAdvocateNavigator: MockNavigator())

    //when
    let homeView = HomeUIView(store: homeStore)

    let textField = await homeView.getSearchTextField()

    //then
    XCTAssertNotNil(textField)
  }

  func test_tapSeeAllAdvocate_then_navigateToListOfAdvocates() async {
    //given
    let navigator = MockNavigator()
    let homeStore = await HomeStore(repository: MockHomeRepository(),
                                    onlineAdvocateNavigator: navigator)

    //when
    let homeView = HomeUIView(store: homeStore)

    try? await homeView.getSeeAllButton()?.tap()

    //then

  }

  func test_viewAppear_andShouldShowCategories() async {
    //given
    let homeStore = await HomeStore(repository: MockHomeRepository(),
                                    onlineAdvocateNavigator: MockNavigator())

    //when
    let homeView = HomeUIView(store: homeStore)
    await homeStore.fetchCategories()

    //then
    let gridCategories = await homeView.gridCategory()
    XCTAssertNotNil(gridCategories)
  }

}

extension HomeUIView {

  func getLoginViewWithText() -> InspectableView<ViewType.Text>? {
    let result = try? inspect().find(text: Constant.Home.Text.NOT_LOGGEDIN_TITLE)
    return result
  }

  func getListOnlinedAdvocates() -> InspectableView<ViewType.Text>? {
    let result = try? inspect().find(text: Constant.Home.Text.NOW_ONLINE)
    return result
  }

  func getSeeAllButton() -> InspectableView<ViewType.Button>? {
    let result = try? inspect().find(viewWithId: "SEE_ALL_BUTTON").button()
    return result
  }

  func getGridCategory() -> InspectableView<ViewType.LazyVGrid>? {
    let result = try? inspect().find(viewWithId: "CATEGORY_GRID").lazyVGrid()
    return result
  }

  func getSearchTextField() -> InspectableView<ViewType.TextField>? {
    let result = try? inspect().find(viewWithId: "SEARCH_ADVOCATE").textField()
    return result
  }

}
*/
