//
//  LHPhotoShowVC.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/19.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class PhotoItem: NSObject {
    var image:UIImage?
    var srcUrl: String?
}
class LHPhotoShowVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ScalableImageViewDelegate {
    
    /** Set true for view */
    var forView = false
    /** The current photo index */
    var currentIndex = 0
    /** Data source 1: Photo Items */
    var items =  [PhotoItem]()
    /** Data source 2*/
    var _urlItems: [String]?
    var _photoItems: [UIImage]?
    /** Delete done callback if has deleted some photos */
    var onDeletePhotoDone: ((_ c: LHPhotoShowVC) -> Void)?
    
    var urlItems: [String]? {
        set {
            _urlItems = newValue;
        }
        get {
            return _urlItems;
        }
    }
    
    var photoItems: [UIImage]? {
        set {
            _photoItems = newValue;
        }
        get {
            return _photoItems;
        }
    }
    
    //Privates
    fileprivate var deleted = false
    fileprivate var titleLabel: UILabel?
    fileprivate var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        if !forView {
            let right = UIBarButtonItem.init(title: "删除", style: .plain, target: self, action: #selector(onClickDelete(_:)))
            self.navigationItem.rightBarButtonItem = right
        }
        let left = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(onClickBack(_:)))
        self.navigationItem.leftBarButtonItem = left
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.textColor = UIColor.white
        self.navigationItem.titleView = titleLabel!
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: view.width, height: view.height-122)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.backgroundColor = self.view.backgroundColor
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.isPagingEnabled = true
        self.view.addSubview(collectionView!)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        if urlItems != nil {
            for url in urlItems! {
                let pi = PhotoItem()
                pi.srcUrl = url
                items.append(pi)
            }
        }
        if photoItems != nil {
            for image in photoItems! {
                let pi = PhotoItem()
                pi.image = image
                items.append(pi)
            }
        }
        
        titleLabel?.text = String(format: "%d/%d",currentIndex + 1,items.count)
        collectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: UICollectionViewScrollPosition(), animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge.all
        collectionView?.contentInsetAdjustmentBehavior = .automatic
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var v = cell.contentView.viewWithTag(100) as? ScalableImageView
        if (v == nil){
            v = ScalableImageView(frame: cell.bounds)
            v?.tag = 100
            v?.delegateTarget = self
            cell.contentView.addSubview(v!)
        }
        let item = items[indexPath.row]
        if item.image != nil {
            v?.imageView?.image = item.image!
        }
        if item.srcUrl != nil {
            v?.imageView?.sd_setImage(with: URL(string: item.srcUrl!))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        titleLabel?.text = String(format: "%d/%d",currentIndex + 1,items.count)
    }

    func onImageViewSingleTap(_ imgv: ScalableImageView) {
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = !nav.isNavigationBarHidden;
        }
    }
    
    @objc func onClickBack(_ sender: Any?){
        self.navigationController?.popViewController(animated: true);
        if deleted {
            if let block = self.onDeletePhotoDone {
                block(self);
            }
        }
    }
    
    @objc func onClickDelete(_ sender: Any?){
        LHHUBViewController().alertView(VC: self, title: "确定要删除吗?", message: nil, block: { (index)in
            if index == 0 {
                self.deleted = true
                self.items.remove(at: self.currentIndex)
                self.collectionView?.reloadData()
                if self.items.count == 0 {
                    self.onClickBack(nil);
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - ScalableImageView

class ScalableImageView : UIScrollView, UIScrollViewDelegate {
    
    fileprivate var _imageView: UIImageView?;
    var imageView: UIImageView? {
        get { return _imageView; }
    }
    
    var delegateTarget: ScalableImageViewDelegate?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        
        _imageView = UIImageView(frame: self.bounds)
        _imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(_imageView!)
        
        let g = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(g)
        
        let g2 = UITapGestureRecognizer(target: self, action:  #selector(handleTap))
        g2.numberOfTapsRequired = 2
        self.addGestureRecognizer(g2)
        g.require(toFail: g2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return _imageView
    }
    
    @objc func handleTap(_ g: UITapGestureRecognizer){
        if g.numberOfTapsRequired == 2 {
            
            var scale = self.zoomScale
            scale = scale < self.maximumZoomScale ? scale + 0.5 : self.minimumZoomScale
            self.setZoomScale(scale, animated: true)
            
        } else {
            
            if let d = delegateTarget {
                d.onImageViewSingleTap(self)
            }
        }
    }
}

protocol ScalableImageViewDelegate {
    func onImageViewSingleTap(_ imgv: ScalableImageView)
}
