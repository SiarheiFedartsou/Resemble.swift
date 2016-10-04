//
//  CGImage+MTLTexture.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 02.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Metal

func releaseData(ptr1: UnsafeMutableRawPointer?, ptr2: UnsafeRawPointer, c: Int)
{
    
}

public extension CGImage {
    
    
    
    class func image(fromMTLTexture texture: MTLTexture) -> CGImage
    {
        let width = texture.width
        let height = texture.height
        
        let imageByteCount = width * height * 4 * 8
        let imageBytes = UnsafeMutablePointer<Float>.allocate(capacity: imageByteCount)
        let bytesPerRow = width * 4 * 8
        let region = MTLRegionMake2D(0, 0, width, height)
        
        texture.getBytes(imageBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        
        let provider = CGDataProvider(dataInfo: nil, data: imageBytes, size: imageByteCount, releaseData: releaseData)
        
        let bitsPerComponent = 32
        let bitsPerPixel = 128
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGBitmapInfo(rawValue:
            CGImageAlphaInfo.premultipliedFirst.rawValue |
                CGBitmapInfo.floatComponents.rawValue |
                CGBitmapInfo.byteOrder32Little.rawValue)
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        let image = CGImage(width: width,
                            height: height,
                            bitsPerComponent: bitsPerComponent,
                            bitsPerPixel: bitsPerPixel,
                            bytesPerRow: bytesPerRow,
                            space: colorSpace,
                            bitmapInfo: bitmapInfo,
                            provider: provider!,
                            decode: nil,
                            shouldInterpolate: false,
                            intent: .defaultIntent)
        
        return image!
        
    }


}

//static void MBEReleaseDataCallback(void *info, const void *data, size_t size)
//{
//    free((void *)data);
//}
//
//@implementation UIImage (MBETextureUtilities)
//
//+ (UIImage *)imageWithMTLTexture:(id<MTLTexture>)texture
//{
//    NSAssert([texture pixelFormat] == MTLPixelFormatRGBA8Unorm, @"Pixel format of texture must be MTLPixelFormatBGRA8Unorm to create UIImage");
//    
//    CGSize imageSize = CGSizeMake([texture width], [texture height]);
//    size_t imageByteCount = imageSize.width * imageSize.height * 4;
//    void *imageBytes = malloc(imageByteCount);
//    NSUInteger bytesPerRow = imageSize.width * 4;
//    MTLRegion region = MTLRegionMake2D(0, 0, imageSize.width, imageSize.height);
//    [texture getBytes:imageBytes bytesPerRow:bytesPerRow fromRegion:region mipmapLevel:0];
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageBytes, imageByteCount, MBEReleaseDataCallback);
//    int bitsPerComponent = 8;
//    int bitsPerPixel = 32;
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    CGImageRef imageRef = CGImageCreate(imageSize.width,
//                                        imageSize.height,
//                                        bitsPerComponent,
//                                        bitsPerPixel,
//                                        bytesPerRow,
//                                        colorSpaceRef,
//                                        bitmapInfo,
//                                        provider,
//                                        NULL,
//                                        false,
//                                        renderingIntent);
//    
//    UIImage *image = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationDownMirrored];
//    
//    CFRelease(provider);
//    CFRelease(colorSpaceRef);
//    CFRelease(imageRef);
//    
//    return image;
//}
//
//@end
