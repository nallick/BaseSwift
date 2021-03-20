//
//  URLExtendedAttributes.swift
//
//  Copyright © 2019-2021 Purgatory Design. Licensed under the MIT License.
//
//  Based on Stack Overflow post from Martin R:
//        https://stackoverflow.com/questions/38343186/write-extend-file-attributes-swift-example/38343753#38343753
//

#if canImport(ObjectiveC)

import Foundation

public extension NSError {

    static func posixError(_ error: Int32) -> NSError {
        return NSError(domain: NSPOSIXErrorDomain, code: Int(error), userInfo: [NSLocalizedDescriptionKey: String(cString: strerror(error))])
    }
}

public extension URL {

    func extendedAttribute(_ name: String) throws -> Data  {
        return try self.withUnsafeFileSystemRepresentation { path in
            let attributeLength = getxattr(path, name, nil, 0, 0, 0)
            guard attributeLength >= 0 else { throw NSError.posixError(errno) }

            var data = Data(count: attributeLength)
            let result =  data.withUnsafeMutableBytes { [count = data.count] in getxattr(path, name, $0.baseAddress, count, 0, 0) }
            guard result >= 0 else { throw NSError.posixError(errno) }
            return data
        }
    }

    func setExtendedAttribute(_ name: String, data: Data) throws {
        try self.withUnsafeFileSystemRepresentation { path in
            let result = data.withUnsafeBytes { setxattr(path, name, $0.baseAddress, data.count, 0, 0) }
            guard result >= 0 else { throw NSError.posixError(errno) }
        }
    }

    func removeExtendedAttribute(_ name: String) throws {
        try self.withUnsafeFileSystemRepresentation { path in
            let result = removexattr(path, name, 0)
            guard result >= 0 else { throw NSError.posixError(errno) }
        }
    }

    func allExtendedAttributes() throws -> [String] {
        return try self.withUnsafeFileSystemRepresentation { path in
            let listLength = listxattr(path, nil, 0, 0)
            guard listLength >= 0 else { throw NSError.posixError(errno) }

            var nameBuffer = Array<CChar>(repeating: 0, count: listLength)
            let result = listxattr(path, &nameBuffer, nameBuffer.count, 0)
            guard result >= 0 else { throw NSError.posixError(errno) }

            return nameBuffer.split(separator: 0).compactMap {
                $0.withUnsafeBufferPointer {
                    $0.withMemoryRebound(to: UInt8.self) {
                        String(bytes: $0, encoding: .utf8)
                    }
                }
            }
        }
    }
}

#endif
