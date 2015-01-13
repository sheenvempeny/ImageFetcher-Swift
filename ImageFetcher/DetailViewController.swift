//
//  DetailViewController.swift
//  ImageFetcher
//
//  Created by Sheen on 1/4/15.
//  Copyright (c) 2015 Sheen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UIScrollViewDelegate {


@IBOutlet weak var scrollView: UIScrollView!
@IBOutlet weak var ImageView: UIImageView!
    var selectedImage: UIImage? = nil
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func updateImageView()
    {
        if (ImageView != nil && selectedImage != nil)
        {
            
            ImageView.image = selectedImage
        }
        
    }
    
    


    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            let thumbImage : UIImage = detail.thumbnail
            var bigImage : UIImage?;
            bigImage = detail.largeImage?
            
            if (bigImage != nil)
            {
                selectedImage = bigImage
                self.updateImageView()
            }
            else
            {
                selectedImage = thumbImage
                var flickerPhoto : FlickrPhoto = detail as FlickrPhoto
                Flickr.loadImageForPhoto(flickerPhoto, thumbnail: false, completionBlock: {( photoImage:UIImage! , error: NSError!) -> Void in
                    self.selectedImage = photoImage
                    self.updateImageView()
                })
            
            }
            
            
        }
        
         
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        updateImageView()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.contentSize = self.ImageView.frame.size
        self.scrollView.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewForZoomingInScrollView(scrollView:UIScrollView) ->  UIView
    {
        return self.ImageView! as UIView
    }
    
    func scrollViewDidEndZooming(scrollView:UIScrollView,  withView view:UIView,  atScale scale:CGFloat) -> Void
    {
        
    }

}

