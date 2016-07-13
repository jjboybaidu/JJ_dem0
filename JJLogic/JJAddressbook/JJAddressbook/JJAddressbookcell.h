//
//  JJAddressbookcell.h
//  JJAddressbook
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJAddressbookcell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel1;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageview1;

+ (JJAddressbookcell *)cell:(UITableView *)tableView;

@end
