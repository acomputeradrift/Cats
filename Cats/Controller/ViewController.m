//
//  ViewController.m
//  Cats
//
//  Created by Jamie on 2018-08-16.
//  Copyright © 2018 Jamie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray <Cat*> *catsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.catsArray = [[NSArray alloc] init];
    Cat *cat1 = [[Cat alloc] init];
    Cat *cat2 = [[Cat alloc] init];
    cat1.catImage = [UIImage imageNamed:@"tumblr_p4mlkqEO8J1sljr6oo1_500"];
    cat2.catImage = [UIImage imageNamed:@"tumblr_static_tumblr_static__640"];
    cat1.title = @"tumblr_p4mlkqEO8J1sljr6oo1_500";
    cat2.title = @"tumblr_p4mlkqEO8J1sljr6oo1_500";
    self.catsArray = [[NSArray alloc] initWithObjects:cat1,cat2,nil];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatCollectionViewCell" forIndexPath:indexPath];
//    //get item in array at index

    Cat *cat = self.catsArray[indexPath.item];
    cell.catImageView.image = cat.catImage;
   //set cell image
    cell.catTitleLabel.text = cat.title;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catsArray.count;
}


@end
