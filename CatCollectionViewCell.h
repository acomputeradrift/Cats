//
//  CatCollectionViewCell.h
//  Cats
//
//  Created by Jamie on 2018-08-16.
//  Copyright © 2018 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *catImageView;
@property (weak, nonatomic) IBOutlet UILabel *catTitleLabel;

@end
