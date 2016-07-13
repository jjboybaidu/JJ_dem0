//
//  JJNewFeaturecell.h
//  JJNewFeature
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJNewFeaturecell : UICollectionViewCell

// UIImage
@property (nonatomic, strong) UIImage *image;

// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;

@end
