$(document).ready(function () {
    $("#prof").click(function () {
        $('a#beh').fadeIn(100);
        $('a#flick').fadeIn(500);
        $('a#last').fadeIn(1000);
        $('a#twit').fadeIn(1500);
        $('a#blog').fadeIn(2000);
        $('a#cv').fadeIn(2500);
        $('#prof').html("Okay, maybe not that many secrets.");
    });

    var video = "<video autoplay loop poster=\"bg.png\" id=\"bgvid\"><source src=\"https:\/\/dl.dropboxusercontent.com\/u\/14905425\/background.mp4\" type=\"video\/mp4\"><\/video>";

    $("#vidya").click(function () {
        $('.container').append(video);
        $('.discuss p').css({
            'color': 'white'
        });
        $('.discuss h3').css({
            'color': 'white'
        });
    });
});