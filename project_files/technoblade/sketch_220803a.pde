import videoExport.*;
import java.text.DecimalFormat;
import java.util.*;

Channel[] channels;
Video[] videos;
Video[] videos_otn;

HashMap<String, Video> curLatVid = new HashMap<String, Video>();
PImage[] img_assets = new PImage[4];
PImage[] lastThumbs;
int data_length;
int data_count;
int data_offset;
PFont font;
int frames = 0;
float currentDay = 0;
float fpd = 10;
int pause = 2;
float currentScale = -1;
int start_day = 00;
int zoom_amount = 300;

int uploadCount = 0;
DecimalFormat decimalFormat = new DecimalFormat("###,###");

VideoExport videoExport;

boolean record = true;
boolean dynamicY = false;
boolean expo = false;

float lineChart_corner1_x = 20;
float lineChart_corner1_y = 200;
float lineChart_corner2_x = 1200;
float lineChart_corner2_y = 600;

float lineChart_width = lineChart_corner2_x - lineChart_corner1_x;
float lineChart_height = lineChart_corner2_y - lineChart_corner1_y;

float point_r = 20.0;

String[] tsv;
String[] videoMeta;
String[] dateLabels;


void lolexit() {
  System.exit(0);
}

void setup() {
  //font = loadFont("Mojangles-48.vlw");
  //font = loadFont("MinecraftSevenv2-Regular-48.vlw");
  font = loadFont("Minecraft-Regular-48.vlw");
  tsv = loadStrings("stats.tsv");
  videoMeta = loadStrings("videoMeta.tsv");

  String[] cnames = new String[4];
  String[] ccolors = new String[4];
  String[] cicons = new String[4];
  int[][] cdatas = new int[4][2];

  img_assets[0] = loadImage("assets/comment.png");
  img_assets[1] = loadImage("assets/eyeball.png");
  img_assets[2] = loadImage("assets/like.png");
  img_assets[3] = loadImage("assets/clock.png");

  img_assets[0].resize(31, 31);
  img_assets[1].resize(28, 18);
  img_assets[2].resize(28, 28);
  img_assets[3].resize(28, 28);

  data_count = 4;
  data_offset = 1;
  data_length = tsv.length - data_offset;
  dateLabels = new String[data_length];

  channels = new Channel[data_count];
  videos = new Video[videoMeta.length-1];
  lastThumbs = new PImage[data_length];

  String[] dict_cname = loadStrings("dictionaries/cname.txt");
  String[] dict_ccolor = loadStrings("dictionaries/ccolor.txt");
  String[] dict_cicon = loadStrings("dictionaries/cicon.txt");
  String[] dict_cdatas = loadStrings("dictionaries/cdatas.txt");

  for (int i = 0; i < videoMeta.length-(data_offset); i++) {
    String[] curVideo = videoMeta[i+1].split("\t");
    videos[i] = new Video(parseInt(curVideo[0]), curVideo[1], parseInt(curVideo[2]), parseInt(curVideo[3]), Long.parseLong(curVideo[4]), parseInt(curVideo[5]));
  }

  for (long i = 1104537600000L / 86400000L; i < round(new Date().getTime() / 86400000L) + 1; i++) {
    curLatVid.put(String.format("%s %tb %<td, %<tY", "", new Date(i * 86400000L)).substring(1), null);
  }

  videos_otn = reverse_videos(videos);

  for (Video video : videos_otn) curLatVid.put(video.date_formatted, video);

  Video lastVid = null;

  for (long i = 1104537600000L / 86400000L; i < round(new Date().getTime() / 86400000L) + 1; i++) {
    String cur_form_date = String.format("%s %tb %<td, %<tY", "", new Date(i * 86400000L)).substring(1);
    //println(cur_form_date);
    if (curLatVid.get(cur_form_date) == null && lastVid == null) curLatVid.put(cur_form_date, null);
    if (curLatVid.get(cur_form_date) == null && lastVid != null) curLatVid.put(cur_form_date, lastVid);
    if (curLatVid.get(cur_form_date) != null) {
      curLatVid.put(cur_form_date, curLatVid.get(cur_form_date));
      lastVid = curLatVid.get(cur_form_date);
    }
  }

  //println(videos[0].title);
  //println(videos[0].date_formatted);
  //println(videos[0].views_formatted);
  //println(videos[0].likes_formatted);
  //println(videos[0].comments_formatted);
  //println(videos[0].views);

  for (int i = 0; i < tsv.length-(data_offset); i++) dateLabels[i] = tsv[i+data_offset].split("\t")[0].replaceAll("\"", "");
  for (int i = 0; i < data_count; i++) {
    String[] t_cname = dict_cname[i].split(" = ");
    String[] t_ccolor = dict_ccolor[i].split(" = ");
    String[] t_cicon = dict_cicon[i].split(" = ");
    String[] t_cdatas = dict_cdatas[i].split(" = ")[1].split(",");
    int[] t_cdatas_int = new int[2];

    cnames[Integer.valueOf(t_cname[0])-1] = t_cname[1];
    ccolors[Integer.valueOf(t_ccolor[0])-1] = t_ccolor[1];
    cicons[Integer.valueOf(t_cicon[0])-1] = t_cicon[1];

    for (int j = 0; j < 2; j++) {
      t_cdatas_int[j] = Integer.valueOf(t_cdatas[j]);
    }
    cdatas[i] = t_cdatas_int;
  }

  for (int i = 0; i < data_count; i++) {
    //println(cnames[i]);
    //println(ccolors[i]);
    //println(cicons[i]);
    //println(cdatas[i]);
    channels[i] = new Channel(cnames[i], ccolors[i], cicons[i], cdatas[i]);
  }

  for (int d = 0; d < data_length; d++) {
    String[] datas = tsv[d+data_offset].split("\t");
    for (int c = 0; c < data_count; c++) {
      Channel curc = channels[c];

      if (!datas[curc.columns[0] -1].equals("")) curc.subs[d] = parseFloat(datas[curc.columns[0] -1]);
      if (!datas[curc.columns[1] -1].equals("")) curc.views[d] = parseFloat(datas[curc.columns[1] -1]);
    }
  }

  size(1920, 1080);
  //smooth(3);
  surface.setLocation(-10, 20);
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

float getDayFromFrameCount(int fc) {
  return fc/fpd + start_day;
}

void drawBackground() {
  currentDay = getDayFromFrameCount(frames);
  background(0, 18, 31);

  textAlign(RIGHT);
  textSize(50);
  fill(255);
  text(dateLabels[floor(currentDay)], width-10, 60);
  textAlign(LEFT);
  text("History of Technoblade (2013-2022)", 655, 60);
}

long prev_total_subs = 0;
long prev_total_views = 0;
long total_subs_pd = 0;
long total_views_pd = 0;
long peak_subs_gain = 0;
long peak_views_gain = 0;
String peak_subs_gain_date = null;
String peak_views_gain_date = null;

float subspd = 0;
float viewspd = 0;

void drawChannels() {
  long total_subs = 0;
  long total_views = 0;
  for (int i = 0; i < data_count; i++) {
    textFont(font, 55);
    Channel curChannel = channels[i];

    image(curChannel.icon_rounded, 40, 40 + 230*i);
    fill(curChannel.c);
    text(curChannel.name, 215, 100 + 230*i);

    String curSubs = decimalFormat.format(lerp(curChannel.subs[floor(currentDay)], curChannel.subs[floor(currentDay)+1], currentDay%1.0));
    String curViews = decimalFormat.format(lerp(curChannel.views[floor(currentDay)], curChannel.views[floor(currentDay)+1], currentDay%1.0));

    float floatValue_s = lerp(curChannel.subs[floor(currentDay)], curChannel.subs[floor(currentDay)+1], currentDay%1.0);
    float subsPDate;


    float floatValue_v = lerp(curChannel.views[floor(currentDay)], curChannel.views[floor(currentDay)+1], currentDay%1.0);
    float viewsPDate;

    total_subs += round(floatValue_s);
    total_views += round(floatValue_v);

    if (currentDay - 1 >= 0) {
      subsPDate = curChannel.subs[floor(currentDay-1)];
      subspd = curChannel.subs[floor(currentDay)] - subsPDate;

      viewsPDate = curChannel.views[floor(currentDay-1)];
      viewspd = curChannel.views[floor(currentDay)] - viewsPDate;

      //if (currentDay % 1 == 0) {
      //  subsPDate = lerp(curChannel.subs[floor(currentDay-1)], curChannel.subs[floor(currentDay)], currentDay%1.0);
      //  viewsPDate = lerp(curChannel.views[floor(currentDay-1)], curChannel.views[floor(currentDay)], currentDay%1.0);
      //  subspd = floatValue_s - subsPDate;
      //  viewspd = floatValue_v - viewsPDate;
      //}
    }

    textSize(30);
    fill(255);
    if (curSubs.equals("-1")) {
      fill(69);
      text("0", 220, 140 + 230*i);
      curSubs = "0";
    } else text(curSubs, 220, 140 + 230*i);
    float sub_w = textWidth(curSubs);
    fill(255, 74, 74);
    text(" subs", 220+sub_w, 140 + 230*i);
    float txt_sub_w = textWidth(" subs");
    fill(150);
    textSize(22);
    text("  (" + keyify((int) subspd) + " /d)", 220+sub_w + txt_sub_w, 140 + 230*i);

    fill(255);
    textSize(30);
    if (curViews.equals("-1")) {
      fill(69);
      text("0", 220, 170 + 230*i);
      curViews = "0";
    } else text(curViews, 220, 170 + 230*i);
    float view_w = textWidth(curViews);
    fill(74, 183, 255);
    text(" views", 220+view_w, 170 + 230*i);
    float txt_view_w = textWidth(" views");
    fill(150);
    textSize(22);
    text("  (" + keyify((int) viewspd) + " /d)", 220+view_w + txt_view_w, 170 + 230*i);
  }

  // total subs
  textSize(35);
  fill(255);
  text("Total ", 20, 960);
  float total_w = textWidth("Total ");
  fill(255, 74, 74);
  text("Subs", 20 + total_w, 960);
  float subs_w = textWidth("Subs");
  fill(255);
  fill(150);
  text(": ", 20 + total_w + subs_w, 960);
  float colon_w = textWidth(": ");
  fill(255);
  text(decimalFormat.format(total_subs), 20 + total_w + subs_w + colon_w, 960);
  float subs_s_w = textWidth(decimalFormat.format(total_subs));
  text("Peak ", 20, 1030);
  float peak_s_w = textWidth("Peak ");
  fill(255, 74, 74);
  text("Subs/d", 20 + peak_s_w, 1030);
  float peak_s_s_w = textWidth("Subs/d");
  fill(150);
  text(": ", 20 + peak_s_w + peak_s_s_w, 1030);

  fill(255);
  text(decimalFormat.format(peak_subs_gain), 20 + peak_s_w + peak_s_s_w + colon_w, 1030);
  float peak_subs_w = textWidth(decimalFormat.format(peak_subs_gain));

  fill(150);
  textSize(22);
  text("  (" + keyifyL(total_subs_pd) + " /d)", 20 + total_w + subs_w + colon_w + subs_s_w, 960);
  text("  (" + peak_subs_gain_date + ")", 20 + peak_s_w + peak_s_s_w + colon_w + peak_subs_w, 1030);


  // total views
  textSize(35);
  fill(255);
  text("Total ", 20, 995);
  fill(74, 183, 255);
  text("Views", 20 + total_w, 995);
  float views_w = textWidth("Views");
  fill(255);
  fill(150);
  text(": ", 20 + total_w + views_w, 995);
  fill(255);
  text(decimalFormat.format(total_views), 20 + total_w + views_w + colon_w, 995);
  float views_v_w = textWidth(decimalFormat.format(total_views));
  text("Peak ", 20, 1065);
  float peak_v_w = textWidth("Peak ");
  fill(74, 183, 255);
  text("Views/d", 20 + peak_s_w, 1065);
  float peak_v_v_w = textWidth("Views/d");
  fill(150);
  text(": ", 20 + peak_v_w + peak_v_v_w, 1065);

  fill(255);
  text(decimalFormat.format(peak_views_gain), 20 + peak_v_w + peak_v_v_w + colon_w, 1065);
  float peak_views_w = textWidth(decimalFormat.format(peak_views_gain));

  fill(150);
  textSize(22);
  text("  (" + keyifyL(total_views_pd) + " /d)", 20 + total_w + views_w + colon_w + views_v_w, 995);
  text("  (" + peak_views_gain_date + ")", 20 + peak_v_w + peak_v_v_w + colon_w + peak_views_w, 1065);

  if (currentDay % 1 == 0) {
    total_subs_pd = (long)(total_subs - prev_total_subs);
    total_views_pd = (long)(total_views - prev_total_views);
    prev_total_subs = total_subs;
    prev_total_views = total_views;

    if (frameCount > 1) {
      if (total_subs_pd > peak_subs_gain) {
        peak_subs_gain = total_subs_pd;
        peak_subs_gain_date = dateLabels[floor(currentDay)];
      }
      if (total_views_pd > peak_views_gain) {
        peak_views_gain = total_views_pd;
        peak_views_gain_date = dateLabels[floor(currentDay)];
      }
    }
  }
}

int pyoffset = 3;
double lastStart_time = 0;

double[] clicks = new double[0];

void drawLatestVideo() {
  Video video = curLatVid.get(dateLabels[floor(currentDay)]);
  if (video != null) {
    PImage curThumb;

    if (lastThumbs[video.index] == null) {
      curThumb = loadImage("videoThumbExtra/hqdefault("+video.index+").jpg");
      curThumb.resize(200, 112);
      lastThumbs[video.index] = curThumb;
      uploadCount++;

      double now = System.currentTimeMillis()/(double)1000f;

      clicks = arraypush(clicks, now);
      double start_time = now - (double)1.00;
      lastStart_time = start_time;

      while (clicks.length > 0 && clicks[0] < start_time) {
        clicks = arrayshift(clicks);
      }

      if (clicks.length > 1) trueUPD = ((float)(clicks.length/(clicks[clicks.length-1] - clicks[0])))/6.0f;
      else trueUPD = 1/6;
    } else {
      curThumb = lastThumbs[video.index];

      double now = System.currentTimeMillis()/(double)1000f;
      double start_time = now - (double)1.00;

      clicks = arraypop(clicks);
      clicks = arraypush(clicks, now);

      while (clicks.length > 0 && clicks[0] < lastStart_time) {
        clicks = arrayshift(clicks);
      }

      trueUPD = ((float)(clicks.length/(clicks[clicks.length-1] - clicks[0])))/6.0f;
    };

    image(curThumb, _width+10, offset*3 + 10);

    fill(255);
    text(video.title, _width+200+20, offset*3 + 30);
    fill(150);
    image(img_assets[1], _width+200+22, offset*3 + 38);
    text(video.views_formatted, _width+200+20+35, offset*3 + 55);

    image(img_assets[2], _width+200+22, offset*3 + 58);
    text(video.likes_formatted, _width+200+20+35, offset*3 + 82);

    image(img_assets[0], _width+200+20+150, offset*3 + 58);
    text(video.comments_formatted, _width+200+20+35 + 150, offset*3 + 82);

    //image(img_assets[0], _width+200+20, offset*3 + 88);
    //text(video.comments_formatted, _width+200+20+35, offset*3 + 109);

    image(img_assets[3], _width+200+20, offset*3 + 88);
    text(video.date_formatted, _width+200+20+35, offset*3 + 109);

    //println(videos[223].title);

    for (int i = 0; i < 3; i++) {
      if (video.index+(i+1) >= videos.length) continue;
      Video lastVideo = videos[video.index+(i+1)];
      PImage pThumb = lastThumbs[lastVideo.index];

      if (pThumb != null) {
        if (pThumb.width != 135 || pThumb.height != 74) pThumb.resize(135, 74);
        image(pThumb, _width+10, offset*3+133+i*84);
      };

      if (lastVideo != null) {
        fill(255);
        text(lastVideo.title, _width+10+145, pyoffset+offset*3+153+i*84);
        fill(150);
        text(lastVideo.views_formatted + " views", _width+10+145, pyoffset+offset*3+175+i*84);
        text(lastVideo.date_formatted, _width+10+145, pyoffset+offset*3+197+i*84);
      }
    }
  }
}

int offset = 230;
int _width = 625;

void drawChartLabels() {
  textSize(25);
  fill(255, 74, 74);
  text("Cummulative Subscribers", _width+10, 110);
  text("Daily Subscribers", _width + 10, 110+606/2);

  fill(74, 183, 255);
  text("Cummulative Views", _width + ((width - _width)/2) + 10, 110);
  text("Daily Views", _width + ((width - _width)/2) + 10, 110+606/2);
}

int prevUpCount = 0;
float trueUPD = 0.0;
float trueUPW = 0.0;
float trueUPM = 0.0;
float trueUPY = 0.0;

float ctrueUPD = 0.0;
float ctrueUPW = 0.0;
float ctrueUPM = 0.0;
float ctrueUPY = 0.0;

void drawUploadRate() {
  Video video = curLatVid.get(dateLabels[floor(currentDay)]);
  if (currentDay % 1 == 0) {
    prevUpCount = uploadCount;
    ctrueUPD = trueUPD;
    ctrueUPW = trueUPD*7;
    ctrueUPM = trueUPD*31;
    ctrueUPY = trueUPD*365;
  }

  trueUPW = trueUPD*7;
  trueUPM = trueUPD*31;
  trueUPY = trueUPD*365;

  textAlign(RIGHT);
  fill(245, 158, 157);
  //text("Live Upload Rate", width-10, offset*3 + 30);
  //text(nf(trueUPD, 0, 2) + " /d", width-10, offset*3 + 60);
  //text(nf(trueUPW, 0, 2) + " /w", width-10, offset*3 + 90);
  //text(nf(trueUPM, 0, 2) + " /m", width-10, offset*3 + 120);
  //text(nf(trueUPY, 0, 2) + " /y", width-10, offset*3 + 150);

//  text("Clean Upload Rate", width-10, offset*3 + 200);
//  text(nf(ctrueUPD, 0, 2) + " /d", width-10, offset*3 + 230);
//  text(nf(ctrueUPW, 0, 2) + " /w", width-10, offset*3 + 260);
//  text(nf(ctrueUPM, 0, 2) + " /m", width-10, offset*3 + 290);
//  text(nf(ctrueUPY, 0, 2) + " /y", width-10, offset*3 + 320);

  text("Upload Rate", width-10, offset*3 + 30);
  text(nf(ctrueUPD, 0, 2) + " /d", width-10, offset*3 + 60);
  text(nf(ctrueUPW, 0, 2) + " /w", width-10, offset*3 + 90);
  text(nf(ctrueUPM, 0, 2) + " /m", width-10, offset*3 + 120);
  text(nf(ctrueUPY, 0, 2) + " /y", width-10, offset*3 + 150);


  textAlign(LEFT);

  //new Timer().scheduleAtFixedRate(new TimerTask() {
  //  @Override
  //    public void run() {
  //    if ((trueUPD - 1) < 0) {}
  //    //else trueUPD-=0.0001;
  //    else trueUPD--;
  //  }
  //}, 0, 1000);
}

void drawBorders() {
  stroke(255);

  // video border
  //line(0, 1080, 1920, 1080);
  //line(1920, 0, 1920, 1080);

  strokeWeight(4);


  // main channel border
  line(_width, 0, _width, 230);
  line(0, 230, _width, 230);

  // second channel border
  line(_width, offset, _width, offset + 230);
  line(0, offset + 230, _width, offset + 230);

  // third channel border
  line(_width, offset*2, _width, offset*2 + 230);
  line(0, offset*2 + 230, _width, offset*2 + 230);

  // fourth channel border
  line(_width, offset*3, _width, offset*3 + 230);
  line(0, offset*3 + 230, _width, offset*3 + 230);

  // excess channel border
  line(_width, offset*4, _width, offset*4 + 230);

  // top charts border
  line(_width, 85, width, 85);

  // between top bottom charts border
  line(_width + ((width - _width)/2), 85, _width + ((width - _width)/2), 691);

  // between left right charts border
  line(_width, 85 + 606/2, width, 85 + 606/2);

  // bottom charts border
  line(_width, offset*3, width, offset*3);
}

void draw() {
  //scale(2.0/3.0);
  currentDay = getDayFromFrameCount(frames);

  drawBackground();
  drawBorders();
  drawChannels();
  drawLatestVideo();
  drawChartLabels();
  drawUploadRate();
  //if (currentDay > data_length-2) exit();

  if (record) saveVideoFrameHamoid();
  frames++;
}

int getDayCountFromDate(String s) {
  int res = -1;
  for (int i = 0; i < dateLabels.length; i++) {
    if (dateLabels[i].equals(s)) {
      res = i;
      break;
    }
  }

  return res;
}

String keyify(int n) {
  boolean negative = n < 0;

  n = abs(n);

  if (n < 1000) {
    if (negative) return "-"+n;
    else return n+"";
  } else if (n < 1000000) {
    if (n%1000 == 0) {
      if (negative) return "-"+(n/1000)+"K";
      else return (n/1000)+"K";
    } else {
      if ((n / 1000) < 10) {
        if (negative) return "-"+nf(n/1000f, 0, 2)+"K";
        else return nf(n/1000f, 0, 2)+"K";
      } else if ((n / 1000) < 100) {
        if (negative) return "-"+nf(n/1000f, 0, 1)+"K";
        else return nf(n/1000f, 0, 1)+"K";
      } else {
        if (negative) return "-"+(n/1000)+"K";
        else return (n/1000)+"K";
      }
    }
  }
  if (n%1000000 == 0) {
    if (negative) return "-"+(n/1000000)+"M";
    else return (n/1000000)+"M";
  } else {
    if ((n / 1000000) < 10) {
      if (negative) return "-"+nf(n/1000000f, 0, 2)+"M";
      else return nf(n/1000000f, 0, 2)+"M";
    } else if ((n / 1000000) < 100) {
      if (negative) return "-"+nf(n/1000000f, 0, 1)+"M";
      else return nf(n/1000000f, 0, 1)+"M";
    } else {
      if (negative) return "-"+n/1000000+"M";
      else return n/1000000+"M";
    }
  }
}

String keyifyL(long n) {
  boolean negative = n < 0;

  n = Math.abs(n);

  if (n < 1000L) {
    if (negative) return "-"+n;
    else return n+"";
  } else if (n < 1000000L) {
    if (n%1000L == 0L) {
      if (negative) return "-"+(n/1000f)+"K";
      else return (n/1000f)+"K";
    } else {
      if ((n / 1000) < 10) {
        if (negative) return "-"+nf(n/1000f, 0, 2)+"K";
        else return nf(n/1000f, 0, 2)+"K";
      } else if ((n / 1000) < 100) {
        if (negative) return "-"+nf(n/1000f, 0, 1)+"K";
        else return nf(n/1000f, 0, 1)+"K";
      } else {
        if (negative) return "-"+n/1000L+"K";
        else return n/1000L+"K";
      }
    }
  }
  if (n%1000000L == 0L) {
    if (negative) return "-"+(n/1000000f)+"M";
    else return (n/1000000f)+"M";
  } else {
    if ((n / 1000000) < 10) {
      if (negative) return "-"+nf(n/1000000f, 0, 2)+"M";
      else return nf(n/1000000f, 0, 2)+"M";
    } else if ((n / 1000000) < 100) {
      if (negative) return "-"+nf(n/1000000f, 0, 1)+"M";
      else return nf(n/1000000f, 0, 1)+"M";
    } else {
      if (negative) return "-"+n/1000000L+"M";
      else return n/1000000L+"M";
    }
  }
}

Video[] reverse_videos(Video[] video_list) {
  Video[] reversed_videos = new Video[video_list.length];

  int j = video_list.length;
  for (int i = 0; i < video_list.length; i++) {
    reversed_videos[j - 1] = video_list[i];
    j -= 1;
  }

  return reversed_videos;
}

double[] arraypush(double[] arr, double item) {
  double[] tmp = Arrays.copyOf(arr, arr.length + 1);
  tmp[tmp.length - 1] = item;
  return tmp;
}

double[] arraypop(double[] arr) {
  double[] tmp = Arrays.copyOf(arr, arr.length - 1);
  return tmp;
}

double[] arrayshift(double[] arr) {
  double[] tmp = Arrays.copyOf(arr, arr.length - 1);
  for (int i = 1; i < arr.length; i++) {
    tmp[i-1] = arr[i];
  }

  return tmp;
}
