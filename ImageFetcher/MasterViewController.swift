//
//  MasterViewController.swift
//  ImageFetcher
//
//  Created by Sheen on 1/4/15.
//  Copyright (c) 2015 Sheen. All rights reserved.
//



import UIKit

enum ViewType
{
    case Grid
    case List
}

class MasterViewController: UICollectionViewController {

    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    var eViewType = ViewType.Grid
    var detailViewController: DetailViewController? = nil
    let _flicker = Flickr()
    var photoList: [FlickrPhoto] = []

    
    @IBAction func showGridOrList(sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            eViewType = ViewType.Grid
        }
        else
        {
            eViewType = ViewType.List
        }
        
        self.collectionView?.reloadData();
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.collectionView?.backgroundColor = UIColor.clearColor()
    
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        progressView.startAnimating()
        
        _flicker.searchFlickrForTerm("dubai", completionBlock:{(searchTearm : String!,results : Array!,error : NSError! ) ->Void in
            
            if (results != nil && results.count > 0)
            {
                
                self.photoList.removeAll(keepCapacity: true)
                for photo in results
                {
                    
                    self.photoList.append(photo as FlickrPhoto)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {()
                    self.progressView.stopAnimating()
                    self.collectionView?.reloadData();
                });
                
            }
            else {
                //    NSLog(@"Error searching Flickr: %@", error.localizedDescription);
           
                 self.progressView.stopAnimating()
            }
            
            
            
        } )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = objects[indexPath.row] as NSDate
//                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }

            if let indexPaths = self.collectionView?.indexPathsForSelectedItems()
            {
                let array = indexPaths as NSArray
                let indexPath = array.objectAtIndex(0) as NSIndexPath
                let object = photoList[indexPath.row]
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
            }
        }
    }

  
    
    override func collectionView(inCollectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        
        return self.photoList.count;
    }
    
   override func numberOfSectionsInCollectionView(inCollectionView: UICollectionView) -> Int
    {
        return 1;
    }
    
    override func collectionView(inCollectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = inCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? FlickrPhotoCell
        cell?.photo = photoList[indexPath.row]
        return cell!;
    }
    
    func collectionView(inCollectionView:UICollectionView , layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
    
//        var photo = photoList[indexPath.row] as FlickrPhoto
//        var retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100) as CGSize
//        retval.height += 35;
//        retval.width += 35;
//        return retval;

        
        var layout = collectionViewLayout as UICollectionViewFlowLayout
        var returnSize = layout.itemSize;
        
        if(eViewType == ViewType.List)
        {
            returnSize.width = inCollectionView.frame.size.width - 100.0
            
        }
    
        return returnSize
    }
    
    func collectionView(inCollectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, insetForSectionAtIndex section:NSInteger) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(50, 20, 50, 20);
    }

    
}

