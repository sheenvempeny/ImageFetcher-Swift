//
//  DetailViewController.swift
//  ImageFetcher
//
//  Created by Sheen on 1/4/15.
//  Copyright (c) 2015 Sheen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

