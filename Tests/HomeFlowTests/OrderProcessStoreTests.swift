//
//  OrderProcessStoreTests.swift
//  HomeFlow
//
//  Created by Ilham Prabawa on 12/11/24.
//

import XCTest
@testable import HomeFlow
import AprodhitKit

final class OrderProcessStoreTests: XCTestCase {
  
  var sut: OrderProcessStore!
  
  private func makeSUT() {
    let advocate = Advocate(id: 1, name: "", price: 60000, photo_url: "URL", gender: "", city: nil, year_exp: nil, avg_ratings: nil, total_consultations: nil, slug: nil, is_online: nil, agency_name: "Peradi Malang", agency_province: nil, agency_city: nil, description: nil, is_busy: nil, educations: [], skills: [], reviews: [], prices: nil, is_video_call_active: nil, is_voice_call_active: nil)
    
    sut = OrderProcessStore(
      advocate: advocate,
      category: .init(),
      selectedPriceCategory: "Rp60.000",
      sktmModel: .init(),
      userSessionDataSource: MockUserSessionDataSource(),
      repository: MockOrderProcessRepository(),
      treatmentRepository: MockTreatmentRepository(),
      paymentNavigator: MockNavigator(),
      sktmNavigator: MockNavigator()
    )
  }
  
  override func tearDown() {
    super.tearDown()
    
    sut = nil
  }
  
  @MainActor
  func test_initStore_andPhotoURL_shouldBeReady() async {
    //given
    makeSUT()
    
    //when
    sut.setLawyerInfo()
    
    //then
    XCTAssertNotNil(sut.lawyerInfoViewModel.imageURL)
    
  }
  
  @MainActor
  func test_initStore_andAgencyName_shouldShow() async {
    //given
    makeSUT()
    
    //when
    sut.setLawyerInfo()
    
    //then
    XCTAssertTrue(sut.lawyerInfoViewModel.agency == "Peradi Malang")
  }
  
  @MainActor
  func test_initStore_andPrice_shouldAvailable() async {
    //given
    makeSUT()
    
    //when
    sut.setLawyerInfo()
    
    //then
    XCTAssertTrue(sut.lawyerInfoViewModel.price == "Rp60.000")
  }
  
  @MainActor
  func test_initStore_andConsultationDuration_shouldHave45MinutesLong() async {
    //given
    makeSUT()
    
    //when
    sut.isProbonoActive = false
    await sut.fetchTreatment()
    
    //then
    XCTAssertEqual(sut.timeConsultation, "45 Menit")
  }
  
  @MainActor
  func test_initStore_andConsultationDuration_shouldHave30MinutesLong() async {
    //given
    makeSUT()
    
    //when
    sut.isProbonoActive = true
    await sut.fetchTreatment()
    
    //then
    XCTAssertEqual(sut.timeConsultation, "30 Menit")
  }
  
  @MainActor
  func test_initStore_validationOnTextArea_notStarted() async {
    //given
   
    //when
    makeSUT()
    
    //then
    XCTAssertEqual(sut.isTextValid, true)
    XCTAssertEqual(sut.issueText, "")
  }
  
  @MainActor
  func test_initStore_buttonShouldNotActivated() async {
    //given
   
    //when
    makeSUT()
    
    //then
    XCTAssertEqual(sut.buttonActive, false)
  }
  
  @MainActor
  func test_validateText_shouldMoreThan10Words() async {
    //given
    makeSUT()
    
    //when
    sut.issueText = "Lorem ipsum dolor sit amet"
    
    //then
    XCTAssertEqual(sut.isTextValid, true)
  }
  
  @MainActor
  func test_textLessThan10Words_ThenErrorShouldShow() async {
    //given
    makeSUT()
    
    //when
    sut.issueText = "Lorem"
    try? await Task.sleep(nanoseconds: 3000)
    
    //then
    XCTAssertEqual(sut.issueTextError, "Minimal 10 Karakter")
  }
  
}
