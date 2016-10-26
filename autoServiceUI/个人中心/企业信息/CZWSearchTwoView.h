//
//  CZWSearchTwoView.h
//  autoService
//
//  Created by bangong on 16/8/12.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZWSearchTwoView : UIView

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *imageUrl;

- (void)loadData;

@end
