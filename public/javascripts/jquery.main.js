var importTable; // global variable to keep track of import data table, preventing reinitialization
$(document).ready(function() {
 
  //Study service forms
  $("#medical_service_uses_services_before_completed_true").click(function(){
    $("#d1").fadeIn('slow');
  });
  $("#medical_service_uses_services_before_completed_false").click(function(){
    $("#d1").fadeOut('slow');
  });
   //Also, if checked is the saved state
  var d1 = $("#medical_service_uses_services_before_completed_true").attr("checked");
  if (d1 === true){
    $("#d1").fadeIn('slow');
  }

  $("#medical_service_expects_bedded_inpatients_true").click(function(){
    $("#d2").fadeIn('slow');
  });
  $("#medical_service_expects_bedded_inpatients_false").click(function(){
    $("#d2").fadeOut('slow');
  });  
  // Also, if checked is teh saved state
  var d2 = $("#medical_service_expects_bedded_inpatients_true").attr("checked");
  if (d2 === true){
    $("#d2").fadeIn('slow');
  }

  // The service bedding description overlay
  $("#bedded_helper_link").click(function(){
    $("#bedded_description").overlay({ expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }, api: true }).load(); 
  });

  //update button activation
  $("#service_studies input[type=submit]").attr('disabled', true);
  $(".radios :input").click(function(){
    $("#service_studies input[type=submit]").attr('disabled', false);
  });

  // flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});

  // index (my studies) datatable
  $('#my_studies .display').dataTable( { "sPaginationType": "full_numbers" });
  
  // show study: datatable
  $("#accrual .display").dataTable({
    "aoColumns": [null,null,null,null,null,null,{"sType":"date"},null,null,null,{"sType":"date"},{"sType":"date"},null],
    "fnDrawCallback": activateRows,
    "iDisplayLength": 30,
    "sPaginationType": "full_numbers", 
    "oLanguage": {"sZeroRecords": "<p><strong>No subjects yet - click 'Add' or 'Import' to get started. Or watch our <a rel='#intro'>4 minute introduction to eNOTIS</a>.</strong></p>"}
  });
  
  // add link involvement overlay
  activateInvolvementOverlay("#actions a[rel=#involvement].add");
  
  // show study: datatable paging - redraw dashes for empty cells, activate other studies and view/edit overlays
  function activateRows(){
    // introduction (for empty datatable) overlay
    $("#accrual a[rel=#intro]").overlay({
      fixed: false, // allows user to scroll if overlay extends beyond viewport
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
  
    // dashes
    $("#accrual .display td:empty, #import .display td:empty").html("--");
    
    // other studies overlay
    $("#accrual a[rel=#other_studies]").overlay({
      fixed: false, // allows user to scroll if overlay extends beyond viewport
      onBeforeLoad: function(){ $("#other_studies .wrap").load(this.getTrigger().attr("href"), "format=js", activateAccept); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onClose: function(){$("#other_studies .wrap").html("");}
    });
    
    // involvement overlay
    activateInvolvementOverlay(".display a[rel=#involvement]");

    // 'delete' links
    $('#accrual a.delete').deleteWithAjax();
  }
  
  // involvement overlay
  function activateInvolvementOverlay(selector){
    $(selector).overlay({
      fixed: false, // allows user to scroll if overlay extends beyond viewport
      closeOnClick: false, // to prevent closing accidentally when dismissing datepickers
      onBeforeLoad: function(){ $("#involvement .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onLoad: function(event){
        // console log check to see if date inputs are loaded yet. usually inconsistent results. for debugging.
        // console.log($("#involvement input.occurred_on"));
        // console.log($("#involvement input.dob"));
        
        // these functions have been changed to "live", to counteract the timing problem of the objects not being loaded when onLoad is called
        
        // involvement cancel link
        $("#involvement a.cancel").live("click", function(e){ e.preventDefault(); event.target.close();});
        
        // clear race checkboxes if unknown or not reported is checked
        $('#involvement_unknown_or_not_reported_race:checked').parents('li.race').find(':checkbox').not('#involvement_unknown_or_not_reported_race').attr('checked', false).attr('disabled', true);
        
        // race checkboxes should disble sibling checkboxes
      	$('#involvement_unknown_or_not_reported_race:checkbox').live("click", function(){
          var e = $(this);
          var others = e.parents('li.race').find(':checkbox').not('#involvement_unknown_or_not_reported_race');
          if(e.is(':checked')){
            others.attr('checked', false).attr('disabled', true);
          }else{
            others.attr('disabled', false);
          }
        });
        
        // datepicker for involvements
        $("#involvement input.occurred_on").live("click", function(){
          if(!$(this).data("dateinput")){
            $(this).dateinput({format: 'yyyy-mm-dd', selectors: true, yearRange: [-20, 1],
              change: function(e, date){ e.target.getInput().val(e.target.getValue('yyyy-mm-dd')).data("date", date); return false; },
              onShow: function(e){
                $("#calmonth").unbind("change").change(function() { e.target.hide().setValue($("#calyear").val(), $(this).val(), e.target.getValue('d')).show(); });
                $("#calyear").unbind("change").change(function() { e.target.hide().setValue($(this).val(), $("#calmonth").val(), e.target.getValue('d')).show(); });
              }
            });
            $(this).data("dateinput").show();
          }
        });
        
        // datepicker for birth date
        $("#involvement input.dob").live("click", function(){
          if(!$(this).data("dateinput")){
            $(this).dateinput({format: 'yyyy-mm-dd', selectors: true, yearRange: [-120, 1],
              change: function(e, date){ e.target.getInput().val(e.target.getValue('yyyy-mm-dd')).data("date", date); return false; },
              onShow: function(e){
                $("#calmonth").unbind("change").change(function() { e.target.hide().setValue($("#calyear").val(), $(this).val(), e.target.getValue('d')).show(); });
                $("#calyear").unbind("change").change(function() { e.target.hide().setValue($(this).val(), $("#calmonth").val(), e.target.getValue('d')).show(); });
              }
            });
            $(this).data("dateinput").show();
          }
        });
      }
    });
  }
  
  // show study: other studies overlay - bind an event onto the accept link that loads the other studies view into the same overlay
  function activateAccept(){
    $("#other_studies .wrap a.accept").click(function(e){
      $("#other_studies .wrap").load($(e.target).attr("href"), "format=js");
      e.preventDefault();
    });
  }
  
  // show study: import overlay
  $("#actions a[rel=#import], #flash a[rel=#import]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    // only load this once (using wrap:empty selector) since uploads trigger a reload of the page
    onBeforeLoad: function(){ $("#import .wrap:empty").load(this.getTrigger().attr("href"), "format=js"); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
    onLoad: function(){
      if (typeof importTable == 'undefined') {
        importTable = $("#import .display").dataTable({
          "iDisplayLength": 10,
          "sPaginationType": "full_numbers",
          "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null]
        });
      }
    }
  });

  // show study: export overlay
  $("#actions a[rel=#export]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    onBeforeLoad: function(){ $("#export .wrap").load(this.getTrigger().attr("href"), "format=js"); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  });
  
  // show study: report overlay
  $("#actions a[rel=#report]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  });

  // show study: study details and charts slider
  $("#study a[rel=#study_information]").click(function(){
    $('#study_information').slideToggle();
    return false;
  });

  // search
  $('#study_results .display').dataTable( {
    "oLanguage": { "sProcessing": '/images/spinner.gif' },
    "bProcessing": true,
    "bServerSide": true,
    "sPaginationType": "full_numbers",
    "sAjaxSource": "search.json?" + $.param({query: $.getUrlVar('query')})
   });

  // search: study information tooltips
  $('#results a[rel=#study_information]').live('mouseover', function(event) {
    jQuery('#results a[rel=#study_information]').tooltip({position: 'center right', offset: [-1*jQuery('#results').offset().top, -1*jQuery('#results').offset().left]});
  });
  
  // session timeouts
  function timeOutWarning(){ $("#session-expire").overlay({ expose: { color: '#fff', loadSpeed: 200, opacity: 0.93 }, closeOnClick: false, api: true }).load(); }
  function timeOutExpired(){ if(window.location.pathname != "/studies"){ window.location.href = '/studies'; } }
  setTimeout(timeOutWarning, 5*60*1000); // 5 minutes
  setTimeout(timeOutExpired, 30*60*1000); // 30 minutes

});

// ajax for delete
jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");} });

function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
    callback = data;
    data = {};
  }
  return jQuery.ajax({
    type: method,
    url: url,
    data: data,
    success: callback,
    dataType: type
  });
}

jQuery.extend({
  put: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'PUT');
  },
  delete_: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'DELETE');
  }
});

jQuery.fn.deleteWithAjax = function() {
  if (this.attr("confirm_msg")) {
    var confirm_msg = this.attr("confirm_msg");
  } else {
    var confirm_msg = "Are you sure?";
  }
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.click(function(e) {
    if (confirm(confirm_msg)) {
      $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    }else{
      e.preventDefault();
    }
  });
  return this;
};

// getUrlVar used in search
$.extend({
  getUrlVars: function(){
    var vars   = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++){
      hash = hashes[i].split('=');
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }
    return vars;
  },
  getUrlVar: function(name){
    return $.getUrlVars()[name];
  }
});

