import RendererWrapper
import SVGRenderer

// class defining a point
public class Point {
  public var x : Float
  public var y : Float
  public init(_ x : Float, _ y : Float){
    self.x = x
    self.y = y
  }
}

public class Color{
  public var r : Float
  public var g : Float
  public var b : Float
  public var a : Float
  public init(_ r : Float, _ g : Float, _ b : Float, _ a : Float){
    self.r = g
    self.g = g
    self.b = b
    self.a = a
  }
}

public var RENDERER_AGG : Int = 0
public var RENDERER_SVG : Int = 1

public var renderer = RENDERER_AGG

public var svg_renderer : SVGRenderer?

public func setRenderer(renderer r: Int) {
  switch r {
  case RENDERER_AGG:
      renderer = RENDERER_AGG
  case RENDERER_SVG:
      renderer = RENDERER_SVG
  default:
      renderer = RENDERER_AGG
  }
}

//Functions pertaining to AGG Renderer////////////////////////////////////////////////////////////////////////////////////////////////
public func drawRect(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point, _ thickness : Float, _ plotObject : UnsafeRawPointer){

  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  x.append(p3.x)
  x.append(p4.x)
  y.append(p1.y)
  y.append(p2.y)
  y.append(p3.y)
  y.append(p4.y)

  draw_rect(x, y, thickness, plotObject)

}

public func drawLine(_ p1 : Point, _ p2 : Point, _ thickness : Float, _ plotObject : UnsafeRawPointer){
  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  y.append(p1.y)
  y.append(p2.y)

  draw_line(x, y, thickness, plotObject)
}

public func drawTransformedLine(_ p1 : Point, _ p2 : Point, _ thickness : Float, _ plotObject : UnsafeRawPointer){
  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  y.append(p1.y)
  y.append(p2.y)

  draw_transformed_line(x, y, thickness, plotObject)
}

public func drawPlotLine(_ p : [Point], _ thickness : Float, _ c : Color, _ plotObject : UnsafeRawPointer){

  var x = [Float]()
  var y = [Float]()

  for index in 0..<p.count {
      x.append(p[index].x)
      y.append(p[index].y)
  }
  draw_plot_lines(x, y, Int32(p.count), thickness, c.r, c.g, c.b, c.a, plotObject)
}

public func drawText(_ s : String, _ p : Point, _ size : Float, _ thickness : Float, _ plotObject : UnsafeRawPointer){

  draw_text(s, p.x, p.y, size, thickness,plotObject)

}

public func drawTransformedText(_ s : String, _ p : Point, _ size : Float, _ thickness : Float, _ plotObject : UnsafeRawPointer){

  draw_transformed_text(s, p.x, p.y, size, thickness,plotObject)

}

public func drawRotatedText(_ s : String, _ p : Point, _ size : Float, _ thickness : Float,_ angle : Float, _ plotObject : UnsafeRawPointer){

  draw_rotated_text(s, p.x, p.y, size, thickness, angle, plotObject)

}

public func drawSolidRect(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point,_ c : Color,_ plotObject : UnsafeRawPointer){

  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  x.append(p3.x)
  x.append(p4.x)
  y.append(p1.y)
  y.append(p2.y)
  y.append(p3.y)
  y.append(p4.y)

  draw_solid_rect(x, y, c.r, c.g, c.b, c.a, plotObject)

}

public func drawSolidRectWithBorder(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point, _ thickness : Float, _ c : Color, _ plotObject : UnsafeRawPointer){

  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  x.append(p3.x)
  x.append(p4.x)
  y.append(p1.y)
  y.append(p2.y)
  y.append(p3.y)
  y.append(p4.y)

  draw_solid_rect(x, y, c.r, c.g, c.b, c.a, plotObject)
  draw_rect(x, y, thickness, plotObject)

}

public func getTextWidth(_ text : String, _ size : Float, _ plotObject : UnsafeRawPointer) -> Float{

  return get_text_width(text, size, plotObject);

}

public func savePlotImage(_ name : String, _ plotObject : UnsafeRawPointer){
  save_image(name, plotObject)
}

