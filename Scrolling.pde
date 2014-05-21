//Gregory Guterman and Steve Avery
//Stack Overflow Dataset Milestone 

import controlP5.*;
import java.util.Set;
import java.util.HashSet;

final int w = 500, h = 500;
final int o1 = 4;

int normalNumber = 0;

int padding;
Visualization v;

ControlP5 cp5;
CColor activeItem;
CColor defaultItem;
Sidebar sidebar;

Set<String> activeTags;
Reader reader;

String[] xMonthTicks = new String[1462];


int moveAmt;

int curMax, curMin;

void setup()
{
  background(255);
  size(w+210, h+104);
  //  frameRate(10);

  moveAmt = 1;
  reader = new Reader("data/dataset.csv");

  activeTags = new HashSet<String>();

  v = new Visualization();
  cp5 = new ControlP5(this);
  sidebar = new Sidebar(w, 300);
  sidebar.checkbox.activateAll();
  sidebar.rb.activate(0);

  activeItem = new CColor(#F09102, #F09102, #F09102, 255, #F09102);
  defaultItem = sidebar.suggestions.getColor();
}


void draw()
{
  background(255);
  text("Normalization", 200, 10);

  drawNormalization();

  v.show();


  if (curMin+moveAmt >= 0 && curMax+moveAmt <= 1461)
  {
    curMin += moveAmt;
    curMax += moveAmt;
  }
}

void drawNormalization()
{
  stroke(0);
  strokeWeight(1);
  fill(0);
  rect(25, 85, 475, 2);
  rect(25, 5, 2, 80);
  text("0", 10, 85);
  text("1", 10, 15);
  text("Aug 08", 25, 98);
  text("Aug 12", 475, 98);

  float[] d = new float[1462];
//  float xScale = 1462/475;
  if (normalNumber == 2)
    d = reader.uniquenorm;
  else if (normalNumber == 3)
    d = reader.newusersnorm;
  else if (normalNumber == 4)
    d = reader.viewsnorm;
  for (int i = 0; i < d.length; i++)
  {
    int x = 25+i*475/1462;
    int y = int(85 - d[i]*80);
    point(x, y);
  }
  //Aug 08, Aug 12
}


int ct = 1;
void controlEvent(ControlEvent theEvent) {
  println(theEvent);
  //name: Suggestions

  Textfield textfield = sidebar.textfield;
  ListBox suggestions = sidebar.suggestions;

  if (theEvent.isFrom(textfield)) {
    String text = textfield.getText();

    //    suggestions.getListBoxItems().length
    for (String s : reader.tags)
    {
      ListBoxItem item;
      if (s.contains(text))
      {
        item = suggestions.getItem(s);//faster if we getItem by Index
        if (item == null)
        {
          ListBoxItem item2 = suggestions.addItem(s, ct++);

          //          println(item2.getValue());
          sidebar.lookup.set(Integer.toString(item2.getValue())+".0", s);
          println(Integer.toString(item2.getValue())+".0");
        }
      }
      else
      {
        try {
          item = suggestions.getItem(s);//faster if we getItem by Index
          if (!item.isActive()) //isActive not visible!
          {
            suggestions.removeItem(s);
          }
        }
        catch(Exception e) {
        }
      }
    }
    //    println(suggestions.getListBoxItems()[1]);
    //    println(suggestions.getListBoxItems().length);
  }
  else if (theEvent.isFrom(suggestions))
  {
    println("event " + Float.toString(theEvent.getValue()) + " " + sidebar.lookup.get(Float.toString(theEvent.getValue())));
    ListBoxItem item = suggestions.getItem(sidebar.lookup.get(Float.toString(theEvent.getValue())));
    item.setIsActive(!item.isActive());

    //    println(item.getName());
    //    println(item.getText());
    TableRow r = reader.table.findRow(item.getText(), 0);
    String s = r.getString(0);
    if (item.isActive())
    {
      //      TableRow r = reader.table.findRow(item.getText(), 0);
      activeTags.add(s);
      color c = color(random(255), random(255), random(255));
      CColor col = new CColor(c, c, c, 255, c);

      v.addLanguage(r, c);
      //      println(r.getString(0));
      item.setColor(col);
    }
    else
    {
      activeTags.remove(s);
      item.setColor(defaultItem);
      v.removeLanguage(r);
    }
    //    suggestions.getItem(int(theEvent.value())).activeToggle();
    //    println(item.isActive());
  }

  else if (theEvent.isFrom(sidebar.rb)) {
    normalNumber = round(theEvent.getValue());
  }
  //
  //  println(suggestions.getListBoxItems().length);
  //  for (int i = 0; i < suggestions.getListBoxItems().length; i++)
  //  {
  //    suggestions.getItem(i).setValue(i);
  //  }
}

void keyPressed()
{
  //  textfield.submit();
  //  println(sidebar.suggestions.getItem(0).isActive());
}

void mouseMoved()
{
  if (mouseX < w && mouseY > 100)
    moveAmt = (min(mouseX, w) - w/2)/75;
  else
    moveAmt = 0;
}

public int y(int y)
{
  return h-y;
}

public class Visualization
{
  ArrayList<Language> languages;
  Axes axes;

  int originX;
  int originY;


  //  String[] xMonthTicks;
  int curTick;

  Visualization()
  {

    int axisWidth = 3;
    padding = 25;

    originX = 0+padding+o1;
    originY = y(100+padding);

    curMin = 1;
    curMax = w-2*padding;

    languages = new ArrayList<Language>();
    //    int ct = 0;
    //    for (TableRow row : reader.table.rows())
    //    {
    //      languages.add(new Language(row, #FF0099, color(random(255), random(255), random(255))));
    //      ct++;
    //      if(ct > 0)
    //        break;
    //    }
    addLanguage(reader.table.getRow(11), color(#FF0099));
    //    languages.add(new Language(reader.table.getRow(0), #FF0099, color(random(255), random(255), random(255))));
    //    languages.add(new Language(reader.table.getRow(8), #FF0099, #FF0099));
    //    languages.add(new Language(reader.table.getRow(4), #FF0099, #0099FF));
    //    languages.add(new Language(reader.table.getRow(24), #FF0099, color(random(255), random(255), random(255))));
    axes = new Axes(originX, originY, padding, w, h, axisWidth, color(0), color(6, 61, 9));

    //    tickBuffer = new ArrayList<int>();
    //    xMonthTicks = new String[1462];
    makeMonthTicks();

    //    println(xMonthTicks[xMonthTicks.length-3]);
    //    println(xMonthTicks[0]);
    //    curTick = 0;
    //    tickBuffer.add(xMonthTicks[curTick]);
    //    curTick++;
  }

  void addLanguage(TableRow r, color c)
  {
    languages.add(new Language(r, #FF0099, c));
  } 

  void removeLanguage(TableRow r)
  {
    println(r);
    for (int i = languages.size()-1; i>=0; i--)
    {
      if (languages.get(i).row.getString(0).equals(r.getString(0)))
      {
        languages.remove(i);
        break;
      }
    }
  } 


  void show()
  {
    noFill();
    stroke(0);
    strokeWeight(4);
    rect(o1-1, 100, w, h);

    for (Language l : languages)
    {
      l.show2(originX, y(originY));
      //      l.move();
    }
    axes.show();
  }
}

int[] scaleCoords(int x, int y)
{
  int[] arr = new int[2];

  if (x-curMin <= 0)
    arr[0] = 0;
  else  
    arr[0] = (x-curMin + padding);
  arr[1] = y(y + padding);
  //  println(curMin +  ", " + curMax);
  //  println(arr[0] +  ", " + arr[1]);
  //println(x +  ", " + y);
  return arr;
}



void makeMonthTicks()
{
  int month = 8;
  String year = "08";
  //  xMonthTicks[1] = new String(numToMonth(month) + " " + year);
  month++;

  for (int i = 0; i < xMonthTicks.length; i++)
  {
    //    if (year.equals("12") && month == 9)
    //      break;

    if (i % 30 == 0)
    {
      if (i % 90 == 0)
        xMonthTicks[i] = new String(numToMonth(month) + " " + year);
      month++;
    }

    if (month == 13)
    {
      month = 1;
      if (year.equals("08"))
        year = "09";
      else if (year.equals("09"))
        year = "10";
      else if (year.equals("10"))
        year = "11";
      else if (year.equals("11"))
        year = "12";
    }
    //    println(xMonthTicks[1461]);
  }
  //  xMonthTicks[1461] = new String(numToMonth(month) + " " + year);
  //  for (int i = 0; i < 1462; i++)
  //  {
  //    if (xMonthTicks[i] != null)
  //      println(i + " " + xMonthTicks[i]);
  //  }
}

String numToMonth(int num)
{
  switch(num)
  {
  case 1:
    return "Jan";
  case 2:
    return "Feb";
  case 3:
    return "Mar";
  case 4:
    return "Apr";
  case 5:
    return "May";
  case 6:
    return "Jun";
  case 7:
    return "Jul";
  case 8:
    return "Aug";
  case 9:
    return "Sep";
  case 10:
    return "Oct";
  case 11:
    return "Nov";
  case 12:
    return "Dec";
  default:
    return "unknown";
  }
}

