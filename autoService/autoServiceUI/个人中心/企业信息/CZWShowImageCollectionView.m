
//
//  CZWShowImageCollectionView.m
//  autoService
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShowImageCollectionView.h"
#import "CZWShowImagePageViewController.h"

@interface ShowIamgeCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ShowIamgeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imageView];
    }
    return self;
}

@end


@interface CZWShowImageCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>


@end

@implementation CZWShowImageCollectionView

+ (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
   // [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
   CZWShowImageCollectionView *_collectionView = [[CZWShowImageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.cellSize = CGSizeMake(100, 100);
        self.cellInsets = UIEdgeInsetsZero;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[ShowIamgeCell class] forCellWithReuseIdentifier:@"collectioncell"];
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
   
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentSize.height);
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowIamgeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CZWShowImagePageViewController *page = [[CZWShowImagePageViewController alloc] init];
    page.imageUrlArray = self.dataArray;
    page.pageIndex = indexPath.row;
    [self.parentViewController.navigationController pushViewController:page animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return self.cellInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during aniation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
