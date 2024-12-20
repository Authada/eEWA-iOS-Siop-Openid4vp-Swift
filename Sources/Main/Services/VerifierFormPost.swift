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

/// A struct representing a form POST request.
public struct VerifierFormPost: Request {
  public typealias Response = DispatchOutcome

  /// The HTTP method for the request.
  public var method: HTTPMethod { .POST }

  /// Additional headers to include in the request.
  public var additionalHeaders: [String: String] = [:]

  /// The URL for the request.
  public var url: URL

  /// The request body as data.
  public var body: Data? {
    var formDataComponents = URLComponents()
    formDataComponents.queryItems = formData.toQueryItems()
    let formDataString = formDataComponents.query
    return formDataString?.data(using: .utf8)
  }

  /// The form data for the request.
  let formData: [String: Any]

  /// The URL request representation of the DirectPost.
  var urlRequest: URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.httpBody = body
    request.allHTTPHeaderFields = additionalHeaders
    return request
  }
}
