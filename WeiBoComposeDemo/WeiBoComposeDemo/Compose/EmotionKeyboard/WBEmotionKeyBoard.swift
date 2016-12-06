//
//  WBEmotionKeyBoard.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/5.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

private let identifier = "emotionKeyboardCell"

/// MARK: - cell的layout
fileprivate class EmotionKeyboardCellLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        itemSize = CGSize(width: screenWidth, height: 258-37-20)
    }
}


class WBEmotionKeyBoard: UIView {
    
    lazy var dataSourceArray = WBEmotionTool.shared.dataSourceArray
    
    lazy var toolBar: WBEmotionToolBar = {
        let toolBar = WBEmotionToolBar()
        toolBar.delegate = self
        return toolBar
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.dataSourceArray[0].count
        pageControl.currentPage = 0
        // 用kvc的方式设置隐藏的属性, OC还是不安全
        pageControl.setValue(UIImage(named:"compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        pageControl.setValue(UIImage(named:"compose_keyboard_dot_normal"), forKey: "_pageImage")
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    /// 选择图片的collectionView
    lazy var emtionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmotionKeyboardCellLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(WBEmotionKeyboardCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = UIColor.green
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension WBEmotionKeyBoard {
    func setupUI() {
        addSubview(emtionCollectionView)
        addSubview(toolBar)
        addSubview(pageControl)
        
        emtionCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(258-37-20)
            make.top.equalTo(self)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(emtionCollectionView.snp.bottom)
            make.bottom.equalTo(toolBar.snp.top)
            
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(37)
            make.bottom.equalTo(self)
        }
    }
    
    func changePageContol (indexPath: IndexPath) {
        //pageControl要改变? 1. numberOfPages, 2.currentPage
        //numberOfPages: 当前的组的cell的个数, 从数据源来的
        //currentPage: 0
        pageControl.numberOfPages = dataSourceArray[indexPath.section].count
        pageControl.currentPage = indexPath.item
    }
}


// MARK: - UICollectionViewDataSource
extension WBEmotionKeyBoard: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSourceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WBEmotionKeyboardCell
        cell.emotions = dataSourceArray[indexPath.section][indexPath.item]
        cell.backgroundColor = UIColor.white
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WBEmotionKeyBoard: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获得显示的cells
        let cells = emtionCollectionView.visibleCells
        //如果屏幕上显示的cell的cell有两个
        if cells.count > 1 {
            let offset = scrollView.contentOffset.x
            //第一个cell,显示的区域
            let cellOne = cells[0]
            //offset与origin.x的绝对值
            let regionOne = abs(cellOne.frame.origin.x - offset)
            //第一个cell的indexPath
            let indexPathOne = emtionCollectionView.indexPath(for: cellOne)
            
            //第二个cell
            let cellTwo = cells[1]
            //offset与origin.x的绝对值
            let regionTwo = abs(cellTwo.frame.origin.x - offset)
            //第二个cell的indexPath
            let indexPathTwo = emtionCollectionView.indexPath(for: cellTwo)
            
            //offset的originx的差的绝对值越小, 则显示的区域越大
            if regionOne < regionTwo {
                //使用cellOne的section
                toolBar.index = (indexPathOne?.section)!
                changePageContol(indexPath: indexPathOne!)
            } else {
                //使用cellTwo的section
                toolBar.index = (indexPathTwo?.section)!
                changePageContol(indexPath: indexPathTwo!)
            }
        }
    }
}

// MARK: - WBEmotionToolBarDelegate
extension WBEmotionKeyBoard: WBEmotionToolBarDelegate {
    func changeEmotion(index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        // toolBar与emotionCollectionView的联动,顺便toolBar与pageControl的联动
        emtionCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        changePageContol(indexPath: indexPath)
    }
}
