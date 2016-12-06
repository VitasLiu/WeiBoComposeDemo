//
//  WBComposeViewController.swift
//  WeiBo
//
//  Created by Vitas on 2016/11/23.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit


private let identifierCell = "identifierCell"
private let maxPictureCount = 5

// MARK: - cell的layout
class ComposeImageLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        // 因为(screenWidth - 4 * 10) / 3 在系统里计算出来的结果是124.666666666667,3个itemSize的宽度比总的要大0.0001,所以不够位置, 只显示出两个item
        itemSize = CGSize(width: (screenWidth - 4 * 10) / 3 - 0.1, height: (screenWidth - 4 * 10) / 3 - 0.1)
    }
}

class WBComposeViewController: UIViewController {
    /// pictureView的数据源
    lazy var pictures: [UIImage] = []
    
    var selectedIndex: Int = 0
    
    /// 取消按钮
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIButton(title: "取消", fontSize: 15, color: UIColor.white, bgImage: "new_feature_finish_button", target: self, selector: #selector(cancel))
        let buttonItem = UIBarButtonItem(customView: button)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        return buttonItem
    }()
    
    /// 发布按钮
    lazy var composeButton: UIButton = {
        let button = UIButton(title: "发布", fontSize: 15, color: UIColor.white, bgImage: "new_feature_finish_button", target: self, selector: #selector(compose))
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        return button
    }()
    
    /// toolbar
    lazy var toolBar: UIToolbar = UIToolbar()
    
    /// textView
    lazy var textView: WBComposeTextView = WBComposeTextView()
    
    /// 选择图片的collectionView
    lazy var pictureView: UICollectionView = {
       let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ComposeImageLayout())
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WBComposeCell.self, forCellWithReuseIdentifier: identifierCell)
        collectionView.backgroundColor = UIColor.green
        
        return collectionView
    }()
    /// 是否是默认键盘
    var isDefaultKeyboard: Bool = true
    /// toolBar是否需要执行动画
    var shouldAnimation: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
        
        /// 键盘将要变化通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addOrDeleteEmotion(notification:)), name: addOrDeleteNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 设置UI
