//
//  LHMyUploadPhotoVC.swift
//  LHTool
//
//  Created by 刘恒 on 2018/7/18.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHMyUploadPhotoVC: LHBaseViewController {

    var images:[UIImage] = [UIImage]()
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addPhoto(_ sender: Any) {
        addPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LHMyUploadPhotoVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LHMyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LHMyCollectionViewCell
        cell.tag = indexPath.row
        if images.count == 0 {
            cell.myButton.isHidden = true
            cell.myImage = UIImage.init(named: "btn_addPicture_BgImage")!
        } else {
            if indexPath.row == images.count  {
                cell.myButton.isHidden = true
                cell.myImage = UIImage.init(named: "btn_addPicture_BgImage")!
            } else {
                cell.myButton.isHidden = false
                cell.myImage = images[indexPath.row]
            }
        }
        cell.myblock = {(index)in
            print(index)
            self.images.remove(at: index)
            collectionView.reloadData()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (view.width - 40)/3 , height: ((view.width - 40)/3)*1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if images.count == 0 {
            addPhoto()
        } else {
            if indexPath.row == images.count {
                addPhoto()
            } else {
                let vc  = LHPhotoShowVC()
                vc.photoItems = images
                vc.currentIndex = indexPath.row
                vc.onDeletePhotoDone = {(c)in
                    self.images.removeAll()
                    for pi in c.items {
                        self.images.append(pi.image!)
                    }
                    collectionView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    

    func addPhoto() {
        LHHUBViewController().actionSheetView(vc: self, title: nil, message: nil) { (index) in
            switch index {
            case 1:
                break;
            case 2:
                let vc =  TZImagePickerController.init(maxImagesCount: 9, delegate: self)
                self.present(vc!, animated: true, completion: nil)
                break;
            default:
                break
            }
        }
    }
    
    //MARK: - TZImagePickerControllerDelegate
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        //这里获取到相册的图片集合,在这里进行图片上传操作
        for i in 0..<photos.count {
            images.append(photos[i])
        }
        myCollectionView.reloadData()
    }
}