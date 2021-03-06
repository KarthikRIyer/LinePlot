#include <iostream>
#include "include/AGGRenderer.h"
//agg rendering library
#include "agg_basics.h"
#include "agg_rendering_buffer.h"
#include "agg_rasterizer_scanline_aa.h"
#include "agg_scanline_p.h"
#include "agg_pixfmt_rgb.h"
#include "agg_path_storage.h"
#include "platform/agg_platform_support.h"
#include "agg_gsv_text.h"
#include "agg_conv_curve.h"
//lodepng library
#include "lodepng.h"
//header to save bitmaps
#include "savebmp.h"

#define AGG_RGB24
#include "include/pixel_formats.h"

typedef agg::pixfmt_rgb24 pixfmt;
typedef agg::renderer_base<pixfmt> renderer_base;
typedef agg::renderer_scanline_aa_solid<renderer_base> renderer_aa;
typedef agg::renderer_scanline_bin_solid<renderer_base> renderer_bin;
typedef agg::rasterizer_scanline_aa<> rasterizer_scanline;
typedef agg::scanline_p8 scanline;
typedef agg::rgba Color;

const Color black(0.0,0.0,0.0,1.0);
const Color blue_light(0.529,0.808,0.922,1.0);
const Color white(1.0,1.0,1.0,1.0);
const Color white_translucent(1.0,1.0,1.0,0.8);

int frame_width = 1000;
int frame_height = 660;

namespace AGGRenderer{
  unsigned char* buffer = new unsigned char[frame_width*frame_height*3];
  agg::rendering_buffer rbuf (buffer,
                              frame_width,
                              frame_height,
                              -frame_width*3);
  pixfmt pixf(rbuf);

  void write_bmp(const unsigned char* buf, unsigned width, unsigned height, const char* file_name){
    saveBMP(buf, width, height, file_name);
  }

  void write_png(std::vector<unsigned char>& image, unsigned width, unsigned height, const char* filename) {
    //Encode the image
    LodePNGColorType colorType = LCT_RGB;
    unsigned error = lodepng::encode(filename, image, width, height, colorType);

    //if there's an error, display it
    if(error) std::cout << "encoder error " << error << ": "<< lodepng_error_text(error) << std::endl;
  }

  bool write_ppm(const unsigned char* buf,
                  unsigned width,
                  unsigned height,
                  const char* file_name){
                    FILE* fd = fopen(file_name, "wb");
                    if(fd){
                      fprintf(fd, "P6 %d %d 255 ", width, height);
                      fwrite(buf, 1, width*height*3, fd);
                      fclose(fd);
                      return true;
                    }
                    return false;
  }

  class Plot{

  public:
    agg::rasterizer_scanline_aa<> m_ras;
    agg::scanline_p8              m_sl_p8;
    renderer_base rb;
    renderer_aa ren_aa;

    Plot(){
      rb = renderer_base(pixf);
      ren_aa = renderer_aa(rb);
    }

