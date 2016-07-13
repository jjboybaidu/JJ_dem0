//
//  JJTableViewRowAction.m
//  JJTableViewRowAction
//
//  Created by farbell-imac on 16/7/13.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJTableViewRowAction.h"

@interface JJTableViewRowAction()<UITableViewDataSource,UITableViewDelegate>
{
    UITableViewRowAction *deleteRowAction;
    UITableViewRowAction *moreRowAction;
    UITableViewRowAction *sanRowAction;
    UITableViewRowAction *toRowAction;
    UITableViewRowAction *detailRowAction;
    NSMutableArray * cellarray;
}

@end

@implementation JJTableViewRowAction

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果省略了这步就没有数据
    cellarray = [NSMutableArray array];
    NSArray *array = @[@"滑动编辑一",@"滑动编辑二",@"滑动编辑三",@"滑动编辑四"];
    [cellarray addObjectsFromArray:array];
    //FIXME:下面这种添加方法不对？
    // [cellarray addObject:@[@"滑动编辑一",@"滑动编辑二",@"滑动编辑三",@"滑动编辑四"]];
    self.title=@"滑动编辑";
    [self setupTableView];
}

- (void)setupTableView{
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellarray.count;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text =  cellarray[indexPath.row];;
    return cell;
}

#if 0
// Edit the cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //更新数据
        [cellarray removeObjectAtIndex:indexPath.row];
        //更新UI
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
#endif

// Return a array,system will show the content of array for each indexpath row
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0){
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            //1.更新数据
            [cellarray removeObjectAtIndex:indexPath.row];
            //2.更新UI
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        }];
        
        detailRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"细节" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            NSLog(@"点击了细节");
            UIViewController *detailVC = [[UIViewController alloc]init];
            detailVC.view.backgroundColor = [UIColor grayColor];
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
        detailRowAction.backgroundColor=[UIColor brownColor];
        
        
    }
    else if (indexPath.row==1){
        
        // 添加一个修改按钮
        moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了修改");
        }];
        moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            //1.更新数据
            [cellarray removeObjectAtIndex:indexPath.row];
            //2.更新UI
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        }];
        
        
    }
    else if (indexPath.row==2){
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            //1.更新数据
            [cellarray removeObjectAtIndex:indexPath.row];
            //2.更新UI
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            
        }];
        
        // 添加一个修改按钮
        moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了修改");
        }];
        moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        // 添加一个发送按钮
        
        sanRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"发送" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了发送");
        }];
        sanRowAction.backgroundColor=[UIColor orangeColor];
        
    }
    else{
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            //1.更新数据
            [cellarray removeObjectAtIndex:indexPath.row];
            //2.更新UI
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            
        }];
        
        // 添加一个修改按钮
        moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了修改");
        }];
        moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        // 添加一个发送按钮
        
        sanRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"发送" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了发送");
        }];
        sanRowAction.backgroundColor=[UIColor orangeColor];
        // 添加一个发送按钮
        
        toRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了置顶");
            //1.更新数据
            [cellarray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
            //2.更新UI,下面的数字可以控制移动到哪个cell的位置，如果是置顶，就填0，具体看效果
            NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        }];
        toRowAction.backgroundColor=[UIColor purpleColor];
        
        
    }
    
    // 将设置好的按钮放到数组中返回
    if (indexPath.row==0) {
        return @[deleteRowAction,detailRowAction];
        
    }else if (indexPath.row==1){
        return @[moreRowAction,deleteRowAction];
        
    }else if(indexPath.row==2){
        return @[deleteRowAction,moreRowAction,sanRowAction];
        
    }else if(indexPath.row==3){
        return @[deleteRowAction,moreRowAction,sanRowAction,toRowAction];
        
    }
    return nil;
}


@end
