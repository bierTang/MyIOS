//
//  NoVipView.swift
//  community
//
//  Created by MAC on 2020/3/13.
//  Copyright © 2020 cwl. All rights reserved.
//

import UIKit

class NoVipView: UIView {
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var bt1: UIButton!
    @IBOutlet weak var bt2: UIButton!
    
     override func layoutSubviews() {
          super.layoutSubviews()
          
      }
      
      var contentView:UIView!
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          contentView = loadXib()
        contentView.frame = frame;
          addSubview(contentView)
      }
      
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          contentView = loadXib()
          addSubview(contentView)
          
      }
      
      func loadXib() -> UIView {
          let className = type(of:self)
          let bundle = Bundle(for:className)
          let name = NSStringFromClass(className).components(separatedBy: ".").last
          let nib = UINib(nibName: name!, bundle: bundle)
          let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
          
          return view
      }
}
