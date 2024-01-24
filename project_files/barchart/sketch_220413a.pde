import videoExport.*;
import org.intellij.lang.annotations.*;
import org.jetbrains.annotations.*;

//import com.hamoid.*;

import java.text.DecimalFormat;

DecimalFormat decimalFormat = new DecimalFormat("###,###");

int data_count;
int data_length;
String[] tsv;
int[][] top1;
Label[] label;
int topVis = 19; // Amount of bars to show (Top #)
float[] maxes;
PFont font;
PFont customNameFont;

boolean small_scale = false;
boolean record = true;
boolean showSpeed = false;
boolean showYTMilestones = true;
boolean showFirstSince = true;
boolean showIndicator = false;
boolean playButtonCount = false;

float X_MIN = 30; //Bars Margin from left
float X_MAX = 1900; //Bars Margin from right
float Y_MIN = 120; //Bars Margin from the top
float Y_MAX = 1000; //Bars Margin from the bottom
float X_W = X_MAX-X_MIN;
float Y_H = Y_MAX-Y_MIN;
float currentScale = -1;
float BAR_PROPORTION = 0.9; // 1 - BAR_PROPORTION = space between bars
float min_scale = 100;

int frames = 0;
float currentDay = 0;
float fpd = 5;
float BAR_HEIGHT;
VideoExport videoExport;

String[] dateLabels;

int start_day = 0;
//int start_day = 3700;
int milestone_hold = 400;
int indicator_hold = 200;
int dataOffset = 4;
int pfpToBarOff = 37; // higher = shift of bars to the right
int barNameOffset = 20;
int pfpOffsetToBars = 30;
int playbuttonsOffsetX = 40; //X | higher = shift to right
int soy = 7; // Y | higher = shift downward
float sox_indf = -5;

int barNameFontSize = 34;
float barTextYOff = 3; // higher = shift text down
float barOutOfBarTextYOff = 2; // barTextYOff + this
float barTextXOff = 12;

float barValYOff = 3; // higher = shift text down
float barValXOff = 15;
float barValXOff2 = 50;

int barSmallNameFontSize = 30;
int barSmallNameRectHeight = 36;

int barValueFontSize = 34;
int barCustomDailySubsFontSize = 25;

PImage playbutton_silver;
PImage playbutton_gold;
PImage playbutton_diamond;
PImage playbutton_ruby;

PImage playbutton_silver_high;
PImage playbutton_gold_high;
PImage playbutton_diamond_high;
PImage playbutton_ruby_high;

int playbutton_silver_count = 0;
int playbutton_gold_count = 0;
int playbutton_diamond_count = 0;
int playbutton_ruby_count = 0;

String[] units = {"1", "2", "5", "10", "20", "50", "100", "200", "500", "1000", "2000", "5000", "10000", "20000", "50000", "100000", "200000", "500000", "1000000", "2000000", "5000000", "20000000", "50000000", "100000000", "200000000", "500000000", "1000000000", "2000000000", "5000000000", "10000000000"};

int[] unitChoices;

boolean isValidIndex(String[] arr, int index) {
  return index >= 0 && index < arr.length;
}

