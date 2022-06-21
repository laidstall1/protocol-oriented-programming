//
//  protocol_orientated_programmingTests.swift
//  protocol-orientated-programmingTests
//
//  Created by DIGITAL VENTURES on 20/06/2022.
//

import XCTest
@testable import protocol_orientated_programming

class protocol_orientated_programmingTests: XCTestCase {

    private var sut: UserViewModel!
    private var userService: MockUserService!
    private var output: MockUserViewModelOutput!
    
    override func setUpWithError() throws {
        output = MockUserViewModelOutput()
        userService = MockUserService()
        sut = UserViewModel(userService: userService)
        sut.output = output
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        userService = nil
        try setUpWithError()
    }

    func testUpdateView_onAPISuccess_showsImageAndEmail() {
        // given  variables
        let user =  User(id: 1, email: "test@gmail.com", avatar: "https://picsum.com/2")
        userService.fetchUserMockResult = .success(user)
        // when   something happens
        sut.fetchUser()
        // then   result
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].email, "test@gmail.com")
        XCTAssertEqual(output.updateViewArray[0].imageUrl, "https://picsum.com/2")
    }
    
    func testUpdateView_onAPIFailure_showsErrorImageAndDefaultUserNotFoundText() {
        // given
        userService.fetchUserMockResult = .failure(NSError())
        // when
        sut.fetchUser()
        // then
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].email, "No User Found")
        XCTAssertEqual(output.updateViewArray[0].imageUrl, "https://cdn1.iconfinder.com/data/icons/user-fill-icons-set/144/User003_Error-1024.jpg")
    }
}

class MockUserService: UserService {
    var fetchUserMockResult: Result<User, Error>?
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        if let result = fetchUserMockResult {
            completion(result)
        }
    }
}

class MockUserViewModelOutput: UserViewModelViewOutput {
    var updateViewArray: [(imageUrl: String, email: String)] = []
    func updateView(imageUrl: String, email: String) {
        updateViewArray.append((imageUrl, email))
    }
}
