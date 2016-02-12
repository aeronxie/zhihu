//
//  ThemeData.m
//  Zhihu
//
//  Created by 谢飞 on 16/2/11.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "ThemeData.h"
#import "StoriesModel.h"
#import "UIImageView+WebCache.h"
#import "EditorMoedel.h"


@interface ThemeData()<UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *editors;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) ThemeCellConfigureBlock configureCellBlock;

@end

@implementation ThemeData

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems editors:(NSArray *)editors
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(ThemeCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.editors = editors;
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}



- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.row];
}

#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        for (NSInteger i = 0; i < self.editors.count; i++) {
            EditorMoedel *editor = self.editors[i];
            UIImageView *avatar = [[UIImageView alloc]init];
            [avatar sd_setImageWithURL:[NSURL URLWithString:editor.avatar] placeholderImage:[UIImage imageNamed:@"Account_Avatar"]];
            avatar.clipsToBounds = YES;
            avatar.layer.cornerRadius = 10;
            avatar.contentMode = UIViewContentModeScaleAspectFit;
            avatar.frame = CGRectMake( 60 + (i * 20) + (i * 10), 10, 20, 20);
            [cell.contentView addSubview:avatar];
            
        }
        cell.textLabel.text = @"主编";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
    
    
}

@end


