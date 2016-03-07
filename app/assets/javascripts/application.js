//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

$(function(){

  $("#player_list").submit(function(event){
    event.preventDefault();
    var players = []
    console.log("FUNCIONO");
    $("input:checkbox:checked").each(function(){
      players.push($(this).val());
    });
    var team_number = $('#team_number').val();
    console.log(players);
    console.log(team_number);
    $.ajax({
      url: "/team_player",
      type: "POST",
      data: {team: team_number,
             players: players
           }

    });
  });

});
