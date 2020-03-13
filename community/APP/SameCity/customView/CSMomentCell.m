//
//  CSMomentCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/18.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSMomentCell.h"

#define ItemWidth 112*K_SCALE


@implementation CSMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSMomentCell";
//    self.tableview = tableView;
    CSMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadNormal"]];
    [self.contentView addSubview:self.headImg];
    self.headImg.layer.cornerRadius = 4;
    self.headImg.clipsToBounds = YES;
    
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(10);
        make.width.height.equalTo(40);
    }];
    
    self.nameLab = [UILabel labelWithTitle:@"名字" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
        make.right.equalTo(-15);
    }];
    
    self.timeLab = [UILabel labelWithTitle:@"15分钟前" font:10 textColor:@"9b9b9b" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.timeLab];
    
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.left);
        make.bottom.equalTo(self.headImg.bottom).offset(-3);
    }];
    
    self.contentLab = [UILabel labelWithTitle:@"" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.contentLab];
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.left);
        make.top.equalTo(self.headImg.bottom).offset(5);
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
    
    UIImageView *playImg = [[UIImageView alloc]init];
    [self.videoBgView addSubview:playImg];
    playImg.image = [UIImage imageNamed:@"playBtn_icon"];
    [playImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBgView.centerX);
        make.centerY.equalTo(self.videoBgView.centerY);
    }];
    
    self.collectNumLab = [UILabel labelWithTitle:@"0" font:11 textColor:@"9b9b9b" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.collectNumLab];
    
    [self.collectNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.top.equalTo(self.containerView.bottom).offset(14);
    }];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setImage:[UIImage imageNamed:@"collect_gray"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"collect_hover"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.collectBtn];
    [self.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.collectNumLab.centerY);
        make.right.equalTo(self.collectNumLab.left).offset(-5);
    }];
    
    self.praiseNumLab = [UILabel labelWithTitle:@"0" font:11 textColor:@"9b9b9b" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.praiseNumLab];
    
    [self.praiseNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectBtn.left).offset(-35);
        make.centerY.equalTo(self.collectNumLab.centerY);
    }];
    
    self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.praiseBtn setImage:[UIImage imageNamed:@"praiseIcon"] forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"praise_hover"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.praiseBtn];
    [self.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.collectNumLab.centerY);
        make.right.equalTo(self.praiseNumLab.left).offset(-5);
    }];
    
    UIView *grayView = [[UIView alloc]init];
    [self.contentView addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(8);
        make.top.equalTo(self.collectNumLab.bottom).offset(14);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
}
-(void)playVideo{
    if (self.videoBlock) {
        self.videoBlock(@"11");
    }
}
-(void)collectAction:(UIButton *)sender{
    if (![UserTools isLogin]) {
        [[MYToast makeText:@"未登录"]show];
        return;
    }
    sender.selected = !sender.isSelected;
    NSLog(@"收藏");
    
    [[AppRequest sharedInstance]doRequestWithUrl:self.requstStr Params:@{@"user_id":[UserTools userID],@"post_id":self.postId} Callback:^(BOOL isSuccess, id result) {
        NSLog(@"加入收藏：：%@--%@",result,result[@"msg"]);
    } HttpMethod:AppRequestPost isAni:YES];
    
    self.model.is_favorite = sender.isSelected;
    if (sender.isSelected) {
        self.model.favorite_num = [NSString stringWithFormat:@"%ld",self.model.favorite_num.integerValue+1];
    }else{
        self.model.favorite_num = [NSString stringWithFormat:@"%ld",self.model.favorite_num.integerValue-1];
    }
    self.collectNumLab.text = self.model.favorite_num;
}

-(void)praiseAction:(UIButton *)sender{
    if (![UserTools isLogin]) {
        [[MYToast makeText:@"未登录"]show];
        return;
    }
    sender.selected = !sender.isSelected;
    
    self.model.is_like = sender.isSelected;
    
    if (sender.isSelected) {
        self.model.like_num = [NSString stringWithFormat:@"%ld",self.model.like_num.integerValue+1];
    }else{
        self.model.like_num = [NSString stringWithFormat:@"%ld",self.model.like_num.integerValue-1];
    }
    self.praiseNumLab.text = self.model.like_num;
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/Post/is_like" Params:@{@"user_id":[UserTools userID],@"post_id":self.postId} Callback:^(BOOL isSuccess, id result) {
        NSLog(@"点赞：：%@",result);
    } HttpMethod:AppRequestPost isAni:YES];
    
}

-(void)foldTextAction:(UIButton *)sender{
    
    self.isFold = !self.isFold;
    sender.selected = self.isFold;
        
    if (self.backBlock) {
        self.backBlock(sender);
    }
}
-(void)setModel:(CityContentModel *)model{
    _model = model;
    self.collectBtn.selected = model.is_favorite;
    self.praiseBtn.selected = model.is_like;
    self.postId = model.idss;
    
    self.praiseNumLab.text = model.like_num;
    self.collectNumLab.text = model.favorite_num;
    
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
            make.left.equalTo(self.headImg.left);
            make.top.equalTo(self.headImg.bottom).offset(5);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.greaterThanOrEqualTo(10);
        }];
//        [self.contentLab updateConstraints:^(MASConstraintMaker *make) {
//            make.height.lessThanOrEqualTo(2000);
//        }];
    }else{
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.left);
            make.top.equalTo(self.headImg.bottom).offset(5);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.lessThanOrEqualTo(60);
        }];
//        [self.contentLab updateConstraints:^(MASConstraintMaker *make) {
//            make.height.lessThanOrEqualTo(60);
//        }];
    }
    if (model.content.length == 0) {
        [self.contentLab remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.left);
            make.top.equalTo(self.headImg.bottom).offset(-10);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.height.equalTo(15);
        }];
    }
    
    self.nameLab.text = model.nick_name;
    
    
    if (model.avatar.length > 5) {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.avatar]] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
    }else if (model.user_avatar.length > 5) {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
    }
    
    self.timeLab.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    
    self.contentLab.text = model.content;
    
    if (model.path.count > 0 || model.video.length > 5) {
        [self.containerView refreshData:model.path];
        
        CGFloat sh = ItemWidth;
        if (model.path.count >6) {
            sh = ItemWidth*3 +10;
        }else if (model.path.count > 3){
            sh = ItemWidth*2 +5;
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
