//
//  SnakeModel.swift
//  swift-snake
//
//  Created by Weihang Lo on 7/4/16.
//  Copyright © 2016 Weihang Lo. All rights reserved.
//

import Foundation

struct WorldSize {
    let width: Int
    let height: Int
}

struct Point {
    let x: Int
    let y: Int
}

enum Direction {
    case Up
    case Down
    case Right
    case Left
    
    func shouldChangeDirection(direction: Direction) -> Bool {
        var canChange = true
        
        switch self {
        case .Right, .Left:
            canChange = direction == .Up || direction == .Down
        case .Up, .Down:
            canChange = direction == .Right || direction == .Left
        }
        return canChange
    }
}

class SnakeModel {
    
    private var _cachedTail: Point?
    private var _direction: Direction = .Right
    
    private(set) var worldSize: WorldSize
    
    var body: [Point] = []
    var head: Point! {
        return body.first
    }
    var direction: Direction {
        get {
            return _direction
        }
        set (newDirection) {
            if _direction.shouldChangeDirection(newDirection) {
                _direction = newDirection
            }
        }
    }
    
    
    init(worldSize: WorldSize) {
        guard worldSize.width >= 5 && worldSize.height >= 5 else {
            fatalError("worldSize should be (width, height) >= (5, 5)")
        }
        self.worldSize = worldSize
        
        for i in 0..<2 {
            body.append(Point(x: worldSize.width / 2 - i, y: worldSize.height / 2))
        }
    }
    
    
    private func _willMoveHead() -> Point {
        var newHead: Point!
        
        switch direction {
        case .Up:
            newHead = Point(x: head.x, y: head.y + 1)
        case .Down:
            newHead = Point(x: head.x, y: head.y - 1)
        case .Right:
            newHead = Point(x: head.x + 1, y: head.y)
        case .Left:
            newHead = Point(x: head.x - 1, y: head.y)
        }
        return newHead
    }
    
    private func _bump(intoPoint point: Point, byHead head: Point) -> Bool {
        return point.x == head.x && point.y == head.y
    }
    
    func moveHead() {
        body.insert(_willMoveHead(), atIndex: 0)
        _cachedTail = body.popLast()
    }
    
    func extendBody() {
        if let tail = _cachedTail {
            body.append(tail)
        }
    }
    
    func bumpIntoSelf() -> Bool {
        for (idx, point) in body.enumerate() {
            if idx == 0 { continue }
            
            if point.x == head.x && point.y == head.y {
                return true
            }
        }
        
        if let tail = _cachedTail {
            if tail.x == head.x && tail.y == head.y {
                return true
            }
        }
        
        return false
    }
    
    func bumpIntoBorder() -> Bool {
        return head.x > worldSize.width || head.x < 0 || head.y > worldSize.height || head.y < 0
    }
    
}
