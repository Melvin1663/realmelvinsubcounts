class Label {
  String name;
  float[] values = new float[data_length];
  int[] ranks = new int[data_length];
  color c;
  PImage icon;
  public Label(String n, String col) {
    name = n;
    for (int i = 0; i < data_length; i++) {
      values[i] = -2147483648.0;
    }
    String[] colorcode = hex2rgb(col).split(",");
    //println(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
    c = color(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
    icon = loadImage("0.png");
  }
  public Label(String n) {
    name = n;
    for (int i = 0; i < data_length; i++) {
      values[i] = -2147483648.0;
    }
    c = color(random(50, 200),random(50, 200),random(50, 200));
    icon = loadImage("0.png");
  }
  public Label(String n, String col, String img) {
    name = n;
    for (int i = 0; i < data_length; i++) {
      values[i] = -2147483648.0;
    }
    icon = loadImage(img);
    String[] colorcode = hex2rgb(col).split(",");
    
    c = color(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
  }
}

String hex2rgb(String hex) {
   return String.valueOf(Integer.valueOf(hex.substring( 1, 3 ), 16 ))+","+
          String.valueOf(Integer.valueOf(hex.substring( 3, 5 ), 16 ))+","+
          String.valueOf(Integer.valueOf(hex.substring( 5, 7 ), 16 ));
}