    void draw_solid_rect(const float *x, const float *y, float r, float g, float b, float a){

      agg::path_storage rect_path;
      rect_path.move_to(*x, *y);
      for (int i = 1; i < 4; i++) {
        rect_path.line_to(*(x+i),*(y+i));
      }
      rect_path.close_polygon();
      m_ras.add_path(rect_path);
      Color c(r, g, b, a);
      ren_aa.color(c);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_rect(const float *x, const float *y, float thickness){

      agg::path_storage rect_path;
      rect_path.move_to(*x, *y);
      for (int i = 1; i < 4; i++) {
        rect_path.line_to(*(x+i),*(y+i));
      }
      rect_path.close_polygon();
      agg::conv_stroke<agg::path_storage> rect_path_line(rect_path);
      rect_path_line.width(thickness);
      m_ras.add_path(rect_path_line);
      ren_aa.color(black);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_transformed_line(const float *x, const float *y, float thickness){

      agg::path_storage rect_path;
      rect_path.move_to(*x, *y);
      rect_path.line_to(*(x+1),*(y+1));
      agg::trans_affine matrix;
      matrix *= agg::trans_affine_translation(frame_width*0.1f, frame_height*0.1f);
      agg::conv_transform<agg::path_storage, agg::trans_affine> trans(rect_path, matrix);
      agg::conv_curve<agg::conv_transform<agg::path_storage, agg::trans_affine>> curve(trans);
      agg::conv_stroke<agg::conv_curve<agg::conv_transform<agg::path_storage, agg::trans_affine>>> stroke(curve);
      stroke.width(thickness);
      m_ras.add_path(stroke);
      ren_aa.color(black);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_line(const float *x, const float *y, float thickness){

      agg::path_storage rect_path;
      rect_path.move_to(*x, *y);
      rect_path.line_to(*(x+1),*(y+1));
      agg::conv_stroke<agg::path_storage> rect_path_line(rect_path);
      rect_path_line.width(thickness);
      m_ras.add_path(rect_path_line);
      ren_aa.color(black);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_plot_lines(const float *x, const float *y, int size, float thickness, float r, float g, float b, float a){

      agg::path_storage rect_path;
      rect_path.move_to(*x, *y);
      for (int i = 1; i < size; i++) {
        rect_path.line_to(*(x+i),*(y+i));
      }
      agg::conv_stroke<agg::path_storage> rect_path_line(rect_path);
      rect_path_line.width(thickness);
      m_ras.add_path(rect_path_line);
      Color c(r, g, b, a);
      ren_aa.color(c);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_text(const char *s, float x, float y, float size, float thickness){

      agg::gsv_text t;
      t.size(size);
      t.text(s);
      t.start_point(x,y);
      agg::conv_stroke<agg::gsv_text> stroke(t);
      stroke.width(thickness);
      m_ras.add_path(stroke);
      ren_aa.color(black);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_transformed_text(const char *s, float x, float y, float size, float thickness){

      agg::gsv_text t;
      t.size(size);
      t.text(s);
      t.start_point(x,y);
      agg::trans_affine matrix;
      matrix *= agg::trans_affine_translation(frame_width*0.1f, frame_height*0.1f);
      agg::conv_transform<agg::gsv_text, agg::trans_affine> trans(t, matrix);
      agg::conv_curve<agg::conv_transform<agg::gsv_text, agg::trans_affine>> curve(trans);
      agg::conv_stroke<agg::conv_curve<agg::conv_transform<agg::gsv_text, agg::trans_affine>>> stroke(curve);
      stroke.width(thickness);
      m_ras.add_path(stroke);
      ren_aa.color(black);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    void draw_rotated_text(const char *s, float x, float y, float size, float thickness, float angle){

      agg::gsv_text t;
      t.size(size);
      t.text(s);
      t.start_point(0,0);
      agg::trans_affine matrix;
      matrix *= agg::trans_affine_rotation(agg::deg2rad(angle));
      matrix *= agg::trans_affine_translation(x, y);
      agg::conv_transform<agg::gsv_text, agg::trans_affine> trans(t, matrix);
      agg::conv_curve<agg::conv_transform<agg::gsv_text, agg::trans_affine>> curve(trans);
      agg::conv_stroke<agg::conv_curve<agg::conv_transform<agg::gsv_text, agg::trans_affine>>> stroke(curve);
      stroke.width(thickness);
      m_ras.add_path(stroke);
      ren_aa.color(black);
      agg::render_scanlines(m_ras, m_sl_p8, ren_aa);

    }

    float get_text_width(const char *s, float size){

      agg::gsv_text t;
      t.text(s);
      t.size(size);
      return t.text_width();

    }

    void save_image(const char *s){
      char* file_ppm = (char *) malloc(1 + strlen(s)+ strlen(".ppm") );
      strcpy(file_ppm, s);
      strcat(file_ppm, ".ppm");
      char* file_png = (char *) malloc(1 + strlen(s)+ strlen(".png") );
      strcpy(file_png, s);
      strcat(file_png, ".png");
      char* file_bmp = (char *) malloc(1 + strlen(s)+ strlen(".bmp") );
      strcpy(file_bmp, s);
      strcat(file_bmp, ".bmp");
      write_ppm(buffer, frame_width, frame_height, file_ppm);

      std::vector<unsigned char> image(buffer, buffer + (frame_width*frame_height*3));
      write_png(image, frame_width, frame_height, file_png);

      write_bmp(buffer, frame_width, frame_height, file_bmp);

      delete[] buffer;
    }

  };

  const void * initializePlot(){
    memset(buffer, 255, frame_width*frame_height*3);
    Plot *plot = new Plot();
    return (void *)plot;
  }

  void draw_rect(const float *x, const float *y, float thickness, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_rect(x, y, thickness);

  }

  void draw_solid_rect(const float *x, const float *y, float r, float g, float b, float a, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_solid_rect(x, y, r, g, b, a);

  }

  void draw_line(const float *x, const float *y, float thickness, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_line(x, y, thickness);

  }

  void draw_transformed_line(const float *x, const float *y, float thickness, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_transformed_line(x, y, thickness);

  }

  void draw_plot_lines(const float *x, const float *y, int size, float thickness, float r, float g, float b, float a, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_plot_lines(x, y, size, thickness, r, g, b, a);

  }

  void draw_text(const char *s, float x, float y, float size, float thickness, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_text(s, x, y, size, thickness);

  }

  void draw_transformed_text(const char *s, float x, float y, float size, float thickness, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_transformed_text(s, x, y, size, thickness);

  }

  void draw_rotated_text(const char *s, float x, float y, float size, float thickness, float angle, const void *object){

    Plot *plot = (Plot *)object;
    plot -> draw_rotated_text(s, x, y, size, thickness, angle);

  }

  float get_text_width(const char *s, float size, const void *object){

    Plot *plot = (Plot *)object;
    return plot -> get_text_width(s, size);

  }

  void save_image(const char *s, const void *object){

    Plot *plot = (Plot *)object;
    plot -> save_image(s);

  }

}
