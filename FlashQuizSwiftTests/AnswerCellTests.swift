//
//  AnswerCellTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest

class AnswerCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAnswerCellGenerically() {
        let cell = AnswerCell()
        cell.layoutSubviews()
        cell.prepareForReuse()
        cell.selected = !cell.selected // change selected
        cell.selected = !cell.selected // change it back
        cell.startLoadingImage()
        let image : UIImage? = nil
        cell.finishLoadingWithImage(image)
    }
    
}
