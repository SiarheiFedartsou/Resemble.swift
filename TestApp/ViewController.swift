//
//  ViewController.swift
//  TestApp
//
//  Created by Sergey Fedortsov on 02.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import UIKit
import Resemble

class ViewController: UIViewController {

    struct AdjustSaturationUniforms
    {
        let saturationFactor: Float
    };
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let image1 = (UIImage(named: "test1.png")?.cgImage)!
        let image2 = (UIImage(named: "test2.png")?.cgImage)!
        
        let time = CFAbsoluteTimeGetCurrent()
        
//        let img1 = Image(image: image1)
//        let img2 = Image(image: image2)
//        
//        
//        let diff = img1.compare(to: img2, errorPixelTransform: .movementDifferenceIntensity)
//        let outputImage = UIImage(cgImage: diff.CGImageRepresentation())
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
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        let outputImage = UIImage(cgImage: CGImage.image(fromMTLTexture: outputTexture))
        
        print("Time \(CFAbsoluteTimeGetCurrent() - time)")
        
        imageView.image = outputImage
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

