//
//  WBComposeCell.swift
//  WeiBo
//
//  Created by Vitas on 2016/12/5.
//  Copyright © 2016年 Vitas. All rights reserved.
//

import UIKit

protocol WBComposeCellDelegate: NSObjectProtocol {
    func addOrChangePicture(cell: WBComposeCell)
    func deletePicture(cell: WBComposeCell)
}

class WBComposeCell: UICollectionViewCell {
    
    weak var delegate: WBComposeCellDelegate?
    
    var image: UIImage? {
        didSet {
            if let iamge = image {
                addButton.setBackgroundImage(iamge, for: .normal)
                addButton.setBackgroundImage(iamge, for: .highlighted)
                deleteButton.isHidden = false
            } else {
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .highlighted)
                deleteButton.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var addButton: UIButton = UIButton(title: nil, bgImage: "compose_pic_add", target: self, selector: #selector(addOrChangePicture))
    
    lazy var deleteButton: UIButton = UIButton(title: nil, bgImage: "compose_photo_close", target: self, selector: #selector(deletePicture))
    
}

extension WBComposeCell {
    func setupUI () {
        contentView.addSubview(addButton)
        contentView.addSubview(deleteButton)
        
        addButton.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.left.equalTo(addButton.snp.right).offset(-10)
            make.top.equalTo(addButton.snp.top).offset(-10)
        }
    }
}

extension WBComposeCell {
    @objc fileprivate func addOrChangePicture() {
        delegate?.addOrChangePicture(cell: self)
    }
    
    @objc fileprivate func deletePicture() {
        delegate?.deletePicture(cell: self)
    }
}
