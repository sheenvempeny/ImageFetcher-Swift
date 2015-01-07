//
//  FlickrPhotoCell.h
//  Flickr Search
//
//  Created by Brandon Trebitowski on 7/11/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;

@interface FlickrPhotoCell : UICollectionViewCell
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) FlickrPhoto *photo;
@end
