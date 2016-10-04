//
//  XCTestCase+UIImage.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest

extension NSImage {
    
    var cgImage: CGImage? {
        let context = NSGraphicsContext.current()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        var nsRect = NSRectFromCGRect(rect)
        return self.cgImage(forProposedRect: &nsRect, context: context, hints: nil)
    }
    
    var pngData: Data? {
        guard let cgImage = self.cgImage else { return nil }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = self.size
        return bitmapRep.representation(using: .PNG, properties: [:])
    }
    
    func save(atPath path: String)
    {
        try? pngData?.write(to: URL(fileURLWithPath: path))
    }
}

extension XCTestCase {
    func image(named name: String) -> NSImage
    {
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: nil)
        let image = NSImage(contentsOfFile: path!)
        return image!
    }
}
