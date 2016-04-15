//
//  PageView.swift
//  PPT
//
//  Created by jasnig on 16/4/2.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

public class PageView: UIView {
    // 滚动方向
    public enum Direction {
        case Left
        case Right
        
    }
    
    // PageControl位置
    public enum PageControlPosition {
        case TopCenter
        case BottomLeft
        case BottomRight
        case BottomCenter
    }
    
    public typealias PageDidClickAction = (clickedIndex: Int) -> Void
    public typealias SetupImageForImageView = (imageView: UIImageView, index: Int) -> Void
    
    //MARK:- 可供外部修改的属性
    
    // pageControl的位置 默认为底部中间
    public var pageControlPosition: PageControlPosition = .BottomCenter
    
    // 点击响应
    public var pageDidClick:PageDidClickAction?
    
    // 设置图片
    public var setupImageForImageView: SetupImageForImageView?
    
    // 滚动间隔
    public var timerInterval = 3.0
    
    /// 图片总数, 需要在初始化的时候指定*
    private var imagesCount = 0
    
    /// 其他page的颜色
    public var pageIndicatorTintColor = UIColor.whiteColor() {
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    /// 当前page的颜色
    public var currentPageIndicatorTintColor = UIColor.whiteColor() {
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }

    
    /// 文字和图片的个数需要相等
    public var titlesArray: [String]? = nil {
        willSet {
            if let titles = newValue {
                //调试过程中会触发断言
                assert(titles.count == imagesCount, "标题的个数需要和图片的个数相等")
                // 实际运行中会不显示标题
                if titles.count != imagesCount {
                    return
                }
                
                // 如果设置了title 那么添加textLabel
                insertSubview(textLabel, belowSubview: pageControl)
                textLabel.text = titles[currentIndex]

            }
        }
    }

    // 文字的颜色 默认为黑色
    public var textColor = UIColor.blackColor() {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    // 文字背景颜色 默认为半透明白色
    public var textBackgroundColor = UIColor.whiteColor() {
        didSet {
            textLabel.backgroundColor = textBackgroundColor
        }
    }

    
    /// 是否自动滚动, 默认为自动滚动
    public var autoScroll = true {
        willSet {
            if !newValue {
                stopTimer()
            }
        }
    }
    
    //MARK:- 私有属性
    private var scrollDirection: Direction = .Left
    
    private var currentIndex = -1
    private var leftIndex = -1
    private var rightIndex = 1
    
    
    private var timer: NSTimer?
    
    private lazy var scrollView: UIScrollView = { [weak self] in
        let scroll = UIScrollView(frame: CGRectZero)
        
        if let strongSelf = self {
            scroll.delegate = strongSelf

        }
        scroll.bounces = false
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
    
    /// 显示文字 在设置了文字的时候才会添加label
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)
        return label
    }()
    
    lazy var currentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        /// 可点击
        imageView.userInteractionEnabled = true
        return imageView
    }()

    lazy var rightImageView = UIImageView()
    lazy var leftImageView = UIImageView()
    
    //MARK:- 初始化
    public convenience init(imagesCount: Int, setupImageForImageView: SetupImageForImageView?) {
        self.init(imagesCount: imagesCount, setupImageForImageView: setupImageForImageView, pageDidClick: nil)
    }
    
    public init(imagesCount: Int, setupImageForImageView: SetupImageForImageView?, pageDidClick: PageDidClickAction?) {
        
        // 这个blosure 处理点击
        self.pageDidClick = pageDidClick
        // 这个blosure获取图片 相当于UITableView的cellForRow...方法
        self.setupImageForImageView = setupImageForImageView
        // 相当于UITableView的numberOfRows...方法
        self.imagesCount = imagesCount
        
        super.init(frame: CGRectZero)
        // 这里面添加了各个控件, 和设置了初始的图片和title
        initialization()
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 初始设置和内部函数
    
    private func initialization()  {
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapdAction))
        tapGuesture.numberOfTapsRequired = 1
        currentImageView.addGestureRecognizer(tapGuesture)
        
        leftImageView.contentMode = .ScaleAspectFill
        rightImageView.contentMode = .ScaleAspectFill

        pageControl.numberOfPages = imagesCount
        pageControl.sizeForNumberOfPages(imagesCount)
        
        addSubview(scrollView)
        addSubview(pageControl)

        scrollView.addSubview(currentImageView)
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(rightImageView)
        // 添加初始化图片
        loadImages()
        
        startTimer()
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        let width = bounds.size.width
        let height = bounds.size.height
        let pageHeight:CGFloat = 28.0
        
        
        
        switch pageControlPosition {
            case .BottomLeft:
                pageControl.frame = CGRect(x: 0, y: height - pageHeight, width: width / 2, height: pageHeight)

            case .BottomCenter:
                pageControl.frame = CGRect(x: 0, y: height - pageHeight, width: width, height: pageHeight)

            case .BottomRight:
                pageControl.frame = CGRect(x: width / 2, y: height - pageHeight, width: width / 2, height: pageHeight)

            case .TopCenter:
                pageControl.frame = CGRect(x: 0, y: 0, width: width, height: pageHeight)

        }
        
        currentImageView.frame = CGRect(x: width, y: 0, width: width, height: height)
        leftImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        rightImageView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        textLabel.frame = CGRect(x: 0, y: height - pageHeight, width: width, height: pageHeight)

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
        
        UIView.animateWithDuration(3.0, animations: {
            self.scrollView.setContentOffset(CGPoint(x: self.bounds.size.width * 2, y: 0), animated: true)
            
        }, completion: nil)
        
    }
    
    func imageTapdAction() {
        pageDidClick?(clickedIndex:currentIndex)
    }
    
    deinit {
//        debugPrint("\(self.debugDescription) --- 销毁")
        stopTimer()
    }
    
    /// 当父view将释放的时候需要 释放掉timer以释放当前view
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview == nil {
            stopTimer()

        }
    }
}

extension PageView: UIScrollViewDelegate {
    
    // 手指触摸到时
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScroll {
            stopTimer()

        }
    }
    
    // 松开手指时
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            startTimer()

        }
    }
    
    /// 代码设置scrollview的contentOffSet滚动完成后调用
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // 重新加载图片
        loadImages()

    }
    
    /// scrollview的滚动是由拖拽触发的时候,在它将要停止时调用
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // fabs 绝对值
        if fabs(scrollView.contentOffset.x - scrollView.bounds.size.width) > scrollView.bounds.size.width / 2 {
            
            scrollDirection = scrollView.contentOffset.x > bounds.size.width ? .Left : .Right
            // 重新加载图片
            loadImages()
        }
        

    }
    
    
    private func loadImages() {
        
        // 根据滚动方向不同设置将要显示的图片下标
        switch scrollDirection {
            
            case .Left:
                currentIndex = (currentIndex + 1) % imagesCount

            case .Right:
                currentIndex = (currentIndex - 1 + imagesCount) % imagesCount
            
        }
        
        leftIndex = (currentIndex - 1 + imagesCount) % imagesCount
        rightIndex = (currentIndex + 1) % imagesCount
        
        setupImageForImageView?(imageView: currentImageView, index: currentIndex)
        setupImageForImageView?(imageView: rightImageView, index: rightIndex)
        setupImageForImageView?(imageView: leftImageView, index: leftIndex)
        
        pageControl.currentPage = currentIndex
        if let titles = titlesArray { // 已经添加了textLabel 直接设置文字即可
            textLabel.text = titles[currentIndex]

        }
        
        scrollView.contentOffset = CGPoint(x: bounds.size.width, y: 0)


    }
}

