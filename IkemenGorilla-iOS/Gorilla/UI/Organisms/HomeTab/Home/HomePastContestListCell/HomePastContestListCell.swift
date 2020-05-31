//
//  HomePastContestListCell.swift
//  Gorilla
//
//  Created by admin on 2020/05/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class HomePastContestListCell: UICollectionViewCell, View, ViewConstructor {
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let contestNameLabel = UILabel().then {
        $0.apply(fontStyle: .regular, size: 14)
        $0.textColor = Color.textBlack
    }
    
    private let durationLabel = UILabel().then {
        $0.apply(fontStyle: .regular, size: 14)
        $0.textColor = Color.textGray
    }
    
    private let formatter = DateFormatter().then {
        $0.dateFormat = "MM-dd"
    }
    
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
        addSubview(contestNameLabel)
        addSubview(durationLabel)
    }
    
    func setupViewConstraints() {
        imageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        contestNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(16)
        }
        durationLabel.snp.makeConstraints {
            $0.top.equalTo(contestNameLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        // Variables
        disposeBag = DisposeBag()
        
        // Views
        imageView.image = #imageLiteral(resourceName: "noimage")
        contestNameLabel.text = ""
        durationLabel.text = ""
    }
    
    // MARK: - Bind Method
    func bind(reactor: HomePastContestListCellReactor) {
        // Action
        
        // State
        reactor.state.map { $0.contest.imageUrl }
            .distinctUntilChanged()
            .bind { [weak self] imageUrl in
                self?.imageView.setImage(imageUrl: imageUrl)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.contest.name }
            .distinctUntilChanged()
            .bind(to: contestNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map {
                var durationString = ""
                durationString += self.formatter.string(from: $0.contest.start)
                durationString += " ~ "
                durationString += self.formatter.string(from: $0.contest.end)
                return durationString
            }
            .distinctUntilChanged()
            .bind(to: durationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
