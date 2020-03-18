//
//  SessionImgCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/30.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "SessionImgCell.h"
#import "SDPhotoBrowser.h"

@interface SessionImgCell () <SDPhotoBrowserDelegate>

@end

@implementation SessionImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"SessionImgCell";
    SessionImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.backgroundColor = [UIColor clearColor];
    self.bgImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImg];
    /////
    
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
    [self.contentView addSubview:self.headImg];
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(10);
        make.height.width.equalTo(34);
    }];
    
    self.userNameLab = [UILabel labelWithTitle:@"用户名" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
    }];
    
    self.timeLabel = [UILabel labelWithTitle:@"时间" font:9 textColor:@"999999" textAlignment:NSTextAlignmentLeft];
      [self.contentView addSubview:self.timeLabel];
      [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(self.contentView.centerX);
          make.top.equalTo(self.headImg.top).offset(-3);
      }];
    ///带箭头的背景框
    UIImage *img = [UIImage imageNamed:@"chatBgImg"];
    // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(25, 15, 8, 8) resizingMode:UIImageResizingModeStretch];
    self.bgImg.image = img;
    
    self.Img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData"]];
    [self.contentView addSubview:self.Img];
    
    CGFloat maxWidth = 200*K_SCALE;
    CGFloat maxHeight = 300*K_SCALE;
    
//    self.Img.contentMode = UIViewContentModeScaleAspectFill;
    self.Img.clipsToBounds = YES;
    [self.Img makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(32);
        make.left.equalTo(self.headImg.right).offset(12);
        make.width.lessThanOrEqualTo(maxWidth);
        make.height.lessThanOrEqualTo(maxHeight);
        make.height.greaterThanOrEqualTo(90);
        make.width.greaterThanOrEqualTo(100);

    }];
    self.Img.userInteractionEnabled = YES;
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage)];
    [self.Img addGestureRecognizer:self.tap];
    self.tap.enabled = NO;
    
    self.describLab = [MLEmojiLabel new];
    self.describLab.delegate = self;
    self.describLab.font = [UIFont systemFontOfSize:14];
    self.describLab.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentView addSubview:self.describLab];
    self.describLab.numberOfLines = 0;
    
    [self.describLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Img.left);
        make.top.equalTo(self.Img.bottom).offset(5);
        make.width.equalTo(self.Img.width);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(30);
        make.bottom.equalTo(self.describLab.bottom).offset(3);
        make.right.equalTo(self.Img.right).offset(3);
    }];
}


-(void)refreshCell:(SessionModel *)model{
//    [self.Img sd_setImageWithURL:[NSURL URLWithString:model.content] placeholderImage:nil];
    __weak typeof(self) wself = self;
    self.timeLabel.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    NSLog(@"mmmmmmmm:%@--%@",model.content,model.images);
    self.userNameLab.text = model.nick_name;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
    self.imageUrl = [NSString stringWithFormat:@"%@%@",mainHost,model.content];
    [self.Img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.content]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            wself.tap.enabled = YES;
            CGFloat maxWidth = 200*K_SCALE;
            CGFloat maxheight = 300*K_SCALE;
            CGFloat ww = image.size.width;
            CGFloat hh = image.size.height;
            if (ww>=hh) {
                if (ww>maxWidth) {
                    ww = maxWidth;
                    hh = image.size.height * (maxWidth/image.size.width);
                }
            }else{
                if (hh>maxheight) {
                    hh = maxheight;
                    ww = image.size.width * (maxheight/image.size.height);
                }
            }
            

            [wself.Img updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(5);
//                make.left.equalTo(18);
                make.width.lessThanOrEqualTo(ww);
                make.height.lessThanOrEqualTo(hh);
            }];

            
        }
    }];
    if (model.descriptions.length > 0) {
        self.describLab.text = model.descriptions;
    }
   
}
-(void)showBigImage{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = 0;
    browser.sourceImagesContainerView = self.contentView;
    browser.imageCount = 1;
    browser.delegate = self;
    [browser show];
}

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (![link hasPrefix:@"http"]) {
        link = [NSString stringWithFormat:@"http://%@",link];
    }
    if (link.length > 5 && ([link containsString:@"www"]||[link containsString:@"http"])) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link]];
        }
    }
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
   
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.Img;
    return imageView.image;
}
@end
