//
//  AdvertisementView.h
//  autoService
//
//  Created by bangong on 16/6/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  广告
 */
@interface AdvertisementView : UIView

@property (nonatomic,weak) UIViewController *prasentViewController;
- (void)loadGifImage;
- (void)reloadData;
@end
