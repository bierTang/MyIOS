

#import "CopyRightCell.h"

@implementation CopyRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CopyRightCell";
    CopyRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell =[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    UILabel *label = [UILabel labelWithTitle: [@"©2020 WeiQunSheQu JBJW开发团队 V." stringByAppendingString: str] font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

@end
