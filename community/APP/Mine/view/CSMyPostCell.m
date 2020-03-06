//
//  CSMyPostCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/31.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSMyPostCell.h"

@implementation CSMyPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSMyPostCell";
    
    CSMyPostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.dayLabel = [UILabel labelWithTitle:@"日" font:26 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.dayLabel.font = [UIFont boldSystemFontOfSize:26];
    [self.contentView addSubview:self.dayLabel];
    
    [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(10);
    }];
    
    self.monthLabel = [UILabel labelWithTitle:@"月" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.monthLabel];
    
    [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.right).offset(3);
        make.bottom.equalTo(self.dayLabel.bottom);
    }];
    
    
    self.contentLab = [UILabel labelWithTitle:@"" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.contentLab];
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(85);
        make.top.equalTo(10);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.height.lessThanOrEqualTo(60);
    }];
    
    self.foldBtn = [UIButton buttonWithTitle:@"显示全文" font:11 titleColor:@"0000ff"];
    [self.foldBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.foldBtn addTarget:self action:@selector(foldTextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.foldBtn];
    self.foldBtn.clipsToBounds = YES;
    [self.foldBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.bottom);
        make.left.equalTo(self.contentLab.left);
        make.height.equalTo(20);
    }];
    
    CGFloat ss = 86*K_SCALE;
    self.containerView = [[PhotoContainer alloc]initWithSize:CGSizeMake(ss, ss)];
    [self.contentView addSubview:self.containerView];
    
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLab.left);
        make.width.equalTo(ss*3 + 10);
        make.top.equalTo(self.foldBtn.bottom).offset(5);
        make.height.equalTo(110*K_SCALE);
    }];
    
    self.videoBgView = [[UIView alloc]init];
    self.videoBgView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.videoBgView];
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
    [self.videoBgView addGestureRecognizer:playTap];
    [self.videoBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(85);
        make.width.equalTo(200);
        make.top.equalTo(self.foldBtn.bottom).offset(5);
        make.height.equalTo(110*K_SCALE);
    }];
    
    UIImageView *playImg = [[UIImageView alloc]init];
    [self.videoBgView addSubview:playImg];
    playImg.image = [UIImage imageNamed:@"playVideoBtn"];
    [playImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBgView.centerX);
        make.centerY.equalTo(self.videoBgView.centerY);
    }];
    
    self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.delBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    self.delBtn.tag = 66;
    [self.delBtn setTitleColor:[UIColor colorWithHexString:@"adadad"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.delBtn];
    [self.delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(self.containerView.bottom).offset(14);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(20);
    }];
    
    self.statusLab = [UILabel labelWithTitle:@"审核中" font:11 textColor:@"ff0000" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.statusLab];
    
    [self.statusLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.containerView.bottom).offset(14);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(20);
    }];
    
    
}
-(void)playVideo{
    if (self.videoBlock) {
        self.videoBlock(@"11");
    }
}
-(void)deleteAction:(UIButton *)sender{
    if (![UserTools isLogin]) {
        [[MYToast makeText:@"未登录"]show];
        return;
    }
    
    if (self.backBlock) {
        self.backBlock(sender);
    }
}


-(void)foldTextAction:(UIButton *)sender{
    
    self.isFold = !self.isFold;
    sender.selected = self.isFold;
        
    if (self.backBlock) {
        self.backBlock(sender);
    }
}
-(void)refreshCell:(CityContentModel *)model{
    
    self.postId = model.idss;
    
    if (model.status.intValue == 1) {
        self.statusLab.text = @"已通过";
        self.statusLab.textColor = [UIColor colorWithHexString:@"09c66a"];
    }else{
        self.statusLab.text = @"审核中";
        self.statusLab.textColor = [UIColor colorWithHexString:@"ff0000"];
    }
    
    if ([self getStringHeightWithText:model.content font:[UIFont systemFontOfSize:14] viewWidth:self.bounds.size.width -32] > 60) {

        self.foldBtn.hidden = NO;
        [self.foldBtn updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20);
        }];
    }else{
        [self.foldBtn updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1);
        }];
        self.foldBtn.hidden = YES;
    }
    
    self.isFold = model.isFold.boolValue;
    self.foldBtn.selected = self.isFold;
    
    if (self.isFold) {
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(85);
            make.top.equalTo(10);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.greaterThanOrEqualTo(10);
        }];

    }else{
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(85);
            make.top.equalTo(10);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.lessThanOrEqualTo(60);
        }];
    }
    if (model.content.length == 0) {
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(85);
            make.top.equalTo(10);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.equalTo(0.1);
        }];
    }
    
    
    self.contentLab.text = model.content;
    
    if (model.path.count > 0 || model.video.length > 5) {
        [self.containerView refreshData:model.path];
        CGFloat sh = 86*K_SCALE;
        if (model.path.count >6) {
            sh = 86*K_SCALE*3 +10;
        }else if (model.path.count > 3){
             sh = 86*K_SCALE*2 +5;
        }
        [self.containerView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sh);
        }];
        if (model.path.count > 0) {
            self.containerView.hidden = NO;
            self.videoBgView.hidden = YES;
        }
        if(model.video.length > 5){
            self.containerView.hidden = YES;
            self.videoBgView.hidden = NO;
        }
        
    }else{
        [self.containerView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0.1);
        }];
        self.videoBgView.hidden = YES;
        self.containerView.hidden = YES;
    }
    
    
    NSString *timeStr = [HelpTools dateStampWithTime:model.create_time.integerValue andFormat:@"YYYY-MM-dd"];
    self.dayLabel.text = [[timeStr componentsSeparatedByString:@"-"]lastObject];
    self.monthLabel.text = [[timeStr componentsSeparatedByString:@"-"][1] stringByAppendingString:@"月"];
    
}


- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。 ceilf向上取整
    return  ceilf(size.height);
}


@end
