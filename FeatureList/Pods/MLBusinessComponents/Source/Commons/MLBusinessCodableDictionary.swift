//
//  MLBusinessCodableDictionary.swift
//  MLBusinessComponents
//
//  Created by Vicente Veltri on 24/04/2020.
//

import Foundation

class MLBusinessCodableDictionary: Codable, CustomStringConvertible {
    private var value: [String: Any]

    init(value: [String: Any]) {
        self.value = value
    }

    var rawValue: [String: Any] {
        return value
    }

    // MARK: - subscripts

    subscript(key: String) -> Any? {
        get {
            return value[key]
        }
        set {
            value[key] = newValue
        }
    }

    // MARK: - Dictionary implementations

    var isEmpty: Bool {
        return value.isEmpty
    }

    var count: Int {
        return value.count
    }

    var capacity: Int {
        return value.capacity
    }

    func index(forKey key: String) -> Dictionary<String, Any>.Index? {
        return value.index(forKey: key)
    }

    var first: (key: String, value: Any)? {
        return value.first
    }

    var keys: Dictionary<String, Any>.Keys {
        return value.keys
    }

    var values: Dictionary<String, Any>.Values {
        return value.values
    }

    // MARK: - Codable

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { self.intValue = intValue
            stringValue = "\(intValue)"
        }

        init?(key: CodingKey) {
            if let intValue = key.intValue {
                self.init(intValue: intValue)
            } else {
                self.init(stringValue: key.stringValue)
            }
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var dict: [String: Any] = [:]

        for key in container.allKeys {
            guard let codingKey = DynamicCodingKeys(key: key) else { continue }

            if let string: String = try? container.decode(String.self, forKey: codingKey) {
                dict[key.stringValue] = string
            } else if let bool: Bool = try? container.decode(Bool.self, forKey: codingKey) {
                dict[key.stringValue] = bool
            } else if let int: Int = try? container.decode(Int.self, forKey: codingKey) {
                dict[key.stringValue] = int
            } else if let double: Double = try? container.decode(Double.self, forKey: codingKey) {
                dict[key.stringValue] = double
            } else if let nestedDict: MLBusinessCodableDictionary = try? container.decode(MLBusinessCodableDictionary.self, forKey: codingKey) {
                dict[key.stringValue] = nestedDict.value
            } else if let array: [String] = try? container.decode([String].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let array: [Bool] = try? container.decode([Bool].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let array: [Int] = try? container.decode([Int].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let array: [Double] = try? container.decode([Double].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let nestedArrayDict: [MLBusinessCodableDictionary] = try? container.decode([MLBusinessCodableDictionary].self, forKey: codingKey) {
                dict[key.stringValue] = nestedArrayDict.map { $0.value }
            }
        }

        value = dict
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)

        for (key, value) in value {
            guard let codingKey = DynamicCodingKeys(stringValue: key) else { continue }

            switch value {
            case let value as String:
                try container.encode(value, forKey: codingKey)
            case let value as Int:
                try container.encode(value, forKey: codingKey)
            case let value as Double:
                try container.encode(value, forKey: codingKey)
            case let value as Bool:
                try container.encode(value, forKey: codingKey)
            case let value as [String: Any]:
                try container.encode(MLBusinessCodableDictionary(value: value), forKey: codingKey)
            case let value as [String]:
                try container.encode(value, forKey: codingKey)
            case let value as [Int]:
                try container.encode(value, forKey: codingKey)
            case let value as [Double]:
                try container.encode(value, forKey: codingKey)
            case let value as [Bool]:
                try container.encode(value, forKey: codingKey)
            case let value as [[String: Any]]:
                try container.encode(value.map { MLBusinessCodableDictionary(value: $0) }, forKey: codingKey)
            default:
                let context = EncodingError.Context(codingPath: [codingKey], debugDescription: "Could not encode value (\(value)) for unknwon type.")
                throw EncodingError.invalidValue(value, context)
            }
        }
    }

    private func toString(value: Any) -> String {
        switch value {
        case let value as String:
            return "\"\(value)\""
        case let value as Int:
            return "\(value)"
        case let value as Double:
            return "\(value)"
        case let value as Bool:
            return "\(value)"
        case let value as [String: Any]:
            return "\(MLBusinessCodableDictionary(value: value))"
        case let value as [String]:
            return "\(value)"
        case let value as [Int]:
            return "\(value)"
        case let value as [Double]:
            return "\(value)"
        case let value as [Bool]:
            return "\(value)"
        case let value as [[String: Any]]:
            return "[".appending(value.map { "\(MLBusinessCodableDictionary(value: $0))" }.joined(separator: ", ").appending("]"))
        default:
            return ""
        }
    }

    var description: String {
        return "[".appending(keys.sorted().map { "\"\($0)\": \(toString(value: rawValue[$0] ?? ""))" }.joined(separator: ", ").appending("]"))
    }
}

extension MLBusinessCodableDictionary: Hashable {
    static func == (lhs: MLBusinessCodableDictionary, rhs: MLBusinessCodableDictionary) -> Bool {
        guard let lhsh = lhs.rawValue as? [String: AnyHashable],
            let rhsh = rhs.rawValue as? [String: AnyHashable] else {
            return false
        }

        return lhsh == rhsh
    }

    func hash(into hasher: inout Hasher) {
        if let hashable = self.rawValue as? [String: AnyHashable] {
            hasher.combine(hashable)
        } else {
            hasher.combine(UUID())
        }
    }
}
