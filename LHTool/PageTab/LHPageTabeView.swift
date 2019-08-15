//
//  LHPageTabeView.swift
//  LHTool
//
//  Created by 刘恒 on 2019/8/10.
//  Copyright © 2019 LH. All rights reserved.
//

import UIKit

let kTabDefautHeight: CGFloat = 38.0
let kTabDefautFontSize: CGFloat = 15.0
let kMaxNumberOfPageItems: Int = 6
let kIndicatorHeight: CGFloat = 2.0
let kIndicatorWidth: CGFloat = 20
let kMinScale: CGFloat = 0.8

func HEIGHT(view: UIView) -> CGFloat {
    return view.bounds.size.height
}

func WIDTH(view: UIView) -> CGFloat {
    return view.bounds.size.width
}

func ORIGIN_X(view: UIView) -> CGFloat {
    return view.frame.origin.x
}

func ORIGIN_Y(view: UIView) -> CGFloat {
    return view.frame.origin.y
}

@objc protocol LHPageTabeViewDelegate: NSObjectProtocol {
    func pageTabViewDidEndChange()
}

class LHPageTabeView: UIView,UIScrollViewDelegate {

    enum LHPageTabTitleStyle: Int {
        case defaultstyle = 0 //正常
        case gradient //渐变
        case blend //填充
    }

    enum LHPageTabIndicatorStyle: Int {
        case defaultstyle = 0 //正常,自定义宽度
        case followtext //跟随文本长度变化
        case stretch //拉伸
    }

    /*设置当前选择项（无动画效果）*/
    var _selectedTabIndex = 0
    var selectedTabIndex: Int  {
        set {
            if newValue >= 0 && newValue < numberOfTabItems && newValue != _selectedTabIndex {
                changeSelectedItemToNextItem(nextIndex: newValue)
                _selectedTabIndex = newValue
                self.lastSelectedTabIndex = _selectedTabIndex
                layoutIndicatorViewWithStyle()
                if(titleStyle == .gradient) {
                    resetTabItemScale()
                }
            }
        }
        get {
            return _selectedTabIndex
        }
    }
    /*一页展示最多的item个数，如果比item总数少，按照item总数计算*/
    var maxNumberOfPageItems: Int = kMaxNumberOfPageItems
    /*tab size，默认(self.width, 38.0)*/
    var tabSize: CGSize = CGSize.zero
    /*item的字体大小*/
    var _tabItemFont: UIFont = UIFont.systemFont(ofSize: CGFloat(kTabDefautFontSize))
    var tabItemFont: UIFont {
        set {
            _tabItemFont = newValue
            for i in 0..<self.numberOfTabItems {
                let tabItem = self.tabItems[i]
                tabItem.font = _tabItemFont
            }
        }
        get {
            return _tabItemFont
        }
    }
    /*未选择颜色*/
    var _unSelectedColor: UIColor = UIColor.black
    var unSelectedColor: UIColor {
        set {
            _unSelectedColor = newValue
            for i in 0..<numberOfTabItems {
                let tabItem = tabItems[i];
                tabItem.textColor = i == selectedTabIndex ? selectedColor : _unSelectedColor
            }
            let rgb = getRGBWithColor(color: _unSelectedColor)
            self.unSelectedColorR = rgb[0]
            self.unSelectedColorG = rgb[1]
            self.unSelectedColorB = rgb[2]
        }
        get {
            return _unSelectedColor
        }
    }
    /*当前选中颜色*/
    var _selectedColor: UIColor = UIColor.red
    var selectedColor: UIColor {
        set {
            _selectedColor = newValue
            let tabItem = tabItems[self.selectedTabIndex]
            tabItem.textColor = _selectedColor
            self.indicatorView.backgroundColor = _selectedColor

            let rgb = getRGBWithColor(color: _selectedColor)
            self.selectedColorR = rgb[0]
            self.selectedColorG = rgb[1]
            self.selectedColorB = rgb[2]
        }
        get {
            return _selectedColor
        }
    }
    /*tab背景色，默认white*/
    var _tabBackgroundColor: UIColor = UIColor.white
    var tabBackgroundColor: UIColor {
        set {
            _tabBackgroundColor  = newValue
        }
        get {
            return _tabBackgroundColor
        }
    }
    /*body背景色，默认white*/
    var _bodyBackgroundColor: UIColor = UIColor.white
    var bodyBackgroundColor: UIColor {
        set {
            _bodyBackgroundColor = newValue
        }
        get {
            return _bodyBackgroundColor
        }
    }
    /*是否打开body的边界弹动效果*/
    var _bodyBounces = true
    var bodyBounces: Bool {
        set {
            _bodyBounces = newValue
        }
        get {
            return _bodyBounces
        }
    }
    /*Title效果设置*/
    var _titleStyle: LHPageTabTitleStyle = .defaultstyle
    var titleStyle: LHPageTabTitleStyle {
        set {
            _titleStyle = newValue
        }
        get {
            return _titleStyle
        }
    }
    /*字体渐变，未选择的item的scale，默认是0.8（0~1）。仅LHPageTabTitleStyleScale生效*/
    var _minScale: CGFloat = kMinScale
    var minScale: CGFloat {
        set {
            _minScale = newValue
        }
        get {
            return _minScale
        }
    }

