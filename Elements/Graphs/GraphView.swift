//
//  GraphView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/2/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI
import MapKit

struct GraphView: View {

    @ObservedObject var settings = Settings.settings

    @State var elements: [GraphElement]
    
    var lines: [Line] {
        return self.elements.filter{ $0 is Line }.map{ $0 as! Line }
    }
    var guidelines: [Guideline] {
        return self.elements.filter{ $0 is Guideline }.map{ $0 as! Guideline }
    }
    var text: [GraphText] {
        return self.elements.filter{ $0 is GraphText }.map{ $0 as! GraphText }
    }
    var angles: [GraphAngle] {
        return self.elements.filter{ $0 is GraphAngle }.map{ $0 as! GraphAngle }
    }
    
    @State var xi: Double = -20
    @State var xf: Double = 20
    @State var yi: Double = -20
    @State var yf: Double = 20
    
    @State var offset: CGSize = .zero
    @State var scale: CGFloat = 1.0
    
    var width: CGFloat
    var centerX: CGFloat
    var centerY: CGFloat
    
    var horizontalAxis: Letter
    var verticalAxis: Letter
    
    var gridLines: Bool
    var gridStyle: CoordinateSystem
    var interactive: Bool
    var popUpGraph: Bool
    
    var precision: Int
    
    @State var showPopUpGraph: Bool = false
    
    init(_ elements: [GraphElement], width: CGFloat = 20, centerX: CGFloat = 0, centerY: CGFloat = 0, horizontalAxis: Letter = Letter("x"), verticalAxis: Letter = Letter("y"), gridLines: Bool = true, gridStyle: CoordinateSystem = .cartesian, interactive: Bool = true, popUpGraph: Bool = false, precision: Int = 1000) {
        self.elements = elements
        self.width = interactive ? width : width/2
        self.centerX = centerX
        self.centerY = centerY
        self.scale = interactive ? 1.0 : 0.5
        self.horizontalAxis = horizontalAxis
        self.verticalAxis = verticalAxis
        self.gridLines = gridLines
        self.gridStyle = gridStyle
        self.interactive = interactive
        self.popUpGraph = popUpGraph
        self.precision = precision
    }

