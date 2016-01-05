//
//  ViewController.h
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSTextField *urlLabel;
- (IBAction)transferClick:(id)sender;
@property (nonatomic, strong) NSMutableArray* allDic;
@property (nonatomic, strong) NSString *classFormater;
@property (nonatomic, strong) NSString *propertyFormater;
@property (weak) IBOutlet NSTextField *jsonField;
@property (nonatomic, strong) NSMutableDictionary* classDict;
@property (nonatomic, copy) NSString *interface;
@property (nonatomic, copy) NSString *implementation;
@end

