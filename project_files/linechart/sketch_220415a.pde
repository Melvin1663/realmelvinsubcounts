import videoExport.*;
import java.text.DecimalFormat;
import java.util.Arrays;

int data_length;
int data_count;
PFont font;
int frames = 0;
float currentDay = 0;
float fpd = 5;
float currentScale = -1;
int start_day = 0;
int zoom_amount = 300;

DecimalFormat decimalFormat = new DecimalFormat("###,###");

VideoExport videoExport;

boolean small_scale = false;
boolean record = true;
boolean dynamicY = false;
boolean expo = true;

String[] dateLabels;
//String[] units = {"1", "2", "5", "10", "20", "50", "100", "200", "500", "1000", "2000", "5000", "10000", "20000", "50000", "100000", "200000", "500000", "1000000", "2000000", "5000000", "20000000", "50000000", "100000000", "200000000", "500000000", "1000000000", "2000000000", "5000000000", "10000000000"};

//long[] units = {1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 20000000, 50000000, 100000000, 200000000, 500000000, 1000000000, 2000000000};
long[] units = {1L, 2L, 5L, 10L, 20L, 50L, 100L, 200L, 500L, 1000L, 2000L, 5000L, 10000L, 20000L, 50000L, 100000L, 200000L, 500000L, 1000000L, 2000000L, 5000000L, 10000000L, 20000000L, 50000000L, 100000000L, 200000000L, 500000000L,
  1000000000L, 2000000000L, 5000000000L, 10000000000L, 20000000000L, 50000000000L, 100000000000L, 200000000000L, 500000000000L};
String[] tsv;
float[] maxes;
float[] mins;
float[] maxnmins;
Label[] label;
int[] unitChoices;
int[][] top1;

float X_MIN = 30.0;
float X_MAX = 1500.0;
float Y_MIN = 400.0;
float Y_MAX = 1550.0;
float X_W = X_MAX-X_MIN;
float Y_H = Y_MAX-Y_MIN;
float point_r = 20.0;

PGraphics pg;

void lolexit() {
  System.exit(0);
}

