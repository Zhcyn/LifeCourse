#import "TCMeCell.h"
@implementation TCMeCell
{
    UIImageView *imgView;
    UILabel *tLb;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgView = [[UIImageView alloc] init];
        imgView.frame=CGRectMake(15, 15, 20, 20);
        [self.contentView addSubview:imgView];
        tLb = [[UILabel alloc] init];
        tLb.frame=CGRectMake(60, 10, self.contentView.frame.size.width-80, 30);
        tLb.font = [UIFont systemFontOfSize:16.0f];
        tLb.textAlignment=NSTextAlignmentLeft;
        tLb.textColor = [UIColor blackColor];
        [self.contentView addSubview:tLb];
    }
    return self;
}
-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;
    imgView.image=[UIImage imageNamed:dict[@"img"]];
    tLb.text=dict[@"title"];
}
@end
