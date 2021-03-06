namespace AGGRenderer{

  const void * initializePlot();

  void draw_rect(const float *x, const float *y, float thickness, const void *object);

  void draw_solid_rect(const float *x, const float *y, float r, float g, float b, float a, const void *object);

  void draw_line(const float *x, const float *y, float thickness, const void *object);

  void draw_transformed_line(const float *x, const float *y, float thickness, const void *object);

  void draw_plot_lines(const float *x, const float *y, int size, float thickness, float r, float g, float b, float a, const void *object);

  void draw_text(const char *s, float x, float y, float size, float thickness, const void *object);

  void draw_transformed_text(const char *s, float x, float y, float size, float thickness, const void *object);

  void draw_rotated_text(const char *s, float x, float y, float size, float thickness, float angle, const void *object);

  float get_text_width(const char *s, float size, const void *object);

  void save_image(const char *s, const void *object);

}
