/* ------------------------------
Loading イメージ表示関数
引数： msg 画面に表示する文言
------------------------------ */
module.exports.disp = function disp(msg){
    // 引数なし（メッセージなし）を許容
    if( msg == undefined ){
        msg = "";
    }
    // 画面表示メッセージ
    var dispMsg = "<div class='loadingMsg'>" + msg + "</div>";
    // ローディング画像が表示されていない場合のみ出力
    if($("#loading").length == 0){
        $("body").append("<div id='loading'>" + dispMsg + "</div>");
    }
}

/* ------------------------------
Loading イメージ削除関数
------------------------------ */
module.exports.remove = function remove(){
    $("#loading").remove();
}
