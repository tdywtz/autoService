//
//  CZWNewsMessageNotificationViewController.m
//  autoService
//
//  Created by bangong on 15/12/25.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWNewsMessageNotificationViewController.h"

@implementation CZWNewsMessageNotificationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self createLeftItemBack];
}

-(void)createLeftItemBack{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"bar_btn_returnt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemBackClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)leftItemBackClick{
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 判断是否允许推送
- (BOOL)isAllowedNotification
{
    
    //iOS8 check if user allow notification
    
    if
        (SYSTEM_VERSION_GREATER_THAN(8.0)) {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            
            if
                (UIUserNotificationTypeNone != setting.types) {
                    
                    return
                    YES;
                }
        }
    else
    {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if(UIRemoteNotificationTypeNone != type)
            
            return 
            YES;
    }
    
    
    return 
    NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *uiSwitch = [[UISwitch alloc] init];
        uiSwitch.tag = 100 +indexPath.row;
        [cell.contentView addSubview:uiSwitch];
        [uiSwitch addTarget:self action:@selector(switchButton:) forControlEvents:UIControlEventValueChanged];
 
        [uiSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[uiSwitch]-20-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(uiSwitch)]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:uiSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }

        if (indexPath.row == 0) {
            UISwitch *witch = (UISwitch *)[cell.contentView viewWithTag:100];
            witch.on = ![RCIM sharedRCIM].disableMessageAlertSound;
             cell.textLabel.text = @"声音";
        }else {
             cell.textLabel.text = @"震动";
             UISwitch *witch = (UISwitch *)[cell.contentView viewWithTag:101];
            witch.on = [CZWManager manager].systemShakeState;
        }

    return cell;
}

-(void)switchButton:(UISwitch *)uiSwitch{
 
    if (uiSwitch.tag == 100) {
    
        [[RCIM sharedRCIM] setDisableMessageAlertSound:!uiSwitch.on];
    
    }else{
        [CZWManager manager].systemShakeState  =uiSwitch.on;
    }
}

@end
