//
//  ContestAnimalDetailReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/12.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class ContestAnimalDetailReactor: Reactor {
    enum Action {
        case loadAnimal
        case loadPosts
    }
    
    enum Mutation {
        case setResponse(ContestAnimalDetailResponse)
        case setPostCellReactors([Post])
        case setIsLoading(Bool)
    }
    
    struct State {
        let entry: Entry
        var response: ContestAnimalDetailResponse?
        var postCellReactors: [ContestAnimalDetailPostCellReactor] = []
        var isLoading: Bool = false
    }
    
    let initialState: ContestAnimalDetailReactor.State
    
    init(entry: Entry) {
        initialState = State(entry: entry)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnimal:
            return loadAnimal().map(Mutation.setResponse)
        case .loadPosts:
            guard !currentState.isLoading else { return .empty() }
            return .concat(
                .just(.setIsLoading(true)),
                loadPosts().map(Mutation.setPostCellReactors),
                .just(.setIsLoading(false))
            )
        }
    }
    
    private func loadAnimal() -> Observable<ContestAnimalDetailResponse> {
        return .just(TestData.contestAnimalDetailResponse())
    }
    
    private func loadPosts() -> Observable<[Post]> {
        return .just(TestData.posts(count: 12))
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setResponse(let response):
            state.response = response
        case .setPostCellReactors(let posts):
            state.postCellReactors = posts.map { ContestAnimalDetailPostCellReactor(post: $0) }
        case .setIsLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
