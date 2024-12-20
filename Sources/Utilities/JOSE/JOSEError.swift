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

/*
This enum represents a set of JOSE (Javascript Object Signing and Encryption) errors.
It conforms to the LocalizedError protocol so we can get a human-readable error description.
*/
public enum JOSEError: LocalizedError {
  // The error case representing an unsupported request
  case notSupportedRequest
  case invalidIdTokenRequest
  case invalidPublicKey
  case invalidJWS
  case invalidSigner
  case invalidVerifier
  case invalidDidIdentifier
  case invalidObjectType

  // A computed property to provide a description for each error case
  public var errorDescription: String? {
    switch self {
    case .notSupportedRequest:
      return ".notSupportedRequest"
    case .invalidIdTokenRequest:
      return ".invalidIdTokenRequest"
    case .invalidPublicKey:
      return ".invalidPublicKey"
    case .invalidJWS:
      return ".invalidJWS"
    case .invalidSigner:
      return ".invalidSigner"
    case .invalidVerifier:
      return ".invalidVerifier"
    case .invalidDidIdentifier:
      return ".invalidDidIdentifier"
    case .invalidObjectType:
      return ".invalidObjectType"
    }
  }
}
