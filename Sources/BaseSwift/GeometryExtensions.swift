//
//  GeometryExtensions.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//

#if canImport(CoreGraphics)

import CoreGraphics

infix operator ⋅ : MultiplicationPrecedence
infix operator ⨯ : MultiplicationPrecedence

// MARK: CGPoint

@inlinable public prefix func - (operand: CGPoint) -> CGPoint {
    CGPoint(x: -operand.x, y: -operand.y)
}

@inlinable public func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
}

@inlinable public func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
}

@inlinable public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

@inlinable public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

@inlinable public func += (lhs: inout CGPoint, rhs: CGFloat) {
    lhs.x += rhs
    lhs.y += rhs
}

@inlinable public func -= (lhs: inout CGPoint, rhs: CGFloat) {
    lhs.x -= rhs
    lhs.y -= rhs
}

@inlinable public func += (lhs: inout CGPoint, rhs: CGPoint) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

@inlinable public func -= (lhs: inout CGPoint, rhs: CGPoint) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

@inlinable public func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x*rhs, y: lhs.y*rhs)
}

@inlinable public func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x/rhs, y: lhs.y/rhs)
}

@inlinable public func *= (lhs: inout CGPoint, rhs: CGFloat) {
    lhs.x *= rhs
    lhs.y *= rhs
}

@inlinable public func /= (lhs: inout CGPoint, rhs: CGFloat) {
    lhs.x /= rhs
    lhs.y /= rhs
}

extension CGPoint {

    @inlinable public func dotProduct(_ operand: CGPoint) -> CGFloat {
        x*operand.x + y*operand.y
    }

    @inlinable public static func ⋅ (lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        lhs.dotProduct(rhs)
    }

    @inlinable public func crossProduct(_ operand: CGPoint) -> CGFloat {
        x*operand.y - y*operand.x
    }

    @inlinable public static func ⨯ (lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        lhs.crossProduct(rhs)
    }

    @inlinable public var magnitude: CGFloat {
        sqrt(x*x + y*y)
    }

    @inlinable public var magnitude2: CGFloat {     // magnitude squared
        x*x + y*y
    }
}


// MARK: -
// MARK: CGSize

@inlinable public func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
}

@inlinable public func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
}

@inlinable public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

@inlinable public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

@inlinable public func += (lhs: inout CGSize, rhs: CGFloat) {
    lhs.width += rhs
    lhs.height += rhs
}

@inlinable public func -= (lhs: inout CGSize, rhs: CGFloat) {
    lhs.width -= rhs
    lhs.height -= rhs
}

@inlinable public func += (lhs: inout CGSize, rhs: CGSize) {
    lhs.width += rhs.width
    lhs.height += rhs.height
}

@inlinable public func -= (lhs: inout CGSize, rhs: CGSize) {
    lhs.width -= rhs.width
    lhs.height -= rhs.height
}

// MARK: -
// MARK: CGRect

@inlinable public func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
    CGRect(origin: lhs.origin + rhs, size: lhs.size)
}

@inlinable public func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
    CGRect(origin: lhs.origin - rhs, size: lhs.size)
}

@inlinable public func += (lhs: inout CGRect, rhs: CGPoint) {
    lhs.origin += rhs
}

@inlinable public func -= (lhs: inout CGRect, rhs: CGPoint) {
    lhs.origin -= rhs
}

extension CGRect {

    @inlinable public var minPoint: CGPoint {
        CGPoint(x: self.minX, y: self.minY)
    }

    @inlinable public var midPoint: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }

    @inlinable public var maxPoint: CGPoint {
        CGPoint(x: self.maxX, y: self.maxY)
    }

    @inlinable public func enlargedBy(_ value: CGFloat) -> CGRect {
        CGRect(origin: self.origin, size: self.size + value)
    }

    @inlinable public func enlargedBy(_ size: CGSize) -> CGRect {
        CGRect(origin: self.origin, size: self.size + size)
    }

    @inlinable public func enlargedBy(dw: CGFloat, dh: CGFloat) -> CGRect {
        CGRect(origin: self.origin, size: self.size + CGSize(width: dw, height: dh))
    }
}

#endif
