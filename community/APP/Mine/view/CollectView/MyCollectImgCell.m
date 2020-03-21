//
//  MyCollectImgCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/22.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "MyCollectImgCell.h"

@implementation MyCollectImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"MyCollectImgCell";
    MyCollectImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.contentLab = [UILabel labelWithTitle:@"" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.contentLab];
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(5);
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
    
    CGFloat ss = ItemWidth;
    self.containerView = [[PhotoContainer alloc]initWithSize:CGSizeMake(ss, ss)];
    [self.contentView addSubview:self.containerView];
    
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLab.left);
        make.width.equalTo(ss*3 + 10);
        make.top.equalTo(self.foldBtn.bottom).offset(5);
        make.height.equalTo(ss);
    }];
    
    self.videoBgView = [[UIView alloc]init];
    self.videoBgView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.videoBgView];
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
    [self.videoBgView addGestureRecognizer:playTap];
    [self.videoBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.width.equalTo(200);
        make.top.equalTo(self.foldBtn.bottom).offset(5);
        make.height.equalTo(110*K_SCALE);
    }];
    
    self.videoBgImg = [[UIImageView alloc]init];
    [self.videoBgView addSubview:self.videoBgImg];
    self.videoBgImg.contentMode = UIViewContentModeScaleAspectFill;
    self.videoBgImg.layer.masksToBounds = YES;
    [self.videoBgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.top.equalTo(0);
    }];
    
    UIImageView *playImg = [[UIImageView alloc]init];
    [self.videoBgView addSubview:playImg];
    playImg.image = [UIImage imageNamed:@"playBtn_icon"];
    playImg.contentMode = UIViewContentModeScaleAspectFit;
    [playImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBgView.centerX);
        make.centerY.equalTo(self.videoBgView.centerY);
    }];
    
    self.nameLab = [UILabel labelWithTitle:@"名字" font:11 textColor:@"adadad" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.containerView.bottom);
//        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(32);
    }];
    
    self.timeLab = [UILabel labelWithTitle:@"" font:11 textColor:@"adadad" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.timeLab];
    
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.right).offset(25);
        make.centerY.equalTo(self.nameLab.centerY);
    }];
    
    UIButton *delBtn = [UIButton buttonWithTitle:@"删除" font:11 titleColor:@"adadad"];
    [delBtn addTarget:self action:@selector(cancelCollect:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:delBtn];
    delBtn.tag = 66;
    [delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLab.centerY);
        make.right.equalTo(-16);
    }];
    
    UIView *grayView = [[UIView alloc]init];
    [self.contentView addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(8);
        make.top.equalTo(self.nameLab.bottom);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}
-(void)cancelCollect:(UIButton *)sender{
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


-(void)refreshModel:(CityContentModel *)model{
    
    if (model.video.length > 5) {
        self.containerView.hidden = YES;
        self.videoBgView.hidden = NO;
        [self.videoBgImg sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    }else if(model.images.count > 0){
        self.containerView.hidden = NO;
        self.videoBgView.hidden = YES;
    }else{
        self.containerView.hidden = YES;
        self.videoBgView.hidden = YES;
    }
    
    self.nameLab.text = model.nick_name;
    
    if ([self getStringHeightWithText:model.content font:[UIFont systemFontOfSize:14] viewWidth:self.bounds.size.width -32] > 60) {
        
        self.foldBtn.hidden = NO;
        [self.foldBtn updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20);
        }];
    }else{
        
        [self.foldBtn updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0.01);
        }];
        self.foldBtn.hidden = YES;
    }
    
    self.isFold = model.isFold.boolValue;
    self.foldBtn.selected = self.isFold;
    
    if (self.isFold) {
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(5);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.greaterThanOrEqualTo(10);
        }];
        
    }else{
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(5);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.lessThanOrEqualTo(60);
        }];
       
    }
    
    
    if (model.video && model.title) {
        self.contentLab.text = model.title;
    }else{
        self.contentLab.text = model.content;
    }
    self.timeLab.text = [HelpTools distanceTimeWithBeforeTime:model.create_time.doubleValue];
    
    if (model.images.count > 0 || model.video.length > 5) {
        [self.containerView refreshData:model.images];
        CGFloat sh = ItemWidth;
        if (model.images.count >6) {
            sh = ItemWidth*3 +10;
        }else if (model.images.count > 3){
             sh = ItemWidth*2 +5;
        }
        [self.containerView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sh);
        }];
        if (model.images.count > 0) {
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
        self.containerView.hidden = YES;
    }
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
-(void)playVideo{
    if (self.videoBlock) {
        self.videoBlock(@"11");
    }
}

@end
