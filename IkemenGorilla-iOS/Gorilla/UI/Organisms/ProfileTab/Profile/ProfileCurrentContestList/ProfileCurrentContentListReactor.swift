//
//  ProfileCurrentContentListReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/04.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class ProfileCurrentContestListReactor: Reactor {
    enum Action {
        case load
    }
    
    enum Mutation {
        case setContestListCellReactors([Contest])
        case setIsLoading(Bool)
    }
    
    struct State {
        var contestListCellReactors: [ProfileCurrentContestListCellReactor] = []
        var isLoading: Bool = false
    }
    
    let initialState = ProfileCurrentContestListReactor.State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return Observable.concat(
                Observable.just(.setIsLoading(true)),
                loadCurrentContests().map(Mutation.setContestListCellReactors),
                Observable.just(.setIsLoading(false))
            )
        }
    }
    
    private func loadCurrentContests() -> Observable<[Contest]> {
        .just(TestData.contests(count: 4))
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setContestListCellReactors(let contests):
            state.contestListCellReactors = contests.map { ProfileCurrentContestListCellReactor(contest: $0) }
        case .setIsLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
