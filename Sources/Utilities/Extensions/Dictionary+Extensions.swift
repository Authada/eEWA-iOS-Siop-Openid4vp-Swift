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

/**
 Extension to `Dictionary` where both the `Key` and `Value` conform to `Encodable`.

 This extension adds a `toJSONData()` method that attempts to convert the dictionary
 to JSON data using `JSONSerialization`.

 - Returns: The JSON `Data` if the conversion is successful; otherwise, nil.

 - Note: This function will fail and return nil if the dictionary contains keys or values that aren't encodable.
 */
public extension Dictionary where Key: Encodable {
  func toJSONData() -> Data? {
    do {
      return try JSONSerialization.data(withJSONObject: self, options: [])
    } catch {
      return nil
    }
  }

  func toThrowingJSONData() throws -> Data {
    return try JSONSerialization.data(withJSONObject: self, options: [])
  }
}

public extension Dictionary where Key == String, Value == Any {
  // Creates a dictionary from a JSON file in the specified bundle
  static func from(bundle name: String) -> Result<Self, JSONParseError> {
    let fileType = "json"
    guard let path = Bundle.module.path(forResource: name, ofType: fileType) else {
      return .failure(.fileNotFound(filename: name))
    }
    return from(JSONfile: URL(fileURLWithPath: path))
  }

  // Converts the dictionary to an array of URLQueryItem objects
  func toQueryItems() -> [URLQueryItem] {
    var queryItems: [URLQueryItem] = []
    for (key, value) in self {
      if let stringValue = value as? String {
        queryItems.append(URLQueryItem(name: key, value: stringValue))
      } else if let numberValue = value as? NSNumber {
        queryItems.append(URLQueryItem(name: key, value: numberValue.stringValue))
      } else if let arrayValue = value as? [Any] {
        let arrayQueryItems = arrayValue.compactMap { (item) -> URLQueryItem? in
          guard let stringValue = item as? String else { return nil }
          return URLQueryItem(name: key, value: stringValue)
        }
        queryItems.append(contentsOf: arrayQueryItems)
      }
    }
    return queryItems
  }

  func getValue<T: Codable>(
    for key: String,
    error: LocalizedError
  ) throws -> T {
    guard let value = self[key] as? T else {
      throw error
    }
    return value
  }
}
