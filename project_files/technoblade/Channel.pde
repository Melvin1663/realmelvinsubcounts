class Channel {
  String name;
  float[] subs = new float[data_length];
  float[] views = new float[data_length];
  int[] columns = new int[2];
  color c;
  PImage icon;
  PImage image;
  PImage icon_rounded;
  PImage image_rounded;
  
  public Channel(String n, String col, String img, int[] clmns) {
    name = n;
    columns = clmns;
    String imgString;
    String imgString_rounded;
    if (img.equals("x")) imgString = n + ".jpg";
    else imgString = img;
    if (img.equals("x")) imgString_rounded = n + ".png";
    else imgString_rounded = img;
    
    image = loadImage("icons/"+imgString);
    image_rounded = loadImage("icons_rounded/"+imgString_rounded);
    
    icon = loadImage("icons/"+imgString);
    icon_rounded = loadImage("icons_rounded/"+imgString_rounded);
    
    int iconSize = 150;
    
    icon.resize(iconSize, iconSize);
    icon_rounded.resize(iconSize, iconSize);
    for (int i = 0; i < data_length; i++) {
      subs[i] = -1;
      views[i] = -1;
    }
    String[] colorcode = hex2rgb(col).split(",");
    c = color(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2])); 
  }
}

String hex2rgb(String hex) {
   return String.valueOf(Integer.valueOf(hex.substring( 1, 3 ), 16 ))+","+
          String.valueOf(Integer.valueOf(hex.substring( 3, 5 ), 16 ))+","+
          String.valueOf(Integer.valueOf(hex.substring( 5, 7 ), 16 ));
}
