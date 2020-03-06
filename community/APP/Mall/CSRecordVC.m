//
//  CSRecordVC.m
//  community

#import "CSRecordVC.h"
#import "RecordCell.h"

@interface CSRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray<CSRecordModel *> *dataArr;

@property (nonatomic,strong)NoDataView *nodataView;
@end

@implementation CSRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[RecordCell class] forCellReuseIdentifier:@"RecordCell"];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(-BottomSpace);
    }];
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestShopRecord:[UserTools userID] curentpage:@"1" counts:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        
        if (state == AppRequestState_Success) {
            wself.dataArr = [CSRecordModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            
            [wself.tableView reloadData];
        }
        
    }];
    
    self.nodataView = [[NoDataView alloc]initWithTitle:@"暂无记录"];
    [self.view addSubview:self.nodataView];
    [self.nodataView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(300);
        make.centerY.equalTo(self.view.centerY);
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nodataView.hidden = self.dataArr.count;
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell = [[RecordCell alloc]cellInitWith:tableView Indexpath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.row]];
    
    return cell;
}

@end
