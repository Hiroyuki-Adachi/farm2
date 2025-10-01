export const init = () => {
    window.execPrint = function(url) {
        if(popupConfirm("印刷を実行した場合、印刷した日報が原紙となります。印刷しますか？", function(result) {
            if(result) {
                fetch(url, {
                    method: "POST"
                })
                .then((res) => res.text())
                .then((text) => {
                    if (document.getElementById("print_stamp") != null) {
                        document.getElementById("print_stamp").innerHTML = text;
                        popupAlert("印刷した日報を原紙として保管してください。");
                    }
                    window.print();
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
                    if (document.getElementById("print_stamp") != null) {
                        document.getElementById("print_stamp").innerHTML = text;
                        popupAlert("印刷情報を削除しました。");
                    }
                });
            }
        }));
    };

    function layCover(coverName) 
    {
        const coverElm = document.getElementById(`cover_${coverName}`);
        const conteElm = document.getElementById(`content_${coverName}`);
        if ((coverElm != null) && (conteElm != null)) {
            coverElm.style.height = `${conteElm.clientHeight}px`;
            coverElm.style.width  = `${conteElm.clientWidth}px`;
        }
    }

    if (document.getElementById("covering_flag").value === "true") {
        layCover("work");
        layCover("workers");
        layCover("lands");
        layCover("machines");
        layCover("chemicals");
        layCover("whole_crops");
    }
};
