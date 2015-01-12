//
//  Flickr.m
//  Flickr Search
//
//  Created by Brandon Trebitowski on 6/28/12.
//  Copyright (c) 2012 Brandon Trebitowski. All rights reserved.
//

#import "Flickr.h"
#import "FlickrPhoto.h"

#define kFlickrAPIKey @"d02c877c0a4220890f14fc95f8b16983"

@implementation Flickr

+ (NSString *)flickrSearchURLForSearchTerm:(NSString *) searchTerm
{
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1",kFlickrAPIKey,searchTerm];
}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto size:(NSString *) size
{
    if(!size)
    {
        size = @"m";
    }
    return [NSString stringWithFormat:@"https://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
}

- (void)searchFlickrForTerm:(NSString *) term completionBlock:(FlickrSearchCompletionBlock) completionBlock
{
    
    NSString *searchURL = [Flickr flickrSearchURLForSearchTerm:term];
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError *error = nil;
         NSDictionary *searchResultsDict = (NSDictionary *)responseObject;
        NSString * status = searchResultsDict[@"stat"];
        if ([status isEqualToString:@"fail"]) {
            NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
            completionBlock(term, nil, error);
        } else {
            
            NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
            NSMutableArray *flickrPhotos = [@[] mutableCopy];
            for(NSMutableDictionary *objPhoto in objPhotos)
            {
                FlickrPhoto *photo = [[FlickrPhoto alloc] init];
                photo.farm = [objPhoto[@"farm"] intValue];
                photo.server = [objPhoto[@"server"] intValue];
                photo.secret = objPhoto[@"secret"];
                photo.photoID = [objPhoto[@"id"] longLongValue];
                
                NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"m"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                          options:0
                                                            error:&error];
                UIImage *image = [UIImage imageWithData:imageData];
                photo.thumbnail = image;
                
                [flickrPhotos addObject:photo];
            }
            
            completionBlock(term,flickrPhotos,nil);
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(term, nil, error);
    }];
    [operation start];
}

+ (void)loadImageForPhoto:(FlickrPhoto *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock
{
    
    NSString *size = thumbnail ? @"m" : @"b";
    NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:flickrPhoto size:size];

    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage *image = responseObject;
       
        if([size isEqualToString:@"m"])
        {
            flickrPhoto.thumbnail = image;
        }
        else
        {
            flickrPhoto.largeImage = image;
        }
        
        completionBlock(image,nil);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         completionBlock(nil,error);
    }];
    
    [operation start];
}



@end
