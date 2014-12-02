// SetUp datepicker for all data-behaviour
$(document).ready(function(){
    setup_currency();
    setup_date_picker();
    setup_tooltips_types();
    focus_the_first_input();
    add_alert_to_form_error();
    prevent_click_on_disabled();
    // TODO metodo que joga fixed on top MENU se tiver datepicker? Achar uma forma paleativa de por o fixed top e margin top se quebrar o Datepicker
});

// Re-add it dropdown-menu event for every page:change
$(document).on("page:change", function() {
    $(".navbar .dropdown").hover((function() {
        $(this).find(".dropdown-menu").first().stop(true, true).slideDown();
    }), function() {
        $(this).find(".dropdown-menu").first().stop(true, true).slideUp();
    });
});

/*
 * placement = left,right,top,bottom
 */
function set_up_tiper(tipers, placement) {
    for(i in tipers) {
        tiper = $(tipers[i]);
        tiper.attr('data-toggle', 'tooltip');
        tiper.attr('data-placement', placement);
    }
}

// SetUp DatePicker listener event
function setup_date_picker() {
    var datepicker_input = $('[data-behaviour~="datepicker"]');
    if(datepicker_input == undefined || datepicker_input === undefined) return;

    datepicker_input.datepicker({
        autoclose: true,
        format: 'dd/mm/yyyy',
        language: 'pt-BR',
        startDate: 'today'
    });
}

// Tooltips types setup
function setup_tooltips_types() {
    tipers = $('.tooltiper.top');
    set_up_tiper(tipers, 'top');

    tipers = $('.tooltiper.bottom');
    set_up_tiper(tipers, 'bottom');

    tipers = $('.tooltiper.left');
    set_up_tiper(tipers, 'left');

    tipers = $('.tooltiper.right');
    set_up_tiper(tipers, 'right');

    $('.tooltiper').tooltip({trigger:'hover'});
}

// Dynamic class alert added
function add_alert_to_form_error() {
    $('#error_explanation').addClass('alert alert-danger');
}

function prevent_click_on_disabled() {
    $('.disabled').click(function(e){
        e.preventDefault();
    });
}

// show the Ad dynamic after it "upload_intent"
function show_ad_image(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e){
            $('#new_ad_image')
                .attr('src',e.target.result);
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// SetUp mask for currency inputs
function setup_currency() {
    $('.currency_mask').maskMoney();
}

// Focus the first input on the form
function focus_the_first_input() {
    setTimeout(function(){
        $($('form input')[3]).focus();
    }, 300);
}