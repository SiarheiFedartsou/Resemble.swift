//
//  Image+Test.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 02.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
@testable import Resemble

extension Image {
    func preparedForTest() -> Image
    {
        let data = UIImagePNGRepresentation(UIImage(cgImage: self.CGImageRepresentation()))!
        let uiimage = UIImage(data: data)!
        return Image(image: uiimage.cgImage!)
    }
}