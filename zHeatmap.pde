// heatmap code based on Heat Distribution by Justin Dailey
// http://openprocessing.org/sketch/46554


void update_heatmap()
{
  // Calculate the new heat value for each pixel
  for(int i = 0; i < heatmapW; ++i)
    for(int j = 0; j < heatmapH; ++j)
      heatmap[index ^ 1][i][j] = calc_pixel(i, j);
   
  // flip the index to the next heatmap
  index ^= 1;
}
 
float calc_pixel(int i, int j)
{
  float total = 0.0;
  int count = 0;
 
  // This is were the magic happens...
  // Average the heat around the current pixel to determin the new value
  for(int ii = -1; ii < 2; ++ii)
  {
    for(int jj = -1; jj < 2; ++jj)
    {
      if(i + ii < 0 || i + ii >= heatmapW || j + jj < 0 || j + jj >= heatmapH)
        continue;
 
      ++count;
      total += heatmap[index][i + ii][j + jj];
    }
  }
   
  // return the average
  return total / count;
}
 
void apply_heat(int i, int j, int r, float delta)
{
  // apply delta heat (or remove it) at location
  // (i, j) with radius r
  for(int ii = -(r / 2); ii < (r / 2); ++ii)
  {
    for(int jj = -(r / 2); jj < (r / 2); ++jj)
    {
      if(i + ii < 0 || i + ii >= heatmapW || j + jj < 0 || j + jj >= heatmapH)
        continue;
       
      // apply the heat
      heatmap[index][i + ii][j + jj] += delta;
      heatmap[index][i + ii][j + jj] = constrain(heatmap[index][i + ii][j + jj], 0.0, 20.0);
    }
  }
}




class Gradient
{
  ArrayList colors;
   
  // Constructor
  Gradient()
  {
    colors = new ArrayList();
  }
   
  void addColor(color c)
  {
    colors.add(c);
  }
   
  color getGradient(float value)
  {
    // make sure there are colors to use
    if(colors.size() == 0)
      return #000000;
     
    // if its too low, use the lowest value
    if(value <= 0.0)
      return (color)(Integer) colors.get(0);
     
    // if its too high, use the highest value
    if(value >= colors.size() - 1)
      return (color)(Integer) colors.get(colors.size() -  1);
     
    // lerp between the two needed colors
    int color_index = (int)value;
    color c1 = (color)(Integer) colors.get(color_index);
    color c2 = (color)(Integer) colors.get(color_index + 1);
     
    return lerpColor(c1, c2, value - color_index);
  }
}