void setup() {
  //font = loadFont("ConcertOne-Symbol-48.vlw");
  font = loadFont("Mojangles-48.vlw");
  customNameFont = loadFont("MinercraftoryRegular-48.vlw");
  //font = loadFont("ObelixPro-Fixed-48.vlw");
  randomSeed(2735929);
  tsv = loadStrings("data/newLife.tsv");
  //tsv = loadStrings("C:/Users/User/Downloads/Abacaba Tutorial's Example Data - Sheet1.tsv");

  playbutton_silver = loadImage("utils/silver.png");
  playbutton_gold = loadImage("utils/gold.png");
  playbutton_diamond = loadImage("utils/diamond.png");
  playbutton_ruby = loadImage("utils/ruby.png");

  playbutton_silver_high = loadImage("utils/silver.png");
  playbutton_gold_high = loadImage("utils/gold.png");
  playbutton_diamond_high = loadImage("utils/diamond.png");
  playbutton_ruby_high = loadImage("utils/ruby.png");

  String[] labels = tsv[0].split("\t");
  String[] label_colors = tsv[1].split("\t");
  String[] label_icons = tsv[2].split("\t");
  String[] label_inds = tsv[3].split("\t");

  data_count = labels.length -1;
  data_length = tsv.length -dataOffset;
  dateLabels = new String[data_length];
  unitChoices = new int[data_length];
  top1 = new int[data_length][2];
  BAR_HEIGHT = (rankToY(1)-rankToY(0))*BAR_PROPORTION;
  for (int i = 0; i < tsv.length-(dataOffset+1); i++) dateLabels[i] = tsv[i+dataOffset].split("\t")[0].replaceAll("\"", "");

  playbutton_silver.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT*0.7034146));
  playbutton_gold.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT*0.7034146));
  playbutton_diamond.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT*0.7034146));
  playbutton_ruby.resize(floor(BAR_HEIGHT), floor(BAR_HEIGHT*0.7034146));

  playbutton_silver_high.resize(floor(BAR_HEIGHT*1.8), floor(BAR_HEIGHT*0.7034146*1.8));
  playbutton_gold_high.resize(floor(BAR_HEIGHT*1.8), floor(BAR_HEIGHT*0.7034146*1.8));
  playbutton_diamond_high.resize(floor(BAR_HEIGHT*1.8), floor(BAR_HEIGHT*0.7034146*1.8));
  playbutton_ruby_high.resize(floor(BAR_HEIGHT*1.8), floor(BAR_HEIGHT*0.7034146*1.8));

  maxes = new float[data_length];
  for (int d = 0; d < data_length; d++) maxes[d]=0;

  label = new Label[data_count];
  for (int i = 0; i < data_count; i++) {
    //println(labels[i+1]);
    //println(label_colors[i+1]);
    //println(label_icons[i+1]);
    //println(label_inds[i+1]);
    label[i] = new Label(labels[i+1], label_colors[i+1], label_icons[i+1], label_inds[i+1]);
  }

  for (int d = 0; d < data_length; d++) {
    String[] datas = tsv[d+dataOffset].split("\t");
    for (int l = 0; l < data_count; l++) {
      if ((l+1) < datas.length && datas[l+1] != "") {
        float val = Float.parseFloat(datas[l+1]);

        if (val < 0) continue;

        label[l].values[d] = val;
        if (val>maxes[d]) maxes[d] = val;
      }
    }
  }

  getRankings();
  getUnits();
  size (1920, 1080, P2D);
  println("Done.");

  if (record) {
    videoExport = new VideoExport(this, "chart.mp4");
    videoExport.setFrameRate(60);
    videoExport.startMovie();
  }
}

void saveVideoFrameHamoid() {
  videoExport.saveFrame();
  if (getDayFromFrameCount(frames+1) >= data_length) {
    //videoExport.endMovie();
    exit();
  }
}

void draw() {
  if (small_scale) scale(2.0/3.0);
  currentDay = getDayFromFrameCount(frames);
  if (currentDay > data_length-2) exit();
  currentScale = getXScale(currentDay);
  
  drawBackground();
  drawHorizTickmarks();
  drawBars();
  
  //thread("drawBackground");
  //thread("drawHorizTickmarks");
  //thread("drawBars");

  //try {
  //  Thread.sleep(10);
  //} catch (Exception e) {
  //  println(e);
  //}
  //videoExport.startMovie();
  if (record) saveVideoFrameHamoid();

  frames++;
}

float getDayFromFrameCount(int fc) {
  return fc/fpd + start_day;
}

void drawBackground() {
  noTint();
  background(43, 41, 44);
  fill(255);
  textFont(font, 65);
  textAlign(RIGHT);
  text(dateLabels[floor(currentDay)], width-20, 60);
  textFont(customNameFont, 60);
  textAlign(LEFT);
  text("NewLife SMP", 15, 75);
  fill(209, 209, 209);
  text("2007-2023", textWidth("NewLife SMP  "), 75);
}

void drawHorizTickmarks() {
  float preferredUnit = waIndex(unitChoices, currentDay, 4);
  if (preferredUnit < 0) preferredUnit = 0;
  float unitRem = preferredUnit%1.0;
  if (unitRem < 0.001) {
    unitRem = 0;
  } else if (unitRem >= 0.999) {
    unitRem = 0;
    preferredUnit = ceil(preferredUnit);
  }

  int thisUnit = convert(units[(int)preferredUnit]);
  int nextUnit = convert(units[(int)preferredUnit+1]);

  drawTickMarksOfUnit(thisUnit, 255-unitRem*255);
  if (unitRem >= 0.001) {
    drawTickMarksOfUnit(nextUnit, unitRem*255);
  }
}

