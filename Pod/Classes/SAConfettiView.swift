//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
//

import UIKit
import QuartzCore

public class SAConfettiView: UIView {

    public enum ConfettiType {
        case confetti
        case triangle
        case star
        case diamond
        case image(UIImage)

        var imageName: String {
            switch self {
            case .confetti:
                return "confetti"
            case .triangle:
                return "triangle"
            case .star:
                return "star"
            case .diamond:
                return "diamond"
            default: fatalError()
            }
        }
    }

    fileprivate var emitter: CAEmitterLayer = CAEmitterLayer()
    public var colors: [UIColor] = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                                    UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                                    UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                                    UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                                    UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
    public var intensity: Float = 0.5
    public var type: ConfettiType = .confetti
    public private(set) var active: Bool = false

    public func startConfetti() {
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)

        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }

    public func stopConfetti() {
        emitter.birthRate = 0
        active = false
    }

    func imageForType(type: ConfettiType) -> UIImage? {
        if case let .image(image) = type {
            return image
        }

        guard let path = Bundle(for: SAConfettiView.self).path(forResource: "SAConfettiView", ofType: "bundle"),
        let imagePath = Bundle(path: path)?.path(forResource: type.imageName, ofType: "png") else { return nil }

        let url = NSURL(fileURLWithPath: imagePath)
        let data = NSData(contentsOf: url as URL)
        if let data = data, let image = UIImage(data: data as Data) {
            return image
        }
        return nil
    }

    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(M_PI)
        confetti.emissionRange = CGFloat(M_PI_4)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type: type)?.cgImage
        return confetti
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
