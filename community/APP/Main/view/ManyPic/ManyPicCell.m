//
//  ManyPicCell.m
//  community
//
//  Created by MAC on 2019/12/24.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "ManyPicCell.h"


@implementation ManyPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"ManyPicCell";
    ManyPicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadNormal"]];
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
    
    if (!self.imgArr) {
        self.imgArr = [NSMutableArray new];
    }else{
        [self.imgArr removeAllObjects];
    }
    
    for (int i =0; i<9; i++) {
        UIImageView *imgView1 = [[UIImageView alloc]init];
        [self.contentView addSubview:imgView1];
        imgView1.contentMode = UIViewContentModeScaleAspectFill;
        imgView1.clipsToBounds = YES;
        imgView1.hidden = YES;
        [imgView1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(12);
            make.width.equalTo(100);
            make.height.equalTo(100);
            make.top.equalTo(25);
        }];
        imgView1.tag = i;
        imgView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        [imgView1 addGestureRecognizer:tap];

        [self.imgArr addObject:imgView1];
    }

    
    self.describLab = [MLEmojiLabel new];
    self.describLab.delegate = self;
    self.describLab.font = [UIFont systemFontOfSize:14];
    self.describLab.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentView addSubview:self.describLab];
    self.describLab.numberOfLines = 0;
    
    [self.describLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(160);
        make.width.equalTo(250*K_SCALE);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(23);
        make.bottom.equalTo(self.describLab.bottom).offset(3);
        make.width.equalTo(265*K_SCALE);
    }];
}

