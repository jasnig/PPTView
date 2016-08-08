//
//  ViewController.swift
//  PPT
//
//  Created by jasnig on 16/4/2.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    //    let imagesUrl = ["http://g.hiphotos.baidu.com/lvpics/w=1000/sign=1be9ee3b2f34349b74066a85f9da14ce/3801213fb80e7bec6a230cc0282eb9389b506b11.jpg", "http://g.hiphotos.baidu.com/lvpics/w=1000/sign=1be9ee3b2f34349b74066a85f9da14ce/3801213fb80e7bec6a230cc0282eb9389b506b11.jpg", "http://g.hiphotos.baidu.com/lvpics/w=1000/sign=1be9ee3b2f34349b74066a85f9da14ce/3801213fb80e7bec6a230cc0282eb9389b506b11.jpg", "http://g.hiphotos.baidu.com/lvpics/w=1000/sign=1be9ee3b2f34349b74066a85f9da14ce/3801213fb80e7bec6a230cc0282eb9389b506b11.jpg" , "http://g.hiphotos.baidu.com/lvpics/w=1000/sign=1be9ee3b2f34349b74066a85f9da14ce/3801213fb80e7bec6a230cc0282eb9389b506b11.jpg"]
    
    // 图片
    let images = [UIImage(named:"1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named:"5")]
    // 标题个数要和图片个数相同
    let titles = ["这是第1个页面", "这是第2个页面", "这是第3个页面", "这是第4个页面", "这是第5个页面"]
    var pptView1: PPTView!
    var pptView2: PPTView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果是从storyboard中加载的controller请设置这个属性为false
        automaticallyAdjustsScrollViewInsets = false
        
        // 添加第一个 带标题
        addPptView1()
        
        // 添加第二个 不带标题
        addPptView2()
        
        
        
    }
    
    func addPptView1()  {
        
        pptView1 = PPTView(imagesCount: { () -> Int in
            return self.images.count
            }, setupImageAndTitle: { (titleLabel, imageView, index) in
                imageView.image = self.images[index]
                titleLabel.text = self.titles[index]
                titleLabel.textColor = UIColor.redColor()
        }) { (clickedIndex) in
            // 处理点击
            print(clickedIndex)
            self.messageLabel.text = "点击了第\(clickedIndex)张图片"
        }

        pptView1.frame = CGRect(x: 0, y: 100, width: view.bounds.size.width, height: 200)
        //设置pageController的颜色
        pptView1.pageIndicatorTintColor = UIColor.whiteColor()
        pptView1.currentPageIndicatorTintColor = UIColor.brownColor()
        pptView1.pageControlPosition = .TopCenter
        // 滚动间隔, 默认三秒
        //        pptView.timerInterval = 2.0
        
        // 关闭自动滚动
        //        scrollImage.autoScorll = false
        view.addSubview(pptView1)
        /// 如果是网络获取到的信息, 获取完毕可以调用reloadData()重新加载页面
        //        pptView1.reloadData()

    }

    
    func addPptView2()  {
        
        pptView2 = PPTView.PPTViewWithImagesCount({ () -> Int in
            return self.images.count
        })
        .setupImageAndTitle({ (titleLabel, imageView, index) in
            imageView.image = self.images[index]
            titleLabel.text = self.titles[index]
            titleLabel.textColor = UIColor.redColor()
        })
        .setupPageDidClickAction({ (clickedIndex) in
            // 处理点击
            print(clickedIndex)
            self.messageLabel.text = "点击了第\(clickedIndex)张图片"
        })
    
        pptView2.frame = CGRect(x: 0, y: 310, width: view.bounds.size.width, height: 200)
        //设置pageController的颜色
        pptView2.pageIndicatorTintColor = UIColor.whiteColor()
        pptView2.currentPageIndicatorTintColor = UIColor.brownColor()
        pptView2.pageControlPosition = .BottomCenter
        // 滚动间隔, 默认三秒
        //        pptView.timerInterval = 2.0
        
        // 关闭自动滚动
        //        scrollImage.autoScorll = false
        view.addSubview(pptView2)
        
        /// 如果是网络获取到的信息, 获取完毕可以调用reloadData()重新加载页面
//        pptView2.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

