#import "TCUserItemsViewController.h"
@interface TCUserItemsViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end
@implementation TCUserItemsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=LocalString(@"User notice");
    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView *webview=[[UIWebView alloc] initWithFrame:CGRectMake(10,TopBarHeight+15, SCREEN_WIDTH-20, CONTENT_HEIGHT-AeraSizeHeight-15)];
    webview.delegate=self;
    webview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:webview];
    _webView=webview;
    [self loadLocalHtml];
}
-(void)loadLocalHtml{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"userItems.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    BOOL isLoad = [webView isLoading];
    if (isLoad) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"var script = document.createElement('script');"
                     "script.type = 'text/javascript';"
                     "script.text = \"function ResizeImages() { "
                     "var myimg,oldwidth;"
                     "var maxwidth=%f;" 
                     "for(i=0;i <document.images.length;i++){"
                     "myimg = document.images[i];"
                     "if(myimg.width > maxwidth){"
                     "oldwidth = myimg.width;"
                     "myimg.width = maxwidth;"
                     "myimg.height = myimg.height * (maxwidth/oldwidth)/ (maxwidth/oldwidth);"
                     "}"
                     "}"
                     "}\";"
                     "document.getElementsByTagName('head')[0].appendChild(script);",SCREEN_WIDTH-50];
    [_webView stringByEvaluatingJavaScriptFromString:str];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
@end
