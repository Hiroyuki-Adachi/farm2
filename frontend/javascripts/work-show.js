window.execPrint = function(url) {
    if(popupConfirm("印刷を実行した場合、印刷した日報が原紙となります。印刷しますか？", function(result) {
        if(result) {
            $.ajax({
                url: url,
                type: "POST",
                dataType: "html"
            }).done(function(html) {
                $("#print_stamp").html(html);
                window.print();
                popupAlert("印刷した日報を原紙として保管してください。");
            });
        }
    }));
};

window.cancelPrint = function(url) {
    if(popupConfirm("印刷を情報を削除してもよろしいですか？", function(result) {
        if(result) {
            $.ajax({
                url: url,
                type: "DELETE",
                dataType: "html"
            }).done(function(html) {
                $("#print_stamp").html(html);
                popupAlert("印刷情報を削除しました。");
            });
        }
    }));
};

$(function() {
    $("#cover_broccoli").height($("#content_broccoli").height()).width($("#content_broccoli").width());
    $("#cover_whole_crop").height($("#content_whole_crop").height()).width($("#content_whole_crop").width());
});
