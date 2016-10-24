//
//  EditViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "EditImageViewController.h"
#import "EditImageCell.h"
#import "CZWBasicPanNavigationController.h"

@interface EditImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    CGPoint _velocity;
   // NSInteger _index;
}
@end

@implementation EditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createLeftItemBack];
    [self createRightItem];
    [self createCollcetionView];
   
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.imageArray.count];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        NSIndexPath *path = [NSIndexPath indexPathForItem:self.index inSection:0];
        [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    });
    
}



-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn setImage:[UIImage imageNamed:@"auto_deleteImageSymbol"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    if (self.imageArray.count == 0) {
        return;
    }
    
    [self.imageArray removeObjectAtIndex:_index];
    if (self.block) {
        self.block(_index);
    }
    [_collectionView reloadData];
    if (_collectionView.contentOffset.x > 0) {
        _collectionView.contentOffset = CGPointMake(_collectionView.contentOffset.x-WIDTH, 0);
    }
    _index = _collectionView.contentOffset.x/WIDTH;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",_index+1,self.imageArray.count];
    if (self.imageArray.count == 0){
        self.navigationItem.title = @"0/0";
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }
}

-(void)createCollcetionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[EditImageCell class] forCellWithReuseIdentifier:@"collectioncell"];
    
   [_collectionView makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(UIEdgeInsetsZero);
   }];
}

#pragma mark - UICollectionViewDataSource/delegate

//每一个view就是一行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];//复用
    //NSLog(@"%@",self.assetArray);

    cell.image = self.imageArray[indexPath.row];
    return cell;
}




#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(WIDTH,HEIGHT-64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = scrollView.contentOffset.x/WIDTH;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",_index+1,self.imageArray.count];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
//        NSLog(@"+++++++++++++%ld",_index);
//        __weak __typeof(self)weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            printf("STOP IT!!\n");
//            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//            if (_velocity.x > 0 ) {
//                NSInteger k = _index+1 < weakSelf.imageArray.count?_index+1:weakSelf.imageArray.count-1;
//                NSIndexPath *path = [NSIndexPath indexPathForItem:k inSection:0];
//                [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//            }else if(_velocity.x < 0 ){
//                NSInteger k = _index-1 >= 0?_index-1:0;
//                NSIndexPath *path = [NSIndexPath indexPathForItem:k inSection:0];
//                [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//            }
//        });
    }
}


-(void)deleteImage:(deleteImage)block{
    self.block = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
