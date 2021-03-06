//
//  VoteContestViewController.swift
//  Gorilla
//
//  Created by admin on 2020/06/27.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import ReusableKit

final class VoteContestViewController: UIViewController, View, ViewConstructor, TransitionPresentable {
    
    struct Reusable {
        static let contestCell = ReusableCell<VoteContestCell>()
    }
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    private let titleLabel = UILabel().then {
        $0.apply(fontStyle: .medium, size: 20)
        $0.textColor = Color.black
        $0.text = "開催中のコンテスト"
    }
    
    private let contestsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = VoteContestCell.Const.itemSize
        $0.minimumLineSpacing = 24
        $0.scrollDirection = .vertical
    }).then {
        $0.backgroundColor = Color.white
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.register(Reusable.contestCell)
        $0.contentInset.top = 56
        $0.contentInset.bottom = 24
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewConstraints()
    }
    
    // MARK: - Setup Methods
    func setupViews() {
        navigationItem.leftBarButtonItem = cancelButton
        
        contestsCollectionView.addSubview(titleLabel)
        view.addSubview(contestsCollectionView)
    }
    
    func setupViewConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-40)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        contestsCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    func bind(reactor: VoteContestReactor) {
        // Action
        reactor.action.onNext(.refresh)
        
        cancelButton.rx.tap
            .bind { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
                
        contestsCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.showVoteContestDetailPage(voteContestDetailReactor: reactor.createVoteContestDetailReactor(indexPath: indexPath))
            }
            .disposed(by: disposeBag)
        
        contestsCollectionView.rx.contentOffset
            .distinctUntilChanged()
            .bind { [weak self] contentOffset in
                guard let collectionView = self?.contestsCollectionView else { return }
                if collectionView.contentOffset.y + collectionView.frame.size.height > collectionView.contentSize.height {
                    reactor.action.onNext(.load)
                }
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.contestCellReactors }
            .distinctUntilChanged()
            .bind(to: contestsCollectionView.rx.items(Reusable.contestCell)) { _, reactor, cell in
                cell.reactor = reactor
            }
            .disposed(by: disposeBag)
    }
}
