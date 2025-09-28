export const init = () => {
    window.execPrint = function(url) {
        if(popupConfirm("印刷を実行した場合、印刷した日報が原紙となります。印刷しますか？", function(result) {
            if(result) {
                fetch(url, {
                    method: "POST"
                })
                .then((res) => res.text())
                .then((text) => {
                    document.getElementById("print_stamp").innerHTML = text;
                    window.print();
                    popupAlert("印刷した日報を原紙として保管してください。");
                });
            }
        }));
    };

    window.cancelPrint = function(url) {
        if(popupConfirm("印刷を情報を削除してもよろしいですか？", function(result) {
            if(result) {
                fetch(url, {
                    method: "DELETE"
                })
                .then((res) => res.text())
                .then((text) => {
                    document.getElementById("print_stamp").innerHTML = text;
                    popupAlert("印刷情報を削除しました。");
                });
            }
        }));
    };
};
