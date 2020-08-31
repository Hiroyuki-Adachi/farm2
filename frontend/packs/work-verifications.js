$(function() {
    $("#tbl_list").floatThead({
        position: 'absolute',
        scrollContainer:true,
        zIndex: 999
    });
    $(window).resize(function() {
        setTableWrapperHeight();
    });

    $("#list").on('click', ".show-work", function() {
        execShow($(this).data("url"));
    });
    $("#list").on('click', ".execute", function() {
        execCreate($(this).data("url"), $(this).data("work"));
    });
    $("#list").on('click', ".cancel", function() {
        execDestroy($(this).data("url"));
    });

    setTableWrapperHeight();
});

function setTableWrapperHeight() {
    if($("#list")[0]) {
        $("#list").height($(window).height() - $("#list").offset().top - $("#btn_toolbar").height() - 15);
    }
}

function execCreate(url, work_id) {
    loading.disp("承認中...");
    $.ajax({
        url: url,
        type: "POST",
        data: {work_id: work_id},
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
    loading.disp("取消中...");
    $.ajax({
        url: url,
        type: "DELETE",
        dataType: "html"
    }).done(function(html) {
        $("#list").html(html);
    }).always(function() {
        loading.remove();
        changePrint($("#print_self")[0]);
    });
    return false;
}

function execShow(url) {
    $.ajax({
        url: url,
        type: "GET",
        dataType: "html"
    }).done(function(html) {
        $("#show_work_body").html(html);
        $("#show_work").modal({keyboard: true});
    }).always(function() {
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