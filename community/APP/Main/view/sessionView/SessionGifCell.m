//
//  SessionGifCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/10.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "SessionGifCell.h"

@implementation SessionGifCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"SessionGifCell";
    SessionGifCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    //////
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
    [self.contentView addSubview:self.headImg];
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(2);
        make.height.width.equalTo(34);
    }];
    
    self.userNameLab = [UILabel labelWithTitle:@"用户名" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
    }];
    
    UIImage *img = [UIImage imageNamed:@"chatBgImg"];
    // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(25, 15, 8, 8) resizingMode:UIImageResizingModeStretch];
    self.bgImg.image = img;
    
    self.gifImg = [[FLAnimatedImageView alloc]init];
    [self.contentView addSubview:self.gifImg];
    
    CGFloat maxWidth = 260*K_SCALE;
    CGFloat maxHeight = 350*K_SCALE;
    
    
    [self.gifImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
//        make.left.equalTo(18);
        make.left.equalTo(self.headImg.right).offset(12);
        make.width.lessThanOrEqualTo(maxWidth);
        make.height.lessThanOrEqualTo(maxHeight);
        make.height.greaterThanOrEqualTo(100);
    }];
    
    self.gifImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigGif)];
    [self.gifImg addGestureRecognizer:tap];
    
    self.describLab = [UILabel labelWithTitle:@"" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.describLab.numberOfLines = 0;
    [self.contentView addSubview:self.describLab];
    
    [self.describLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gifImg.left);
        make.top.equalTo(self.gifImg.bottom).offset(5);
        make.width.equalTo(self.gifImg.width);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(11);
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(23);
        make.bottom.equalTo(self.describLab.bottom).offset(3);
        make.right.equalTo(self.gifImg.right).offset(3);
    }];
}

-(void)showBigGif{
    if (self.backBlock) {
        self.backBlock(@"");
    }
}
-(void)refreshCell:(SessionModel *)model{
    //    [self.Img sd_setImageWithURL:[NSURL URLWithString:model.content] placeholderImage:nil];
   self.userNameLab.text = model.nick_name;
   [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
    
    
    NSURL *originalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.content]];

    __block FLAnimatedImage *animatedImage;
    
    NSData *savedata =[[NSUserDefaults standardUserDefaults] dataForKey:[NSString stringWithFormat:@"GIF_%@",model.idss]];
    if (savedata) {
        animatedImage = [FLAnimatedImage animatedImageWithGIFData:savedata];
        self.gifImg.animatedImage = animatedImage;
        self.describLab.text = model.descriptions;
        return ;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = nil;
//        NSData *savedata =[[NSUserDefaults standardUserDefaults] dataForKey:[NSString stringWithFormat:@"GIF_%@",model.idss]];
        data = savedata;
        //[CSDataBase cacheDataByCacheType:DB_GIF Identify:[NSString stringWithFormat:@"GIF_%@",model.idss] versionCode:@"1"];
        if (data == nil) {
            data =[NSData dataWithContentsOfURL:originalURL];
//            [CSDataBase insertCacheDataByIdentify:[NSString stringWithFormat:@"GIF_%@",model.idss] CacheType:DB_GIF versionCode:@"1" data:data];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"GIF_%@",model.idss]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        //通知主线程刷新
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                
                CGSize size = [FLAnimatedImage sizeForImage:animatedImage];
                
                CGFloat maxWidth = 260*K_SCALE;
                //    CGFloat maxHeight = 350*K_SCALE;
                CGFloat h = 30;
                if (size.width>0) {
                    h = maxWidth * size.height / size.width;
                }
                
                [self.gifImg updateConstraints:^(MASConstraintMaker *make) {
                    make.height.lessThanOrEqualTo(h);
                    make.width.lessThanOrEqualTo(maxWidth);
                }];
                
                self.gifImg.animatedImage = animatedImage;
                if (!savedata && self.backBlock) {
                    self.backBlock(@"200");
                }
                
                
            });
        }
        
        
    });
    

    
//    if (model.descriptions.length > 0) {
        self.describLab.text = model.descriptions;
//    }
    
}


-(void)prepareForReuse{
    [super prepareForReuse];
    self.gifImg.animatedImage = nil;
}

@end
