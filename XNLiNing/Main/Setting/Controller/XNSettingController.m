//
//  XNSettingController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSettingController.h"
#import "XNSettingCell.h"
#import "XNSettingCollectionHeaderView.h"
#import "XNSettingCollectionFooterView.h"
#import "XNLoginController.h"

@interface XNSettingController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConH;

@end

static NSString *headerId = @"XNSettingCollectionHeaderView";
static NSString *footerId = @"XNSettingCollectionFooterView";
static NSString *cellId = @"XNSettingCell";

@implementation XNSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    self.collectionView.backgroundColor = XNAPPNormalBGColor;
    [self.collectionView registerClass:[XNSettingCell class] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XNSettingCollectionHeaderView class])
                                                    bundle:[NSBundle mainBundle]]
                                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:headerId];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XNSettingCollectionFooterView class])
                                                    bundle:[NSBundle mainBundle]]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:footerId];
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XNSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                        forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusable = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        XNSettingCollectionHeaderView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
        reusable = headerCell;
    } else if (kind == UICollectionElementKindSectionFooter) {
        XNSettingCollectionFooterView *footerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId forIndexPath:indexPath];
        [footerCell setBlock:^(BOOL isLogin) {
            if (isLogin) {
                XNUserDefaults *ud = [XNUserDefaults new];
                ud.userName = @"";
                ud.userPassword = @"";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:RCIM_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[RCIM sharedRCIM] disconnect:YES];
                [[RCIM sharedRCIM] logout];
                
                [XNAlertView showWithTitle:@"退出登录成功" done:^{
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    XNLoginController *loginVC = [[XNLoginController alloc] init];
                    [window setRootViewController:loginVC];
                }];
            } else {
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                XNLoginController *loginVC = [[XNLoginController alloc] init];
                [window setRootViewController:loginVC];
            }
        }];
        reusable = footerCell;

    }
    return reusable;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(XNScreen_Width, 200);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(XNScreen_Width, 80);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
