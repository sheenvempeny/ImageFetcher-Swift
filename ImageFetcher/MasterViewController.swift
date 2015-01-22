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
    var refreshControl:UIRefreshControl! = nil
    
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
    
    func refershControlAction() -> Void
    {
        self.searchPhotos(control: self.refreshControl)
    }
    
    func stopControllProgress(#control:UIView) -> Void
    {
        if control == self.progressView
        {
            self.progressView.stopAnimating()
        }
        else
        {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func searchPhotos(#control:UIView) -> Void
    {
        _flicker.searchFlickrForTerm("dubai", completionBlock:{(searchTearm : String!,results : Array!,error : NSError! ) ->Void in
            
            if (results != nil && results.count > 0)
            {
                
                self.photoList.removeAll(keepCapacity: true)
                for photo in results
                {
                    
                    self.photoList.append(photo as FlickrPhoto)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {()
                    
                    self.stopControllProgress(control: control)
                    self.collectionView?.reloadData();
                });
                
            }
            else {
                //    NSLog(@"Error searching Flickr: %@", error.localizedDescription);
                
                self.stopControllProgress(control: control)
            }
            
            
            
        } )

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.collectionView?.backgroundColor = UIColor.clearColor()
    
        
        self.refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.grayColor();
        refreshControl!.addTarget(self, action: "refershControlAction", forControlEvents: .ValueChanged)
        self.collectionView!.addSubview(refreshControl!)
        self.collectionView!.alwaysBounceVertical = true
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        progressView.startAnimating()
        self.searchPhotos(control: self.progressView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail" {

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

