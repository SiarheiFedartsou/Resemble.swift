//
//  ErrorPixelTransform.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

public enum ErrorPixelTransform {
    case flat
    case movement
    case flatDifferenceIntensity
    case movementDifferenceIntensity
    
    var strategy: ErrorPixelTransformStrategy {
        switch self {
        case .flat:
            return FlatErrorPixelTransformStrategy()
        case .movement:
            return MovementErrorPixelTransformStrategy()
        case .flatDifferenceIntensity:
            return FlatDifferenceIntensityErrorPixelTransformStrategy()
        case .movementDifferenceIntensity:
            return MovementDifferenceIntensityErrorPixelTransformStrategy()
        }
    }
}
