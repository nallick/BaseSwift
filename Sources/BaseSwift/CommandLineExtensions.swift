//
//  CommandLineExtensions.swift
//
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import Foundation

extension CommandLine {

    public typealias Parameters = [String: [String]]

    public static var parameters: Parameters? {
        var result: [String: [String]] = [:]

        var parameterName = ""
        var parameterValues: [String] = []
        for index in 1 ..< self.arguments.count {
            let argument = self.arguments[index]
            guard let firstCharacter = argument.first else { return nil }
            if firstCharacter == "-" {
                if parameterName != "" {
                    result[parameterName] = parameterValues
                }

                parameterName = argument
                parameterValues = []
                guard !result.keys.contains(parameterName) else { return nil }
            } else {
                guard parameterName != "" else { return nil }
                parameterValues.append(argument)
            }
        }

        if parameterName != "" {
            result[parameterName] = parameterValues
        }

        return result
    }
}
