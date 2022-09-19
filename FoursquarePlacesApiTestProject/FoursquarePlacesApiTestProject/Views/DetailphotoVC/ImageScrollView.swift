//
//  ImageScrollView.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 18.09.2022.
//

import UIKit
import SDWebImage

class ImageScrollView: UIScrollView {
    
  private  var imageZoomView: UIImageView!
    
  private lazy var zoomTap: UITapGestureRecognizer = {
        let z = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        z.numberOfTapsRequired = 2
        return z
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage){
        //при переиспользовании предыдущая картинка удаляется
        if imageZoomView != nil {
        imageZoomView.removeFromSuperview()
        imageZoomView = nil
        }
        imageZoomView = UIImageView(image: image)
        print(image.size)
        self.addSubview(imageZoomView)
        configurateFor(imageSize: image.size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //срабатывание функции по определению центра фото
        centerImage()
    }
    
    //MARK: - определение contentSize
    private func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        setMinMaxZoomScale()
        self.zoomScale = self.minimumZoomScale//при запуске
        self.imageZoomView.addGestureRecognizer(self.zoomTap)
        self.imageZoomView.isUserInteractionEnabled =  true
    }
    
    //MARK: - настройка макс и мин зум
    private func setMinMaxZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        let xScale = boundsSize.width/imageSize.width
        let yScale = boundsSize.height/imageSize.height
        let minScale = min(xScale,yScale)
        
        var maxScale: CGFloat = 1.0
        
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if maxScale >= 0.5 {
            maxScale = max(1.0,minScale)
        }
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    private func centerImage() {
        let boundsSize = self.bounds.size
        var frameTocenter = imageZoomView.frame ?? CGRect.zero
        if frameTocenter.size.width < boundsSize.width {
            frameTocenter.origin.x = (boundsSize.width - frameTocenter.size.width)/2
        }else{
            frameTocenter.origin.x = 0
        }
        
        if frameTocenter.size.height < boundsSize.height {
            frameTocenter.origin.y = (boundsSize.height - frameTocenter.size.height)/2
        }else{
            frameTocenter.origin.y = 0
        }
        imageZoomView.frame = frameTocenter
    }
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer ) {
        let location = sender.location(in: sender.view)
        //кастомная функция
        self.zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currentScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if(minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        //встроенная функция
        self.zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        zoomRect.size.width = bounds.size.width/scale
        zoomRect.size.height =  bounds.size.height/scale
        zoomRect.origin.x = center.x - (zoomRect.size.width/2)
        zoomRect.origin.y = center.y - (zoomRect.size.height/2)
        return zoomRect
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
       self.centerImage()//возврат к центру после зума
    }
}
