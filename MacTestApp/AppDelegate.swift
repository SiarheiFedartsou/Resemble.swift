//
//  AppDelegate.swift
//  MacTestApp
//
//  Created by Sergey Fedortsov on 03.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Cocoa
import ResembleMac

extension NSImage {
    
    var cgImage: CGImage? {
        let context = NSGraphicsContext.current()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        var nsRect = NSRectFromCGRect(rect)
        return self.cgImage(forProposedRect: &nsRect, context: context, hints: nil)
    }
    
    func save(atPath path: String)
    {
        guard let cgImage = self.cgImage else { return }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = self.size
        let data = bitmapRep.representation(using: .PNG, properties: [:])
        try? data?.write(to: URL(fileURLWithPath: path))
    }
}


struct AdjustSaturationUniforms
{
    let saturationFactor: Float
};

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let image1 = (NSImage(named: "test1.png")?.cgImage)!
        let image2 = (NSImage(named: "test2.png")?.cgImage)!
        
        
        let time = CFAbsoluteTimeGetCurrent()
        
        //                let img1 = Image(image: image1)
        //                let img2 = Image(image: image2)
        //
        //
        //                let diff = img1.compare(to: img2, errorPixelTransform: .movementDifferenceIntensity)
        //                let cgImage = diff.CGImageRepresentation()
        //                let outputImage = NSImage(cgImage: cgImage, size:NSSize(width: cgImage.width, height: cgImage.height))
        //
        //
        let context = MetalContext()
        let texture1 = context.texture(fromImage: image1)
        let texture2 = context.texture(fromImage: image2)
        
        
        let kernelFunction = context.library.makeFunction(name: "find_diff_flat")
        let pipeline = try! context.device.makeComputePipelineState(function: kernelFunction!)
        
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: texture1!.pixelFormat,
                                                                         width: texture1!.width,
                                                                         height: texture1!.height,
                                                                         mipmapped: false)
        textureDescriptor.usage = .shaderWrite
        textureDescriptor.resourceOptions = .storageModeManaged
        textureDescriptor.storageMode = .managed
        let outputTexture = context.device.makeTexture(descriptor: textureDescriptor)
        
        let threadgroupCounts = MTLSizeMake(8, 8, 1)
        let threadgroups = MTLSizeMake(outputTexture.width / threadgroupCounts.width,
                                       outputTexture.height / threadgroupCounts.height,
                                       1);
        
        let commandBuffer = context.commandQueue.makeCommandBuffer()

        
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()
        
        
        
        commandEncoder.setComputePipelineState(pipeline)
        commandEncoder.setTexture(texture1, at: 0)
        commandEncoder.setTexture(texture2, at: 1)
        commandEncoder.setTexture(outputTexture, at: 2)
        
        
        var uniforms = AdjustSaturationUniforms(saturationFactor: 0.5)
        
        let uniformBuffer = context.device.makeBuffer(length: MemoryLayout<AdjustSaturationUniforms>.size, options: .cpuCacheModeWriteCombined)
        memcpy(uniformBuffer.contents(), &uniforms, MemoryLayout<AdjustSaturationUniforms>.size)
        
        commandEncoder.setBuffer(uniformBuffer, offset: 0, at: 0)
        
        
        commandEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupCounts)
        
        commandEncoder.endEncoding()
        
        let blitEncoder = commandBuffer.makeBlitCommandEncoder()
        
        blitEncoder.synchronize(texture: outputTexture, slice: 0, level: 0)
        
        blitEncoder.endEncoding()
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        
        
        let cgImage = CGImage.image(fromMTLTexture: outputTexture)
        let outputImage = NSImage(cgImage: cgImage, size:NSSize(width: cgImage.width, height: cgImage.height))
        
        print("Time \(CFAbsoluteTimeGetCurrent() - time)")
        
        outputImage.save(atPath: "/Users/sergeyfedortsov/testmac.png")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

