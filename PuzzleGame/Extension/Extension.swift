//
//  Extension.swift
//  PuzzleGame
//
//  Created by Ahmad Shaheer on 07/06/2024.
//

import Foundation
import SwiftUI


//MARK: COLOR extensions

extension UIColor {
    func toHex() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return ""
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count >= 4 ? components[3] : 1.0
        
        return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(red) * 255), lroundf(Float(green) * 255), lroundf(Float(blue) * 255), lroundf(Float(alpha) * 255))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
        
        func toHex() -> String {
              if #available(iOS 14.0, *) {
                  let uiColor = UIColor(self)
                  return uiColor.toHex()
              } else {
                  return ""
              }
          }
    }
    
    static let screenBackground = Color(hex: "#181A20")
    static let pinkColor = Color(hex: "#C238CC")
    static let purpleColor = Color(hex: "#7c1db8")
    static let dullBackground = Color(hex: "#1F222A")

}

extension Font {
    static let heading = Font.custom("Poppins-Medium", size: 20)
    static let subHeading = Font.custom("Poppins-Medium", size: 18)
    static let bodyText = Font.custom("Poppins-Medium", size: 15)
    static let description = Font.custom("Poppins-Medium", size: 13)
}


extension View {
    public func foregroundLinearGradient(colors: [Color],
                                         startPoint: UnitPoint,
                                         endPoint: UnitPoint) -> some View {
        self.overlay {
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(self)
        }
    }
}
