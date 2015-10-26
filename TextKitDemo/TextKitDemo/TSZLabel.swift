//
//  TSZLabel.swift
//  TextKitDemo
//
//  Created by Tsz on 15/10/25.
//  Copyright © 2015年 Tsz. All rights reserved.

import UIKit

class TSZLabel: UILabel {

 /// MARK: 重写text属性
    override var text: String? {
        didSet{
            //把文本的内容 设置给textStorage 存储
            prepareTextStorage()
        }
       
    }
    //绘制内容 ， 只要重写就需要自己绘制的方法 ，绘制由layoutManager
    override func drawTextInRect(rect: CGRect) {
        
        let range = NSMakeRange(0, textStorage.length)
        
        //绘制的textStorage 中保留的内容
        layoutManager.drawGlyphsForGlyphRange(range, atPoint: CGPointZero)
    }
    
    //MARK: 准备
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextSystem()
    }

    ///准备文本系统
    private func prepareTextSystem() {
        
        //根据 textKit 的 关系 布局
        
        /**
        准备 textStorage
        */
        prepareTextStorage()
        
        //建立对象之间 的关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        
    }
    
 ///准备文本存储的内容
    private func prepareTextStorage(){
        //1、使用label 自身的文字设置storage
        //attributedText 是UILabel的一个属性  是这个类型的 NSAttributedString ，
        if attributedText != nil {
            textStorage.setAttributedString(attributedText!)
        }else{
            textStorage.setAttributedString(NSAttributedString(string: text!))
        }
        
        //2、检测 URL 的范围
        if let ranges = urlRanges() {
            
            //遍历范围 设置文字字体的颜色属性
            for  r in ranges {
                textStorage.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: r)
            }
        }
    }
 /// 检测文本中url 的所有范围
    private func urlRanges()  ->  [NSRange]? {
        
        /// 需要的正则表达式 , 这个正则表达式匹配 字母   和数字
        let pattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
        
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        //用正则匹配url的内容  matchesInString 重复匹配多次
        
        let results = regex.matchesInString(textStorage.string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, textStorage.length))
        // 遍历 数组 ， 生成结果
        var ranges = [NSRange]()
        
        //遍历得到结果  ,0 和 pattern 完全匹配的内容  1 第一个 () 的内容
        for r  in  results {
            
            ranges.append(r.rangeAtIndex(0))
        }
        
        return ranges
    }
    //更新绘制结果
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //保持容器尺寸的及时更新
//        textContainer.size = bounds.size
    }
    
    
    
//MARK: TextKit类的格式的懒加载
    ///存储内容 ，NSTextStorage 是NSMutableAttributedString 的子类 ，保存着文本的主要信息
    private lazy var textStorage = NSTextStorage()
    
    /// 负责布局
    private lazy var layoutManager = NSLayoutManager()
    
    ///设置尺寸  --  只需要在一个地方 设置 layoutSubviews
    private lazy var textContainer = NSTextContainer()
}
