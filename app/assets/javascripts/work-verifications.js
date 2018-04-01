$(function() {
    $("#tbl_list").floatThead({
        position: 'absolute',
        scrollContainer:true
    });
    $(window).resize(function() {
        setTableWrapperHeight();
    });

    $(document).on({
        'mouseenter': function() {
            var e = $(this);
            e.off('hover');
            $.get(e.data('url'), function(data) {
                e.popover({content: data, html: true});
                e.popover('show');
            });
        },
        'mouseleave': function() {
            var e = $(this);
            e.popover('hide');
        }},
        'span.hover'
    );

    setTableWrapperHeight();
});

function setTableWrapperHeight() {
    if($("#list")[0]) {
        $("#list").height($(window).height() - $("#list").offset().top - $("#btn_toolbar").height() - 15);
    }
}

function execCreate(url, work_id) {
    dispLoading("承認中...");
    $.ajax({
        url: url,
        type: "POST",
        data: {work_id: work_id},
        dataType: "html"
    }).done(function(html) {
        $("#list").html(html);
    }).always(function() {
        removeLoading();
    });
    return false;
}

function execDestroy(url) {
    dispLoading("取消中...");
    $.ajax({
        url: url,
        type: "DELETE",
        dataType: "html"
    }).done(function(html) {
        $("#list").html(html);
    }).always(function() {
        removeLoading();
    });
    return false;
}
