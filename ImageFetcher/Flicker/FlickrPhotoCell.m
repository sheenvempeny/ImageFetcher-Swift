//
//  FlickrPhotoCell.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 7/11/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "FlickrPhotoCell.h"
#import "FlickrPhoto.h"
#import "Flickr.h"

@implementation FlickrPhotoCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;      
    }
    return self;
}

- (void) setPhoto:(FlickrPhoto *)photo
{
    if(_photo != photo)
    {
        _photo = photo;
    }
   
    self.imageView.image = _photo.thumbnail;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.backgroundColor = selected?[UIColor greenColor]:[UIColor grayColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
