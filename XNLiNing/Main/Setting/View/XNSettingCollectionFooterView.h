//
//  XNSettingCollectionFooterView.h
//  XNLiNing
//
//  Created by xunan on 2017/3/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionFooterViewBlock)(BOOL isLogin);

@interface XNSettingCollectionFooterView : UICollectionReusableView

@property (nonatomic, copy) CollectionFooterViewBlock block;
- (void)setBlock:(CollectionFooterViewBlock)block;

@end
