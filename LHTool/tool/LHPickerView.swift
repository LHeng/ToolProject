//
//  LHPickerView.swift
//  LHTool
//
//  Created by 刘恒 on 2018/6/26.
//  Copyright © 2018年 LH. All rights reserved.
//

import UIKit

class LHPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    enum Mytype {
        case selector
        case date
        case time
    }
    
    typealias Block = (_ string : String) ->()
    typealias dateBlock = (_ data:Date) ->()
    var textLabel : UILabel!
    var confirmButton : UIButton!
    
    var _dataList : [String] = [String]()
    var dataList : [String] {
      set {
                _dataList = newValue
        }
        get {
            return _dataList
        }
    }
    
    var _dateStr : String = ""
    var dateStr : String {
        set {
            _dateStr = newValue
        }
        get {
           return _dateStr
        }
    }
    
    var _timeStr : String = ""
    var timeStr : String {
        set {
            _timeStr = newValue
        }
        get {
            return _timeStr
        }
    }
    
    var seleRow : Int = 0
    var view: UIView!
    var bgView: UIView!

    var myblock : Block!
    var dateblock : dateBlock!
    
    var datePicker : UIDatePicker!
    
    var pickerView : UIPickerView!
    
    init(frame: CGRect,type:Mytype) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        view = UIView.init(frame: self.bounds)
        view?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        addSubview(view)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideView))
        view.addGestureRecognizer(tap)
        if type == Mytype.selector {
            pickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 200))
            pickerView.delegate = self
            pickerView.dataSource = self
        } else if type == Mytype.date {
            datePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 200))
            datePicker.datePickerMode = .date
            datePicker.locale = Locale.init(identifier: "zh_CN")
            let maxDate = Date.init(timeIntervalSinceNow: 24*60*60)
            datePicker.maximumDate = maxDate
            let minDate = Date.init()
            datePicker.maximumDate = minDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: timeStr)
            if timeStr.count > 0 {
                datePicker.date = date!
            }
        } else if type == Mytype.time {
            datePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 200))
            datePicker.datePickerMode = .time
            datePicker.locale = Locale.init(identifier: "zh_CN")
            let maxDate = Date.init(timeIntervalSinceNow: 24*60*60)
            datePicker.maximumDate = maxDate
            let minDate = Date.init()
            datePicker.maximumDate = minDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = dateFormatter.date(from: dateStr)
            if dateStr.count > 0 {
                datePicker.date = date!
            }
        }
        initWithPicker(view: datePicker)
    }
    
    func initWithPicker(view: UIView) {
        let barth : CGFloat = 40
        let rect = CGRect.init(x: 0, y: height, width: width, height: view.height+barth)
        bgView = UIView.init(frame: rect)
        bgView.backgroundColor = UIColor.white
        bgView.isUserInteractionEnabled = true
        addSubview(bgView)
        
        let bar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: width, height: barth))
        bar.layoutIfNeeded()
        bgView.addSubview(bar)
        
        confirmButton = UIButton.init(type: .custom)
        confirmButton.frame = CGRect.init(x: width - 50, y: 0, width: 50, height: 40)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.darkGray, for: .normal)
        confirmButton.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        bgView.addSubview(confirmButton)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: barth-0.5, width: width, height: 0.5))
        line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        bar.addSubview(line)
        
        view.frame = CGRect.init(x: 0, y: barth, width:view.width, height: view.height)
        view.backgroundColor = bgView.backgroundColor
        bgView.addSubview(view)
    }
    
    //消失
    @objc func hideView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.y = self.height
        }) { (true) in
            self.removeFromSuperview()
        }
    }
 
    //确认
    @objc func buttonEvent() {
       
        if let _ = myblock {
            myblock(dataList[seleRow])
        }
        if let _ = dateblock {
            dateblock(datePicker.date)
        }
        hideView()
    }
    
    //显示
    func showInView() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.y = UIScreen.main.bounds.height - self.bgView.frame.height
        }) { (true) in
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seleRow = row
    }
}
