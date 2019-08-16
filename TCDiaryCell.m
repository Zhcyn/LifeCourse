#import "TCDiaryCell.h"
#import "DHDeviceUtil.h"
#import "ICLanguageTool.h"
@implementation TCDiaryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.contentView.frame.size.width-30, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textColor = [DHDeviceUtil colorWithHexString:@"#111111"];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,50, self.contentView.frame.size.width-30, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.textColor = [DHDeviceUtil colorWithHexString:@"#666666"];
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}
@end
