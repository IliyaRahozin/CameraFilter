//
//  FiltersService.swift
//  CameraFilter
//
//  Created by Illia Rahozin on 15.11.2023.
//

import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            
            return Disposables.create()
        }
    }
    
    func applyFilter(
        to inputImage: UIImage,
        completion: @escaping ((UIImage) -> ())
    ) {
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter?.setValue(sourceImage, forKey: kCIInputImageKey)
            if let outpitImage = filter?.outputImage,
               let extentFrom = filter?.outputImage?.extent,
               let cgImage = self.context.createCGImage(outpitImage, from: extentFrom) {
                
                let processedImage = UIImage(
                                         cgImage: cgImage,
                                         scale: inputImage.scale,
                                         orientation: inputImage.imageOrientation
                                     )
                completion(processedImage)
            }
                
        }
    }
}
