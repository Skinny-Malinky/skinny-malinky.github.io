/* 
Author: Struan Fraser
*/
$(document).ready(function () {
    $('.ajax-popup-link').magnificPopup({
        type: 'ajax',

        fixedContentPos: false,
        fixedBgPos: true,

        overflowY: 'auto',

        closeBtnInside: true,
        preloader: false,

        midClick: true,
        removalDelay: 300,
        mainClass: 'mfp-fade'
    });
    $('.fader').click(function (disappear) {
        $('#intro').slideUp(400, portSlide());
    });
    
    $('.back').click(function (back) {
        $('#portfolio').slideUp(400, introSlide());
    });

    function introSlide(){
        $('#intro').slideDown();
    }

    function portSlide(){
        $('#portfolio').slideDown();       
    };
});