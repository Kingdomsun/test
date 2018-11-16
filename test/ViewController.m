//
//  ViewController.m
//  test
//
//  Created by Kingdom on 2018/9/14.
//  Copyright © 2018年 Liukang. All rights reserved.
//

#import "ViewController.h"
#import "LYIMONewsReadInfoModel.h"
#import "MJExtension.h"
#import "SSZipArchive.h"

@interface ViewController ()

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) int timeNum;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginChange) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)beginChange
{
    _timeNum ++;
    NSLog(@"time = %d",_timeNum);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:[self getFilePath]];
    if (result) {
        [self deleteSameZipFile];
        NSLog(@"ddddd");
    }else
    {
        NSLog(@"aaaaaa");
        NSMutableArray *array = [[NSMutableArray alloc]init]; //用来盛放数据的value
        NSData *json_data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        [json_data writeToFile:[self getFilePath] atomically:YES];
    }
//    [self deleteSameZipFile];
//
//    NSMutableArray *array = [[NSMutableArray alloc]init]; //用来盛放数据的value
//
//    for (int i =0; i<0; i++)
//    {
//        LYIMONewsReadInfoModel *model = [LYIMONewsReadInfoModel new];
//        model.UserID = @"000221330";
//        model.NewsID = @"155466652264556555";
//        model.Accesslike = @"grf";
//        model.AccessTime = @"1000";
//        model.AccessNum = @"23";
//        model.ResidenceTime = @"562";
//        model.CommentsNum = @"56";
//        model.AccessWay = @"IOS";
//        [array addObject:[model mj_keyValues]];
//    }
//
//
//    NSData *json_data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
//    [json_data writeToFile:[self getFilePath] atomically:YES];
    
    
}
- (IBAction)addData:(id)sender
{
    NSArray *array = [self readLocalFile];
    
    NSMutableArray *objArray = [NSMutableArray array];
    [objArray addObjectsFromArray:array];
    
    
    LYIMONewsReadInfoModel *model = [LYIMONewsReadInfoModel new];
    model.UserID = @"sssssssssss";
    model.NewsID = @"155466652264556555";
    model.Accesslike = @"grf";
    model.AccessTime = @"1000";
    model.AccessNum = @"23";
    model.ResidenceTime = @"562";
    model.CommentsNum = @"56";
    model.AccessWay = @"IOS";
    [objArray addObject:[model mj_keyValues]];
    
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:objArray options:NSJSONWritingPrettyPrinted error:nil];
    [json_data writeToFile:[self getFilePath] atomically:YES];
}

- (IBAction)zipFiles:(id)sender
{
    /*
     第一个参数:压缩文件的存放位置
     第二个参数:要压缩哪些文件(路径)
     */
    
    NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Caches/readInfo.zip"];
    
    NSArray *array = @[[self getFilePath]];
    [SSZipArchive createZipFileAtPath:path withFilesAtPaths:array];
    
}

//删除本地文件夹里面相同的文件夹
- (void)deleteSameZipFile
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    NSString *extension = @"readInfo.zip";
    
    while ((filename = [e nextObject])) {
        
        if ([filename isEqualToString:extension]) {
            
            //上传zip文件
            //完成后删除
            [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

- (NSString*)getFilePath
{
    NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Caches/newsReadInfo.json"];
    NSLog(@"newsReadInfo = %@",path);
    return path;
}

// 读取本地JSON文件
- (NSMutableArray *)readLocalFile
{
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}




@end