    var body: some View {
        
        GeometryReader { geometry in
                
            ZStack {

                // MARK: Grid

                // Axes
                Path { path in
                    
                    path.move(to: point(0, yi, geometry))
                    path.addLine(to: point(0, yf, geometry))

                    path.move(to: point(xi, 0, geometry))
                    path.addLine(to: point(xf, 0, geometry))

                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)

                // Grid Lines
                Path { path in
                        
                    for x in adjustDisplayRange(range: xi...xf) {
                        path.move(to: point(Double(x), yi, geometry))
                        path.addLine(to: point(Double(x), yf, geometry))
                    }

                    for y in adjustDisplayRange(range: yi...yf) {
                        path.move(to: point(xi, Double(y), geometry))
                        path.addLine(to: point(xf, Double(y), geometry))
                    }
                        
//                    else if gridStyle == .polar {
//
//                        for θ in 0...23 {
//                            path.move(to: point(0, 0, geometry))
//                            path.addLine(to: point((xf-xi)/2*cos(Double(θ) * .pi/12), (xf-xi)/2*sin(Double(θ) * .pi/12), geometry))
//                        }
//
//                        for r in adjustDisplayRange(range: 0...(xf-xi)/2) {
//                            path.move(to: point(r, 0, geometry))
//                            path.addArc(center: point(0, 0, geometry), radius: point(r, 0, geometry).x - point(0, 0, geometry).x, startAngle: Angle(radians: 0), endAngle: Angle(radians: .pi), clockwise: true)
//                            path.addArc(center: point(0, 0, geometry), radius: point(r, 0, geometry).x - point(0, 0, geometry).x, startAngle: Angle(radians: 0), endAngle: Angle(radians: .pi), clockwise: false)
//                        }
//                    }
                }
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)

                // Numbers
                ForEach(adjustDisplayRange(range: xi...xf, number: true), id: \.self) { num in
                    Text(formatNum(num))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .position(point(Double(num), 0, geometry, limitY: true, num: num))
                }
                ForEach(adjustDisplayRange(range: yi...yf, number: true), id: \.self) { num in
                    Text(formatNum(num))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .position(point(0, Double(num), geometry, limitX: true, num: num))
                }

                // MARK: Lines

                ForEach(self.lines.indices, id: \.self) { l in
                    
                    let line = self.lines[l]

                    if let shape = line as? LineShape {

                        LinePlot(line: shape, xi: xi, xf: xf, yi: yi, yf: yf, precision: precision, geometry: geometry) { x, y, geometry in
                            return point(x, y, geometry)
                        }
                        .fill(color(shape.color, edit: true))
                        .opacity(shape.opacity)

                    } else {

                        LinePlot(line: line, xi: xi, xf: xf, yi: yi, yf: yf, precision: precision, geometry: geometry) { x, y, geometry in
                            return point(x, y, geometry)
                        }
                        .stroke(color(line.color, edit: true), lineWidth: 3)
                    }
                }

                // Guidelines

                ForEach(self.guidelines.indices, id: \.self) { l in

                    let guideline = self.guidelines[l]

                    Path { path in

                        path.move(to: point(guideline.start.x, guideline.start.y, geometry))
                        
                        if guideline.circle {
                            path.addArc(center: point(guideline.end.x, guideline.end.y, geometry),
                                        radius: point(guideline.start.x, 0, geometry).x - point(guideline.end.x, 0, geometry).x,
                                        startAngle: Angle(radians: 0), endAngle: Angle(radians: .pi), clockwise: true)
                            path.addArc(center: point(guideline.end.x, guideline.end.y, geometry),
                                        radius: point(guideline.start.x, 0, geometry).x - point(guideline.end.x, 0, geometry).x,
                                        startAngle: Angle(radians: .pi), endAngle: Angle(radians: .pi*2), clockwise: true)
                        } else {
                            path.addLine(to: point(guideline.end.x, guideline.end.y, geometry))
                        }
                    }
                    .stroke(color(guideline.color, edit: true), lineWidth: 1)
                }
                
                // Graph Angles
                
                ForEach(self.angles.indices, id: \.self) { a in
                    
                    let angle = self.angles[a]
                    
                    let center = point(angle.center.x, angle.center.y, geometry)
                    let scaledSize: Double = point(0.1, 0, geometry).x - point(0, 0, geometry).x
                    let size: Double = scaledSize > 30 ? 30 : scaledSize

                    Path { path in
                        
                        path.move(to: CGPoint(x: center.x + size*cos(angle.start.radians), y: center.y - size*sin(angle.start.radians)))
                        
                        if abs(Int(angle.end.degrees) % 360 - Int(angle.start.degrees) % 360) % 180 == 90 {
                            path.addLine(to: CGPoint(x: center.x + size*cos(angle.start.radians) + size*cos(angle.end.radians), y: center.y - size*sin(angle.start.radians) - size*sin(angle.end.radians)))
                            path.addLine(to: CGPoint(x: center.x + size*cos(angle.end.radians), y: center.y - size*sin(angle.end.radians)))
                        } else {
                            path.addArc(center: point(angle.center.x, angle.center.y, geometry), radius: size, startAngle: angle.start, endAngle: -angle.end, clockwise: angle.endAngle > angle.startAngle)
                        }
                    }
                    .stroke(color(angle.color, edit: true), lineWidth: 1)
                    
                    if let string = angle.string {
                        Text(string)
                            .font(.system(size: size/2))
                            .fontWeight(.bold)
                            .position(x: center.x + size*cos(angle.start.radians) + size*cos(angle.end.radians), y: center.y - size*sin(angle.start.radians) - size*sin(angle.end.radians))
                    }
                }

                // Graph Text

//                ForEach(self.text.indices, id: \.self) { t in
//
//                    let text = self.text[t]
//
//                    Text(text.text)
//                        .font(.system(size: point(0, 0, geometry).y - point(0, Double(text.size), geometry).y))
//                        .foregroundColor(color(text.color))
//                        .position(point(text.position.x, ytext.position.y, geometry))
//                        .rotationEffect(text.rotation)
//                }
                
                Rectangle()
                    .opacity(1e-10)
            }
            .frame(width: geometry.size.width*2*scale, height: geometry.size.height*2*scale, alignment: .center)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .offset(offset)
            .background(Color.init(white: 0.05).opacity(popUpGraph ? 0:1).edgesIgnoringSafeArea(.all))
            .overlay(
                Rectangle()
                    .fill(Color.init(white: 0.6))
                    .opacity(popUpGraph ? 0.1 : 0)
                    .onTapGesture {
                        if popUpGraph {
                            SoundManager.play(haptic: .medium)
                            self.showPopUpGraph.toggle()
                        }
                    }
            )
            .gesture(DragGesture()
                .onChanged { value in
                    self.offset = interactive ? value.translation : offset
                }
                .onEnded { value in
                    let translation = coordinates(x: value.translation.width, y: value.translation.height, geometry)
                    move(translation)
                }
            )
            .gesture(MagnificationGesture()
                .onChanged { value in
                    self.scale = interactive ? value.magnitude : scale
                }
                .onEnded { value in
                    zoom(value)
                }
            )
            .fullScreenCover(isPresented: self.$showPopUpGraph) {
                ZStack {
                    GraphView(elements, horizontalAxis: horizontalAxis, verticalAxis: verticalAxis, gridStyle: gridStyle)
                    XButtonOverlay {
                        self.showPopUpGraph = false
                    }
                }
                .background(Color.init(white: 0.05).edgesIgnoringSafeArea(.all))
            }
            .animation(nil)
            .onAppear {
                setInitialBounds(geometry)
                setPoints()
            }
            .onChange(of: geometry.size) { _ in
                setInitialBounds(geometry)
                setPoints()
            }
        }
    }
    
    func point(_ x: Double, _ y: Double, _ geometry: GeometryProxy, limitX: Bool = false, limitY: Bool = false, num: Double? = nil) -> CGPoint {
        
        var xPos = CGFloat(x - xi) * geometry.size.width/(CGFloat(xf-xi)/(2*scale))
        var yPos = CGFloat(yf - y) * geometry.size.height/(CGFloat(yf-yi)/(2*scale))
        
        if limitX {
            var labelWidth: CGFloat {
                guard let num = num else { return 0 }
                let label = UILabel()
                label.text = formatNum(num)
                label.font = UIFont.preferredFont(forTextStyle: .caption1)
                return label.intrinsicContentSize.width
            }
            if xPos + offset.width - 5 - labelWidth/2 < geometry.size.width*(scale-1/2) {
                xPos = geometry.size.width*(scale-1/2) - offset.width + 5 + labelWidth/2
            } else if xPos + offset.width + 5 + labelWidth/2 > geometry.size.width*(scale+1/2) {
                xPos = geometry.size.width*(scale+1/2) - offset.width - 5 - labelWidth/2
            }
        }
        if limitY {
            if yPos + offset.height - 10 < geometry.size.height*(scale-1/2) {
                yPos = geometry.size.height*(scale-1/2) - offset.height + 10
            } else if yPos + offset.height + 10 > geometry.size.height*(scale+1/2) {
                yPos = geometry.size.height*(scale+1/2) - offset.height - 10
            }
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func coordinates(x: CGFloat, y: CGFloat, _ geometry: GeometryProxy) -> CGPoint {
        
        let xPos = x / (geometry.size.width/(CGFloat(xf-xi)/(2*scale)))
        let yPos = y / (geometry.size.height/(CGFloat(yf-yi)/(2*scale)))
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func setInitialBounds(_ geometry: GeometryProxy) {
        if geometry.size.height > geometry.size.width {
            self.xi = centerX-width
            self.xf = centerX+width
            self.yi = (centerY-width) * Double(geometry.size.height/geometry.size.width)
            self.yf = (centerY+width) * Double(geometry.size.height/geometry.size.width)
        } else {
            self.yi = centerY-width
            self.yf = centerY+width
            self.xi = (centerX-width) * Double(geometry.size.width/geometry.size.height)
            self.xf = (centerX+width) * Double(geometry.size.width/geometry.size.height)
        }
    }
    
    func move(_ translation: CGPoint) {
        guard interactive else { return }
        xi -= Double(translation.x)
        xf -= Double(translation.x)
        yi += Double(translation.y)
        yf += Double(translation.y)
        self.offset = .zero
        setPoints()
    }
    
    func zoom(_ value: CGFloat) {
        guard interactive else { return }
        let dx = (xf-xi)/Double(value) - (xf-xi)
        let dy = (yf-yi)/Double(value) - (yf-yi)
        xi -= dx/2
        xf += dx/2
        yi -= dy/2
        yf += dy/2
        self.scale = 1.0
        setPoints()
    }
    
    func setPoints() {
        
        for line in lines {
            
            // Cartesian Coordinates
            if line.modes.graphType == .cartesian {
                
                let dx = (xf-xi)/Double(precision)
                
                for i in 0...precision {
                    
                    let x = xi + Double(i)*dx
                    
                    if line.domain ~= x, line.points[x] == nil {
                        
                        let y = Expression(line.equation.items).plugIn(Number(x), to: horizontalAxis, using: line.equation.modes)

                        if let number = Value.setValue(y, keepExp: false) as? Number {
                            line.points[x] = number.value
                        }
                        else if y is Error {
                            line.points[x] = .nan
                        }
                    }
                }
            }
        }
    }
    
    func adjustDisplayRange(range: ClosedRange<Double>, number: Bool = false) -> [Double] {
        
        var numbers: [Double] = []
        
        guard gridLines else { return [] }
        
        let dx = CGFloat(xf-xi)/(2*scale)
        
        let power = floor(log10(dx))
        let base = dx / pow(10,power)
        
        var baseLevel: CGFloat {
            if abs(power) >= 2 {
                switch base {
                case 1..<2:
                    return 2
                case 2..<4:
                    return 5
                case 4..<7:
                    return 10
                case 7..<10:
                    return 20
                default:
                    return 1
                }
            } else {
                switch base {
                case 1..<2:
                    return 2
                case 2..<5:
                    return 5
                case 5..<10:
                    return 10
                default:
                    return 1
                }
            }
        }
        
        if power <= -6 {
            return []
        }
        
        let difference = baseLevel * pow(10, power-1)
        
        var start: Double = 0
        if !(range ~= start) {
            while start < range.lowerBound {
                start += difference
            }
            while start > range.upperBound {
                start -= difference
            }
        }
        
        var num = start
        
        // Negative
        while num >= range.lowerBound {
            numbers.insert(num, at: 0)
            num -= difference * (number ? 1 : 0.25) * (UIScreen.main.bounds.width > 1000 ? 0.5 : 1)
        }
        
        num = start
        
        // Positive
        while num <= range.upperBound {
            numbers.append(num)
            num += difference * (number ? 1 : 0.25) * (UIScreen.main.bounds.width > 1000 ? 0.5 : 1)
        }
        
        return numbers
    }
    
    func formatNum(_ num: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 6
        
        if num == 0 {
            return "0"
        }
        if abs(num) >= 1e6 || abs(num) < 1e-6 {
            let power = floor(log10(abs(num)))
            let base = num / pow(10, power)
            return (numberFormatter.string(from: NSNumber(value: base)) ?? String(base)) + "E" + (numberFormatter.string(from: NSNumber(value: power)) ?? String(power))
        }
        
        return numberFormatter.string(from: NSNumber(value: num)) ?? String(num)
    }
}




