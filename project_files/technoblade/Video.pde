import java.util.Date;

class Video {
  String title;
  int index;
  int views;
  int likes;
  int comments;
  long date;
  String date_formatted;
  String views_formatted;
  String likes_formatted;
  String comments_formatted;

  public Video(int i, String t, int v, int l, long d, int c) {
    title = t;
    views = v;
    likes = l;
    comments = c;
    date = d;
    index = i;

    Date date_raw = new Date(d);

    views_formatted = decimalFormat.format(v);
    likes_formatted = decimalFormat.format(l);
    comments_formatted = decimalFormat.format(c);
    date_formatted = String.format("%s %tb %<td, %<tY", "", date_raw).substring(1);
  }
}
