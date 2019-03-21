#include "include/RendererWrapper.h"
#include "AGGRenderer.h"

const void * initializePlot(){
  return AGGRenderer::initializePlot();
}

void draw_rect(const float *x, const float *y, float thickness, const void *object){
  AGGRenderer::draw_rect(x, y, thickness, object);
}

void draw_solid_rect(const float *x, const float *y, const void *object){
  draw_solid_rect(x, y, object);
}

void draw_line(const float *x, const float *y, float thickness, const void *object){
  draw_line(x, y, thickness, object);
}

void draw_plot_lines(const float *x, const float *y, int size, float thickness, const void *object){
  draw_plot_lines(x, y, size, thickness, object);
}

void draw_text(const char *s, float x, float y, float size, float thickness, const void *object){
  draw_text(s, x, y, size, thickness, object);
}

void draw_rotated_text(const char *s, float x, float y, float size, float thickness, float angle, const void *object){
  draw_rotated_text(s, x, y, size, thickness, angle, object);
}

float get_text_width(const char *s, float size, const void *object){
  get_text_width(s, size, object);
}

void save_image(const char *s, const void *object){
  save_image(s, object);
}