void drawTickMarksOfUnit(int u, float alpha) {
  for (int v = 0; v < currentScale; v+=u) {
    float x = valueToX(v);
    float estAlpha = (((1920-(x+pfpToBarOff))/220)*100)*2.5;
    if (x+pfpToBarOff > 1700 && alpha > estAlpha) {
      alpha = estAlpha;
    }
    fill(100, 100, 100, alpha);
    float w = 2;
    rect(x-w/2+pfpToBarOff, Y_MIN-7, w, Y_H+5);
    textAlign(CENTER);
    textFont(font, 30);
    text(keyify(v), x+pfpToBarOff, Y_MIN-10);
  }
}

int leadingWho = 0;

void drawBars() {
  noStroke();
  for (int l = 0; l < data_count; l++) {
    //noTint();
    
    Label ll = label[l];
    if (ll.values[round(currentDay)] < 0 || ll.ranks[round(currentDay)] > topVis+1) continue;
    if (ll.ranks[round(currentDay)] == 1) {
      leadingWho = l;
      //println(ll.name);
    }
    tint(255, ll.showUp);
    if (ll.showUp < 260) ll.showUp+=10;
    float val = linIndex(ll.values, currentDay);
    float x = valueToX(val);
    float rank = waIndex(ll.ranks, currentDay, 5);
    float y = rankToY(rank);
    y = Float.valueOf(String.format("%.1f", y)); // corrected floating point inaccuracies
    //interpolated[0] = ll.values[floor(currentDay)];
    //interpolated[interpolated.length-1] = ll.values[ceil(currentDay)];

    //interpolated = interpolate(ll.values[floor(currentDay)], round(fpd), ll.values[ceil(currentDay)]);

    String currentValue = decimalFormat.format(lerp(ll.values[floor(currentDay)], ll.values[floor(currentDay)+1], currentDay%1.0));
    float floatValue = lerp(ll.values[floor(currentDay)], ll.values[floor(currentDay)+1], currentDay%1.0);
    float subsPDate;
    float subsRes = 0;
    float subsResStable = 0;
    if (currentDay-1 >= 0) {
      subsPDate = lerp(ll.values[floor(currentDay-1)], ll.values[floor(currentDay)], currentDay%1.0);
      subsRes = floatValue - subsPDate;
      
      subsPDate = ll.values[floor(currentDay-1)];
      subsResStable = ll.values[floor(currentDay)] - subsPDate;
    };

    //int parsedIndex = round(Integer.parseInt(String.valueOf(currentDay).split("\\.")[1])/(10/fpd));

    //if (interpolated.length > 2) currentValue = decimalFormat.format(interpolated[parsedIndex]);

    if (showIndicator) {
      if (dateLabels[floor(currentDay)].equals(ll.ind) && ll.indd == 0) {
        highlight(ll, y, x);
      } else if (ll.indd != 0 && ll.indd < indicator_hold) {
        highlight(ll, y, x);
      }
    }

    fill(ll.c, ll.showUp);
    
    //if (ll.ranks[round(currentDay)] == 7) println(y, Float.valueOf(String.format("%.1f", y)));
    
    rect(X_MIN+pfpToBarOff, y, x-X_MIN, BAR_HEIGHT, 0, 0, 0, 0);
    textFont(font, barNameFontSize);

    float nameWidth = textWidth(ll.name);
    textSize(barValueFontSize);
    float curValWidth = textWidth(currentValue);
    textSize(barNameFontSize);

    //println(textWidth(ll.name), x-X_MIN);
    boolean nameOutBar = nameWidth > x-X_MIN-barNameOffset;
    if (nameOutBar) {
      textAlign(LEFT);
      textSize(barSmallNameFontSize);
      float is_label_width = textWidth(ll.name);
      nameWidth = is_label_width + 15;
      //text(ll.name, x+6+18, y+BAR_HEIGHT-6);
      //println(ll.showUp/260.0);
      fill(153, 153, 153, ll.showUp/260.0*100);
      rect(x-6+curValWidth+pfpToBarOff+barTextXOff+30-10, round(y+BAR_HEIGHT-13+barTextYOff)+4+barOutOfBarTextYOff, is_label_width+20, -barSmallNameRectHeight, 0, 0, 0, 0); //def = 10
      fill(255, ll.showUp);
      text(ll.name, x-6+curValWidth+pfpToBarOff+barTextXOff+30, round(y+BAR_HEIGHT-13+barTextYOff)-3+barOutOfBarTextYOff);
    } else {
      textAlign(RIGHT);
      fill(255, ll.showUp);
      text(ll.name, x-6+pfpToBarOff+barTextXOff-15, round(y+BAR_HEIGHT-13+barTextYOff));
    }
    //float appx = max(x-6,X_MIN+textWidth(ll.name)+6);

    image(ll.icon, round(X_MIN-40)+pfpOffsetToBars, y);
    //image(ll.associated_ico, round(X_MIN-40+22), y);
    
    if (ll.indd != 0) {
      fill(95, 172, 113, ll.showUp);
      rect(round(X_MIN-pfpToBarOff), y, 5, BAR_HEIGHT, 5, 5, 5, 5); // Indicator bar
    }

    //fill(255, 255, 85);
    fill(255, ll.showUp);
    if ((int)currentDay-1 >= 0 && (int)currentDay-1 <= ll.values.length && val < ll.values[(int)currentDay-1]) fill(247, 101, 101);
    //textFont(font, 40);
    textAlign(LEFT);

    String textValue = currentValue;
    if (showSpeed) textValue+=" (" + decimalFormat.format(ceil(subsRes)) + ")";

    float textValCoordsX;
    float textValCoordsY;
    float valWidth;

    textSize(barValueFontSize);
    textValCoordsX = x-6+barValXOff2+nameWidth;
    textValCoordsY = y+BAR_HEIGHT-13+barTextYOff;
    //text(textValue + " - ", textValCoordsX+9, textValCoordsY+2);
    text(textValue, x-6+pfpToBarOff+barValXOff, round(y+BAR_HEIGHT-13+barValYOff));
    if (nameOutBar) valWidth = textWidth(textValue)-40;
    else {
      textValCoordsX = x-6+curValWidth+pfpToBarOff+sox_indf;
      valWidth = -55;
    }
    //textSize(barCustomDailySubsFontSize);
    //fill(209, 209, 209, ll.showUp);
    //text(keyify(ceil(subsResStable), false) + " /day", x-6+pfpToBarOff+barValXOff+2, round(y+BAR_HEIGHT-13+barValYOff+28));
    

    fill(255, ll.showUp);

    float sox = pfpToBarOff+playbuttonsOffsetX;

    if (showYTMilestones) {
      if (floatValue > 99999 && floatValue < 1000000 && ll.m100kd < milestone_hold) {
        if (ll.m100kd == 0) playbutton_silver_count++;
        showSilver(ll, textValCoordsX+valWidth+10+sox, textValCoordsY-20-13+soy);
      } else if (floatValue > 999999 && floatValue < 9999999 && ll.m1md < milestone_hold) {
        if (ll.m1md == 0) playbutton_gold_count++;
        showGold(ll, textValCoordsX+valWidth+10+sox, textValCoordsY-20-13+soy);
      } else if (floatValue > 9999999 && floatValue < 99999999 && ll.m10md < milestone_hold) {
        if (ll.m10md == 0) playbutton_diamond_count++;
        showDiamond(ll, textValCoordsX+valWidth+10+sox, textValCoordsY-20-13+soy);
      } else if (floatValue > 99999999 && ll.m100md < milestone_hold) {
        if (ll.m100md == 0) playbutton_ruby_count++;
        showRuby(ll, textValCoordsX+valWidth+10+sox, textValCoordsY-20-13+soy);
      }
    }

    if (playButtonCount) {
      fill(255, ll.showUp);
      textSize(30);
      textAlign(LEFT);

      //Silver
      image(playbutton_silver_high, 1000, 970);
      text(playbutton_silver_count, 1070, 1007);

      //Gold
      image(playbutton_gold_high, 1000, 1020);
      text(playbutton_gold_count, 1070, 1057);

      //Diamond
      image(playbutton_diamond_high, 1200, 970);
      text(playbutton_diamond_count, 1270, 1007);

      //Red Diamond
      image(playbutton_ruby_high, 1200, 1020);
      text(playbutton_ruby_count, 1270, 1057);
    }

    if (showFirstSince) {
      Label currentTop1 = label[top1[(int)currentDay][0]];
      Label currentTop2 = label[leadingWho];
      float floatValue2 = lerp(currentTop1.values[floor(currentDay)], currentTop1.values[floor(currentDay)+1], currentDay%1.0);
      float prevFloatValue2 = floatValue2;
      if ((int)currentDay-1 > 0) prevFloatValue2 = lerp(currentTop1.values[floor(currentDay-1)], currentTop1.values[floor(currentDay)], currentDay%1.0);
      float subsPDate2;
      float subsRes2 = 0;
      float leadingSubs = floatValue2 - lerp(currentTop2.values[floor(currentDay)], currentTop2.values[floor(currentDay)+1], currentDay%1.0);
      float prevLeadingSubs = leadingSubs;
      if ((int)currentDay-1 > 0) prevLeadingSubs = prevFloatValue2 - lerp(currentTop2.values[floor(currentDay-1)], currentTop2.values[floor(currentDay)], currentDay%1.0);
      //println(leadingSubs, prevLeadingSubs);
      if (currentDay-1 >= 0) {
        subsPDate2 = lerp(currentTop1.values[floor(currentDay-1)], currentTop1.values[floor(currentDay)], currentDay%1.0);
        subsRes2 = floatValue2 - subsPDate2;
      };
      currentTop1.image.resize(130, 130);
      image(currentTop1.image, width-150, height-220);

      textAlign(RIGHT);
      textSize(37);
      fill(255, ll.showUp);
      text("#1 for " + decimalFormat.format(top1[(int)currentDay][1]) + " Days", width-165, height-100);
      if (leadingSubs < prevLeadingSubs) fill(247, 101, 101);
      else fill(101, 247, 101, ll.showUp);
      text(decimalFormat.format(leadingSubs) + " Subs Lead", width-165, height-180);
      if (subsRes2 < 0) fill(247, 101, 101);
      else fill(101, 247, 101, ll.showUp);

      text(decimalFormat.format(subsRes2) + " Subs per Day", width-165, height-140);
      textFont(customNameFont, 60);
      fill(currentTop1.c, ll.showUp);
      text(currentTop1.name, width-17, height-22);
    }

    //fill(20);
    //rect(0, Y_MIN, X_MIN-3, Y_MAX);
  }
}

