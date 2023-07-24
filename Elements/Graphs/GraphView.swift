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
    var lightBackground: Bool
    
    var precision: Int
    
    @State var showPopUpGraph: Bool = false
    
    init(_ elements: [GraphElement], width: CGFloat = 21, centerX: CGFloat = 0, centerY: CGFloat = 0, horizontalAxis: Letter = Letter("x"), verticalAxis: Letter = Letter("y"), gridLines: Bool = true, gridStyle: CoordinateSystem = .cartesian, interactive: Bool = true, popUpGraph: Bool = false, lightBackground: Bool = false, precision: Int = 2000) {
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
        self.lightBackground = lightBackground
        self.precision = precision
    }

    var body: some View {
        
        GeometryReader { geometry in
                
            ZStack {
                
                axesView(size: geometry.size)
                gridLinesView(size: geometry.size)
                guidelinesView(size: geometry.size)
                graphAnglesView(size: geometry.size)
                linesView(size: geometry.size)
                gridLabelsView(size: geometry.size)
                graphTextView(size: geometry.size)
                
                Rectangle()
                    .opacity(1e-10)
            }
            .frame(width: geometry.size.width*2*scale, height: geometry.size.height*2*scale, alignment: .center)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .offset(offset)
            .background(Color.init(white: 0.05).opacity(popUpGraph ? 0:1).edgesIgnoringSafeArea(.all))
            .overlay(
                ZStack {
                    if popUpGraph {
                        Rectangle()
                            .fill(Color.init(white: 0.75))
                            .opacity(lightBackground ? 0.1 : 1e-6)
                            .onTapGesture {
                                SoundManager.play(haptic: .medium)
                                self.showPopUpGraph.toggle()
                            }
                    }
                }
            )
            .gesture(DragGesture()
                .onChanged { value in
                    self.offset = interactive ? value.translation : offset
                }
                .onEnded { value in
                    let translation = coordinates(x: value.translation.width, y: value.translation.height, size: geometry.size)
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
                    GraphView(elements, width: angles.isEmpty ? 21 : 2.2, horizontalAxis: horizontalAxis, verticalAxis: verticalAxis, gridStyle: gridStyle)
                    XButtonOverlay {
                        self.showPopUpGraph = false
                    }
                }
                .background(Color.init(white: 0.05).edgesIgnoringSafeArea(.all))
            }
            .onAppear {
                setInitialBounds(size: geometry.size)
                setPoints()
            }
            .onChange(of: geometry.size) { size in
                setInitialBounds(size: size)
                setPoints()
            }
        }
    }
    
    @ViewBuilder
    private func axesView(size: CGSize) -> some View {
        Path { path in
            
            path.move(to: point(0, yi, size: size))
            path.addLine(to: point(0, yf, size: size))

            path.move(to: point(xi, 0, size: size))
            path.addLine(to: point(xf, 0, size: size))

        }
        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    }
    
    @ViewBuilder
    private func gridLinesView(size: CGSize) -> some View {
        Path { path in
            if xf > xi, yf > yi {
                
                for x in adjustDisplayRange(range: xi...xf, size: size) {
                    path.move(to: point(Double(x), yi, size: size))
                    path.addLine(to: point(Double(x), yf, size: size))
                }
                
                for y in adjustDisplayRange(range: yi...yf, size: size) {
                    path.move(to: point(xi, Double(y), size: size))
                    path.addLine(to: point(xf, Double(y), size: size))
                }
                
            }
        }
        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
    }
    
    @ViewBuilder
    private func gridLabelsView(size: CGSize) -> some View {
        if xf > xi, yf > yi {
            
            // Numbers
            ForEach(adjustDisplayRange(range: xi...xf, number: true, size: size), id: \.self) { num in
                Text(formatNum(num))
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .position(point(Double(num), 0, size: size, limitY: true, num: num))
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
            }
            ForEach(adjustDisplayRange(range: yi...yf, number: true, size: size), id: \.self) { num in
                Text(formatNum(num))
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .position(point(0, Double(num), size: size, limitX: true, num: num))
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
            }
        }
    }
    
    @ViewBuilder
    private func linesView(size: CGSize) -> some View {
        ForEach(self.lines.indices, id: \.self) { l in
            
            let line = self.lines[l]

            if let shape = line as? LineShape {

                LinePlot(line: shape, xi: xi, xf: xf, yi: yi, yf: yf, precision: precision, size: size) { x, y, geometry in
                    return point(x, y, size: size)
                }
                .fill(shape.color)
                .opacity(shape.opacity)

            } else {

                LinePlot(line: line, xi: xi, xf: xf, yi: yi, yf: yf, precision: precision, size: size) { x, y, geometry in
                    return point(x, y, size: size)
                }
                .stroke(line.color, lineWidth: 3)
                .shadow(radius: 4)
                .zIndex(1)
            }
        }
    }
    
    @ViewBuilder
    private func guidelinesView(size: CGSize) -> some View {
        ForEach(self.guidelines.indices, id: \.self) { l in

            let guideline = self.guidelines[l]

            Path { path in

                path.move(to: point(guideline.start.x, guideline.start.y, size: size))
                
                if guideline.circle {
                    path.addArc(center: point(guideline.end.x, guideline.end.y, size: size),
                                radius: point(guideline.start.x, 0, size: size).x - point(guideline.end.x, 0, size: size).x,
                                startAngle: Angle(radians: 0), endAngle: Angle(radians: .pi), clockwise: true)
                    path.addArc(center: point(guideline.end.x, guideline.end.y, size: size),
                                radius: point(guideline.start.x, 0, size: size).x - point(guideline.end.x, 0, size: size).x,
                                startAngle: Angle(radians: .pi), endAngle: Angle(radians: .pi*2), clockwise: true)
                } else {
                    path.addLine(to: point(guideline.end.x, guideline.end.y, size: size))
                }
            }
            .stroke(guideline.color, lineWidth: 1.5)
        }
    }
    
    @ViewBuilder
    private func graphAnglesView(size: CGSize) -> some View {
        ForEach(self.angles.indices, id: \.self) { a in
            
            let angle = self.angles[a]
            
            let center = point(angle.center.x, angle.center.y, size: size)
            let scaledSize: Double = point(min(0.1, angle.maxSize ?? 0.1), 0, size: size).x - point(0, 0, size: size).x
            let angleSize: Double = scaledSize > 30 ? 30 : scaledSize

            Path { path in
                
                path.move(to: CGPoint(x: center.x + angleSize*cos(angle.start.radians), y: center.y - angleSize*sin(angle.start.radians)))
                
                if abs(Int(angle.end.degrees) % 360 - Int(angle.start.degrees) % 360) % 180 == 90 {
                    path.addLine(to: CGPoint(x: center.x + angleSize*cos(angle.start.radians) + angleSize*cos(angle.end.radians), y: center.y - angleSize*sin(angle.start.radians) - angleSize*sin(angle.end.radians)))
                    path.addLine(to: CGPoint(x: center.x + angleSize*cos(angle.end.radians), y: center.y - angleSize*sin(angle.end.radians)))
                } else {
                    path.addArc(center: point(angle.center.x, angle.center.y, size: size), radius: angleSize, startAngle: angle.start, endAngle: -angle.end, clockwise: angle.endAngle > angle.startAngle)
                }
            }
            .stroke(angle.color, lineWidth: 1)
            
            if let string = angle.string {
                Text(string)
                    .font(.system(size: angleSize/2, design: .rounded).weight(.bold))
                    .position(x: center.x + angleSize*cos(angle.start.radians) + angleSize*cos(angle.end.radians), y: center.y - angleSize*sin(angle.start.radians) - angleSize*sin(angle.end.radians))
            }
        }
    }
    
    @ViewBuilder
    private func graphTextView(size: CGSize) -> some View {
        ForEach(self.text.indices, id: \.self) { t in

            let text = self.text[t]

            Text(text.text)
                .font(.system(size: point(0, 0, size: size).y - point(0, Double(text.size), size: size).y))
                .foregroundColor(text.color)
                .position(point(text.position.x, text.position.y, size: size))
                .rotationEffect(text.rotation)
                .dynamicTypeSize(..<DynamicTypeSize.xLarge)
        }
    }
    
    func point(_ x: Double, _ y: Double, size: CGSize, limitX: Bool = false, limitY: Bool = false, num: Double? = nil) -> CGPoint {
        
        var xPos = CGFloat(x - xi) * size.width/(CGFloat(xf-xi)/(2*scale))
        var yPos = CGFloat(yf - y) * size.height/(CGFloat(yf-yi)/(2*scale))
        
        if limitX {
            var labelWidth: CGFloat {
                guard let num = num else { return 0 }
                let label = UILabel()
                label.text = formatNum(num)
                label.font = UIFont.preferredFont(forTextStyle: .caption1)
                return label.intrinsicContentSize.width
            }
            if xPos + offset.width - 5 - labelWidth/2 < size.width*(scale-1/2) {
                xPos = size.width*(scale-1/2) - offset.width + 5 + labelWidth/2
            } else if xPos + offset.width + 5 + labelWidth/2 > size.width*(scale+1/2) {
                xPos = size.width*(scale+1/2) - offset.width - 5 - labelWidth/2
            }
        }
        if limitY {
            if yPos + offset.height - 10 < size.height*(scale-1/2) {
                yPos = size.height*(scale-1/2) - offset.height + 10
            } else if yPos + offset.height + 10 > size.height*(scale+1/2) {
                yPos = size.height*(scale+1/2) - offset.height - 10
            }
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func coordinates(x: CGFloat, y: CGFloat, size: CGSize) -> CGPoint {
        
        let xPos = x / (size.width/(CGFloat(xf-xi)/(2*scale)))
        let yPos = y / (size.height/(CGFloat(yf-yi)/(2*scale)))
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    func setInitialBounds(size: CGSize) {
        if size.height > size.width {
            self.xi = centerX-width
            self.xf = centerX+width
            self.yi = (centerY-width) * Double(size.height/size.width)
            self.yf = (centerY+width) * Double(size.height/size.width)
        } else {
            self.yi = centerY-width
            self.yf = centerY+width
            self.xi = (centerX-width) * Double(size.width/size.height)
            self.xf = (centerX+width) * Double(size.width/size.height)
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
    
    func adjustDisplayRange(range: ClosedRange<Double>, number: Bool = false, size: CGSize) -> [Double] {
        
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
            num -= difference * (number ? 1 : 0.25) * (size.width > 1000 ? 0.5 : 1)
        }
        
        num = start
        
        // Positive
        while num <= range.upperBound {
            numbers.append(num)
            num += difference * (number ? 1 : 0.25) * (size.width > 1000 ? 0.5 : 1)
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




