//
//  swift_snakeTests.swift
//  swift-snakeTests
//
//  Created by Weihang Lo on 7/4/16.
//  Copyright © 2016 Weihang Lo. All rights reserved.
//

import XCTest
@testable import swift_snake

class swift_snakeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func checkBodyIdentical(body: [Point], anotherBody: [Point]) -> Bool {
        var identical: Bool = false
        for (i, point) in body.enumerated() {
            let point2 = anotherBody[i]
            
            identical = point2.x == point.x && point2.y == point.y
            
            if !identical { break }
        }
        return identical
    }
    
    func testSnakeInit() {
        let snake = SnakeModel(worldSize: WorldSize(width: 20, height: 20))
        
        let body = [Point(x: 10, y: 10), Point(x: 9, y: 10)]
        
        let flag = checkBodyIdentical(body: snake.body, anotherBody: body)
        XCTAssertTrue(flag,  "Initial body is not correct")
    }
    
    func testSnakeMove() {
        let snake = SnakeModel(worldSize: WorldSize(width: 20, height: 20))
        
        var body = [Point(x: 10, y: 11), Point(x: 10, y: 10)]
        snake.direction = .Up
        snake.moveHead()
        var flag = checkBodyIdentical(body: snake.body, anotherBody: body)
        XCTAssertTrue(flag,  "Body is not correct after moving north")
        
        body = [Point(x: 9, y: 11), Point(x: 10, y: 11)]
        snake.direction = .Left
        snake.moveHead()
        flag = checkBodyIdentical(snake.body, anotherBody: body)
        XCTAssertTrue(flag,  "Body is not correct after moving Left")
        
        body = [Point(x: 9, y: 10), Point(x: 9, y: 11)]
        snake.direction = .Down
        snake.moveHead()
        flag = checkBodyIdentical(snake.body, anotherBody: body)
        XCTAssertTrue(flag,  "Body is not correct after moving south")
        
        snake.direction = .Right
        snake.moveHead()
        body = [Point(x: 10, y: 10), Point(x: 9, y: 10)]
        flag = checkBodyIdentical(snake.body, anotherBody: body)
        XCTAssertTrue(flag,  "Body is not correct after moving east")
    }
    
    
    func testSnakeExtend() {
        let snake = SnakeModel(worldSize: WorldSize(width: 20, height: 20))
        snake.extendBody()
        
        var body = [Point(x: 10, y: 10), Point(x: 9, y: 10)]
        var flag = checkBodyIdentical(body: snake.body, anotherBody: body)
        XCTAssertTrue(flag, "Body is not correct when called extendBody without move")
        
        body.insert(Point(x: 10, y: 11), at: 0)
        snake.direction = .Up
        snake.moveHead()
        snake.extendBody()
        flag = checkBodyIdentical(snake.body, anotherBody: body)
        XCTAssertTrue(flag, "Body is not correct when called extendBody after moving Left")
        
        body.insert(Point(x: 11, y: 11), at: 0)
        snake.direction = .Right
        snake.moveHead()
        snake.extendBody()
        flag = checkBodyIdentical(snake.body, anotherBody: body)
        XCTAssertTrue(flag, "Body is not correct when called extendBody after moving east")
    }
    
    func testSnakeBumpIntoBorder() {
        let snake = SnakeModel(worldSize: WorldSize(width: 6, height: 6))
        
        snake.direction = .Right
        snake.moveHead()
        var flag = snake.bumpIntoBorder()
        XCTAssertFalse(flag, "Snake should not bump into the border")
        snake.moveHead()
        flag = snake.bumpIntoBorder()
        XCTAssertFalse(flag, "Snake should not bump into the border")
        snake.moveHead()
        flag = snake.bumpIntoBorder()
        XCTAssertFalse(flag, "Snake should not bump into the border")
        
        snake.moveHead()
        flag = snake.bumpIntoBorder()
        XCTAssertTrue(flag, "Snake should bump into the border")
    }
    
    func testSnakeBumpIntoSelf() {
        let snake = SnakeModel(worldSize: WorldSize(width: 20, height: 20))
        
        snake.direction = .Right
        snake.moveHead()
        snake.extendBody()
        snake.moveHead()
        snake.extendBody()
        snake.direction = .Up
        snake.moveHead()
        snake.direction = .Left
        snake.moveHead()
        snake.direction = .Down
        snake.moveHead()
        let flag = snake.bumpIntoSelf()
        XCTAssertTrue(flag, "Snake did not bump into itself")
    }
}
