//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
// hey hey

$(function(){


  $(".ball").ready(function(event){
    var animation = gon.animation;
    var events = gon.events;
    var counter = animation.length;
    var local_id = gon.local;
    var speed = 20;
    for (var i = 0; i < counter; i++) {
      time = animation[i][0];
      name = animation[i][1];
      avatar = animation[i][2];
      field = animation[i][3];
      text = events[i][1];
      local_goals = animation[i][4];
      visitor_goals = animation[i][5];
      local = animation[i][6];
      setTimeout(function(time,name,avatar,field,text,local_goals,visitor_goals, local_id, local, speed) { return function() { clock_move(time,name,avatar,field,text,local_goals,visitor_goals, local_id, local, speed); }; }(time,name,avatar,field,text,local_goals,visitor_goals, local_id, local, speed), speed*i);
    }
  });

  var goal_show = '<div class="indication" id="goal"><img src="/assets/goal.png" class= "goal_img"></div>'
  var yellow_show = '<div class="indication" id="yellow"><img src="/assets/yellow.png" class= "yellow_img"></div>'
  var red_show = '<div class="indication" id="red"><img src="/assets/red.png" class= "red_img"></div>'
  var freekick_show = '<div class="indication" id="freekick"><img src="/assets/freekick.png" class= "freekick_img"></div>'
  var penalty_show = '<div class="indication" id="penalty"><img src="/assets/penalty.png" class= "penalty_img"></div>'
  var doubleyellow_show = '<div class="indication" id="doubleyellow"><img src="/assets/doubleyellow.png" class= "doubleyellow_img"></div>'


  function clock_move(time,name,avatar,field,text,local_goals,visitor_goals, local_id, local, speed) {
    $("#gk_local").hide();
    $("#gk_visitor").hide();
    $(".clock").html('<h2>' + time + "'" + '</h2>');
    var top = Math.floor((Math.random() * 220) + 15);
    $(".animated").animate({left: field, top: top},speed/2);
    // $(".animated").animate({top: top},500);
    var data_html = "<img src='" + avatar + "'class='avatar'><br><span class='name_player' style='overflow: visible;'>" + name + "</span>";
    $("#animated_player").html(data_html);
    $("#event_text h3").html(text);
    $(".clock").html('<h2>' + time + "'" + '</h2>');
    $("#local_score").html(local_goals);
    $("#visitor_score").html(visitor_goals);

    var text_show;

    if (local_id == local ) {
      $("#event_text").css("color","blue");
      text_show = "<h4 style='color: blue'>" + time + ": " + text + "</h4>";
    } else {
      $("#event_text").css("color","red");
      text_show = "<h4 style='color: red'>" + time + ": " + text + "</h4>";
    }

    

    if (text.includes("goal")){
      if (local_id == local ) {
        $(".animated").animate({left: 600, top: 75},speed/4);
        $("#featured_events").prepend(text_show).css("color","blue");
        $("#featured_events").prepend(goal_show);
      } else {
        $(".animated").animate({left: 0, top: 75},speed/4);
        $("#featured_events").prepend(text_show).css("color","red");
        $("#featured_events").prepend(goal_show);
      }
    }

    if (text.includes("misses")){
      var miss = Math.floor((Math.random() * 220) + 15);
      if (local_id == local ) {
        $(".animated").animate({left: 600, top: miss},speed/4);
      } else {
        $(".animated").animate({left: 0, top: miss},speed/4);
      }
      $("#featured_events").prepend(text_show);
    }

    if (text.includes("blocked")){
      if (local_id == local ) {
        $(".animated").animate({left: 600, top: 75},speed/8);
        $("#gk_visitor").css("display", "inline-block");
      } else {
        $(".animated").animate({left: 0, top: 75},speed/8);
        $("#gk_local").css("display", "inline-block");
      }
      $("#featured_events").prepend(text_show);
    }

    if (text.includes("yellow")){
      if (local_id == local ) {
        $("#featured_events").prepend(text_show);
      } else {
        $("#featured_events").prepend(text_show);
      }
      $("#featured_events").prepend(yellow_show);
    }

    if (text.includes("second")){
      if (local_id == local ) {
        $("#featured_events").prepend(text_show);
      } else {
        $("#featured_events").prepend(text_show);
      }
      $("#featured_events").prepend(doubleyellow_show);
    }

    if (text.includes("penalty")){
      if (local_id == local ) {
        $("#featured_events").prepend(text_show);
      } else {
        $("#featured_events").prepend(text_show);
      }
      $("#featured_events").prepend(penalty_show);
    }

    if (text.includes("red")){
      if (local_id == local ) {
        $("#featured_events").prepend(text_show);
      } else {
        $("#featured_events").prepend(text_show);
      }
      $("#featured_events").prepend(red_show);
    }

    if (text.includes("free kick")){
      if (local_id == local ) {
        $("#featured_events").prepend(text_show);
      } else {
        $("#featured_events").prepend(text_show);
      }
      $("#featured_events").prepend(freekick_show);
    }

  };

  
});
