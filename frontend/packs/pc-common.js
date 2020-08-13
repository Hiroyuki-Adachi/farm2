import '../stylesheets/pc-common';
window.loading = require("../javascripts/loading");

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

// bootbox-rails
$(function() {
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

  const confirmed = function(element, result) {
    if (result.value) {
      // User clicked confirm button
      element.removeAttribute('data-confirm')
      element.click()
    }
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
        confirmed(element, {value: result});
      }
    };
    bootbox.confirm(opts);
  }
  
  $("a[data-confirm]").on('click',handleConfirm);
});

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
