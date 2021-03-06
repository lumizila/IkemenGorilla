//
//  FanAnimalDetailCurrentContestView.swift
//  Gorilla
//
//  Created by admin on 2020/07/18.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class FanAnimalDetailCurrentContestView: UIView, View, ViewConstructor {
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    private let currentContestLabel = UILabel().then {
        $0.apply(fontStyle: .medium, size: 20)
        $0.textColor = Color.textBlack
        $0.text = "参加中のコンテスト"
    }
    
    private let floatingContestView = FloatingContestView()
    
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
        addSubview(currentContestLabel)
        addSubview(floatingContestView)
    }
    
    func setupViewConstraints() {
        currentContestLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        floatingContestView.snp.makeConstraints {
            $0.top.equalTo(currentContestLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    func bind(reactor: FanAnimalDetailReactor) {
        // Action
        
        // State
        reactor.state.map { $0.currentContest?.imageUrl ?? "" }
            .distinctUntilChanged()
            .bind { [weak self] imageUrl in
                self?.floatingContestView.imageView.setImage(imageUrl: imageUrl)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentContest?.name }
            .distinctUntilChanged()
            .bind(to: floatingContestView.contestNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentContest?.catchCopy }
            .distinctUntilChanged()
            .bind(to: floatingContestView.catchCopyLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map {
                guard let contest = $0.currentContest else { return "" }
                var durationString = "開催期間："
                durationString += formatter.string(from: contest.start)
                durationString += " ~ "
                durationString += formatter.string(from: contest.end)
                return durationString
            }
            .distinctUntilChanged()
            .bind(to: floatingContestView.durationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
