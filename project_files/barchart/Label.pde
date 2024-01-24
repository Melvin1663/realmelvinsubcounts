class Label {
  String name; // Bar name
  String ind;
  float[] values = new float[data_length]; // Bar values
  int[] ranks = new int[data_length]; // Bar rank overtime
  color c; // Bar color
  int m100kd = 0; // silver play button stopwatch
  int m1md = 0; // gold play button stopwatch
  int m10md = 0; // diamond play button stopwatch
  int m100md = 0; // red diamond play button stopwatch
  int showUp = 0; // first appearance stopwatch
  int indd = 0; // Highlight stopwatch
  PImage icon; // Bar icon
  PImage image; // Bar image (bar icon but bigger)
  PImage associated_ico; // role icon
  public Label(String n, String col) {
    name = n;
    for (int i = 0; i < data_length; i++) {
      values[i] = -1;
      ranks[i] = topVis+2;
    }
    String[] colorcode = hex2rgb(col).split(",");
    //println(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
    c = color(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
    icon = loadImage("utils/0.png");
    image = loadImage("utils/0.png");
    icon.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT));
  }
  public Label(String n) {
    name = n;
    for (int i = 0; i < data_length; i++) {
      values[i] = -1;
      ranks[i] = topVis+2;
    }
    c = color(random(50, 200),random(50, 200),random(50, 200));
    icon = loadImage("utils/0.png");
    image = loadImage("utils/0.png");
    icon.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT));
  }
  public Label(String n, String col, String img) {
    name = n;
    for (int i = 0; i < data_length; i++) {
      values[i] = -1;
      ranks[i] = topVis+2;
    }
    String imgString;
    if (img.equals("x")) imgString = n + ".jpg";
    else imgString = img;
    icon = loadImage("icons/"+imgString);
    image = loadImage("icons/"+imgString);
    icon.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT));
    String[] colorcode = hex2rgb(col).split(",");
    
    c = color(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
  }
  public Label(String n, String col, String img, String indic) {
    name = n;
    ind = indic.replace("\"", "");
    for (int i = 0; i < data_length; i++) {
      values[i] = -1;
      ranks[i] = topVis+2;
    }
    String imgString;
    if (img.equals("x")) imgString = n + ".jpg";
    else imgString = img;
    icon = loadImage("icons/"+imgString);
    image = loadImage("icons/"+imgString);
    //associated_ico = loadImage("assets/rats/"+imgString.replace(".jpg", ".png"));
    //associated_ico.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT));
    icon.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT));
    String[] colorcode = hex2rgb(col).split(",");
    
    c = color(Integer.parseInt(colorcode[0]), Integer.parseInt(colorcode[1]), Integer.parseInt(colorcode[2]));
  }
}

String hex2rgb(String hex) {
   return String.valueOf(Integer.valueOf(hex.substring( 1, 3 ), 16 ))+","+
          String.valueOf(Integer.valueOf(hex.substring( 3, 5 ), 16 ))+","+
          String.valueOf(Integer.valueOf(hex.substring( 5, 7 ), 16 ));
}
