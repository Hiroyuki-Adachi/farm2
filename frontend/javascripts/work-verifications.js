import { Modal } from 'bootstrap';

$(function() {
    $("#tbl_list").floatThead({
        position: 'absolute',
        scrollContainer:true,
        zIndex: 999
    });
    $(window).resize(function() {
        setTableWrapperHeight();
    });

    $("#print_self").on('change', function() {
        changePrint($(this)[0]);
    });

    $("#list").on('click', ".show-work", function() {
        execShow($(this).data("url"));
    });

    setTableWrapperHeight();
});

$(window).on('load', function() {
    $("#print_self").attr("checked", true);
    changePrint($("#print_self")[0]);
});

function setTableWrapperHeight() {
    if($("#list")[0]) {
        $("#list").height($(window).height() - $("#list").offset().top - $("#btn_toolbar").height() - 15);
    }
}

function execCreate(url) {
    verificationModal.hide();
    verificationModal = null;

    loading.disp("承認中...");
    $.ajax({
        url: url,
        type: "PUT",
        headers: {
            'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
        },
        dataType: "html"
    }).done(function(html) {
        $("#list").html(html);
    }).always(function() {
        loading.remove();
        changePrint($("#print_self")[0]);
    });
    return false;
}

function execDestroy(url) {
    verificationModal.hide();
    verificationModal = null;
    loading.disp("取消中...");
    $.ajax({
        url: url,
        type: "DELETE",
        headers: {
            'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
        },
        dataType: "html"
    }).done(function(html) {
        $("#list").html(html);
    }).always(function() {
        loading.remove();
        changePrint($("#print_self")[0]);
    });
    return false;
}

let verificationModal = null;
function execShow(url) {
    $.ajax({
        url: url,
        type: "GET",
        dataType: "html"
    }).done(function(html) {
        $("#show_work_content").html(html);
        verificationModal = new Modal(document.getElementById("show_work"));
        verificationModal.show();
    }).always(function() {
        $("#work_exec").on('click', function() {
            execCreate($(this).data("url"), $(this).data("work"));
        });
        $("#work_cancel").on('click', function() {
            execDestroy($(this).data("url"));
        });
    });
    return false;
}

function changePrint(checkbox) {
    if(checkbox.checked) {
        $("[name='self_flag']").closest("tr").hide();
    } else {
        $("#tbl_list").find("tr").show();
    }
}