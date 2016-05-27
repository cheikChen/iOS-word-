//
//  ViewController.m
//  demo
//
//  Created by Cheik.chen on 16/5/6.
//  Copyright © 2016年 fx. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>

@interface ViewController ()<QLPreviewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) QLPreviewController *qlpreviewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _progressView.progress = 0;
    _qlpreviewController = [[QLPreviewController alloc] init];
    _qlpreviewController.dataSource = self;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSString *file = [self getFile];
    // 加载沙盒的文件数据
    NSData *data = [NSData dataWithContentsOfFile:file];
    
    if(!data)
    {
        NSURLSession *session = [NSURLSession sharedSession];
//        NSURL *url = [NSURL URLWithString:@"http://my.job592.com/baike/doc_docGet.action?id=2468&uid=fe893922fba5bc64918fcbab39678463&time=1462520838&filename=2468.doc"];
        NSURL *url = [NSURL URLWithString:@"http://my.job592.com/baike/doc_docGet.action?id=2005&uid=2729eb1f3e1c099ab1b3a1608aad12ac&time=1462760376&filename=2005.doc"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(!error)
            {
                NSLog(@"下载完成");
                NSData *data1 = [NSData dataWithContentsOfURL:location];
                [data1 writeToFile:file atomically:YES];
            }
            
            
        }] resume];
    }

}
- (IBAction)btnClick:(UIButton *)sender {
    
//     [self.navigationController pushViewController:_qlpreviewController animated:YES];
     [self presentViewController:_qlpreviewController animated:YES completion:nil];
    
}

#pragma mark - qlpreViewdataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
//返回一个需要加载文件的URL
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller
                     previewItemAtIndex:(NSInteger)index {
   
    
    return [NSURL fileURLWithPath:[self getFile]];
}

-(NSString *)getFile{

    // 获得Library/Caches文件夹
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 获得文件名
    NSString *filename = @"2005.doc";
    // 计算出文件的全路径
    NSString *file = [cachesPath stringByAppendingPathComponent:filename];

    NSLog(@"%@",file);
    return file;
}


@end
