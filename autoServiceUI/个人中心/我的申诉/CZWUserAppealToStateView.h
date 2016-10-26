//
//  CZWUserAppealToStateView.h
//  autoService
//
//  Created by bangong on 15/12/24.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CZWUserAppealToStateViewState){
    CZWUserAppealToStateViewStatePass,
    CZWUserAppealToStateViewStateNow,
    CZWUserAppealToStateViewStateFuture
};
@interface CZWUserAppealToStateView : UIView

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIImageView *arrowImageView;

- (instancetype)initWithText:(NSString *)text State:(CZWUserAppealToStateViewState)state last:(BOOL)last;
@end
