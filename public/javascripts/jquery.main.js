$(document).ready(function() {
  // flash messages
  $("#flash .close").click(function(){$("#flash").fadeOut(300); return false;});

  // index (my studies) datatable
  $('#my_studies .display').dataTable( {
   "oLanguage": { "sProcessing": '/images/spinner.gif' },
   "bProcessing": true,
   "bServerSide": true,
   "sPaginationType": "full_numbers",
   "sAjaxSource": "studies.json"
  });
  
  // show study: datatable
  $("#accrual .display").dataTable({
    "fnDrawCallback": activateRows,
    "iDisplayLength": 30,
    "sPaginationType": "full_numbers", 
    "oLanguage": {"sZeroRecords": "<p><strong>No subjects yet - click 'Add' or 'Import' to get started. Or watch our <a rel='#intro'>4 minute introduction to eNOTIS</a>.</strong></p>"}
  });
  
  // show study: datatable paging - redraw dashes for empty cells, activate other studies and view/edit overlays
  function activateRows(){
    // introduction (for empty datatable) overlay
    $("a[rel=#intro]").overlay({
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
    });
  
    // dashes
    $("#accrual .display td:empty, #import .display td:empty").html("--");
    
    // other studies overlay
    $("a[rel=#other_studies]").overlay({
      onBeforeLoad: function(){ $("#other_studies .wrap").load(this.getTrigger().attr("href"), "format=js", activateAccept); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onClose: function(){$("#other_studies .wrap").html("");}
    });
    
    // involvement overlay
    $("a[rel=#involvement]").overlay({
      onBeforeLoad: function(){ $("#involvement .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onLoad: function(event){
        // dateinput
        $("#involvement input.occurred_on").dateinput({format: 'yyyy-mm-dd', selectors: true, yearRange: [-20, 1]});
        $("#involvement input.dob").dateinput({format: 'yyyy-mm-dd', selectors: true, yearRange: [-120, 1],
          change: function(e, date){ e.target.getInput().val(e.target.getValue('yyyy-mm-dd')).data("date", date); return false; },
          onShow: function(e){
            $("#calmonth").unbind("change").change(function() { e.target.hide().setValue($("#calyear").val(), $(this).val(), e.target.getValue('d')).show(); });
            $("#calyear").unbind("change").change(function() { e.target.hide().setValue($(this).val(), $("#calmonth").val(), e.target.getValue('d')).show(); });
          }
        });
        // cancel link
        $("#involvement a.cancel").click(function(e){ e.preventDefault(); event.target.close();});
      }
    });
    
    // 'delete' links
    $('#accrual a.delete').deleteWithAjax();
  }
  
  // show study: other studies overlay - bind an event onto the accept link that loads the other studies view into the same overlay
  function activateAccept(){
    $("#other_studies .wrap a.accept").click(function(e){
      $("#other_studies .wrap").load($(e.target).attr("href"), "format=js");
      e.preventDefault();
    });
  }
  
  // show study: import overlay
  $("#actions a[rel=#import]").overlay({
    onBeforeLoad: function(){ $("#import .wrap").load(this.getTrigger().attr("href"), "format=js"); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  });

  // show study: export overlay
  $("#actions a[rel=#export]").overlay({
    onBeforeLoad: function(){ $("#export .wrap").load(this.getTrigger().attr("href"), "format=js"); },
    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  });
  
  // show study: report overlay
  $("a[rel=#report]").overlay({
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

  // search page
  // jQuery('#results a[rel=#study_information]').tooltip({position: 'center right', offset: [-1*jQuery('#results').offset().top, -1*jQuery('#results').offset().left]});
  //  $("#subject_results .subject_display").dataTable({"aoColumns": [{ "sType": "html" }]});

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