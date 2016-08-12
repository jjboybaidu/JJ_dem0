//
//  JJAddressbookcell.m
//  JJAddressbook
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJAddressbookcell.h"

@implementation JJAddressbookcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (JJAddressbookcell *)cell:(UITableView *)tableView{
    
    static NSString *ID = @"Contactcell";
    
    JJAddressbookcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JJAddressbookcell" owner:nil options:nil]lastObject];
        
    }
    
    return cell;
}

@end
