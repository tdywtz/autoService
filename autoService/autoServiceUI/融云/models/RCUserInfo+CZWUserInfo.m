//
//  RCUserInfo+CZWUserInfo.m
//  autoService
//
//  Created by bangong on 15/12/29.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "RCUserInfo+CZWUserInfo.h"
#import <objc/runtime.h>

@implementation RCUserInfo (CZWUserInfo)

- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait phone:(NSString *)phone addressInfo:(NSString *)addressInfo realName:(NSString *)realName{
    
    if (self = [super init]) {
        
        self.userId        =   userId;
        
        self.name          =   username;
        
        self.portraitUri   =   portrait;
        
        self.phone         =   phone;
        
        self.addressInfo   =   addressInfo;
        
        self.realName     =   realName;
        
    }
    
    return self;
    
}

//添加属性扩展set方法

char* const PHONE = "PHONE";

char* const ADDRESSINFO = "ADDRESSINFO";

char* const REALNAME   = "REALNAME";



-(void)setPhone:(NSString *)newPhone{
    
    objc_setAssociatedObject(self,PHONE,newPhone,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)setAddressInfo:(NSString *)newAddressInfo{
    
    objc_setAssociatedObject(self,ADDRESSINFO,newAddressInfo,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRealName:(NSString *)nweRealName{
    
    objc_setAssociatedObject(self,REALNAME,nweRealName,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//添加属性扩展get方法

-(NSString *)phone{
    
    return objc_getAssociatedObject(self,PHONE);
    
}

-(NSString *)addressInfo{
    
    return objc_getAssociatedObject(self,ADDRESSINFO);
    
}

-(NSString *)realName{
    
    return objc_getAssociatedObject(self,REALNAME);
    
}

@end
