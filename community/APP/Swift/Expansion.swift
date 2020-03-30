//  各种扩展方法等
//  Expansion.swift
//  TianJianUser
//
//  Created by MacBookProHY02 on 2019/5/16.
//  Copyright © 2019 JackTang. All rights reserved.
//

import UIKit

let Screen_Width = UIScreen.main.bounds.size.width
let Screen_Height = UIScreen.main.bounds.size.height
let StateBar_Height = UIApplication.shared.statusBarFrame.height

let Color_FDD25C = UIColor(red: 0xFD/0xff, green: 0xD2/0xff, blue: 0x5C/0xff, alpha: 1)
let Color_F79530 = UIColor(red: 0xF7/0xff, green: 0x95/0xff, blue: 0x30/0xff, alpha: 1)
let Color_999999 = UIColor(red: 0x99/0xff, green: 0x99/0xff, blue: 0x99/0xff, alpha: 1)
let Color_333333 = UIColor(red: 0x33/0xff, green: 0x33/0xff, blue: 0x33/0xff, alpha: 1)
let Color_666666 = UIColor(red: 0x66/0xff, green: 0x66/0xff, blue: 0x66/0xff, alpha: 1)
let Color_24B480 = UIColor(red: 0x24/0xff, green: 0xB4/0xff, blue: 0x80/0xff, alpha: 1)
let Color_24B4804 = UIColor(red: 0x24/0xff, green: 0xB4/0xff, blue: 0x80/0xff, alpha: 0.4)
let Color_F0F0F0 = UIColor(red: 0xF0/0xff, green: 0xF0/0xff, blue: 0xF0/0xff, alpha: 1)
let Color_FFFFFF = UIColor(red: 0xFF/0xff, green: 0xFF/0xff, blue: 0xFF/0xff, alpha: 1)
let Color_F5F5F5 = UIColor(red: 0xF5/0xff, green: 0xF5/0xff, blue: 0xF5/0xff, alpha: 1)
let Color_FEE7A5 = UIColor(red: 0xFE/0xff, green: 0xE7/0xff, blue: 0xA5/0xff, alpha: 1)
let Color_EAE4DE = UIColor(red: 0xEA/0xff, green: 0xE4/0xff, blue: 0xDE/0xff, alpha: 1)
let Color_FFE680 = UIColor(red: 0xFF/0xff, green: 0xE6/0xff, blue: 0x80/0xff, alpha: 1)
let Color_F1F2F3 = UIColor(red: 0xF1/0xff, green: 0xF2/0xff, blue: 0xF3/0xff, alpha: 1)
let Color_EA4B4A = UIColor(red: 0xEA/0xff, green: 0x4B/0xff, blue: 0x4A/0xff, alpha: 1)
let Color_EEBD4D = UIColor(red: 0xEE/0xff, green: 0xBD/0xff, blue: 0x4D/0xff, alpha: 1)
let Color_E02020 = UIColor(red: 0xE0/0xff, green: 0x20/0xff, blue: 0x20/0xff, alpha: 1)
let Color_BBBBBB = UIColor(red: 0xBB/0xff, green: 0xBB/0xff, blue: 0xBB/0xff, alpha: 1)
let Color_209992 = UIColor(red: 0x20/0xff, green: 0x99/0xff, blue: 0x92/0xff, alpha: 1)
let Color_29CF93 = UIColor(red: 0x29/0xff, green: 0xCF/0xff, blue: 0x93/0xff, alpha: 1)
let Color_838786 = UIColor(red: 0x83/0xff, green: 0x87/0xff, blue: 0x86/0xff, alpha: 1)
let Color_2496B41 = UIColor(red: 0x24/0xff, green: 0x96/0xff, blue: 0xB4/0xff, alpha: 0.1)
class Expansion: NSObject {

}
//MARK: -定义button相对label的位置
enum ButtonEdgeInsetsStyle {
    case Top
    case Left
    case Right
    case Bottom
}
extension UIButton {
    
    func layoutButton(style: ButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        //        if Double(version) >= 8.0 {
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        //        }else{
        //            labelWidth = self.titleLabel?.frame.size.width
        //            labelHeight = self.titleLabel?.frame.size.height
        //        }
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .Top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-imageTitleSpace/2, right: 0)
            break;
            
        case .Left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
            break;
            
        case .Bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-imageTitleSpace/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-imageTitleSpace/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .Right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-imageTitleSpace/2, bottom: 0, right: imageWidth!+imageTitleSpace/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
}

