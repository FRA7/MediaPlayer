//
//  ViewController.m
//  MediaPlayer
//
//  Created by FRAJ on 2019/7/10.
//  Copyright © 2019 FRAJ. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayerViewController.h"

#import "DDTTYLogger.h"
#import "HTTPServer.h"
#import "HttpsConnection.h"

#define SCREEN_WIDTH        (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT       (CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewController ()

@property (nonatomic, strong) HTTPServer *httpServer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MediaPlayer";
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(10, 150, SCREEN_WIDTH-20, 40);
    [button1 setTitle:@"HTTP在线播放" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(httpOnlinePlay) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(10, 210, SCREEN_WIDTH-20, 40);
    [button2 setTitle:@"HTTP离线播放" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(openHttpServer) forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(10, 270, SCREEN_WIDTH-20, 40);
    [button3 setTitle:@"HTTPS在线播放" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(httpsOnlinePlay) forControlEvents:UIControlEventTouchUpInside];
    [button3 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(10, 330, SCREEN_WIDTH-20, 40);
    [button4 setTitle:@"HTTPS离线播放" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(openHttpsServer) forControlEvents:UIControlEventTouchUpInside];
    [button4 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button4];
    
}




-(void)httpOnlinePlay{
    
    NSString * url = @"http://domain.wooba.cn/static/yc/output/outputR.m3u8";
    
    VideoPlayerViewController *videoPlayerViewController = [[VideoPlayerViewController alloc] init];
    videoPlayerViewController.url = url;
    [self.navigationController pushViewController:videoPlayerViewController animated:YES];
    
}

- (void)openHttpServer {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    self.httpServer=[[HTTPServer alloc]init];
    [self.httpServer setType:@"_http._tcp."];
    [self.httpServer setPort:9479];//这里是设置服务器端口，端口号写一个不容易重复的即可
//    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//    NSString *webPath = [pathPrefix stringByAppendingPathComponent:@"Downloads"];//下载路径
    NSString *webPath = [[NSBundle mainBundle] bundlePath];
    
    [self.httpServer setDocumentRoot:webPath];//这一步在给服务器设置路径的时候，一定要注意和缓存TS数据的路径一致
    NSLog(@"服务器路径：%@", webPath);
    NSError *error;
    if ([self.httpServer start:&error]) {
        NSLog(@"开启HTTP服务器 端口:%hu",[self.httpServer listeningPort]);
        
        VideoPlayerViewController *videoPlayerViewController = [[VideoPlayerViewController alloc] init];
        videoPlayerViewController.url = @"http://127.0.0.1:9479/outputR.m3u8";
        [self.navigationController pushViewController:videoPlayerViewController animated:YES];
        
    }
    else{
        NSLog(@"服务器启动失败错误为:%@",error);
    }
}

-(void)httpsOnlinePlay{
    
    NSString * url = @"https://jth.tyread.com/static/yc/output/outputRS.m3u8";
    
    VideoPlayerViewController *videoPlayerViewController = [[VideoPlayerViewController alloc] init];
    videoPlayerViewController.url = url;
    [self.navigationController pushViewController:videoPlayerViewController animated:YES];
    
}

- (void)openHttpsServer {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    self.httpServer=[[HTTPServer alloc]init];
    [self.httpServer setType:@"_http._tcp."];
    [self.httpServer setConnectionClass:[HttpsConnection class]];//设置HTTPS服务
    [self.httpServer setPort:9479];//这里是设置服务器端口，端口号写一个不容易重复的即可
    //    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    //    NSString *webPath = [pathPrefix stringByAppendingPathComponent:@"Downloads"];//下载路径
    NSString *webPath = [[NSBundle mainBundle] bundlePath];
    
    [self.httpServer setDocumentRoot:webPath];//这一步在给服务器设置路径的时候，一定要注意和缓存TS数据的路径一致
    NSLog(@"服务器路径：%@", webPath);
    NSError *error;
    if ([self.httpServer start:&error]) {
        NSLog(@"开启HTTPS服务器 端口:%hu",[self.httpServer listeningPort]);
        
        VideoPlayerViewController *videoPlayerViewController = [[VideoPlayerViewController alloc] init];
        videoPlayerViewController.url = @"https://127.0.0.1:9479/outputR.m3u8";
        [self.navigationController pushViewController:videoPlayerViewController animated:YES];
        
    }
    else{
        NSLog(@"服务器启动失败错误为:%@",error);
    }
}
@end
