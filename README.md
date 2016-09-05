#PPTView



-----

##最终效果(和其他效果相似)


![轮播图.gif](http://upload-images.jianshu.io/upload_images/1271831-ae8f562e2e164182.gif?imageMogr2/auto-orient/strip)


---

### 书写思路移步 [简书](http://www.jianshu.com/p/2cbda66343d7)

---

### 使用方法
	
			// 1. 初始化, 传入图片总数, 设置图片, 处理点击图片(类似于UITableView的Delegate, Datasource使用)
	        pptView1 = PPTView(imagesCount: images.count, setupImageForImageView: {[unowned self] (imageView, index) in
            //设置图片
            // 加载网络图片示例
            //                imageView.kf_setImageWithURL(NSURL(string: self.imagesUrl[index]), placeholderImage: nil)
            
            // 本地图片
            imageView.image = self.images[index]
            
        }) {[unowned self] (clickedIndex) in
            // 处理点击
            print(clickedIndex)
            self.messageLabel.text = "点击了第\(clickedIndex)张图片"
            
        }
        // 2. 设置frame
        pptView1.frame = CGRect(x: 0, y: 100, width: view.bounds.size.width, height: 200)
        //3. 设置标题
        pptView1.titlesArray = titles
        
        //4. 自定义
        //设置pageController的颜色
        pptView1.pageIndicatorTintColor = UIColor.whiteColor()
        pptView1.currentPageIndicatorTintColor = UIColor.brownColor()
        pptView1.textColor = UIColor.redColor()
        pptView1.pageControlPosition = .TopCenter
        // 滚动间隔, 默认三秒
        //        pptView.timerInterval = 2.0
        
        // 关闭自动滚动
        //        scrollImage.autoScorll = false
        view.addSubview(pptView1)




####如果对您有帮助,请随手给个star鼓励一下 , 欢迎交流