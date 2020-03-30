//  卡密购买页
//  KamiPayController.swift
//  community
//
//  Created by MAC on 2020/3/7.
//  Copyright © 2020 cwl. All rights reserved.
//

import UIKit
import SafariServices
class KamiPayController: UIViewController {
    var id1 = serveHost
    var id2 = serveHost
    var id3 = serveHost
    var str = "0"
    var qqStr = ""
    var wxStr = ""
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var qqLabel: UILabel!
    @IBOutlet weak var qqButton: UIButton!
    
    @IBOutlet weak var wxLabel: UILabel!
    @IBOutlet weak var wxButton: UIButton!
    
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.cornerRadius = 8
        view1.layer.masksToBounds = true

        if (CSCaches.shareInstance().getUserModel(USERMODEL).wx.count > 0) {
               wxStr = CSCaches.shareInstance().getUserModel(USERMODEL).wx
           }
           if (CSCaches.shareInstance().getUserModel(USERMODEL).qq.count > 0) {
               qqStr = CSCaches.shareInstance().getUserModel(USERMODEL).qq
           }
        qqLabel.text = qqStr
        wxLabel.text = wxStr
        qqButton.layer.cornerRadius = 4
        wxButton.layer.cornerRadius = 4
        
        //代理版本才需要请求接口
        if (UserTools.isAgentVersion()) {
            
            str = "1"
            AppRequest.sharedInstance().requestMerBerCardBlock { (state, result) in
                      
                       
                       if (state == AppRequestState_Success) {
                           
                           self.id1 = JSON(result)["data"]["month"].string ?? ""
                           self.id2 = JSON(result)["data"]["season"].string ?? ""
                           self.id3 = JSON(result)["data"]["year"].string ?? ""
                           if self.DYStringIsEmpty(value: self.id1 as AnyObject) {
                               self.id1 = ""
                           }
                           if self.DYStringIsEmpty(value: self.id2 as AnyObject) {
                               self.id2 = ""
                           }
                           if self.DYStringIsEmpty(value: self.id3 as AnyObject) {
                               self.id3 = ""
                           }
                              }

                       
                   }
        }

 
        
        AppRequest.sharedInstance().requestCardInfo(str){ (state, result) in
                             
                              
                              if (state == AppRequestState_Success) {
                                  print("返回的啥1", JSON(result))
                                self.infoLabel.text = JSON(result)["data"]["content"].string ?? ""
                                     }

                              
                          }
        
    }
    
    //value 是AnyObject类型是因为有可能所传的值不是String类型，有可能是其他任意的类型。
    func DYStringIsEmpty(value: AnyObject?) -> Bool {
        //首先判断是否为nil
        if (nil == value) {
            //对象是nil，直接认为是空串
            return true
        }else{
            //然后是否可以转化为String
            if let myValue  = value as? String{
                //然后对String做判断
                return myValue == "" || myValue == "(null)" || 0 == myValue.count
            }else{
                //字符串都不是，直接认为是空串
                return true
            }
        }
    }

    
    /**
        验证URL格式是否正确
        */
       private func verifyUrl(str:String) -> Bool {
           //创建NSURL实例
           if let url = NSURL(string: str) {
               //检测应用是否能打开这个NSURL实例
            return UIApplication.shared.canOpenURL(url as URL)
           }
           return false
       }
    
    @IBAction func back(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn1(_ sender: Any) {
//        //是官方版本去在线客服
        if (!UserTools.isAgentVersion()) {
            let vc = WebServeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }

        if !verifyUrl(str: id1) {
            MYToast.makeText("暂无自助购买链接，请联系销售代理购买")?.show()
            return
        }
        let url = URL(string: id1)
         print("返回id是",id1)
       if #available(iOS 10, *) {
        UIApplication.shared.open(url!, options: [:],
                                      completionHandler: {
                                        (success) in
            })
        } else {
        UIApplication.shared.openURL(url!)
        }

//        let safari = SFSafariViewController(url: URL(string: id1)!)
//        self.present(safari, animated: true, completion: nil)
       }
    @IBAction func btn2(_ sender: Any) {
//        //是官方版本去在线客服
           if (!UserTools.isAgentVersion()) {
               let vc = WebServeVC()
               self.navigationController?.pushViewController(vc, animated: true)
               return
           }
//        
        
        if !verifyUrl(str: id2) {
            MYToast.makeText("暂无自助购买链接，请联系销售代理购买")?.show()
                   return
               }
         let url = URL(string: id2)

              if #available(iOS 10, *) {
               UIApplication.shared.open(url!, options: [:],
                                             completionHandler: {
                                               (success) in
                   })
               } else {
               UIApplication.shared.openURL(url!)
        }
       }
    @IBAction func btn3(_ sender: Any) {
//        //是官方版本去在线客服
           if (!UserTools.isAgentVersion()) {
               let vc = WebServeVC()
               self.navigationController?.pushViewController(vc, animated: true)
               return
           }
//        
        
        if !verifyUrl(str: id3) {
            MYToast.makeText("暂无自助购买链接，请联系销售代理购买")?.show()
                   return
               }
         let url = URL(string: id3)

              if #available(iOS 10, *) {
               UIApplication.shared.open(url!, options: [:],
                                             completionHandler: {
                                               (success) in
                   })
               } else {
               UIApplication.shared.openURL(url!)
        }
       }
    
    @IBAction func copy1(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = qqStr
        MYToast.makeText("复制成功")?.show()
        
    }
    @IBAction func copy2(_ sender: Any) {
         let pasteboard = UIPasteboard.general
               pasteboard.string = wxStr
        MYToast.makeText("复制成功")?.show()
    }
    
    
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButtonItem = UIBarButtonItem()
         
        backButtonItem.title = "返回";
        self.navigationItem.backBarButtonItem = backButtonItem
        
        self.navigationItem.title = "购买商城"
        
    }
    
}