void setup() {
  //font = loadFont("ConcertOne-Symbol-48.vlw");
  font = loadFont("Mojangles-48.vlw");
  randomSeed(2735929);
  tsv = loadStrings("newLife_.tsv");

  String[] labels = tsv[0].split("\t");
  String[] label_colors = tsv[1].split("\t");
  //String[] label_icons = tsv[2].split("\t");

  data_count = labels.length -1;
  data_length = tsv.length -3;
  dateLabels = new String[data_length];
  maxes = new float[data_length];
  mins = new float[data_length];
  maxnmins = new float[data_length];
  label = new Label[data_count];
  top1 = new int[data_length][2];

  unitChoices = new int[data_length];

  for (int i = 0; i < tsv.length-4; i++) dateLabels[i] = tsv[i+3].split("\t")[0].replaceAll("\"", "");
  for (int d = 0; d < data_length; d++) maxes[d]=0.0;
  for (int i = 0; i < data_count; i++) {
    //if (label_colors[i] != "" && label_icons[i] != "") label[i] = new Label(labels[i+1], label_colors[i+1], label_icons[i+1]);
    //else if (label_colors[i] != "") label[i] = new Label(labels[i+1], label_colors[i+1]);
    //else if (label_icons[i] != "") label[i] = new Label(labels[i+1], "#000000", label_icons[i+1]);
    //else label[i] = new Label(labels[i+1]);
    label[i] = new Label(labels[i+1], label_colors[i+1]);
  }

  float[] list = new float[zoom_amount];
  String listMin = "";
  //println(listMin);
  //exit();
  int listCount = 0;

  for (int d = 0; d < data_length; d++) {
    String[] datas = tsv[d+3].split("\t");
    for (int l = 0; l < data_count; l++) {
      if ((l+1) < datas.length && datas[l+1] != "") {
        float curMax = 0;
        float curMin = 0;
        float[] samplefMins = new float[zoom_amount-1];
        for (int i = 1; i < zoom_amount; i++) {
          int search = zoom_amount-1;
          //println(label[0].ranks[0]);
          if (d-search < 0) search = i;
          if (d-i < 0) continue;
          samplefMins[i-1] = label[l].values[d-i];
          if (label[l].values[d-i] == -2147483648) continue;

          if (label[l].values[d-i] > curMax) curMax = label[l].values[d-i];
          //if (label[l].ranks[d-search] == data_count-1)
        }
        //if (d == 2000) {
        //println(samplefMins);
        //println(min(samplefMins));
        //lolexit();
        //}

        //println(samplefMins);
        //println(min(samplefMins));
        //lolexit();

        //exit();

        float val = Float.parseFloat(datas[l+1]);
        //if (d==1000)  {
        //println(samplefMins);
        //lolexit();
        //}
        curMin = min(samplefMins);
        //println(curMin);
        //println(samplefMins);
        //Arrays.sort(samplefMins);
        //exit();

        if (val == -2147483648) continue;
        //println(curMin);
        //println(samplefMins);
        //exit();
        //println(samplefMins);
        //println("--------------------------------");
        list[listCount] = curMax;
        listMin += "\n"+curMin;

        //listMinCount++;
        listCount++;

        //println(listMinCount, listCount);
        curMax = 0;
        curMin = 0;
        samplefMins = new float[zoom_amount-1];

        label[l].values[d] = val;
        //maxes[d] = 1000;
      }
    }
    //println(list);
    Arrays.sort(list);
    String listMinSFinal = "";
    float[] listMinFinal;
    String[] listMinStr = listMin.split("\n");
    for (int i = 1; i < listMinStr.length; i++) {
      if (Float.parseFloat(listMinStr[i]) == -2147483648) continue;
      listMinSFinal += "\n"+Float.parseFloat(listMinStr[i]);
    }
    String[] listMinAFinal = listMinSFinal.split("\n");
    int isYDynamic = 0;
    if (dynamicY) isYDynamic = 1;
    listMinFinal = new float[listMinAFinal.length-isYDynamic];
    for (int i = 1; i < listMinAFinal.length; i++) {
      listMinFinal[i-1] = Float.parseFloat(listMinAFinal[i]);
    }
    float minimum = min(listMinFinal);

    //println(listMin[0]);

    maxes[d] = list[list.length-1]-minimum;
    mins[d] = minimum;
    list = new float[zoom_amount];
    listMin = "";
    listCount = 0;
    //listMinCount = 0;
  }

  //println(mins);
  //exit();

  //println(label[0].values[3]);

  for (int i = 0; i < maxes.length; i++) {
    maxnmins[i] = maxes[i]+mins[i];
  }
  //for(int day = 0; day < data_count; day++){
  //  unitChoices[day] = 0;
  //  while(units[unitChoices[day]] < maxes[day]*0.17){
  //    unitChoices[day]++;
  //  }
  //  //horizUnitChoice[day] = 0;
  //  //while(units[horizUnitChoice[day]] < day*0.2){
  //  //  horizUnitChoice[day]++;
  //  //}
  //  //if(day >= LAST_DAY+DELAY_BEFORE_ZOOM){
  //  //  textUnitChoice[day] = 50;
  //  //}else{
  //  //  textUnitChoice[day] = 1;
  //  //  while(textUnitChoice[day] < day*0.106){
  //  //    textUnitChoice[day]++;
  //  //  }
  //  //}
  //}
  getUnits();
  size(1920, 1080);
  surface.setLocation(-10, 20);
  pg = createGraphics(width, height);
  pg.smooth(8);
  println("Done.");

  if (record) {
    videoExport = new VideoExport(this, "chart.mp4");
    videoExport.setFrameRate(60);
    videoExport.startMovie();
  }
}

void drawVertTickmarks(float cday) {
  int c1 = unitChoices[(int)cday];
  int c2 = unitChoices[(int)cday+1];

  if (c1 != c2) {
    drawGridVertHelper(c1, cday, lerp(1, 0, cday%1.0));
    drawGridVertHelper(c2, cday, lerp(0, 1, cday%1.0));
  } else {
    drawGridVertHelper(c1, cday, 1.0);
  }
}

void drawGridVertHelper(int u, float cday, float alpha) {
  if (u < 0) u = 0;
  long unit = units[u];
  float offset = 80;
  pg.strokeWeight(4);
  pg.stroke(220, 220, 220, 70*alpha);
  pg.fill(220, 220, 220, 110*alpha);
  if (expo) {
    for (int ux = 0; ux < unitChoices[(int)cday+min(500, data_length-(int)cday)]; ux++) {
      long v = units[ux];
      //if (v != 1000000L) continue;
      //if (v == 1000000L || v == 2000000L) {
      float lineY = valueToY(v);
      pg.line(X_MIN+offset, lineY, X_MAX+offset, lineY);
      pg.textFont(font, 20);
      pg.textAlign(RIGHT);
      pg.text(keyify((int)v), X_MIN-17+offset, lineY+16);
      //}
    }
  } else if (!expo) {
    //for (long v = 0; v < maxes[(int)cday+1]*1.5; v += unit) {
    //  float lineY = (v);
    //  pg.line(X_MIN, lineY, X_MAX, lineY);
    //  pg.textFont(font, 48);
    //  pg.textAlign(RIGHT);
    //  pg.text(keyify((int)v), X_MIN-17, lineY+16);
    //}
    for (long v = 0; v < maxes[(int)cday+1]*1.5; v += unit) {
      float lineY = (v);
      println(lineY);
      pg.line(X_MIN+offset, lineY, X_MAX+offset, lineY);
      pg.textFont(font, 20);
      pg.textAlign(RIGHT);
      pg.text(keyify((int)v), X_MIN-17+offset, lineY+16);
    }

    //println("Hello");
  }
}