extension WBComposeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupTextView()
        setupToolBar()
        setupPictureView()
    }
    
    /// 设置navigationBar
    func setupNavigationBar() {
        // 取消按钮
        navigationItem.leftBarButtonItem = leftBarButtonItem
        // 发布按钮: 默认是disable的状态
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeButton)
        composeButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        composeButton.setTitleColor(UIColor.gray, for: .disabled)
        composeButton.isEnabled = false
        
        // titleView
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        let titleString = NSMutableAttributedString(string: "发布微博\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.black])
        let userNameString = NSAttributedString(string: "Vitas", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.lightGray])
        titleString.append(userNameString)
        
        titleLabel.attributedText = titleString
        
        navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
    }
    
    /// 设置textView
    func setupTextView() {
        textView.placeHolder = "Say something"
        textView.delegate = self
        view.addSubview(textView)
        
        /// 自动布局
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    /// 设置图片选择视图
    func setupPictureView() {
        textView.addSubview(pictureView)
        //textView是一个scrollView, 自动布局的时候,其right作为参照是contentSize的width
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(100)
            make.left.equalTo(textView).offset(10)
            make.width.equalTo(screenWidth - 2*10)
            make.height.equalTo(screenWidth - 2*10)
        }
    }
    
    /// 设置toolBar
    func setupToolBar() {
        view.addSubview(toolBar)
        
        //添加五个item
        let itemDictArray: [[String: Any]] = [["image": "compose_toolbar_picture", "Selector": #selector(emotionKeyboard)],
            ["image": "compose_trendbutton_background", "Selector": #selector(emotionKeyboard)],
            ["image": "compose_mentionbutton_background", "Selector": #selector(emotionKeyboard)],
            ["image": "compose_emoticonbutton_background", "Selector": #selector(emotionKeyboard)],
            ["image": "compose_keyboardbutton_background", "Selector": #selector(emotionKeyboard)]]
        
        var itemsArray: [UIBarButtonItem] = []
        
        for dict in itemDictArray {
            if let image = dict["image"] as? String,
                let selector = dict["Selector"] as? Selector {
                // 按钮的buttonItem
                let button = UIButton(title: nil, image: image, target: self, selector: selector)
                let buttonItem = UIBarButtonItem(customView: button)
                itemsArray.append(buttonItem)
                button.sizeToFit()
                // 弹簧buttonItem
                let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                itemsArray.append(flexibleItem)
            }
        }
        
        itemsArray.removeLast()
        toolBar.items = itemsArray
        
        toolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }
}

// MARK: - 处理事件
extension WBComposeViewController {
    
    /// 添加或删除表情
    ///
    /// - Parameter notification: 通知
    @objc fileprivate func addOrDeleteEmotion(notification: Notification) {
        if let userInfo = notification.userInfo {
            // 如果是删除表情
            if let isDelete = userInfo["isDelete"] as? Bool, isDelete == true {
                // 文本视图自带的删除方法
                textView.deleteBackward()
            }
            // 如果是插入表情, 获取从cell传递过来的emotion(模型对象), 接着textView就要执行插入表情的方法
            if let emotion = userInfo["emotion"] as? WBEmotionModel {
                // 让textView插入表情
                textView.insertEmotion(emotion: emotion)
            }
        }
    }
    
    /// 取消返回到主页
    @objc fileprivate func cancel() {
        print("取消")
    }
    
    /// 发布微博
    @objc fileprivate func compose() {
        print("发布微博")
    }
    
    /// 切换键盘
    @objc fileprivate func emotionKeyboard() {
        let emotionKeyboard = WBEmotionKeyBoard(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 271))
        emotionKeyboard.backgroundColor = UIColor.white
        
        //要想切换键盘, 首先需要将当前的键盘收起来
        
        //收起键盘
        //becomeFirstResponder: 弹出键盘, 把光标定位到当前控件
        
        //收起键盘后,要迅速弹出键盘, 会产生两次动画, 让第一次动画不执行
        shouldAnimation = false
        textView.resignFirstResponder()
        shouldAnimation = true
        
        //如果是默认键盘, 弹出自定义键盘
        if isDefaultKeyboard {
            //使用自定义的键盘
            textView.inputView = emotionKeyboard
            isDefaultKeyboard = false
            //如果是自定义键盘, 弹出系统键盘
        } else {
            textView.resignFirstResponder()
            textView.inputView = nil
            isDefaultKeyboard = true
        }
        //弹出键盘
        textView.becomeFirstResponder()
    }
    
    //[UIWindow endDisablingInterfaceAutorotationAnimated:]苹果的bug
    /// keyboardWillChange 键盘将要发生变化通知
    @objc fileprivate func keyboardWillChange(notification: Notification) {
        //print(notification.userInfo)
        
        if shouldAnimation == false {
            return
        }
        
        //从userInfo中获取键盘的frame的originX
        if let userInfo = notification.userInfo as? [String: Any],
            let keyboardEndOriginY = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? CGFloat
        {
            //计算出toolBar的bottom的offset
            let offset = keyboardEndOriginY - screenHeight
            
            //更新toolBar的布局
            toolBar.snp.updateConstraints({ (make) in
                make.bottom.equalTo(offset)
            })
            
            //执行动画
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                //强制更新UI,让toolBar的布局生效
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - UITextViewDelegate
extension WBComposeViewController: UITextViewDelegate {
    /// 文字发生变化的代理方法
    func textViewDidChange(_ textView: UITextView) {
        composeButton.isEnabled = textView.text.characters.count > 0
    }
}

// MARK: - UICollectionViewDataSource
extension WBComposeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count < maxPictureCount ? pictures.count + 1 : maxPictureCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCell, for: indexPath) as! WBComposeCell
        cell.delegate = self
        //如果是加号按钮传nil, 如果是图片的cell, 就传image
        //判断是否是加号
        if indexPath.row == pictures.count {
            cell.image = nil
        } else {
            cell.image = pictures[indexPath.row]
        }
        
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WBComposeViewController: UICollectionViewDelegate {
    
}

extension WBComposeViewController: WBComposeCellDelegate {
    func addOrChangePicture(cell: WBComposeCell) {
        //通过cell获取cell对应的index
        selectedIndex = (pictureView.indexPath(for: cell)?.item)!
        
        //1. 弹出imagePicker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// 删除图片
    ///
    /// - Parameter cell: 点击的cell
    func deletePicture(cell: WBComposeCell) {
        selectedIndex = (pictureView.indexPath(for: cell)?.item)!
        pictures.remove(at: selectedIndex)
        pictureView.reloadData()
    }
}

extension WBComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //从相册中取出原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //获取原图的大小(M)(B->KB->MB)
//        let imageLength = (UIImagePNGRepresentation(image)?.count)! / (1024 * 1024)
        //将原图压缩成小图
        let littleImage = image.wb_createImage(isCornored: false, size: CGSize(width: 50, height: 50))
        //小图的大小(M)
//        let littleimageLength = Double((UIImagePNGRepresentation(littleImage)?.count)!) / (1024.0 * 1024.0)
        
        //使用小图
        //如果点击的是加号
        if selectedIndex == pictures.count {
            pictures.append(littleImage)
        } else {
            pictures[selectedIndex] = littleImage
        }
        // 一旦实现UIImagePickerControllerDelegate的didFinishPickingMediaWithInfo方法, 就需要自己去dismiss
        //把图片选择的controller dismiss掉
        dismiss(animated: true, completion: nil)
        
        //刷新CollectionView
        pictureView.reloadData()
    }
}











