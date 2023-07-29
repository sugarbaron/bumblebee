//
//  ResourcesText.swift
//  bumblebee
//
//  Created by sugarbaron on 04.02.2023.
//

import Foundation
import SwiftUI

extension Resources { public final class Text { } }

extension Resources.Text {
    
    public final class Asset { public let name: String; public init(_ name: String) { self.name = name } }
    
}

// MARK: contributions
public extension String {
    
    static func text(_ asset: Resources.Text.Asset) -> String { Resources.Text.translate(asset) }
    
}

public extension Text {
    
    init(_ asset: Resources.Text.Asset) { self.init(String.text(asset)) }
    
}

// MARK: tools
private extension Resources.Text {
    
    private static let english = "Base"
    
    static func translate(_ asset: Asset, file name: String = "Localizable") -> String {
        if asset.name.isEmpty { return "" }
        let language: String = preferredLanguage
        return translate(asset, in: language, file: name)
    }
    
    /**
     * we can not use `Locale.current` because in case when user set language, which
     * is absent among languages which are supported by our application, `Locale.current`
     * will provide different locale than was set by user on device
     **/
    private static var preferredLanguage: String {
        guard let preferred: String = readSettings() else { return english }
        // cutting region: zh-Hans-RU -> zh-Hans
        let regionIndex: String.Index = preferred.lastIndex(of: "-") ?? preferred.endIndex
        let language: String = .init(preferred.prefix(upTo: regionIndex))
        return (language == "en") ? english : language // because using "Base" for "en"
    }
    
    private static func readSettings() -> String? {
        UserDefaults.standard.array(forKey: "AppleLanguages")?[0] as? String
    }
    
    private static func translate(_ asset: Asset, in language: String, file: String) -> String {
        let translation: String = find(asset, in: file, for: language)
        return (asset.name == translation) ? find(asset, in: file, for: english) : translation
    }
    
    private static func find(_ asset: Asset, in file: String, for language: String) -> String {
        guard let path: String = Bundle.main.path(forResource: language, ofType: "lproj"),
              let targetBundle: Bundle = .init(path: path)
        else { return asset.name }
        return NSLocalizedString(asset.name, tableName: file, bundle: targetBundle, comment: "")
    }
    
}
