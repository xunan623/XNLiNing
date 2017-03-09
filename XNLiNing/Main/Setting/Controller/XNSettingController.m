//
//  XNSettingController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSettingController.h"
#import "XNSettingHeaderView.h"
#import "XNSettingCell.h"

@interface XNSettingController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) XNSettingHeaderView *topView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConH;

@end

static NSString *headerId = @"XNSettingHeaderView";

@implementation XNSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    [self.collectionView registerClass:[XNSettingCell class] forCellWithReuseIdentifier:@"XNSettingCell"];
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XNSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XNSettingCell class])
                                                                    forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    if (indexPath.row == 0) {
        [cell addSubview:self.topView];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return (CGSize){XNScreen_Width, 200};
    }
    return (CGSize){(XNScreen_Width-5)/4,(XNScreen_Width-5)/4};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

#pragma mark - Setting && Getting
- (XNSettingHeaderView *)topView {
    if (!_topView) {
        _topView = [XNSettingHeaderView msGetInstance];
    }
    return _topView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
