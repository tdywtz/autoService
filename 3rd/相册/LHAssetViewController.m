//
//  LHAssetViewController.m
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import "LHAssetViewController.h"
#import "LHAssetViewCell.h"
#import "LHAssetPickerController.h"
#import "LHPageViewcontroller.h"

#define myHeight [UIScreen mainScreen].bounds.size.height
#define myWidth [UIScreen mainScreen].bounds.size.width

@interface LHAssetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{

    UIButton *rigthBtn;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,weak) LHAssetPickerController *picker;

@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) ALAsset *aseet;

@end

@implementation LHAssetViewController
- (void)dealloc
{
    [_assetArray removeAllObjects];
 
    _assetArray = nil;
    _aseet = nil;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    self.navigationItem.title = [self.assetGroup valueForProperty:ALAssetsGroupPropertyName];
    self.picker = (LHAssetPickerController *)self.navigationController;
    _resultArray = [[NSMutableArray alloc] init];
  
    [self createLeftItem];
    [self createRightItem];
    [self createCollcetionView];
    [self setAssetArray];
    [self createFootView];
    
}

-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self createButtonWithFrame:CGRectMake(0, 0, 15, 40) Target:self action:@selector(blockClick) ImageName:@"item_left" Text:nil]];
}

-(void)blockClick{
    [_assetArray removeAllObjects];

    _assetArray = nil;
    _aseet = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createRightItem{
    rigthBtn = [self createButtonWithFrame:CGRectMake(0, 0, 40, 20) Target:self action:@selector(rightClick) ImageName:nil  Text:@"取消"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigthBtn];
}

-(UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action ImageName:(NSString *)name Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeScaleAspectFit];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)rightClick{
    [_assetArray removeAllObjects];

    _assetArray = nil;
    _aseet = nil;

    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)createFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, myHeight-40, myWidth, 40)];
    view.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    view.alpha = 0.8;
    [self.view addSubview:view];
    UIButton *btnLeft = [self createButonWithFrame:CGRectMake(10, 0, 40, 40) Text:@"预览" Color:[UIColor whiteColor] Target:self Action:@selector(footClick:)];
    [view addSubview:btnLeft];
    
    UIButton *btnRight = [self createButonWithFrame:CGRectMake(myWidth-50, 0, 40, 40) Text:@"完成" Color:[UIColor whiteColor] Target:self Action:@selector(footClick:)];
    [view addSubview:btnRight];
    [view addSubview:btnRight];
    
}

-(void)footClick:(UIButton *)btn{

    if ([btn.titleLabel.text isEqualToString:@"完成"]) {
       
        if (_resultArray.count > 0) {
            if (self.picker.getAsset) {
                self.picker.getAsset(_resultArray);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if (_resultArray.count == 0) {
            [self alertView:@"还没有选择图片"];
            return;
        }
        LHPageViewcontroller *preview = [LHPageViewcontroller initWithSpace:15];
        preview.assets = _resultArray;
        [preview setViewControllerWithCurrent:0];
        [self .navigationController pushViewController:preview animated:NO];
    }
}

#pragma mark - 创建按钮
-(UIButton *)createButonWithFrame:(CGRect)frame Text:(NSString *)text Color:(UIColor *)color Target:(id)target Action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)createCollcetionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, myWidth, myHeight-40) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
   
    [_collectionView registerClass:[LHAssetViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
}

-(void)setAssetArray{
    if (!self.assetArray) {
        _assetArray = [[NSMutableArray alloc] init];
    }else{
        [self.assetArray removeAllObjects];
    }
    __weak __typeof(self)weakSelf = self;
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [weakSelf.assetArray addObject:result];
        }
        else{
            [weakSelf.collectionView reloadData];
        }
    }];
}


#pragma mark - UICollectionViewDataSource/delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView//设置有多少个段
{
    return 1;
}
//每一个view就是一行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    LHAssetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];//复用
    __weak __typeof(self)weakSelf = self;
   [cell getResult:^(ALAsset *result, BOOL add,NSInteger num) {
       if (add) {
           if (weakSelf.resultArray.count == weakSelf.picker.maxNumber) {
           
               [weakSelf.collectionView reloadData];
               return;
           }
           weakSelf.aseet = weakSelf.assetArray[num];
           [weakSelf.resultArray addObject:weakSelf.assetArray[num]];
       }else{
           [weakSelf.resultArray removeObject:weakSelf.assetArray[num]];
       }
       [weakSelf.collectionView reloadData];
   }];
    
 
    cell.isSelect = NO;
 
    for (int i = 0; i < _resultArray.count; i ++) {
        if ([_resultArray[i] isEqual:self.assetArray[indexPath.row]]) {
            cell.isSelect = YES;
            break;
        }
    }
    cell.maxNum = self.picker.maxNumber;
    cell.num = indexPath.row;
    cell.asset = self.assetArray[indexPath.row];
    return cell;
}

-(void)alertView:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    [UIView animateWithDuration:0.3 animations:^{
        [al dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    LHAssetPreviewController *preview = [[LHAssetPreviewController alloc] init];
//    preview.assetArray = self.assetArray;
//    preview.resultArray = _resultArray;
//    preview.index = indexPath.row;
//    
//    [preview getRsuelt:^(NSArray *array) {
//        if (array) {
//            [_resultArray setArray:array];
//            [_collectionView reloadData];
//        }
//    }];
//
//    [self .navigationController pushViewController:preview animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    return CGSizeMake(WIDTH/4-2, WIDTH/4-2);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section//设置页眉的高度
//{
//    return CGSizeMake(30, 30);//当竖着滚，横坐标没用，横着滚，纵坐标没用
//}


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
