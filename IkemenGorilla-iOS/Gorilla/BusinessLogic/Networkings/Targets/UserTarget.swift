//
//  UserTarget.swift
//  Gorilla
//
//  Created by admin on 2020/06/30.
//  Copyright © 2020 admin. All rights reserved.
//

import Moya

enum UserTarget {
    case getUser(userId: String)
}

extension UserTarget: TargetType {
    var path: String {
        switch self {
        case .getUser(let userId):
            return "/users/\(userId)"
        }
    }
    
    var method: Method {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getUser:
            return URLEncoding.default
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://8ca2bc8b-a8b2-432f-95c1-04b81b793ef8.mock.pstmn.io") ?? undefined("endpoint for frontend echo dose not exist")
    }
    
    var headers: [String: String]? {
        nil
    }

    var sampleData: Data {
        Data()
    }
}
