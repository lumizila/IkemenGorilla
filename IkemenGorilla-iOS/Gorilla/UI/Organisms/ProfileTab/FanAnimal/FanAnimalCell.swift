//
//  FanAnimalCell.swift
//  Gorilla
//
//  Created by admin on 2020/06/11.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class FanAnimalCell: UICollectionViewCell, View, ViewConstructor {
    
    struct Const {
        static let cellWidth: CGFloat = (DeviceSize.screenWidth - 64) / 2
        static let cellHeight: CGFloat = cellWidth + 16 + 16 + 16 + 36
        static let itemSize: CGSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Const.cellWidth / 2
        $0.clipsToBounds = true
    }
    
    private let animalNameLabel = UILabel().then {
        $0.apply(fontStyle: .regular, size: 16)
        $0.textColor = Color.black
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let fanButton = FanButton()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    func setupViews() {
        addSubview(imageView)
        addSubview(animalNameLabel)
        addSubview(fanButton)
    }
    
    func setupViewConstraints() {
        imageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.size.equalTo(Const.cellWidth)
        }
        animalNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.centerX.equalTo(imageView.snp.centerX)
            $0.height.equalTo(16)
        }
        fanButton.snp.makeConstraints {
            $0.top.equalTo(animalNameLabel.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    func bind(reactor: FanAnimalCellReactor) {
        // Action
        fanButton.rx.tap
            .bind { _ in
                reactor.action.onNext(.tapFanButton)
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.fanAnimal.iconUrl }
            .distinctUntilChanged()
            .bind { [weak self] iconUrl in
                self?.imageView.setImage(imageUrl: iconUrl)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.fanAnimal.name }
            .distinctUntilChanged()
            .bind(to: animalNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.fanAnimal.isFan }
            .distinctUntilChanged()
            .bind(to: fanButton.rx.isFan)
            .disposed(by: disposeBag)
    }
}
