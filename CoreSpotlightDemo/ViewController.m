//
//  ViewController.m
//  CoreSpotlightDemo
//
//  Created by shenzhenshihua on 2018/9/17.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()

@end

@implementation ViewController
//https://blog.csdn.net/qq_30513483/article/details/51718975
// github  https://github.com/iHTCboy/CoreSpotlightSearchDemo
- (void)viewDidLoad {
    [super viewDidLoad];
    [self supportSpotlightSearch];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)supportSpotlightSearch {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            NSArray * keyWords = @[@"海洋", @"发自", @"鲁", @"我的位置", @"星星评价", @"音乐"];
            NSArray * desceip = @[@"演示正常", @"演示带有时间", @"演示通讯录", @"显示导航", @"演示星星评价", @"演示音乐"];
            //创建SearchableItems的数组
            NSMutableArray *searchableItems = [[NSMutableArray alloc] initWithCapacity:keyWords.count];
            
            for (NSInteger i = 0; i < keyWords.count; i++) {
                CSSearchableItemAttributeSet * itemButs = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
                if (i == 1) {
                    // 设置 为 邮件模式 【 右上角有时间】
                    itemButs.contentType = (NSString*)kUTTypeMessage;
                    itemButs.contentCreationDate = [NSDate date];
                }
                if (i == 2) {
                    // 设置为通讯录  只有第一个号码可以打
                    itemButs.phoneNumbers = @[@"13066839134", @"13045861053"];
                    itemButs.supportsPhoneCall = @1;
                }
                if (i == 3) {
                    // 导航功能
                    itemButs.longitude = @113.270793;
                    itemButs.latitude = @23.135308;
                    itemButs.supportsNavigation = @1;
                }
                if (i == 4) {
                    // 评价带星星
                    itemButs.contentType = (NSString*) kUTTypeAudio;
                    itemButs.rating = @3.5;
                    itemButs.ratingDescription = @"高分3.5分";
                }
                if (i == 5) {
                    // 音乐
                    itemButs.contentType = (NSString*) kUTTypeAudio;
                    itemButs.album = @"album";
                    itemButs.lyricist = @"lyricist";
                    itemButs.composer = @"composer";
                    itemButs.artist = @"artist";
                    itemButs.musicalGenre = @"Rock";
                    itemButs.recordingDate = [NSDate date];
                    itemButs.audioSampleRate = @(44100.0);
                }
                
                //添加title
                itemButs.title = keyWords[i];
                //添加 详情
                itemButs.contentDescription = desceip[i];
                // 图片
                itemButs.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"logo.png"]);
                // 这个设置没有用呢？
//                itemButs.thumbnailURL = [NSURL URLWithString:@"http://olxnvuztq.bkt.clouddn.com/63b85e5cfb57.png"];
                
                //属性集合与条目进行关联
                CSSearchableItem * searchItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"%ld", i+1] domainIdentifier:@"SH.CoreSpotlightDemo" attributeSet:itemButs];
                
                [searchableItems addObject:searchItem];
            }
            
            //把条目数组与索引进行关联
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@",error);
                }
            }];

            
        }
        @catch (NSException *exception) {
                     NSLog(@"%s, %@", __FUNCTION__, exception);
        }
        @finally {
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