    /*Indicator效果设置*/
    var _indicatorStyle: LHPageTabIndicatorStyle = .defaultstyle
    var indicatorStyle: LHPageTabIndicatorStyle {
        set {
            _indicatorStyle = newValue
        }
        get {
            return _indicatorStyle
        }
    }
    /*下标高度，默认是2.0*/
    var indicatorHeight: CGFloat = kIndicatorHeight
    /*下标宽度，默认是0。LHPageTabIndicatorStyleFollowText时无效*/
    var indicatorWidth: CGFloat = kIndicatorWidth

    //data
    var lastSelectedTabIndex = 0
    /*记录上一次的索引 */
    var numberOfTabItems: Int = 0
    var tabItemWidth: CGFloat = 0.0
    var tabItems: [MyItem] = [MyItem]()


    //animation
    var isNeedRefreshLayout = true

    var isChangeByClick = false

    var  leftItemIndex: Int = 0 //记录滑动时左边的itemIndex
    var  rightItemIndex: Int = 0 //记录滑动时右边的itemIndex

    /*LHPageTabTitleStyleScale*/
    var   selectedColorR: CGFloat = 1.0
    var   selectedColorG: CGFloat = 0.0
    var   selectedColorB: CGFloat = 0.0
    var   unSelectedColorR: CGFloat = 0.0
    var   unSelectedColorG: CGFloat = 0.0
    var   unSelectedColorB: CGFloat = 0.0

    var childControllers:[UIViewController] = [UIViewController]()

    var childTitles: [String] = [String]()

    //按钮视图
    lazy var tabView: UIScrollView =  {
        let tabView = UIScrollView()
        tabView.showsVerticalScrollIndicator = false
        tabView.showsHorizontalScrollIndicator = false
        tabView.delegate = self
        tabView.clipsToBounds = true
        return tabView
    }()

    //页面视图
    lazy var bodyView: UIScrollView =  {
        let bodyView = UIScrollView()
        bodyView.isPagingEnabled = true
        bodyView.showsVerticalScrollIndicator = false
        bodyView.showsHorizontalScrollIndicator = false
        bodyView.delegate = self
        bodyView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        return bodyView
    }()

