//
//  CZWChatViewController.m
//  autoService
//
//  Created by bangong on 15/12/17.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWChatViewController.h"
#import "CZWBasicPanNavigationController.h"
#import "CZWChatImageViewController.h"
#import "CZWLocationViewController.h"
#import "CZWTextMessage.h"
#import "CZWFriendsNotificationCell.h"

#include "CZWUserInformationViewController.h"
#include "CZWExpertInformationViewController.h"
#import "LHAssetPickerController.h"

@interface CZWChatViewController ()

@end

@implementation CZWChatViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self createLeftItem];
    [[RCIM sharedRCIM] clearUserInfoCache];
    self.enableSaveNewPhotoToLocalSystem = YES;
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
    self.displayUserNameInCell = NO;

    [self.conversationMessageCollectionView registerClass:[CZWFriendsNotificationCell class] forCellWithReuseIdentifier:@"CZWFriendsNotificationCell"];
    
}

-(void)createLeftItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 30);
    [button setImage:[UIImage imageNamed:@"bar_btn_returnt"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemBackClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)leftItemBackClick{

        [self.navigationController popViewControllerAnimated:YES];
    
}

//- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
//    
//    messageCotent.senderUserInfo = userInfo;
//    return messageCotent;
//}

//- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message{
//    message.content.senderUserInfo = userInfo;
//    return message;
//}

//将要展示时
//- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
//  
//    if ([cell isKindOfClass:[RCMessageCell class]]) {
//        RCMessageCell *messageCell = (RCMessageCell *)cell;
//        RCMessageModel *model = self.conversationDataRepository[indexPath.row];
//  
//        UIImageView *iocnIamgeView = (UIImageView *)messageCell.portraitImageView;
//        if ([model.senderUserId isEqualToString:[CZWManager manager].rongyunID]) {
//             messageCell.nicknameLabel.text = self.targetInfo.userName;
//            if (self.sendInfo.image) {
//                iocnIamgeView.image = self.sendInfo.image;
//            }else{
//                [iocnIamgeView sd_setImageWithURL:[NSURL URLWithString:self.sendInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"userIconDefaultImage"]];
//            }
//            
//            if ([self.sendInfo.type isEqualToString:@"2"]) {
//                iocnIamgeView.layer.cornerRadius = 22.5;
//                iocnIamgeView.layer.masksToBounds = YES;
//            }else{
//                iocnIamgeView.layer.cornerRadius = 3;
//                iocnIamgeView.layer.masksToBounds = YES;
//            }
//        }else{
//            messageCell.nicknameLabel.text = self.targetInfo.userName;
//            if (self.targetInfo.image) {
//                iocnIamgeView.image = self.targetInfo.image;
//            }else{
//                 [iocnIamgeView sd_setImageWithURL:[NSURL URLWithString:self.sendInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"expertIconDefaultImage"]];
//            }
//            
//            if ([self.targetInfo.type isEqualToString:@"2"]) {
//                iocnIamgeView.layer.cornerRadius = 22.5;
//                iocnIamgeView.layer.masksToBounds = YES;
//            }else{
//                iocnIamgeView.layer.cornerRadius = 3;
//                iocnIamgeView.layer.masksToBounds = YES;
//            }
//
//        }
//    
//    }
//}

//未知消息cell
//
//- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
//                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//  
//    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
//
//    if ([model.content isMemberOfClass:[RCContactNotificationMessage class]]) {
//       // RCContactNotificationMessage *message = (RCContactNotificationMessage *)model.content;
//       
//        RCTextMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZWFriendsNotificationCell" forIndexPath:indexPath];
//        cell.model = model;
//        return cell;
//    }
//    return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
//}
//
//- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
//                                layout:(UICollectionViewLayout *)collectionViewLayout
//                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
//    RCMessageContent *messageContent = model.content;
//    if ([messageContent isMemberOfClass:[RCContactNotificationMessage class]]) {
//      
//        return CGSizeMake(collectionView.frame.size.width, 66);
//    } else {
//        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
//    }
//}
//
//
//- (RCMessageBaseCell *)rcUnkownConversationCollectionView:(UICollectionView *)collectionView
//                                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
//    NSLog(@"message objectName = %@", model.objectName);
//    RCUnknownMessageCell *cell = [collectionView
//                           dequeueReusableCellWithReuseIdentifier:@"friends"
//                           forIndexPath:indexPath];
//    [cell setDataModel:model];
//    NSLog(@"============================'");
//    return cell;
//}
//
//- (CGSize) rcUnkownConversationCollectionView:(UICollectionView *)collectionView
//                                       layout:(UICollectionViewLayout *)collectionViewLayout
//                       sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
//  //  NSLog(@"message objectName = %@", model.objectName);
//    return CGSizeMake(collectionView.frame.size.width, 66);
//}

- (void)didTapCellPortrait:(NSString *)userId{

    NSString *url = [NSString stringWithFormat:auto_infoByRYID,userId];
    url  = [NSString stringWithFormat:@"%@&val=1",url];
    [CZWAFHttpRequest GET:url success:^(id responseObject) {
        if ([responseObject count]) {
            NSDictionary *dict = [responseObject firstObject];
            if ([dict[@"type"] isEqualToString:USERTYPE_EXPERT]) {
                CZWExpertInformationViewController *info = [[CZWExpertInformationViewController alloc] init];
                info.eid = dict[@"uid"];
                [self.navigationController pushViewController:info animated:YES];
            }else if([dict[@"type"] isEqualToString:USERTYPE_USER]){
                CZWUserInformationViewController *user = [[CZWUserInformationViewController alloc] init];
                user.userID = dict[@"uid"];
                [self.navigationController pushViewController:user animated:YES];
            }
        }

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark override
/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param model 图片消息model
 */
- (void)presentImagePreviewController:(RCMessageModel *)model{

    CZWChatImageViewController *iamgeCtro = [[CZWChatImageViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:iamgeCtro];
    iamgeCtro.messageModel = model;
    [self presentViewController:nvc animated:YES completion:nil];

}

#pragma mark override
/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageContent 位置消息
 */
- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent{
    CZWLocationViewController *location = [[CZWLocationViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:location];
    location.locationName =  locationMessageContent.locationName;
    location.location = locationMessageContent.location;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didSendMessage:(NSInteger)stauts content:(RCMessageContent *)messageCotent{
    if ([messageCotent isKindOfClass:[RCImageMessage class]]) {
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.conversationDataRepository.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else{
        [super didSendMessage:stauts content:messageCotent];
    }
}

#pragma mark - RCPluginBoardViewDelegate

/**
 *  点击事件
 *
 *  @param pluginBoardView 功能模板
 *  @param tag             标记
 */
-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag{
   
    if (tag == 1001) {
        LHAssetPickerController *picker = [[LHAssetPickerController alloc] init];
        picker.maxNumber = 9;
        __weak __typeof(self)weakSelf = self;
        [picker getAssetArray:^(NSArray *assetArray) {
            NSTimeInterval time = 0.0;
            for ( int i = 0; i < assetArray.count; i ++) {
                ALAsset *asset = assetArray[i];
                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                     [strongSelf sendImageMessage:imageMessage pushContent:@"图片"];
                });
                time = time+i*0.2;
            }
        }];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

@end
