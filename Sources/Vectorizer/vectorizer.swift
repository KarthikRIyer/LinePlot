import RendererWrapper
// class defining a point
public class Point {
  public var x : Float
  public var y : Float
  public init(_ x : Float, _ y : Float){
    self.x = x
    self.y = y
  }
}

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

public func drawPlotLine(_ p : [Point], _ thickness : Float, _ plotObject : UnsafeRawPointer){

  var x = [Float]()
  var y = [Float]()

  for index in 0..<p.count {
      x.append(p[index].x)
      y.append(p[index].y)
  }

  draw_plot_lines(x, y, Int32(p.count), thickness, plotObject)
}

public func drawText(_ s : String, _ p : Point, _ size : Float, _ thickness : Float, _ plotObject : UnsafeRawPointer){

  draw_text(s, p.x, p.y, size, thickness,plotObject)

}

public func drawRotatedText(_ s : String, _ p : Point, _ size : Float, _ thickness : Float,_ angle : Float, _ plotObject : UnsafeRawPointer){

  draw_rotated_text(s, p.x, p.y, size, thickness, angle, plotObject)

}

public func drawSolidRect(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point,  _ plotObject : UnsafeRawPointer){

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

  draw_solid_rect(x, y, plotObject)

}

public func drawSolidRectWithBorder(_ p1 : Point,_ p2 : Point,_ p3 : Point,_ p4 : Point, _ thickness : Float, _ plotObject : UnsafeRawPointer){

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

  draw_solid_rect(x, y, plotObject)
  draw_rect(x, y, thickness, plotObject)

}

public func getTextWidth(_ text : String, _ size : Float, _ plotObject : UnsafeRawPointer) -> Float{

  return get_text_width(text, size, plotObject);

}

public func savePlotImage(_ name : String, _ plotObject : UnsafeRawPointer){
  save_image(name, plotObject)
}

public func initialize() -> UnsafeRawPointer{
  let object = UnsafeRawPointer(initializePlot())
  return object!
}
