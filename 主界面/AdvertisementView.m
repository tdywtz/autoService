//
//  AdvertisementView.m
//  autoService
//
//  Created by bangong on 16/6/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "AdvertisementView.h"
#import <ImageIO/ImageIO.h>
#import "CZWAdvertisementViewController.h"
#import "CZWComprehensiveInformationViewController.h"

@interface GifImageView : UIImageView
{
    CGImageSourceRef source;
}
@property (nonatomic,weak) AdvertisementView *prasentView;

@end

@implementation GifImageView

//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url
               returnData:(void(^)(NSArray<UIImage *> * imageArray,
                                   NSArray<NSNumber *>*timeArray,
                                   CGFloat totalTime,
                                   NSArray<NSNumber *>* widths,
                                   NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
   
    if (!source) {
         source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    }
   // CGImageSourceRemoveCacheAtIndex(source, 2);
   
    CGFloat height = 0;
    if (source) {
        height = WIDTH/7;
        
    }else{
        return;
    }
    [_prasentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放所有图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

-(void)yh_setImage:(NSURL *)imageUrl{
    
    __weak id __self = self;
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        CFTimeInterval currentTime = 0.5;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
//            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
//            currentTime+=[timeArray[i] floatValue];
            [times addObject:@(0.5)];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层添加
        [[(UIImageView *)__self layer] addAnimation:animation forKey:@"gifAnimation"];
    }];
}



@end

#pragma  mark - AdvertisementView
@implementation AdvertisementView
{
    GifImageView *_gifIamgeView;
    NSDictionary *_dictionary;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
 
        _gifIamgeView = [[GifImageView alloc] init];
        _gifIamgeView.prasentView = self;
        [self addSubview:_gifIamgeView];
        [_gifIamgeView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
    }
    return self;
}


- (void)tapGesture{
    CZWAdvertisementViewController *advertisement = [[CZWAdvertisementViewController alloc] init];
   
    NSInteger skipType  =  [_dictionary[@"skipType"] integerValue];

    if (skipType == 1) {
        advertisement.title = _dictionary[@"title"];
        advertisement.urlString = _dictionary[@"skipUrl"];
        [self.prasentViewController.navigationController pushViewController:advertisement animated:YES];

    }else if (skipType == 2){
        CZWComprehensiveInformationViewController *vc = [[CZWComprehensiveInformationViewController alloc] init];
        vc.fid = _dictionary[@"fid"];
        [self.prasentViewController.navigationController pushViewController:vc animated:YES];
    }
}

-(void)loadGifImage{
  
    [CZWAFHttpRequest GET:auto_DTopAdv success:^(id responseObject) {
        _dictionary = responseObject;

        if ([_dictionary[@"advUrl"] length]) {
            [_gifIamgeView yh_setImage:[NSURL URLWithString:_dictionary[@"advUrl"]]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData{
    [_gifIamgeView yh_setImage:[NSURL URLWithString:_dictionary[@"advUrl"]]];
}
@end
