class Sidebar
{

  final int baseX, baseY;
  CheckBox checkbox;
  Textfield textfield;
  ListBox suggestions;

  StringDict lookup;

  int timesRun = 0; 

  RadioButton rb;

  Textlabel normal; 

  Sidebar(int x, int y)
  {
    baseX = x;
    baseY = y;

    lookup = new StringDict();

    textfield = cp5.addTextfield("textfield")
      .setPosition(baseX+10, 10)
        .setSize(195, 30)
          .setAutoClear(false)
            ;
    textfield.captionLabel().set("Tag Search");

    //Load the Listbox for suggestions of the state name
    suggestions = cp5.addListBox("Suggestions")
      .setPosition(baseX+10, 10+45)
        .setSize(195, 250)
          ;
    suggestions.captionLabel().set("");
    suggestions.actAsPulldownMenu(false);
    suggestions.setColorActive(#F09102);
    ListBoxItem it = suggestions.addItem(reader.tags[11], 0);
    it.setColor(new CColor(#ff0099, #ff0099, #ff0099, 255, #ff0099));
    it.setIsActive(true);
    activeTags.add("html");
    lookup.set(Integer.toString(0)+".0", "html");

    checkbox = cp5.addCheckBox("checkBox")
      .setPosition(baseX+20, baseY + 20)
        .setColorForeground(color(120))
          .setColorActive(#F09102)
            .setColorLabel(color(0))
              .setSize(20, 20)
                .setItemsPerRow(2)
                  .setSpacingColumn(60)
                    .setSpacingRow(20)
                      .addItem("Questions", 0)
                        .addItem("Answers", 50)
                          .addItem("Comments", 100)
                            .addItem("Upvotes", 150)
                              .addItem("Downvotes", 200)
                                .addItem("Favorites", 255)
                                  ;

    rb = cp5.addRadioButton("radio")
      .setPosition(baseX+20, baseY+200)
        .setColorForeground(color(120))
          .setColorActive(#ff0099)
            .setColorLabel(color(0))
              .addItem("None", 1)
                .addItem("Unique active users", 2)
                  .addItem("New user registrations", 3)
                    .addItem("Site views", 4);

  }



  //
  //  void keyPressed() {
  //    if (key==' ') {
  //      checkbox.deactivateAll();
  //    } 
  //    else {
  //      for (int i=0;i<6;i++) {
  //        // check if key 0-5 have been pressed and toggle
  //        // the checkbox item accordingly.
  //        if (keyCode==(48 + i)) { 
  //          // the index of checkbox items start at 0
  //          checkbox.toggle(i);
  //          println("toggle "+checkbox.getItem(i).name());
  //          // also see 
  //          // checkbox.activate(index);
  //          // checkbox.deactivate(index);
  //        }
  //      }
  //    }
  //  }

  void show()
  {
    noFill();
    stroke(0);
    strokeWeight(4);
    rect(baseX, baseY, 200, h);
  }
}

