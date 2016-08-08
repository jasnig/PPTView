//
//  TestController.swift
//  PPT
//
//  Created by jasnig on 16/4/5.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    @IBOutlet weak var testPage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 这里是在storyBoard中使用这个PPTView的正确方式
        
        automaticallyAdjustsScrollViewInsets = false

        let images = [UIImage(named:"1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named:"5")]
        let titles = ["这是第1个页面", "这是第2个页面", "这是第3个页面", "这是第4个页面", "这是第5个页面"]
        
        let scrollImage = PPTView.PPTViewWithImagesCount({ () -> Int in
            return images.count
        })
        .setupImageAndTitle({ (titleLabel, imageView, index) in
                imageView.image = images[index]
                titleLabel.text = titles[index]
                titleLabel.textColor = UIColor.redColor()
        })
        .setupPageDidClickAction({ (clickedIndex) in
            // 处理点击
            print(clickedIndex)
        })
        scrollImage.frame = CGRect(x: 0, y: 200, width: view.bounds.size.width, height: 200)
        //        scrollImage.pageControlPosition = .Right
        
        //        scrollImage.autoScorll = false
        view.addSubview(scrollImage)
        
        scrollImage.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: testPage.bounds.size.height)
        
        // 添加到testPage上
        testPage.addSubview(scrollImage)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
