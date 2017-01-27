//
//  AFNDemo.m
//  苍井空
//
//  Created by liuyi on 17/1/24.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "AFNDemo.h"
#import "AFNetworking.h"
#define XMGBoundary @"520it"
#define XMGEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]
#define XMGNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
@interface AFNDemo ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation AFNDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)get{
    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    //afHttpSessionManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    //    1. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
    //
    //       如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
    //       如果返回格式不是JSON的,
    //
    //    请求格式 requestSerializer
    //
    //    AFHTTPRequestSerializer            二进制格式
    //    AFJSONRequestSerializer            JSON
    //    AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
    //
    //    返回格式  responseSerializer
    //
    //    AFHTTPResponseSerializer           二进制格式
    //    AFJSONResponseSerializer           JSON
    //    AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    //    AFXMLDocumentResponseSerializer (Mac OS X)
    //    AFPropertyListResponseSerializer   PList
    //    AFImageResponseSerializer          Image
    //    AFCompoundResponseSerializer       组合
    
    [afHttpSessionManager GET:@"http://120.25.226.186:32812/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"get success:%@",responseObject);
        //回调是在主线程中，可以直接更新UI
        self.label.text = @"success";
        NSLog(@"%@", [NSThread currentThread]); ///<: 0x14e27e80>{number = 1, name = main}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get failure:%@",error);
    }];
}
- (void)post1{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    [sessionManager POST:@"http://120.25.226.186:32812/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post success:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post failure:%@",error);
    }];
    
}

- (void)post2{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it",
                             };
    
    [sessionManager POST:@"http://120.25.226.186:32812/login" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post success:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post failure:%@",error);
    }];
}

- (void)download{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [urlSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //fractionCompleted 下载的比列
        NSLog(@"progress:%f completed:%lld,totalcount:%lld",downloadProgress.fractionCompleted,downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载完成才会走这里。
        // 指定下载文件保存的路径
        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        NSLog(@"file url:%@", fileURL);
        
        return fileURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@ %@", filePath, error);
    }];
    [task resume];
}


- (void)uplod{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/upload"]];
    request.HTTPMethod = @"POST";
    
    // 设置请求头(告诉服务器,这是一个文件上传的请求)
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", XMGBoundary] forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    // 文件参数
    // 分割线
    [body appendData:XMGEncode(@"--")];
    [body appendData:XMGEncode(XMGBoundary)];
    [body appendData:XMGNewLine];
    
    // 文件参数名
    [body appendData:XMGEncode([NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"test.png\""])];
    [body appendData:XMGNewLine];
    
    // 文件的类型
    [body appendData:XMGEncode([NSString stringWithFormat:@"Content-Type: image/png"])];
    [body appendData:XMGNewLine];
    
    // 文件数据
    [body appendData:XMGNewLine];
    [body appendData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"]]];
    [body appendData:XMGNewLine];
    
    // 结束标记
    /*
     --分割线--\r\n
     */
    [body appendData:XMGEncode(@"--")];
    [body appendData:XMGEncode(XMGBoundary)];
    [body appendData:XMGEncode(@"--")];
    [body appendData:XMGNewLine];
    NSURLSessionUploadTask *task = [urlSessionManager uploadTaskWithRequest:request fromData:body progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"progress:%f completed:%lld,totalcount:%lld",uploadProgress.fractionCompleted,uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"completion responseObject:%@",responseObject);
    }];
    [task resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
