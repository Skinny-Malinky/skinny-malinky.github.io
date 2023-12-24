$(document).ready(function () {

    $('button#addrss').click(function (addFeed) {
        addFeed.preventDefault();
        var feed = $('input#feed').val();
        fetchIt(feed);
    });
});

function fetchIt(feed) {
    $.post('fetch.php', {
            url: feed
        },
        function (data) {
            parsePost(data);
        }
        //});
    );
}

function getNode(xml, n, i) {
    var info = $(xml).find(n).eq(i);
    return info;
}

function parsePost(data) {
    var xml = data,
        xmlDoc = $.parseXML(xml),
        $xml = $(xmlDoc);
    //only manipulate data from here

    //for each article
    $(xml).find('item').each(function (i) {
        //Find XML elements
        var title = getNode(xml, 'title', i);
        var description = getNode(xml, 'description', i);
        var link = getNode(xml, 'link', i);
        var image = getNode(xml, 'url', 0);
        var pubdate = getNode(xml, 'pubDate', i);
        printPost(xml, title, description, link, image, pubdate, i);

        //var overlap = Date.parse(curDa2);
        //if (x == 15) {
        //return false;
        //}
        //var curDa = $('#date').text();
        // Date.parse(curDa);
        // if (overlap > curDa || curDa === undefined) {
        //    $curDa2 = $(xml).find('pubDate').eq(i);

        //} //else {
        //x++;
        //}
        //});

        if (i == 15) {
            return false;
        }
    });
}

function printPost(xml, title, description, link, image, pubdate, i) {
    //check date


    // Fill HTML Elements
    $('#container ').append('<a id = \"' + pubdate.text() + '\" href = \"' + link.text() + '\">' + '<div class=\"newpost\">' + '<img src=\"' + image.text() + '\" \/>' + '<article class=\"extract\">' + '<h1>' + title.text() + '<\/h1>' + '<p>' + description.text() + '<\/p>' + '<\/article>' + '<\/div>' + '<\/a>');
    $('.newpost').fadeIn(i * 500);
}
//$(this).find('li').text();
//$(".newpost h1 ").html(title.text());





/*function fetchIt() {
    $.post('fetch.php', {
            url: 'http://wtfpod.libsyn.com/rss'
        },
        function (data) {
            var xml = data,
                xmlDoc = $.parseXML(xml),
                $xml = $(xmlDoc);
            var title = $(xml).find("
                title ").eq(2);
            //$(this).find('li').text();
            $(".newpost h1 ").html(title.text());
        });
    //});
}*/

/*var xml = $.parseXML(data),
                    xml = $(xmlDoc),
                    $title = $xml.find('title');*/
//var html = $.parseHTML(data);
//alert($(html).find('title').text());

/*  DEBUGGING TOOLS
$(document).ready(function () {
    alert('It works!');
});
*/