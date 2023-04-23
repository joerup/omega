//
//  LinePlot.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/1/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct LinePlot: Shape {
    
    var line: Line
    
    var xi: Double
    var xf: Double
    var yi: Double
    var yf: Double
    
    var precision: Int
    
    var geometry: GeometryProxy
    
    var point: (Double, Double, GeometryProxy) -> CGPoint
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        var continueLine = false
        
        // MARK: Cartesian
            
        if line.modes.graphType == .cartesian {
            
            let dx = (xf-xi)/Double(precision)
            
            for i in 0...precision {

                let x: Double = xi + Double(i)*dx

                if let y = line.points[x] {
                    
                    var location: CGPoint? {
                        if yi...yf ~= y {
                            return point(x, y, geometry)
                        }
                        else if !y.isFinite {
                            return nil
                        }
                        else if y > yf, let yp = line.points[xi+Double(i-1)*dx], yp <= yf {
                            return point(x-(y-yf)*dx/(y-yp), yf, geometry)
                        }
                        else if y > yf, let yn = line.points[xi+Double(i+1)*dx], yn <= yf {
                            return point(x+(y-yf)*dx/(y-yn), yf, geometry)
                        }
                        else if y < yi, let yp = line.points[xi+Double(i-1)*dx], yp >= yi {
                            return point(x-(y-yi)*dx/(y-yp), yi, geometry)
                        }
                        else if y < yi, let yn = line.points[xi+Double(i+1)*dx], yn >= yi {
                            return point(x+(y-yi)*dx/(y-yn), yi, geometry)
                        }
                        else if line is LineShape, y > yf {
                            return point(x, yf, geometry)
                        }
                        else if line is LineShape, y < yi {
                            return point(x, yi, geometry)
                        }
                        return nil
                    }
                    
                    if let location = location {
                        if path.isEmpty || (!continueLine && !(line is LineShape)) {
                            path.move(to: location)
                        } else {
                            path.addLine(to: location)
                        }
                        continueLine = true
                    } else {
                        continueLine = false
                    }
                }
            }
            
            if let shape = line as? LineShape {
                
                let upper = xf < line.domain.upperBound ? xf : line.domain.upperBound
                let lower = xi > line.domain.lowerBound ? xi : line.domain.lowerBound
                
                var end: Double {
                    switch shape.location {
                    case .top:
                        return yf
                    case .bottom:
                        return yi
                    default:
                        return 0
                    }
                }
                
                path.addLine(to: point(upper, end, geometry))
                path.addLine(to: point(lower, end, geometry))
                
                path.closeSubpath()
            }
        }
        
        // MARK: Polar
        
        else if line.modes.graphType == .polar {
            
            let dθ = 2*Double.pi/Double(precision)
            
            for i in 0...precision {
                
                let θ: Double = Double(i)*dθ
                
                if let r = line.points[θ] {
                    
                    let x = r*cos(θ)
                    let y = r*sin(θ)
                    
                    var location: CGPoint? {
                        if yi...yf ~= y {
                            return point(x, y, geometry)
                        }
                        else if !y.isFinite {
                            return nil
                        }
                        else if line is LineShape, y > yf {
                            return point(x, yf, geometry)
                        }
                        else if line is LineShape, y < yi {
                            return point(x, yi, geometry)
                        }
                        return nil
                    }
                    
                    if let location = location {
                        if path.isEmpty || (!continueLine && !(line is LineShape)) {
                            path.move(to: location)
                        } else {
                            path.addLine(to: location)
                        }
                        continueLine = true
                    } else {
                        continueLine = false
                    }
                }
            }
            
            if line is LineShape {
                path.addLine(to: point(0, 0, geometry))
                path.closeSubpath()
            }
        }

        return path
    }
}

enum CoordinateSystem {
    case cartesian
    case polar
}