//void drawTickMarksOfUnit(int u, float alpha) {
//  for (int v = 0; v < currentScale; v+=u) {
//    float x = valueToX(v);
//    pg.fill(100, 100, 100, alpha);
//    float w = 2;
//    pg.rect(x-w/2+18, Y_MIN-7, w, Y_H+5);
//    pg.textAlign(CENTER);
//    pg.textFont(font, 20);
//    pg.text(keyify(v), x+18, Y_MIN-10);
//  }
//}

void saveVideoFrameHamoid() {
  videoExport.saveFrame();
  if (getDayFromFrameCount(frames+1) >= data_length) {
    //videoExport.endMovie();
    exit();
  }
}

void draw() {
  pg.beginDraw();
  if (small_scale) scale(2.0/3.0);
  currentDay = getDayFromFrameCount(frames);
  if (currentDay > data_length-3) {
    //try {
    //  Thread.sleep(60000);
    //} catch (Exception e) {
    //  println(e);
    //}
    exit();
  }
  currentScale = getYScale(currentDay);
  //println(maxes[round(currentDay)]);
  drawBackground();
  //drawAxis();
  drawLines();
  //drawVertTickmarks(currentDay);

  pg.endDraw();

  image(pg, 0, 0);

  if (record) saveVideoFrameHamoid();

  frames++;
}

void drawAxis() {
  float offset = 15;
  fill(100, 100, 100);
  pg.rect(X_MIN+80, 227, 5, 777);
  pg.rect(X_MIN+80, 1003, X_MAX-82-offset, 5);
  pg.rect(X_MIN+80, 227, X_MAX-82-offset, 5);

  //Y
}

void drawBackground() {
  pg.background(43, 41, 44);
  pg.fill(255);
  pg.textFont(font, 30);
  pg.textAlign(LEFT);
  pg.text(dateLabels[floor(currentDay)], 5, 40);
}

void drawLines() {
  for (int l = 0; l < data_count; l++) {
    //if (currentDay % 1 != 0) continue;
    Label ll = label[l];
    float val = linIndex(ll.values, currentDay);
    if (val == -2147483648/* || ll.ranks[(int)currentDay] > 30*/) continue;
    pg.fill(43, 41, 44);
    //beginShape();

    for (int i = 1; i < zoom_amount; i++) {
      if ((currentDay-i) < 0) continue;
      if (linIndex(ll.values, (int)currentDay-(i-1)) == -2147483648 || linIndex(ll.values, (int)currentDay-i) == -2147483648) continue;
      pg.stroke(ll.c);
      pg.strokeWeight(10);

      float offset = currentDay-((int)currentDay);


      //if (i == 1) pg.line(
      //  valueToX(i-2),
      //  valueToY(linIndex(ll.values, currentDay-(i-1))),
      //  valueToX(i-1 + offset),
      //  valueToY(linIndex(ll.values, (int)currentDay-i))
      //  );
      /*else*/
      if (i == 1) {
        //pg.stroke(255);
        pg.line(
          valueToX(i-2),
          valueToY(linIndex(ll.values, currentDay-(i-1))),
          valueToX(i-1 + offset),
          valueToY(linIndex(ll.values, (int)currentDay-i))
          );
      } else if (i == zoom_amount-1) {
        //pg.stroke(255);
        pg.line(
          valueToX(i-2),
          valueToY(linIndex(ll.values, currentDay-(i-1))),
          valueToX(i-1),
          valueToY(linIndex(ll.values, currentDay-i))
          );
      } else pg.line(
        valueToX(i-2 + offset),
        valueToY(linIndex(ll.values, (int)currentDay-(i-1))),
        valueToX(i-1 + offset),
        valueToY(linIndex(ll.values, (int)currentDay-i))
        );
    }
    pg.noStroke();

    
    pg.fill(ll.c);
     pg.ellipseMode(CENTER);
     //float realR = lerp(point_r, 0, 0);
     //ellipse(X_MAX,valueToY(linIndex(ll.values, currentDay)),realR,realR);
     pg.circle(X_MAX+42-X_MIN, valueToY(linIndex(ll.values, currentDay)), point_r);
     pg.fill(ll.c);
     pg.textFont(font, 35);
     pg.textAlign(LEFT);
     pg.text(ll.name, X_MAX+60-X_MIN, valueToY(val)+5+5);
     pg.fill(255);
     if ((int)currentDay-1 >= 0 && (int)currentDay-1 <= ll.values.length && val < ll.values[(int)currentDay-1]) pg.fill(247, 101, 101);
     //text(decimalFormat.format(val), X_MAX+textWidth(ll.name)+15, valueToY(val)+5);
     
     
  }
  //noFill();
  //stroke(255, 102, 0);
  //curve(20, 0, 20, 104, 292, 96, 292, 244);
  //curve(20, 104, 292, 96, 292, 244, 60, 260);
  //stroke(255, 102, 0);
  //curve(292, 96, 292, 244, 60, 260, 60, 260);
}

