//
//  File.swift
//  
//
//  Created by Murilo Araujo on 09/11/20.
//

import Foundation
import JWT

struct JWTToken: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
    }
    
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
