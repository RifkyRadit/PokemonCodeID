//
//  Utility.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 30/07/25.
//

import UIKit

func showErrorAlert(errorMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return alert
}

func getCustomAttributeText(fullText: String, rangeText: String) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: fullText)
    let rangeOfText = (fullText as NSString).range(of: rangeText)
    
    let rangeOfFullText = NSRange(location: 0, length: fullText.count)
    attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: rangeOfFullText)
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15) as Any, range: rangeOfFullText)
    attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: rangeOfText)
    
    return attributedString
}

func getValidateAreaGestureTapText(gesture: UITapGestureRecognizer, label: UILabel, attributedText: NSAttributedString, rangeText: String) -> Bool {
    let tapLocation = gesture.location(in: label)
    let textContainer = NSTextContainer(size: label.bounds.size)
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    
    let layoutManager = NSLayoutManager()
    layoutManager.addTextContainer(textContainer)
    
    let textStorage = NSTextStorage(attributedString: attributedText)
    textStorage.addLayoutManager(layoutManager)
    
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textOffset = CGPoint(x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                             y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
    
    let adjustedTapLocation = CGPoint(x: tapLocation.x - textOffset.x, y: tapLocation.y - textOffset.y)
    
    let glyphIndex = layoutManager.glyphIndex(for: adjustedTapLocation, in: textContainer)
    let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
    
    if characterIndex >= attributedText.length {
        return false
    }
    
    let fullText = (label.attributedText?.string ?? "") as NSString
    let rangeOfText = fullText.range(of: rangeText)
    
    return NSLocationInRange(characterIndex, rangeOfText)
}
