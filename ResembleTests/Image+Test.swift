//
//  Image+Test.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 02.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
@testable import ResembleMac

extension Image {
    func preparedForTest() -> Image
    {
        let cgImage = self.CGImageRepresentation()
        let data = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height)).pngData
        let image = NSImage(data: data!)
        return Image(image: image!.cgImage!)
    }
}