-(void)showBigImage:(UITapGestureRecognizer *)tap{
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    NSInteger tag = tap.view.tag;
//    if (!tag) {
//        tag = 0;
//    }
//    browser.currentImageIndex = tag;
//    browser.sourceImagesContainerView = self.contentView;
//    browser.imageCount = self.imgURLArr.count;
//    browser.delegate = self;
//    [browser show];
    
    
    if(self.backBlock){
            NSInteger tag = tap.view.tag;
            if (!tag) {
                tag = 0;
            }
        NSLog(@"设置的tag是%ld",(long)tag);
        self.backBlock([NSString stringWithFormat:@"%ld",tag]);
    }
    
    
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@",self.imgURLArr[index]];
    NSURL *url = [NSURL URLWithString:imageUrl];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.imgArr[index];
    return imageView.image;
}
-(void)refreshCell:(SessionModel *)model{
    CGFloat kk = K_SCALE;
    self.timeLabel.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    self.userNameLab.text = model.nick_name;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
     
    self.describLab.text = model.descriptions;
    
    //首先全部隐藏
    for (UIImageView *img in self.imgArr){
        img.hidden = YES;
    }
    
    
    self.imgURLArr = model.images_array;
    for (int a =0; a<model.images_array.count; a++) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@",model.images_array[a]];
        [self.imgArr[a] sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
        self.imgArr[a].hidden = NO;

    }
    
    if (model.images_array.count == 1) {
        UIImageView *imgview = self.imgArr[0];
        [imgview remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(15);
            make.top.equalTo(32);
            make.width.equalTo(252*kk);
            make.height.equalTo(142*kk);
        }];
        
        [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(8);
            make.top.equalTo(30);
            make.bottom.equalTo(imgview.bottom).offset(6);
            make.right.equalTo(imgview.right).offset(6);
        }];
    }else if (model.images_array.count == 2){
        UIImageView *imgview1 = self.imgArr[0];
        [imgview1 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(15);
            make.top.equalTo(32);
            make.width.equalTo(125*kk);
            make.height.equalTo(165*kk);
        }];
        
        UIImageView *imgview2 = self.imgArr[1];
        [imgview2 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview1.right).offset(2);
            make.top.equalTo(32);
            make.width.equalTo(125*kk);
            make.height.equalTo(165*kk);
        }];
        
    }else if (model.images_array.count == 3 || model.images_array.count == 6 || model.images_array.count ==9){
        UIImageView *imgview = self.imgArr[0];
        [imgview remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(15);
            make.top.equalTo(32);
            make.width.equalTo(252*kk);
            make.height.equalTo(142*kk);
        }];
        UIImageView *imgview1 = self.imgArr[1];
        [imgview1 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview.left);
            make.top.equalTo(imgview.bottom).offset(2);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        
        UIImageView *imgview2 = self.imgArr[2];
        [imgview2 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview1.right).offset(2);
            make.top.equalTo(imgview1.top);
            make.width.equalTo(125*kk);
            make.height.equalTo(165*kk);
        }];
        if (model.images_array.count == 3) {
            [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImg.right).offset(5);
                make.top.equalTo(30);
                make.bottom.equalTo(imgview1.bottom).offset(3);
                make.right.equalTo(imgview2.right).offset(3);
            }];
        }else if (model.images_array.count > 3){
            UIImageView *imgview3 = self.imgArr[3];
            UIImageView *imgview4 = self.imgArr[4];
            UIImageView *imgview5 = self.imgArr[5];
            [imgview3 remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgview.left);
                make.top.equalTo(imgview1.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [imgview4 remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgview3.right).offset(2);
                make.top.equalTo(imgview3.top);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [imgview5 remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(imgview.right);
                make.top.equalTo(imgview3.top);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            if (model.images_array.count > 6) {
                UIImageView *imgview6 = self.imgArr[6];
                UIImageView *imgview7 = self.imgArr[7];
                UIImageView *imgview8 = self.imgArr[8];
                [imgview6 remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imgview.left);
                    make.top.equalTo(imgview4.bottom).offset(2);
                    make.width.equalTo(82.5*kk);
                    make.height.equalTo(125*kk);
                }];
                [imgview7 remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imgview3.right).offset(2);
                    make.top.equalTo(imgview6.top);
                    make.width.equalTo(82.5*kk);
                    make.height.equalTo(125*kk);
                }];
                [imgview8 remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(imgview.right);
                    make.top.equalTo(imgview6.top);
                    make.width.equalTo(82.5*kk);
                    make.height.equalTo(125*kk);
                }];
                [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.headImg.right).offset(5);
                    make.top.equalTo(30);
                    make.bottom.equalTo(imgview8.bottom).offset(3);
                    make.right.equalTo(imgview.right).offset(3);
                }];
            }else{
                [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.headImg.right).offset(5);
                    make.top.equalTo(30);
                    make.bottom.equalTo(imgview5.bottom).offset(3);
                    make.right.equalTo(imgview.right).offset(3);
                }];
            }
            
        }
        
    }else if (model.images_array.count == 4 || model.images_array.count == 7){
        UIImageView *imgview = self.imgArr[0];
        UIImageView *imgview1 = self.imgArr[1];
        UIImageView *imgview2 = self.imgArr[2];
        UIImageView *imgview3 = self.imgArr[3];
        
        [imgview remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(12);
            make.top.equalTo(32);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        
        [imgview1 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview.right).offset(2);
            make.top.equalTo(32);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        
        [imgview2 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview.left);
            make.top.equalTo(imgview.bottom).offset(2);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        
        [imgview3 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview2.right).offset(2);
            make.top.equalTo(imgview.bottom).offset(2);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        if (model.images_array.count >4) {
            UIImageView *imgview4 = self.imgArr[4];
            UIImageView *imgview5 = self.imgArr[5];
            UIImageView *imgview6 = self.imgArr[6];
            [imgview4 remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgview.left);
                make.top.equalTo(imgview2.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [imgview5 remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgview4.right).offset(2);
                make.top.equalTo(imgview2.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [imgview6 remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(imgview1.right);
                make.top.equalTo(imgview2.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            
            [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImg.right).offset(5);
                make.top.equalTo(30);
                make.bottom.equalTo(imgview6.bottom).offset(3);
                make.right.equalTo(imgview1.right).offset(3);
            }];
        }else{
            [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImg.right).offset(5);
                make.top.equalTo(30);
                make.bottom.equalTo(imgview3.bottom).offset(3);
                make.right.equalTo(imgview1.right).offset(3);
            }];
        }
        
    }else if (model.images_array.count == 5 || model.images_array.count == 8){
        UIImageView *imgview = self.imgArr[0];
        UIImageView *imgview1 = self.imgArr[1];
        UIImageView *imgview2 = self.imgArr[2];
        UIImageView *imgview3 = self.imgArr[3];
        UIImageView *imgview4 = self.imgArr[4];
        [imgview remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(12);
            make.top.equalTo(32);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        
        [imgview1 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview.right).offset(2);
            make.top.equalTo(32);
            make.width.equalTo(125*kk);
            make.height.equalTo(125*kk);
        }];
        
        [imgview2 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview.left);
            make.top.equalTo(imgview1.bottom).offset(2);
            make.width.equalTo(82.5*kk);
            make.height.equalTo(125*kk);
        }];
        [imgview3 remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgview2.right).offset(2);
            make.top.equalTo(imgview1.bottom).offset(2);
            make.width.equalTo(82.5*kk);
            make.height.equalTo(125*kk);
        }];
        [imgview4 remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgview1.right);
            make.top.equalTo(imgview1.bottom).offset(2);
            make.width.equalTo(82.5*kk);
            make.height.equalTo(125*kk);
        }];
         NSLog(@"应该没：：33");
        if (model.images_array.count > 5) {
            UIImageView *imgview5 = self.imgArr[5];
            UIImageView *imgview6 = self.imgArr[6];
            UIImageView *imgview7 = self.imgArr[7];
             NSLog(@"应该没：：66");
            [imgview5 remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgview.left);
                make.top.equalTo(imgview2.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [imgview6 remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgview5.right).offset(2);
                make.top.equalTo(imgview2.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [imgview7 remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(imgview1.right);
                make.top.equalTo(imgview2.bottom).offset(2);
                make.width.equalTo(82.5*kk);
                make.height.equalTo(125*kk);
            }];
            [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImg.right).offset(5);
                make.top.equalTo(30);
                make.bottom.equalTo(imgview7.bottom).offset(3);
                make.right.equalTo(imgview1.right).offset(3);
            }];
        }else{
            [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImg.right).offset(5);
                make.top.equalTo(30);
                make.bottom.equalTo(imgview2.bottom).offset(3);
                make.right.equalTo(imgview1.right).offset(3);
            }];
        }
        
    }else{
        NSLog(@"应该没其他情况了吧：：%@",model.images_array);
    }
    
    
    [self.describLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.imgArr[model.images_array.count-1].bottom).offset(5);
        make.width.equalTo(250*K_SCALE);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    if (model.descriptions.length > 0) {
        [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(5);
            make.top.equalTo(30);
            make.bottom.equalTo(self.describLab.bottom).offset(3);
            make.width.equalTo(267*kk);
        }];
    }else{
        [self.bgImg remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.right).offset(5);
            make.top.equalTo(30);
            make.bottom.equalTo(self.imgArr[model.images_array.count-1].bottom).offset(3);
            make.width.equalTo(267*kk);
        }];
    }
    
    
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

@end
