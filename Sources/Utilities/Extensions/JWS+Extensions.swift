/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Modified by AUTHADA GmbH
 * Copyright (c) 2024 AUTHADA GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import JOSESwift

internal extension JWS {
    
  // Function to convert Unix timestamp to Date
  func dateFromUnixTimestamp(_ timestamp: Any) -> Date? {
    if let timestampInt = timestamp as? Int {
      return Date(timeIntervalSince1970: TimeInterval(timestampInt))
    } else if let timestampDouble = timestamp as? Double {
      return Date(timeIntervalSince1970: timestampDouble)
    }
    return nil
  }
    
  func verifierAttestationClaims() throws -> VerifierAttestationClaims {
      
    let payload = payload.data()
    guard let json = try JSONSerialization.jsonObject(
        with: payload,
        options: []
    ) as? [String: Any] else {
      throw ValidatedAuthorizationError.validationError("Invalid JWS payload")
    }
      
    guard
      let cnf = json["cnf"] as? [String: Any],
      let jwkDict = cnf["jwk"] as? [String: Any],
      let jwk = convertJSONToPublicKey(json: jwkDict)
    else {
      throw ValidatedAuthorizationError.validationError("Cannot locate cnf/jwk in payload")
    }
      
    return VerifierAttestationClaims(
      iss: try tryExtract(JWTClaimNames.issuer, from: json),
      sub: try tryExtract(JWTClaimNames.subject, from: json),
      iat: try tryExtract(JWTClaimNames.issuedAt, from: json, converter: dateFromUnixTimestamp),
      exp: try tryExtract(JWTClaimNames.expirationTime, from: json, converter: dateFromUnixTimestamp),
      verifierPubJwk: jwk,
      redirectUris: try tryExtract("redirect_uris", from: json),
      responseUris: try tryExtract("response_uris", from: json)
    )
  }
    
  // Function to convert JSON to ECPublicKey or RSAPublicKey
  func convertJSONToPublicKey(json: [String: Any]) -> JWK? {
    guard let kty = json["kty"] as? String else {
      return nil
    }
        
    switch kty {
    case "EC":
      return convertJSONToECPublicKey(json: json)
    case "RSA":
      return convertJSONToRSAPublicKey(json: json)
    default:
      return nil
    }
  }

  // Function to convert JSON to ECPublicKey
  func convertJSONToECPublicKey(json: [String: Any]) -> ECPublicKey? {
    guard
      let x = json["x"] as? String,
      let y = json["y"] as? String,
      let crv = json["crv"] as? String,
      let curve = ECCurveType(rawValue: crv)
    else {
      return nil
    }
    return ECPublicKey(crv: curve, x: x, y: y)
  }

  // Function to convert JSON to RSAPublicKey
  func convertJSONToRSAPublicKey(json: [String: Any]) -> RSAPublicKey? {
    guard
      let n = json["n"] as? String,
      let e = json["e"] as? String
    else {
      return nil
    }
    return RSAPublicKey(modulus: n, exponent: e)
  }
}