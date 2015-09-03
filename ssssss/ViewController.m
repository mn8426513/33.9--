//
//  ViewController.m
//  ssssss
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/**
 所有网络请求,统一使用异步请求!
 
 在今后的开发中,如果使用简单的get/head请求,可以用NSURLConnction异步方法
 GET查/POST增/PUT改/DELETE删/HEAD
 
 GET
 1> URL
 2> NSURLRequest
 3> NSURLConnction 异步
 
 POST
 1> URL
 2> NSMutableURLRequest
 .httpMethod = @"POST";
 str 从 firebug直接粘贴,或者自己写
 变量名1=数值1&变量名2=数值2
 
 .httpData = [str dataUsingEncoding:NSUTF8StringEncoding];
 3> NSURLConnction 异步
 
 */



-(void)data{

    NSString *str  = [NSString stringWithFormat:@"www.baidu.com"];
    
    //创建URL
       // 1. 加载网页 和 打电话 发短信 发邮件 等这些 的URL的创建方式
    NSURL *url = [NSURL URLWithString:str];
       // 2. 加载沙盒中的文件或者自己创建的一个NSBundle包中的文件的时候 用这个方法创建URL
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"沙盒中的文件名称" withExtension:nil];

    
    //将URL转换成 NSURLRequest
       //  1. 不加任何的的一些属性
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
       //  2. 加一些必要的属性，在项目中使用的一种方式
    
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1 cachePolicy:0 timeoutInterval:10];
 
    
    
    
    
    // 发送请求到服务器
    
      //1.使用webview去下载数据
             //1.1  相对简单加载
              [[[UIWebView alloc] init] loadRequest:request];
             //1.2  根据MIMETYPE 下载数据
               NSURLResponse *response =nil;
               NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
                          // 在iOS开发中,如果不是特殊要求,所有的文本编码都是用UTF8
                          // 先用UTF8解释接收到的二进制数据流
              [[[UIWebView alloc]init] loadData:data MIMEType:response.MIMEType textEncodingName:@"UTF8" baseURL:nil];
    
    
       //2.使用NSURLConnection 下载数据
    
             [NSURLConnection sendAsynchronousRequest:request1 queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
              if (connectionError == nil) {
                 // 网络请求结束之后执行!
                 // 将Data转换成字符串
              NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  
                  
            
                 // num = 2
                    NSLog(@"%@ %@", str, [NSThread currentThread]);
            
                 // 更新界面
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        //   此处写一些界面刷新的代码
                                                                         }];
                                           }
               }];
          NSLog(@"come here %@", [NSThread currentThread]);
    
    
        // 3. 使用网络请求代理方法 （已经10多岁了）
        // 是一个很古老的技术
      NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
      // 开始工作,在很多多线程技术中,start run
      dispatch_async(dispatch_queue_create("demo", DISPATCH_QUEUE_CONCURRENT), ^{
        [connection start];
      });
}

#pragma mark - NSURLConnectionDataDelegate代理方法
#pragma mark 接受到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 准备工作
    // 按钮点击就会有网络请求,为了避免重复开辟空间
    //    if (!self.data) {
    //        self.data = [NSMutableData data];
    //    } else {
    //        [self.data setData:nil];
    //    }
}

#pragma mark 接收到数据,如果数据量大,例如视频,会被多次调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 拼接数据,二进制流的体现位置
    // [self.data appendData:data];
}

#pragma mark 接收完成,做最终的处理工作
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 最终处理
    // NSString *str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    // NSLog(@"%@ %@", str, [NSThread currentThread]);
}

#pragma mark 出错处理,网络的出错可能性非常高
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}
@end
