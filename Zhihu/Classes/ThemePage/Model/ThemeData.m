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
#import "EditoCell.h"


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
    return self.items[indexPath.row - 1];
}

#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EditoCell *cell = [[EditoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" editors:self.editors];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
    
    
}

@end


