//
//  CZWMyAccountViewController.h
//  autoService
//
//  Created by bangong on 16/4/6.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWBasicViewController.h"

/**绑定\修改-支付宝账号*/
@interface CZWMyAccountViewController : CZWBasicViewController

@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) void(^success)();
//**绑定成功*/
-(void)success:(void(^)())block;

@end
