//
//  HomeCurrentContestListView.swift
//  Gorilla
//
//  Created by admin on 2020/05/24.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReusableKit
import ReactorKit
import RxSwift

final class HomeCurrentContestListView: UICollectionView, View, ViewConstructor {
    private struct Const {
        static let minimumLineSpacing: CGFloat = 12
        static let cellWidth: CGFloat = DeviceSize.screenWidth - 48
        static let cellHeight: CGFloat = cellWidth * 304 / 327
        static let itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    struct Reusable {
        static let contestListCell = ReusableCell<HomeCurrentContestListCell>()
    }
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = Const.itemSize
        $0.minimumLineSpacing = Const.minimumLineSpacing
        $0.scrollDirection = .horizontal
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        setupViews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    func setupViews() {
        showsHorizontalScrollIndicator = false
        register(Reusable.contestListCell)
    }
    
    func setupViewConstraints() {}
    
    // MARK: - Bind Method
    func bind(reactor: HomeCurrentContestListReactor) {
        // Action
        reactor.action.onNext(.load)
        
        // State
        reactor.state.map { $0.contestListCellReactors }
            .bind(to: rx.items(Reusable.contestListCell)) { _, reactor, cell in
                cell.reactor = reactor
            }
            .disposed(by: disposeBag)
    }
}
