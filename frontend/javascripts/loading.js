/* ------------------------------
Loading イメージ表示関数
引数： msg 画面に表示する文言
------------------------------ */
module.exports.disp = function disp(msg){
    // 引数なし（メッセージなし）を許容
    if(msg == undefined){
        msg = "";
    }

    // ローディング画像が表示されていない場合のみ出力
    if(document.getElementById("loading") == null){
        const dispMsg = document.createElement("div");
        dispMsg.id = "loading";
        dispMsg.innerHTML = `<div class="loadingMsg">${msg}</div>`;

        document.querySelector("body").insertAdjacentElement("beforeend", dispMsg);
    }
}

/* ------------------------------
Loading イメージ削除関数
------------------------------ */
module.exports.remove = function remove(){
    document.getElementById("loading").remove();
}
