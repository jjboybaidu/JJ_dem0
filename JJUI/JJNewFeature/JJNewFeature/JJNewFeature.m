//
//  JJNewFeature.m
//  JJNewFeature
//
//  Created by WilliamLiuWen on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
/*
 实现功能：
 1.图片浏览
 2.有页码控制
 3.可以控制张数
 */

#import "JJNewFeature.h"
#import "JJNewFeaturecell.h"
#define numberPageControl 6 // 多少页新特性
#define numberOfItemsInSectionCount 6

static NSString *ID = @"cell";

@interface JJNewFeature ()

@property (nonatomic, weak) UIPageControl *pagecontrol;

@end

@implementation JJNewFeature


#pragma mark 重写init方法
// 重写init方法，利用init创建UICollectionViewController对象的时候
// 直接给对象视图布局UICollectionViewFlowLayout
- (instancetype)init{
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 个性化布局：设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    // 个性化布局：清空行距
    // 个性化布局：清空图片和图片之前的距离
    layout.minimumLineSpacing = 0;
    // 个性化布局：设置滚动的方向
    // 个性化布局：设置水平滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 返回布局
    return [super initWithCollectionViewLayout:layout];
}


#pragma mark 初始化ViewDidLoad
// self.collectionView != self.view
// 注意： self.collectionView 是 self.view的子控件
// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell
- (void)viewDidLoad {
    [super viewDidLoad];
    // self define cell
    [self.collectionView registerClass:[JJNewFeaturecell class] forCellWithReuseIdentifier:ID];
    // 设置collectionview的分页功能
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // setupPageControl
    [self setupPageControl];
}

// We needn't set the size of pagecontrol because of it can't change,and we have to set the numberofpages,and set pagecontrol color,and set pagecontrol point,
- (void)setupPageControl{
    UIPageControl *control = [[UIPageControl alloc] init];
    control.numberOfPages = numberPageControl;
    control.pageIndicatorTintColor = [UIColor blackColor];// normal
    control.currentPageIndicatorTintColor = [UIColor redColor];// when choose
    control.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height-20);
    self.pagecontrol = control;
    [self.view addSubview:control];
}

#pragma mark - UIScrollView Delegate
// It will revoke if scroll,to cal page number,and set the currentpage
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    self.pagecontrol.currentPage = page;
}


#pragma mark - UICollectionView DataSource
// Number of section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// Number of cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return numberOfItemsInSectionCount;
}

#pragma mark - UICollectionView数据源：cell的数据
// Cell with picture
// 这个cell主要是用来显示图片的
// dequeueReusableCellWithReuseIdentifier
// 1.首先从缓存池里取cell
// 2.看下当前是否有注册Cell,如果注册了cell，就会帮你创建cell
// 3.没有注册，报错
// 拼接图片名称 3.5 320 480
// 针对不同的设备显示不同的图片
// 这里没有图片资源，所以不实现
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JJNewFeaturecell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"JJ_newfeature_%ld",indexPath.row + 1];
    
    //    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    //    if (screenH > 480) { // 5 , 6 , 6 plus
    //        imageName = [NSString stringWithFormat:@"new_feature_%ld-568h",indexPath.row + 1];
    //    }
    cell.image = [UIImage imageNamed:imageName];
    
    // 判断是否为最后一页
    [cell setIndexPath:indexPath count:numberOfItemsInSectionCount];
    return cell;
}

@end
