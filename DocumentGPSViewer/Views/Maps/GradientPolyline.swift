//
//  GradientPolyline.swift
//  DocumentGPSViewer
//
//  Created by Paul Fleury on 07/04/2021.
//

import Foundation
import MapKit

class GradientPolyline: MKPolyline {
    var hues: [CGFloat]?
    public func getHue(from index: Int) -> CGColor {
        return UIColor(hue: (hues?[index])!, saturation: 1, brightness: 1, alpha: 1).cgColor
    }
}

extension GradientPolyline {
    convenience init(locations: [CLLocation], maxSpeed: Double) {
        let coordinates = locations.map( { $0.coordinate } )
        self.init(coordinates: coordinates, count: coordinates.count)

        let V_MAX: Double = maxSpeed, V_MIN = 0.0, H_MAX = 0.24, H_MIN = 0.03
        let coef = Double((H_MAX - H_MIN) / (V_MAX - V_MIN))

        hues = locations.map({
            let velocity: Double = $0.speed
            var velocityHue = CGFloat(H_MAX)
            
            if velocity > V_MAX {
                velocityHue = CGFloat(H_MAX)
            }

            if V_MIN <= velocity || velocity <= V_MAX {
                velocityHue = CGFloat((H_MAX - (velocity - V_MIN) * coef))
            }

            if velocity < V_MIN {
                velocityHue = CGFloat(H_MIN)
            }
            
            if velocityHue < 0 {
                velocityHue = 1 + velocityHue
            }

            return velocityHue
        })
    }
}

class GradidentPolylineRenderer: MKPolylineRenderer {

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let boundingBox = self.path.boundingBox
        let mapRectCG = rect(for: mapRect)

        if(!mapRectCG.intersects(boundingBox)) { return }


        var prevColor: CGColor?
        var currentColor: CGColor?

        guard let polyLine = self.polyline as? GradientPolyline else { return }

        for index in 0...self.polyline.pointCount - 1{
            let point = self.point(for: self.polyline.points()[index])
            let path = CGMutablePath()


            currentColor = polyLine.getHue(from: index)

            if index == 0 {
               path.move(to: point)
            } else {
                let prevPoint = self.point(for: self.polyline.points()[index - 1])
                path.move(to: prevPoint)
                path.addLine(to: point)

                let colors = [prevColor!, currentColor!] as CFArray
                let baseWidth = self.lineWidth / zoomScale

                context.saveGState()
                context.addPath(path)

                let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0, 1])

                context.setLineWidth(baseWidth)
                context.replacePathWithStrokedPath()
                context.clip()
                context.drawLinearGradient(gradient!, start: prevPoint, end: point, options: [])
                context.restoreGState()
            }
            prevColor = currentColor
        }
    }
}