public func initializeAGG() -> UnsafeRawPointer{
  let object = UnsafeRawPointer(initializePlot())
  return object!
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Functions pertaining to SVG Renderer////////////////////////////////////////////////////////////////////////////////////////////////

//extension to get ascii value of character
extension Character {
    var isAscii: Bool {
        return unicodeScalars.allSatisfy { $0.isASCII }
    }
    var ascii: UInt32? {
        return isAscii ? unicodeScalars.first?.value : nil
    }
}

var LCARS_CHAR_SIZE_ARRAY : [Int]?

public func initializeSVG(width w : Float, height h : Float) {
  LCARS_CHAR_SIZE_ARRAY = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 26, 46, 63, 42, 105, 45, 20, 25, 25, 47, 39, 21, 34, 26, 36, 36, 28, 36, 36, 36, 36, 36, 36, 36, 36, 27, 27, 36, 35, 36, 35, 65, 42, 43, 42, 44, 35, 34, 43, 46, 25, 39, 40, 31, 59, 47, 43, 41, 43, 44, 39, 28, 44, 43, 65, 37, 39, 34, 37, 42, 37, 50, 37, 32, 43, 43, 39, 43, 40, 30, 42, 45, 23, 25, 39, 23, 67, 45, 41, 43, 42, 30, 40, 28, 45, 33, 52, 33, 36, 31, 39, 26, 39, 55]
  svg_renderer = SVGRenderer(width : w, height : h)
}

public func getTextWidthSVG(_ text : String, _ size : Float) -> Float {

  var width : Float = 0
  let scaleFactor = size/100.0

  for i in 0..<text.count {
    let index =  text.index(text.startIndex, offsetBy: i)
    width = width + Float(LCARS_CHAR_SIZE_ARRAY![Int(text[index].ascii!)])
  }
  // print("\(text) = \(width*scaleFactor)")

  return width*scaleFactor + 25

}

public func drawRectSVG(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point, _ thickness : Float){

  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  x.append(p3.x)
  x.append(p4.x)
  y.append(p1.y)
  y.append(p2.y)
  y.append(p3.y)
  y.append(p4.y)

  svg_renderer!.draw_rect_svg(x, y, thickness)

}

public func drawLineSVG(_ p1 : Point, _ p2 : Point, _ thickness : Float){
  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  y.append(p1.y)
  y.append(p2.y)

  // draw_line(x, y, thickness, plotObject)
}

public func drawTransformedLineSVG(_ p1 : Point, _ p2 : Point, _ thickness : Float){
  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  y.append(p1.y)
  y.append(p2.y)

  svg_renderer!.draw_transformed_line_svg(x, y, thickness)
}

public func drawPlotLineSVG(_ p : [Point], _ thickness : Float, _ c : Color){

  var x = [Float]()
  var y = [Float]()

  for index in 0..<p.count {
      x.append(p[index].x)
      y.append(p[index].y)
  }
  svg_renderer!.draw_plot_lines_svg(x, y, thickness, c.r, c.g, c.b, c.a)
}

public func drawTextSVG(_ s : String, _ p : Point, _ size : Float, _ thickness : Float, _ angle : Float = 0){

  svg_renderer!.draw_text_svg(s, p.x, p.y, size, thickness, angle)

}

public func drawTransformedTextSVG(_ s : String, _ p : Point, _ size : Float, _ thickness : Float, _ angle : Float = 0){

  svg_renderer!.draw_transformed_text_svg(s, p.x, p.y, size, thickness, angle)

}

public func drawSolidRectSVG(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point,_ c : Color){

  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  x.append(p3.x)
  x.append(p4.x)
  y.append(p1.y)
  y.append(p2.y)
  y.append(p3.y)
  y.append(p4.y)

  svg_renderer!.draw_solid_rect_svg(x, y, c.r, c.g, c.b, c.a)

}

public func drawSolidRectWithBorderSVG(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point, _ thickness : Float, _ c : Color){

  var x = [Float]()
  var y = [Float]()

  x.append(p1.x)
  x.append(p2.x)
  x.append(p3.x)
  x.append(p4.x)
  y.append(p1.y)
  y.append(p2.y)
  y.append(p3.y)
  y.append(p4.y)

  svg_renderer!.draw_solid_rect_with_border_svg(x, y, thickness, c.r, c.g, c.b, c.a)

}

public func saveImageSVG(_ name : String) {
    svg_renderer!.save_image_svg(name)
}

///////////////////////////////////////////////r//////////////////////////////////////////////////////////////////////////////////////
