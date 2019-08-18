//
//  PanModalBackgroundStyle.swift
//  PanModal
//
//  Created by Nikita Nikitsky on 16/08/2019.
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 An enum that defines the possible styles of the background of a pan modal container view.
 */
public enum PanModalBackgroundStyle: Equatable {

    /**
     An enum that defines the possible value of the point of the gradient
     when drawn into the layer's coordinate space
     */
    public enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        case custom(CGPoint)

        var cgPoint: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            case let .custom(cgPoint):
                return cgPoint
            }
        }
    }

    /**
     Sets the backgound style to be the solid color effect with specified alpha.
     */
    case solid(color: UIColor, alpha: CGFloat)

    /**
     Sets the backgound style to be the color gradient effect
     with specified start point of the gradient, end point of the gradient,
     gradient type and alpha.
     */
    case gradient(colors: [UIColor], startPoint: Point, endPoint: Point, type: CAGradientLayerType, alpha: CGFloat)

    /**
     Sets the background style to be the blur effect
     with specified the blur style and degree.
     */
    case blur(style: UIBlurEffect.Style, degree: CGFloat)

    /**
     Sets the background style to be the custom effect
     specified by user.
     */
    case custom(DimmedView)

    public static func == (lhs: PanModalBackgroundStyle, rhs: PanModalBackgroundStyle) -> Bool {
        switch (lhs, rhs) {
        case let (.solid(lhsColor, lhsAlpha), .solid(rhsColor, rhsAlpha)):
            return lhsColor == rhsColor &&
                   lhsAlpha == rhsAlpha
        case let (.gradient(lhsColors, lhsStartPoint, lhsEndPoint, lhsType, lhsAlpha), .gradient(rhsColors, rhsStartPoint, rhsEndPoint, rhsType, rhsAlpha)):
            return lhsColors == rhsColors &&
                   lhsStartPoint.cgPoint == rhsStartPoint.cgPoint &&
                   lhsEndPoint.cgPoint == rhsEndPoint.cgPoint &&
                   lhsType == rhsType &&
                   lhsAlpha == rhsAlpha
        case let (.blur(lhsType, lhsDegree), .blur(rhsType, rhsDegree)):
            return lhsType == rhsType &&
                   lhsDegree == rhsDegree
        default:
            return false
        }
    }

}
