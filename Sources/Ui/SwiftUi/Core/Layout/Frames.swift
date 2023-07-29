//
//  Frames.swift
//  bumblebee
//
//  Created by sugarbaron on 11.07.2023.
//

import SwiftUI

public extension View {
    
    func frame(_ size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
    
    func frame(squared: CGFloat) -> some View {
        frame(width: squared, height: squared)
    }
    
    @ViewBuilder
    func frame(w: CGFloat? = nil, h: CGFloat? = nil) -> some View {
        frame(width: w, height: h)
    }
    
    func frame(minW: CGFloat? = nil,
               optW: CGFloat? = nil,
               maxW: CGFloat? = nil,
               minH: CGFloat? = nil,
               optH: CGFloat? = nil,
               maxH: CGFloat? = nil) -> some View {
        frame(minWidth: minW,
              idealWidth: optW,
              maxWidth: maxW,
              minHeight: minH,
              idealHeight: optH,
              maxHeight: maxH)
    }
    
    func frame(w: CGFloat?, minH: CGFloat?) -> some View {
        self.frame(minHeight: minH)
            .frame(width: w)
    }
    
    func frame(w: CGFloat?, maxH: CGFloat?) -> some View {
        self.frame(maxHeight: maxH)
            .frame(width: w)
    }
    
    func frame(w: CGFloat?, optH: CGFloat?) -> some View {
        self.frame(idealHeight: optH)
            .frame(width: w)
    }
    
    func frame(w: CGFloat?, minH: CGFloat?, maxH: CGFloat?) -> some View {
        self.frame(minHeight: minH, maxHeight: maxH)
            .frame(width: w)
    }
    
    func frame(w: CGFloat?, optH: CGFloat?, minH: CGFloat?, maxH: CGFloat?) -> some View {
        self.frame(minHeight: minH, idealHeight: optH, maxHeight: maxH)
            .frame(width: w)
    }
    
    func frame(minW: CGFloat?, h: CGFloat) -> some View {
        self.frame(minWidth: minW)
            .frame(height: h)
    }
    
    func frame(maxW: CGFloat?, h: CGFloat) -> some View {
        self.frame(maxWidth: maxW)
            .frame(height: h)
    }
    
    func frame(optW: CGFloat?, h: CGFloat) -> some View {
        self.frame(idealWidth: optW)
            .frame(height: h)
    }
    
    func frame(minW: CGFloat?, maxW: CGFloat?, h: CGFloat) -> some View {
        self.frame(minWidth: minW, maxWidth: maxW)
            .frame(height: h)
    }
    
    func frame(minW: CGFloat?, maxW: CGFloat?, optW: CGFloat?, h: CGFloat) -> some View {
        self.frame(minWidth: minW, idealWidth: optW, maxWidth: maxW)
            .frame(height: h)
    }
    
    func frame(edges edgeSize: CGFloat, in geometry: GeometryProxy) -> some View {
        self.frame(width: geometry.w - 2 * edgeSize, height: geometry.h - 2 * edgeSize)
            .positionAt(center: geometry)
    }
    
    func frame(edgeW: CGFloat, edgeH: CGFloat, in geometry: GeometryProxy) -> some View {
        self.frame(width: geometry.w - 2 * edgeW, height: geometry.h - 2 * edgeH)
            .positionAt(center: geometry)
    }
    
    func frame(edges ratio: CGFloat, of geometry: GeometryProxy) -> some View {
        self.frame(width: (1 - 2 * ratio) * geometry.w, height: (1 - 2 * ratio) * geometry.h)
            .positionAt(center: geometry)
    }
    
    func frame(edges ratio: CGFloat, of dimension: Size.Dimension, in geometry: GeometryProxy) -> some View {
        let space: CGFloat = (dimension == .w) ? ratio * geometry.w : ratio * geometry.h
        return self.frame(width: geometry.w - 2 * space, height: geometry.h - 2 * space)
                   .positionAt(center: geometry)
    }
    
    func frame(edgeW wRatio: CGFloat, edgeH hRatio: CGFloat, of geometry: GeometryProxy) -> some View {
        self.frame(width: (1 - 2 * wRatio) * geometry.w, height: (1 - 2 * hRatio) * geometry.h)
            .positionAt(center: geometry)
    }
    
    func frame(edges edgeSize: CGFloat, in space: CGSize) -> some View {
        self.frame(width: space.w - 2 * edgeSize, height: space.h - 2 * edgeSize)
    }
    
    func frame(edgeW: CGFloat, edgeH: CGFloat, in space: CGSize) -> some View {
        self.frame(width: space.w - 2 * edgeW, height: space.h - 2 * edgeH)
    }
    
    func frame(edges ratio: CGFloat, of space: CGSize) -> some View {
        self.frame(width: (1 - 2 * ratio) * space.w, height: (1 - 2 * ratio) * space.h)
    }
    
    func frame(edges ratio: CGFloat, of dimension: Size.Dimension, in space: CGSize) -> some View {
        let edge: CGFloat = (dimension == .w) ? ratio * space.w : ratio * space.h
        return self.frame(width: space.w - 2 * edge, height: space.h - 2 * edge)
    }
    
    func frame(edgeW wRatio: CGFloat, edgeH hRatio: CGFloat, of space: CGSize) -> some View {
        self.frame(width: (1 - 2 * wRatio) * space.w, height: (1 - 2 * hRatio) * space.h)
    }
    
    func indents(_ indent: CGFloat, in space: CGSize) -> some View {
        self.frame(width: space.w - 2 * indent, height: space.h - 2 * indent)
            .padding(indent)
    }
    
    func indents(w indentW: CGFloat, h indentH: CGFloat, in space: CGSize) -> some View {
        self.frame(width: space.w - 2 * indentW, height: space.h - 2 * indentH)
            .padding([.leading, .trailing], indentW)
            .padding([.top, .bottom],       indentH)
    }
    
    func indents(_ ratio: CGFloat, of space: CGSize) -> some View {
        self.frame(width: (1 - 2 * ratio) * space.w, height: (1 - 2 * ratio) * space.h)
            .padding([.leading, .trailing], ratio * space.w)
            .padding([.top, .bottom],       ratio * space.h)
    }
    
    func indents(_ ratio: CGFloat, of dimension: Size.Dimension, in space: CGSize) -> some View {
        let indent: CGFloat = (dimension == .w) ? ratio * space.w : ratio * space.h
        return self.frame(width: space.w - 2 * indent, height: space.h - 2 * indent)
                   .padding(indent)
    }
    
    func indents(w wRatio: CGFloat, h hRatio: CGFloat, of space: CGSize) -> some View {
        self.frame(width: (1 - 2 * wRatio) * space.w, height: (1 - 2 * hRatio) * space.h)
            .padding([.leading, .trailing], wRatio * space.w)
            .padding([.top, .bottom],       hRatio * space.h)
    }
    
}
