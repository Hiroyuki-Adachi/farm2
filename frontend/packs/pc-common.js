$(document).on("change", "div.form-check-inline input[type='checkbox']", function(e) {
    if($(this).prop('checked')) {
        $(this).parent().css("color", "red");
    } else {
        $(this).parent().css("color", "black");
    }
});

$(function() {
    $("div.form-check-inline input[type='checkbox']").trigger("change");

    // for sidebar
    var controller = $("#current_controller").val();
    var action = $("#current_action").val();
    if(controller == "menu" && action == "index") {
        return;
    }
    $("#mySidebar").find("a[data-controller]").each(function(_i, e) {
        if(e.dataset.controller == controller) {
            if($("a[data-controller='" + controller + "']").length <= 1) {
                activeBar(e);
            } else if(JSON.parse(e.dataset.actions).indexOf(action) >= 0) {
                activeBar(e);
            }
        }
    });
});

/* ------------------------------
Loading イメージ表示関数
引数： msg 画面に表示する文言
------------------------------ */
function dispLoading(msg){
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
function removeLoading(){
    $("#loading").remove();
}

// bootbox-rails
(function() {
  const handleConfirm = function(element) {
    if (!allowAction(this)) {
      Rails.stopEverything(element);
    }
  }
	
  const allowAction = function(element) {
    if (element.getAttribute('data-confirm') === null) {
      return true;
    }
    showConfirmationDialog(element);
    return false;
  }

  const showConfirmationDialog = function(element) {
    const message = element.getAttribute('data-confirm');
    const opts = {
      message: message,
      buttons: {
          confirm: {
              label: 'はい',
              className: 'btn-success'
          },
          cancel: {
              label: 'いいえ',
              className: 'btn-danger'
          }
      },
      callback: function(result) {
        if (result) {
          element.removeAttribute('data-confirm');
          element.click();
        }
      }
    };
    bootbox.confirm(opts);
  }
  
  document.addEventListener('rails:attachBindings', function(element) {
    Rails.delegate(document, 'a[data-confirm], input[data-confirm], button[data-confirm]', 'click', handleConfirm);
  });
}).call(this)

// for side-bar
function activeBar(e) {
    var navdiv = $(e).parent("div");
    e.style.backgroundColor = "White";
    navdiv.show();
    $("#" + navdiv.attr("aria-labelledby")).addClass("active");
}

function closeSide() {
    $("#sideWrapper").hide("slow");
    $("#myContent").removeClass("col-md-10");
    $("#myContent").addClass("col-md-12");
    setTimeout(function(){
        $(window).trigger('resize');
    }, 1000);
}