    lazy var indicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.backgroundColor = selectedColor
        return indicatorView
    }()

    weak var delegate: LHPageTabeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(childControllers: [UIViewController], childTitles: [String])  {
        self.init()
        self.childControllers = childControllers
        self.childTitles = childTitles
        initMainView()
        initTabView()
    }

    override func layoutSubviews() {
        initBaseSettings()
        if(isNeedRefreshLayout) {
            //tab layout
            if(tabSize.height <= 0) {
                tabSize.height = kTabDefautHeight;
            }
            if(tabSize.width <= 0) {
                tabSize.width = WIDTH(view: self)
            }
            tabItemWidth = tabSize.width/CGFloat(maxNumberOfPageItems)

            self.tabView.frame = CGRect.init(x: 0, y: 0, width: tabSize.width, height: tabSize.height)
            self.tabView.contentSize = CGSize.init(width: tabItemWidth*CGFloat(numberOfTabItems), height: 0)
            self.tabView.backgroundColor = tabBackgroundColor


            for i in 0..<tabItems.count {
                let tabItem = tabItems[i]
                tabItem.frame = CGRect.init(x: tabItemWidth*CGFloat(i), y: 0, width: tabItemWidth, height: tabSize.height)
            }
            layoutIndicatorViewWithStyle()

            //body layout
            self.bodyView.frame = CGRect.init(x: 0, y: tabSize.height, width: WIDTH(view: self), height: HEIGHT(view: self)-tabSize.height)
            self.bodyView.contentSize = CGSize.init(width: SCREEN_WIDTH*CGFloat(numberOfTabItems), height: 0)
            self.bodyView.contentOffset = CGPoint.init(x: SCREEN_WIDTH*CGFloat(selectedTabIndex), y: 0)
            self.bodyView.backgroundColor = bodyBackgroundColor
            self.bodyView.bounces = bodyBounces

            reviseTabContentOffsetBySelectedIndex(isAnimate: false)

            for i in 0..<childControllers.count {
                let vc = childControllers[i]
                vc.view.frame = CGRect.init(x: WIDTH(view: self)*CGFloat(i), y: 0, width: WIDTH(view: self), height: HEIGHT(view: self)-tabSize.height)
            }
        }
    }

    func initBaseSettings() {
        tabItemFont = UIFont.systemFont(ofSize: kTabDefautFontSize)
        addIndicatorViewWithStyle()
        addTabItemScaleStyle()
    }

    func initTabView() {
        addSubview(self.tabView)
        for i in 0..<numberOfTabItems {
            let tabItem = MyItem()
            tabItem.font = tabItemFont
            tabItem.text = childTitles[i]
            tabItem.textColor = i == selectedTabIndex ? selectedColor : unSelectedColor
            tabItem.textAlignment = .center
            tabItem.isUserInteractionEnabled = true

            let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(changeChildControllerOnClick(tap:)))
            tabItem.addGestureRecognizer(tapRecognizer)
            tabItems.append(tabItem)
            tabView.addSubview(tabItem)
        }
    }

    func initMainView() {
        addSubview(self.bodyView)
        numberOfTabItems = childControllers.count > childTitles.count ? childTitles.count : childControllers.count
        for i in 0..<numberOfTabItems {
            let childController = childControllers[i]
            bodyView.addSubview(childController.view)
        }
    }

    func layoutIndicatorView() {
        let indicatorWidth: CGFloat = getIndicatorWidthWithTitle(title: childTitles[selectedTabIndex])
        let selecedTabItem: MyItem = tabItems[selectedTabIndex];
        self.indicatorView.frame = CGRect.init(x: selecedTabItem.center.x-indicatorWidth/2.0-tabView.contentOffset.x, y: tabSize.height-indicatorHeight, width: indicatorWidth, height: indicatorHeight)
    }

    //pragma mark - Tool
    /**
     根据对应文本计算下标线宽度
     */
    func getIndicatorWidthWithTitle(title: String) -> CGFloat{
        if(indicatorStyle == LHPageTabIndicatorStyle.defaultstyle || indicatorStyle == LHPageTabIndicatorStyle.stretch) {
            return indicatorWidth;
        } else {
            if(title.count <= 2) {
                return 40;
            } else {
                return CGFloat(title.count) * tabItemFont.pointSize + 12;
            }
        }
    }

    /**
     根据选择项修正tab的展示区域
     */
    func reviseTabContentOffsetBySelectedIndex(isAnimate: Bool) {
        let currentTabItem = tabItems[selectedTabIndex]
        let selectedItemCenterX = currentTabItem.center.x

        var reviseX: CGFloat
        if(selectedItemCenterX + tabSize.width/2.0 >= self.tabView.contentSize.width) {
            reviseX = tabView.contentSize.width - tabSize.width; //不足以到中心，靠右
        } else if(selectedItemCenterX - tabSize.width/2.0 <= 0) {
            reviseX = 0; //不足以到中心，靠左
        } else {
            reviseX = selectedItemCenterX - tabSize.width/2.0; //修正至中心
        }
        //如果前后没有偏移量差，setContentOffset实际不起作用；或者没有动画效果
        if(abs(tabView.contentOffset.x - reviseX) < 1 || !isAnimate) {
            finishReviseTabContentOffset()
        }
        tabView.setContentOffset(CGPoint.init(x: reviseX, y: 0), animated: isAnimate)
    }

    /**
     tabview修正完成后的操作，无论是点击还是滑动body，此方法都是真正意义上的最后一步
     */
    func finishReviseTabContentOffset() {
        isNeedRefreshLayout = true
        isChangeByClick = false
        if (delegate?.responds(to: #selector(LHPageTabeViewDelegate.pageTabViewDidEndChange)))! {
            if(lastSelectedTabIndex != selectedTabIndex) {
                delegate?.pageTabViewDidEndChange()
            }
        }
        lastSelectedTabIndex = selectedTabIndex;
    }

    /**
     一般常用改变selected Item方法(无动画效果，直接变色)
     */
    func changeSelectedItemToNextItem(nextIndex: NSInteger) {
        let currentTabItem = tabItems[selectedTabIndex]
        let  nextTabItem = tabItems[nextIndex]
        currentTabItem.textColor = unSelectedColor
        nextTabItem.textColor = selectedColor
    }

    //MARK: Title layout
    func resetTabItemScale() {
        for i in 0..<numberOfTabItems {
            let tabItem = tabItems[i]
            if(i != selectedTabIndex) {
                tabItem.transform = CGAffineTransform.init(scaleX: minScale, y: minScale)
            } else {
                tabItem.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }
        }
    }

    /**
     根据不同风格对下标layout
     */
    func addTabItemScaleStyle() {
        switch (titleStyle) {
        case .defaultstyle:
            break
        case .blend:
            break
        case .gradient:
            resetTabItemScale()
            break;
        }
    }


    /**
     根据不同风格对下标layout
     */
    func layoutIndicatorViewWithStyle() {
        switch (indicatorStyle) {
        case .defaultstyle:
            break
        case .followtext:
            break
        case .stretch:
            layoutIndicatorView()
            break;
        }
    }

    //MARK: Indicator layout
    /**
     根据不同风格添加相应下标
     */
    func addIndicatorViewWithStyle() {
        switch (indicatorStyle) {
        case .defaultstyle:
            break
        case .followtext:
            break
        case .stretch:
            addSubview(self.indicatorView)
            break;
        }
    }


    //MARK: Event response
    @objc func changeChildControllerOnClick(tap: UITapGestureRecognizer) {
        let nextIndex = tabItems.firstIndex(of: tap.view as! MyItem)!
        if(nextIndex != selectedTabIndex) {
            if(titleStyle == .defaultstyle) {
                changeSelectedItemToNextItem(nextIndex: nextIndex)
            }
            isChangeByClick = true
            reviseTabContentOffsetBySelectedIndex(isAnimate: true)
            leftItemIndex = nextIndex > selectedTabIndex ? selectedTabIndex : nextIndex
            rightItemIndex = nextIndex > selectedTabIndex ? nextIndex : selectedTabIndex
            selectedTabIndex = nextIndex
            bodyView.setContentOffset(CGPoint.init(x: self.frame.size.width*CGFloat(selectedTabIndex), y: 0), animated: true)
        }
    }

    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bodyView {
            selectedTabIndex = Int(bodyView.contentOffset.x/WIDTH(view: bodyView))
            reviseTabContentOffsetBySelectedIndex(isAnimate: true)
        }
        //获取偏移量
        let currentPage = scrollView.contentOffset.x/SCREEN_WIDTH
        print(currentPage)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == bodyView {
            reviseTabContentOffsetBySelectedIndex(isAnimate: true)
        } else {
            finishReviseTabContentOffset()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tabView {
            isNeedRefreshLayout = false
            if (indicatorView.superview != nil) {
                let selecedTabItem = tabItems[selectedTabIndex]
                indicatorView.frame = CGRect.init(x: selecedTabItem.center.x-WIDTH(view: self.indicatorView)/2.0-scrollView.contentOffset.x, y: ORIGIN_Y(view: self.indicatorView), width: WIDTH(view: self.indicatorView), height: HEIGHT(view: self.indicatorView))
            }
        } else if scrollView == bodyView {
            //未初始化不处理
            guard (self.bodyView.contentSize.width > 0) else { return }
            isNeedRefreshLayout = false
            //获取当前左右item index(点击方式已获知左右index，无需根据contentoffset计算)
            if !isChangeByClick {
                if(self.bodyView.contentOffset.x <= 0) { //左边界
                    leftItemIndex = 0
                    rightItemIndex = 0
                } else if(self.bodyView.contentOffset.x >= self.bodyView.contentSize.width-WIDTH(view: self.bodyView)) { //右边界
                    leftItemIndex = numberOfTabItems-1
                    rightItemIndex = numberOfTabItems-1
                } else {
                    leftItemIndex = Int(self.bodyView.contentOffset.x/WIDTH(view: self.bodyView))
                    rightItemIndex = leftItemIndex + 1
                }
            }
            //调整title
            switch(titleStyle) {
            case .defaultstyle:
                changeTitleWithDefault()
                break
            case .gradient:
                changeTitleWithGradient()
                break
            case .blend:
                changeTitleWithBlend()
                break
            }

            //调整indicator
            switch (indicatorStyle) {
            case .defaultstyle:
                break
            case .followtext:
                changeIndicatorFrame()
                break;
            case .stretch:
                if(isChangeByClick) {
                    changeIndicatorFrame()
                } else {
                    changeIndicatorFrameByStretch()
                }
                break;
            }
        }
    }

    //MARK: Title animation
    func changeTitleWithDefault() {
        let relativeLocation = self.bodyView.contentOffset.x/WIDTH(view: self.bodyView) - CGFloat(leftItemIndex)
        if(!isChangeByClick) {
            if(relativeLocation > 0.5) {
                changeSelectedItemToNextItem(nextIndex: rightItemIndex)
                selectedTabIndex = rightItemIndex;
            } else {
                changeSelectedItemToNextItem(nextIndex: leftItemIndex)
                selectedTabIndex = leftItemIndex;
            }
        }
    }

    func changeTitleWithGradient() {
        if(leftItemIndex != rightItemIndex) {
            let rightScale = (self.bodyView.contentOffset.x/WIDTH(view: self.bodyView) - CGFloat(leftItemIndex))/CGFloat(rightItemIndex - leftItemIndex);
            let leftScale = 1 - rightScale

            //颜色渐变
            let difR = selectedColorR - unSelectedColorR
            let difG = selectedColorG - unSelectedColorG
            let difB = selectedColorB - unSelectedColorB

            let leftItemColor = UIColor.init(red: unSelectedColorR + leftScale*difR, green: unSelectedColorG + leftScale*difG, blue: unSelectedColorB + leftScale*difB, alpha: 1)
            let rightItemColor = UIColor.init(red: unSelectedColorR + rightScale*difR, green: unSelectedColorG + rightScale*difG, blue: unSelectedColorB + rightScale*difB, alpha: 1)

            let leftTabItem = tabItems[leftItemIndex]
            let rightTabItem = tabItems[rightItemIndex]
            leftTabItem.textColor = leftItemColor
            rightTabItem.textColor = rightItemColor

            //字体渐变
            leftTabItem.transform = CGAffineTransform.init(scaleX: minScale+(1-minScale)*leftScale, y: minScale+(1-minScale)*leftScale)
            rightTabItem.transform = CGAffineTransform.init(scaleX: minScale+(1-minScale)*rightScale, y: minScale+(1-minScale)*rightScale)
        }
    }

    func changeTitleWithBlend() {
        let leftScale = self.bodyView.contentOffset.x/WIDTH(view: self.bodyView) - CGFloat(leftItemIndex)
        if(leftScale == 0) {
            return //起点和终点不处理，终点时左右index已更新，会绘画错误（你可以注释看看）
        }
        let leftTabItem = tabItems[leftItemIndex]
        let rightTabItem = tabItems[rightItemIndex]

        leftTabItem.textColor = selectedColor
        rightTabItem.textColor = unSelectedColor
        leftTabItem.fillColor = unSelectedColor;
        rightTabItem.fillColor = selectedColor;
        leftTabItem.process = leftScale;
        rightTabItem.process = leftScale;
    }

    //MARK: - Indicator animation
    func changeIndicatorFrame() {
        //计算indicator此时的centerx
        let  nowIndicatorCenterX = tabItemWidth*(0.5+self.bodyView.contentOffset.x/WIDTH(view: self.bodyView))
        //计算此时body的偏移量在一页中的占比
        var relativeLocation = (self.bodyView.contentOffset.x/WIDTH(view: self.bodyView) - CGFloat(leftItemIndex))/CGFloat(rightItemIndex-leftItemIndex)
        //记录左右对应的indicator宽度
        let leftIndicatorWidth = getIndicatorWidthWithTitle(title: childTitles[leftItemIndex])
        let rightIndicatorWidth = getIndicatorWidthWithTitle(title: childTitles[rightItemIndex])

        //左右边界的时候，占比清0
        if(leftItemIndex == rightItemIndex) {
            relativeLocation = 0
        }
        //基于从左到右方向（无需考虑滑动方向），计算当前中心轴所处位置的长度
        let nowIndicatorWidth = leftIndicatorWidth + (rightIndicatorWidth-leftIndicatorWidth)*relativeLocation;

        self.indicatorView.frame = CGRect.init(x: nowIndicatorCenterX-nowIndicatorWidth/2.0-tabView.contentOffset.x, y: ORIGIN_Y(view: self.indicatorView), width: nowIndicatorWidth, height: HEIGHT(view: self.indicatorView))
    }

    func changeIndicatorFrameByStretch() {
        guard (indicatorWidth > 0) else { return }
        //计算此时body的偏移量在一页中的占比
        var relativeLocation = (self.bodyView.contentOffset.x/WIDTH(view: self.bodyView)-CGFloat(leftItemIndex))/CGFloat(rightItemIndex-leftItemIndex)
        //左右边界的时候，占比清0
        if(leftItemIndex == rightItemIndex) {
            relativeLocation = 0
        }

        let leftTabItem = tabItems[leftItemIndex]
        let rightTabItem = tabItems[rightItemIndex]

        //当前的frame
        var nowFrame = CGRect.init(x: 0, y: ORIGIN_Y(view: self.indicatorView), width: 0, height: HEIGHT(view: self.indicatorView))

        //计算宽度
        if(relativeLocation <= 0.5) {
            nowFrame.size.width = indicatorWidth+tabItemWidth*(relativeLocation/0.5);
            nowFrame.origin.x = (leftTabItem.center.x-self.tabView.contentOffset.x)-indicatorWidth/2.0;
        } else {
            nowFrame.size.width = indicatorWidth+tabItemWidth*((1-relativeLocation)/0.5);
            nowFrame.origin.x = (rightTabItem.center.x-self.tabView.contentOffset.x)+indicatorWidth/2.0-nowFrame.size.width;
        }
        self.indicatorView.frame = nowFrame;
    }

    //MARK: - Tool
    /**
     获取color的rgb值
     */
    func getRGBWithColor(color: UIColor) -> [CGFloat] {
        var R: CGFloat = 0.0, G: CGFloat = 0.0, B: CGFloat = 0.0;
        let numComponents = color.cgColor.numberOfComponents
        if(numComponents == 4) {
            let components = color.cgColor.components!
            R = components[0]
            G = components[1]
            B = components[2]
        }
        return [R, G, B]
    }

}

class MyItem: UILabel {

    var fillColor: UIColor?

    var _process: CGFloat?
    var process: CGFloat? {
        set {
            _process = newValue
            setNeedsDisplay()
        }
        get {
            return _process
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if fillColor?.isKind(of: UIColor.self) ?? false {
            fillColor!.setFill()
            UIRectFillUsingBlendMode(CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width*process!, height: rect.size.height), .sourceIn)
        }
    }

}