void highlight(Label ll, float y, float x) {
  ll.indd++;
  fill(95, 172, 113, (float)(indicator_hold-ll.indd)/100*indicator_hold);
  rect(X_MIN+18, y, ll.indd*200, BAR_HEIGHT, 0, 10, 10, 0);
  fill(43, 41, 44);
  textSize(40);
  text(ll.name, x-X_MIN+500+textWidth(ll.name)+textWidth(String.valueOf(decimalFormat.format(ll.values[(int)currentDay]))), round(y+32));
}

void showSilver(Label ll, float x, float y) {
  ll.m100kd++;
  if (ll.m100kd > milestone_hold) return;

  if (ll.m100kd > ((float)70/100)*milestone_hold) tint(255, (float)(milestone_hold-ll.m100kd)/50*milestone_hold);
  else if (ll.m100kd < ((float)20/100)*milestone_hold) tint(255, (float)ll.m100kd/50*milestone_hold);

  image(playbutton_silver, x, Float.valueOf(String.format("%.1f", y)));
}

void showGold(Label ll, float x, float y) {
  ll.m1md++;
  if (ll.m1md > milestone_hold) return;

  if (ll.m1md > ((float)70/100)*milestone_hold) tint(255, (float)(milestone_hold-ll.m1md)/50*milestone_hold);
  else if (ll.m1md < ((float)20/100)*milestone_hold) tint(255, (float)ll.m1md/50*milestone_hold);

  image(playbutton_gold, x, Float.valueOf(String.format("%.1f", y)));
}