float getDayFromFrameCount(int fc) {
  return fc/fpd + start_day;
}


float linIndex(float[] a, float index) {
  int indexInt = (int)index;
  float indexRem = index%1.0;
  float beforeVal = a[indexInt];
  float afterVal = a[min(data_length-1, indexInt+1)];
  return lerp(beforeVal, afterVal, indexRem);
}

Float waIndex(float[] a, float index, float window_w) {
  int startI = max(0, ceil(index-window_w));
  int endI = min(data_length-1, floor(index+window_w));
  float counter = 0;
  float summer = 0;

  for (int d = startI; d <= endI; d++) {
    float val = a[d];
    float weight = 0.5+0.5*cos((d-index)/window_w*PI);
    counter +=weight;
    summer += val*weight;
  }

  return summer/counter;
}

Float waIndex(int[] a, float index, float window_w) {
  float[] aFloat = new float[a.length];
  for (int i = 0; i < a.length; i++) {
    aFloat[i] = (float)a [i];
  }

  return waIndex(aFloat, index, window_w);
}

float valueToY(float val) {
  //println(Y_H-Y_MIN);
  //println(val);
  val-=linIndex(mins, currentDay);
  //println(val);
  //println("----------");
  return (Y_MIN-Y_H*val/currentScale)+650;
}

float valueToX(float val) {
  return X_MIN+(X_MAX-30+7)-X_W*val/(zoom_amount);
}

float getYScale(float d) {
  return linIndex(maxes, d+1)*1.3;
}

void getRankings() {
  int daysHeld = 0;
  for (int d = 0; d < data_length; d++) {
    boolean[] taken = new boolean[data_count];
    for (int l = 0; l < data_count; l++) {
      taken[l] = false;
    }

    for (int spot = 0; spot < data_count; spot++) {
      float record = -1;
      int holder = -1;

      for (int l = 0; l < data_count; l++) {
        if (!taken[l]) {
          float val = label[l].values[d];

          //if (val == -2147483648) continue;

          if (val > record) {
            record = val;
            //daysHeld = 0;
            holder = l;
          }
        }
      }

      if (holder < 0) continue;

      if (spot == 0) {
        top1[d][0] = holder;
        top1[d][1] = daysHeld;
        if (d-1 > -1&&top1[d-1][0] != top1[d][0]) daysHeld = 0;
      }
      label[holder].ranks[d] = spot;
      taken[holder] = true;
    }
    daysHeld++;
  }
}

void getUnits() {
  //for (int d = 0; d < data_length-4; d++) {
  //  float Yscale = getYScale(d);
  //  for (int u = 0; u < units.length; u++) {
  //    if (convert(String.valueOf(units[u])) >= Yscale/4.0) {
  //      unitChoices[d+3] = u-1;
  //      break;
  //    }
  //  }
  //}

  for (int d = 0; d < data_length-4; d++) {
    float Yscale = getYScale(d);
    for (int u = 0; u < units.length; u++) {
      if (convert(String.valueOf(units[u])) >= maxes[d]) {
        unitChoices[d+3] = u-1;
        break;
      }
    }
  }
}

int convert(String n) {
  return Integer.parseInt(n.replaceAll("K", "000").replaceAll("M", "000000").replaceAll("B", "000000000").replaceAll("T", "000000000000"));
}

String keyify(int n) {
  if (n < 1000) {
    return n+"";
  } else if (n < 1000000) {
    if (n%1000 == 0) {
      return (n/1000)+"K";
    } else {
      return nf(n/1000f, 0, 1)+"K";
    }
  }
  if (n%1000000 == 0) {
    return (n/1000000)+"M";
  } else {
    return nf(n/1000000f, 0, 1)+"M";
  }
}
