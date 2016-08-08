//
//  PageView.swift
//  PPT
//
//  Created by jasnig on 16/4/2.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class PageView2: UIView {
    
    enum Direction {
        case Left
        case Right
        
    }
    
    private var scrollDirection: Direction = .Left
    
    private var currentIndex = 0
    
    typealias PageDidClickAction = (scrollView: UIScrollView, index: Int) -> Void
    // 点击响应
    var pageDidClick:PageDidClickAction?
    
    var timerInterval = 2.0
    
    ///
    var imagesArray: [UIImage] = [] {
        willSet {
            pageControl.numberOfPages = newValue.count
            currentImageView.image = newValue[0]
            //            otherImageView.image = newValue[1]
            
            if newValue.count > 0 {
                
                leftImageView.image = newValue.last
                rightImageView.image = newValue[1]
                
            }
        }
    }
    
    ///
    var titlesArray: [String]?
    
    
    lazy var currentImageView: UIImageView = {
        let imageView = UIImageView()
        /// 可点击
        imageView.userInteractionEnabled = true
        return imageView
    }()
    
    
    lazy var rightImageView = UIImageView()
    lazy var leftImageView = UIImageView()
    
    lazy var rightView = UIView()
    lazy var leftView = UIView()
    
    /// 其他page的颜色
    var pageIndicatorTintColor = UIColor.whiteColor() {
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    /// 当前page的颜色
    var currentPageIndicatorTintColor = UIColor.whiteColor() {
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    
    private var timer: NSTimer?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: CGRectZero)
        
        // 是否有问题?
        scroll.delegate = self
        scroll.bounces = false
        scroll.alwaysBounceHorizontal = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.pagingEnabled = true
        return scroll
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.hidesForSinglePage = true
        pageC.userInteractionEnabled = false
        
        
        return pageC
    }()
    
    
    init(pageDidClick: PageDidClickAction?) {
        
        self.pageDidClick = pageDidClick
        super.init(frame: CGRectZero)
        initialization()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialization()  {
        //        scrollView.delegate = self
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapAction))
        tapGuesture.numberOfTapsRequired = 1
        currentImageView.addGestureRecognizer(tapGuesture)
        
        addSubview(scrollView)
        addSubview(pageControl)
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(rightImageView)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        
        
        pageControl.frame = CGRect(x: 0, y: 0, width: width, height: 55)
        currentImageView.frame = CGRect(x: width, y: 0, width: width, height: height)
        leftImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        rightImageView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        
        
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        scrollView.contentSize = CGSize(width: 3 * width, height: 0)
        
    }
    
    /// 开启倒计时
    private func startTimer() {
        if timer == nil {
            timer = NSTimer(timeInterval: timerInterval, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    /// 停止倒计时
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    /// 计时器响应方法
    func timerAction() {
        // 更新位置, 更换图片
    }
    
    func imageTapAction() {
        pageDidClick?(scrollView:scrollView, index:currentIndex)
    }
    
    private var oldOffset: CGFloat = 0.0
    
    
}

extension PageView2: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        oldOffset = scrollView.contentOffset.x
        stopTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // fabs 绝对值
        if fabs(scrollView.contentOffset.x - oldOffset) > scrollView.bounds.size.width / 2 {
            
            scrollDirection = scrollView.contentOffset.x > bounds.size.width ? .Left : .Right
            updateOffSetAndImage()
        }
        
        
    }
    
    
    func updateOffSetAndImage() {
        
        
        switch scrollDirection {
            
        case .Left:
            
            //            nextIndex = (nextIndex + 2) % imagesArray.count
            
            if currentIndex == imagesArray.count - 1 {
                currentIndex = 0
                
                leftImageView.image = currentImageView.image
                currentImageView.image = rightImageView.image
                rightImageView.image = imagesArray[currentIndex]
                
            } else {
                currentIndex += 1
                
                leftImageView.image = currentImageView.image
                currentImageView.image = rightImageView.image
                rightImageView.image = imagesArray[currentIndex]
                
            }
            
        case .Right:
            if currentIndex == 0 {
                currentIndex = imagesArray.count - 1
                rightImageView.image = currentImageView.image
                currentImageView.image = leftImageView.image
                leftImageView.image = imagesArray[currentIndex]
            } else {
                currentIndex -= 1
                rightImageView.image = currentImageView.image
                currentImageView.image = leftImageView.image
                leftImageView.image = imagesArray[currentIndex]
            }
            
            
            
        }
        
        scrollView.contentOffset = CGPoint(x: bounds.size.width, y: 0)
        
        
    }
}