void showDiamond(Label ll, float x, float y) {
  ll.m10md++;
  if (ll.m10md > milestone_hold) return;

  if (ll.m10md > ((float)70/100)*milestone_hold) tint(255, (float)(milestone_hold-ll.m10md)/50*milestone_hold);
  else if (ll.m10md < ((float)20/100)*milestone_hold) tint(255, (float)ll.m10md/50*milestone_hold);

  image(playbutton_diamond, x, Float.valueOf(String.format("%.1f", y)));
}

void showRuby(Label ll, float x, float y) {
  ll.m100md++;
  if (ll.m100md > milestone_hold) return;

  if (ll.m100md > ((float)70/100)*milestone_hold) tint(255, (float)(milestone_hold-ll.m100md)/50*milestone_hold);
  else if (ll.m100md < ((float)20/100)*milestone_hold) tint(255, (float)ll.m100md/50*milestone_hold);

  image(playbutton_ruby, x, Float.valueOf(String.format("%.1f", y)));
}

void getRankings() {
  int daysHeld = 0;
  for (int d = 0; d < data_length; d++) {
    boolean[] taken = new boolean[data_count];
    for (int l = 0; l < data_count; l++) {
      taken[l] = false;
    }

    for (int spot = 0; spot < topVis; spot++) {
      float record = -1;
      int holder = -1;

      for (int l = 0; l < data_count; l++) {
        if (!taken[l]) {
          float val = label[l].values[d];

          if (val < 0) continue;

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
float stepIndex(float[] a, float index) {
  return a[(int)index];
}
float linIndex(float[] a, float index) {
  int indexInt = (int)index;
  float indexRem = index%1.0;
  float beforeVal = a[indexInt];
  float afterVal = a[min(data_length-1, indexInt+1)];
  return lerp(beforeVal, afterVal, indexRem);
}

float waIndex(float[] a, float index, float window_w) {
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

float waIndex(int[] a, float index, float window_w) {
  float[] aFloat = new float[a.length];
  for (int i = 0; i < a.length; i++) {
    aFloat[i] = a [i];
  }

  return waIndex(aFloat, index, window_w);
}

float getXScale(float d) {
  float scale = waIndex(maxes, d, 10)*1.3;
  if (scale < min_scale) return min_scale;
  else return scale;
}

float valueToX(float val) {
  return X_MIN+X_W*val/currentScale;
}

float rankToY(float rank) {
  return Y_MIN+rank*(Y_H/topVis);
}

void getUnits() {
  for (int d = 0; d < data_length; d++) {
    float Xscale = getXScale(d);
    for (int u = 0; u < units.length; u++) {
      if (convert(units[u]) >= Xscale/4.0) {
        unitChoices[d] = u-1;
        break;
      }
    }
  }
}

int convert(String n) {
  return Integer.parseInt(n.replaceAll("K", "000").replaceAll("M", "000000").replaceAll("B", "000000000").replaceAll("T", "000000000000"));
}

float[] interpolate(float x, int y, float z) {
  float space = (z - x) / y;
  float[] arr = new float[y+1];
  for (int i = 1; i <= y; i++) arr[i] = ((x + space * i));
  arr[0] = x;
  arr[arr.length-1] = z;
  //println(arr);
  return arr;
}

String keyify(int n, boolean putn) {
  String negative = "";
  if (n < 0 && putn) negative = "-";
  if (n < 1000) {
    return negative+n+"";
  } else if (n < 1000000) {
    if (n%1000 == 0) {
      return negative+(n/1000)+"K";
    } else {
      return negative+nf(n/1000f, 0, 1)+"K";
    }
  }
  if (n%1000000 == 0) {
    return negative+(n/1000000)+"M";
  } else {
    return negative+nf(n/1000000f, 0, 1)+"M";
  }
}

String keyify(int n) {
  String negative = "";
  if (n < 0) negative = "-";
  if (n < 1000) {
    return negative+n+"";
  } else if (n < 1000000) {
    if (n%1000 == 0) {
      return negative+(n/1000)+"K";
    } else {
      return negative+nf(n/1000f, 0, 1)+"K";
    }
  }
  if (n%1000000 == 0) {
    return negative+(n/1000000)+"M";
  } else {
    return negative+nf(n/1000000f, 0, 1)+"M";
  }
}

void setTimeout(Runnable runnable, int delay) {
  new Thread(() -> {
    try {
      Thread.sleep(delay);
      runnable.run();
    }
    catch (Exception e) {
      System.err.println(e);
    }
  }
  ).start();
}
