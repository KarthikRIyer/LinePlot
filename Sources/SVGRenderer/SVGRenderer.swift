import Foundation
public class SVGRenderer{

  var image : String
  var width : Float
  var height : Float

  public init(width w : Float, height h : Float) {
    width = w
    height = h
    image = "<svg height=\"\(h)\" width=\"\(w)\">"
    image = image + "\n" + "<rect width=\"100%\" height=\"100%\" fill=\"white\"/>";
  }

  public func draw_rect_svg(_ x : [Float], _ y : [Float], _ thickness : Float) {
    let w : Float = abs(x[1] - x[0])
    let h : Float = abs(y[1] - y[2])
    let rect : String = "<rect x=\"\(x[0])\" y=\"\(height - y[0])\" width=\"\(w)\" height=\"\(h)\" style=\"fill:rgb(255,255,255);stroke-width:\(thickness);stroke:rgb(0,0,0)\" />"
    image = image + "\n" + rect
  }

  public func draw_solid_rect_svg(_ x : [Float], _ y : [Float], _ r : Float, _ g : Float, _ b : Float, _ a : Float) {
    let w : Float = abs(x[1] - x[0])
    let h : Float = abs(y[1] - y[2])
    let rect : String = "<rect x=\"\(x[0])\" y=\"\(height - y[0])\" width=\"\(w)\" height=\"\(h)\" style=\"fill:rgb(\(r*255.0),\(g*255.0),\(b*255.0));stroke-width:0;stroke:rgb(0,0,0)\" />"
    image = image + "\n" + rect
  }

  public func draw_solid_rect_with_border_svg(_ x : [Float], _ y : [Float], _ thickness : Float, _ r : Float, _ g : Float, _ b : Float, _ a : Float) {
    let w : Float = abs(x[1] - x[0])
    let h : Float = abs(y[1] - y[2])
    let rect : String = "<rect x=\"\(x[0])\" y=\"\(height - y[0])\" width=\"\(w)\" height=\"\(h)\" style=\"fill:rgb(\(r*255.0),\(g*255.0),\(b*255.0));stroke-width:\(thickness);stroke:rgb(0,0,0)\" />"
    image = image + "\n" + rect
  }

  public func draw_transformed_line_svg(_ x : [Float], _ y : [Float], _ thickness : Float, _ r : Float = 0, _ g : Float = 0, _ b : Float = 0, _ a : Float = 1) {
      let x0 = x[0] + (0.1*width)
      var y0 = y[0] + (0.1*height)
      let x1 = x[1] + (0.1*width)
      var y1 = y[1] + (0.1*height)
      y0 = height - y0
      y1 = height - y1
      let line = "<line x1=\"\(x0)\" y1=\"\(y0)\" x2=\"\(x1)\" y2=\"\(y1)\" style=\"stroke:rgb(\(r*255.0),\(g*255.0),\(b*255.0));stroke-width:\(thickness)\" />"
      image = image + "\n" + line
  }

  public func draw_transformed_text_svg(_ s : String, _ x : Float, _ y : Float, _ size : Float, _ thickness : Float, _ angle : Float = 0){
    let x1 = x + 0.1*width
    let y1 = height - y - 0.1*height
    let text = "<text x=\"\(x1)\" y=\"\(y1)\" stroke=\"#000000\" stroke-width=\"\(thickness)\" transform=\"rotate(\(angle),\(x1),\(y1))\">\(s)</text>"
    image = image + "\n" + text
  }

  public func draw_text_svg(_ s : String, _ x : Float, _ y : Float, _ size : Float, _ thickness : Float, _ angle : Float = 0){
    let y1 = height - y
    let text = "<text x=\"\(x)\" y=\"\(y1)\" stroke=\"#000000\" stroke-width=\"\(thickness)\"  transform=\"rotate(\(angle),\(x),\(y1))\">\(s)</text>"
    image = image + "\n" + text
  }

  public func draw_plot_lines_svg(_ x : [Float], _ y : [Float], _ thickness : Float, _ r : Float, _ g : Float, _ b : Float, _ a : Float) {
    for i in 0..<x.count-1 {
      let x1 : [Float] = [x[i], x[i+1]]
      let y1 : [Float] = [y[i], y[i+1]]
      draw_transformed_line_svg(x1, y1, thickness, r, g, b, a)
    }
  }

  public func save_image_svg(_ name : String) {
    image = image + "\n" + "</svg>"
    let url = URL(fileURLWithPath: "\(name).svg")
    do {
        try image.write(to: url, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print("Unable to save image!")
    }
  }

}
