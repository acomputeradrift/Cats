//
//  ViewController.m
//  Cats
//
//  Created by Jamie on 2018-08-16.
//  Copyright © 2018 Jamie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray <Cat*> *catsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *CatCollectionView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.catsArray = [[NSMutableArray alloc] init];
    [self getDataFromUrlAndParse];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getDataFromUrlAndParse{
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=101c46c3f292db59ccf1e2e5bb3ac46a&tags=cat"]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *topDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; //first level
        NSDictionary *photosDict = topDict[@"photos"];
        NSArray *photoArray = photosDict[@"photo"];
        for (NSDictionary* detailDict in photoArray){
            NSString *farm  = [detailDict valueForKey:@"farm"];
            NSString *server  = [detailDict valueForKey:@"server"];
            NSString *KeyId  = [detailDict valueForKey:@"id"];
            NSString *secret  = [detailDict valueForKey:@"secret"];
            NSString* urlStr = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg", farm, server, KeyId, secret];
            Cat *cat = [[Cat alloc]init];
            cat.title = [detailDict valueForKey:@"title"];
            cat.urlString = urlStr;
            [self.catsArray addObject:cat];
            
            
        }
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.CatCollectionView reloadData];
        }];
    }];
    [dataTask resume]; // 6
}


- (void) fetchImage: (Cat*)cat andSetImage: (UIImageView*)imageView{
    
    NSURL *url = [NSURL URLWithString:cat.urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data]; // 2
         cat.catImage = image;
        
        
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
          
            imageView.image = cat.catImage;
            //self.iPhoneImageView.image = image; // 4
        }];
        
    }];
    
    
    [downloadTask resume]; // 5
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatCollectionViewCell" forIndexPath:indexPath];
    //    //get item in array at index
    cell.catImageView.image = nil;
    Cat *cat = self.catsArray[indexPath.item];
    cell.catTitleLabel.text = cat.title;
    [self fetchImage:cat andSetImage:cell.catImageView];
    
    //set cell image
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catsArray.count;
}


@end
