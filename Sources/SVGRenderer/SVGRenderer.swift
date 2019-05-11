import Foundation
public class SVGRenderer{

  var image : String

  public init(width w : Float, height h : Float) {
      image = "<svg height=\"\(h)\" width=\"\(w)\">"
      image = image + "\n" + "<rect width=\"100%\" height=\"100%\" fill=\"white\"/>";
  }

  public func draw_rect_svg(_ x : [Float], _ y : [Float], _ thickness : Float) {
    let w : Float = abs(x[1] - x[0])
    let h : Float = abs(y[1] - y[2])
    let rect : String = "<rect x=\"\(x[3])\" y=\"\(y[3])\" width=\"\(w)\" height=\"\(h)\" style=\"fill:rgb(255,255,255);stroke-width:\(thickness);stroke:rgb(0,0,0)\" />"
    image = image + "\n" + rect
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
