var timeoutWarningTimer;
var timeoutExpiredTimer;
$(document).ready(function() {
  // -------------- Common UI --------------
  // flash messages
  $("#flash .close").livequery(
  'click',function(){
   $("#flash").empty(300); return false;});
  // help db language overlay
  $("a[rel=#database-language]").overlay({
    fixed: false, // allows user to scroll if overlay extends beyond viewport
    expose: {color: '#fff', loadSpeed: 200, opacity: 0.5}
  });
 
  // start/cancel a new form for a participant
  $("#involvement_forms a[rel=#start_form]").livequery(
    'click', function(){
      $("#new_form").load( $(this).attr("href")); 
      return false;
      }
      );
  $("#involvement_forms a[rel=#cancel_form]").livequery(
    'click', function(){
      $("#involvement_forms").load( $(this).attr("href")); 
      return false;
      }
      );
  $("#study_charts").livequery( function(){
    var x = $(this).html();
    jQuery.globalEval(x);
  });
  $(".date").livequery(function(){
      $(this).datepicker({ changeYear: true , changeMonth: true , dateFormat: 'yy-mm-dd',yearRange: '-20:+0', autoSize: true });
  });
  $(".dob").livequery(function(){
      $(this).datepicker({ changeYear: true , changeMonth: true , dateFormat: 'yy-mm-dd',yearRange: '-120:+0', autoSize: true });
  });
  //new and edit event type for a study
  $("#event_types a[rel=#event_type]").livequery(
    'click', function(){
     $("#edit_create_event_type").load( $(this).attr("href"));
     return false;
           }
     );
  //cancel event_type creation/edit
  $("#event_types a[rel=#cancel_eventtype]").livequery(
    'click', function(){
     $("#edit_create_event_type").empty();
     return false;
           }
     );
  //create event
  $("#new_involvement_event").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#involvement_events").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      }
      );
  //edit event
  $(".edit_involvement_event").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#involvement_events").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      }
      );
  //create involvement
  $("#new_involvement").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#pane").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      }
      );

  //create/update event_type
  $("#new_event_type").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#event_types").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      }
      );


  //create/update event_type
  $(".edit_event_type").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#event_types").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      });

  //create/update event_type
  $(".delete_event_type").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#event_types").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      });

  //edi involvement
  $(".edit_involvement").livequery(
    'submit', function(){
      $.post($(this).attr("action"),$(this).serialize(),
      function(data,textStatus,jqXHR) {
      $("#involvement_demographics").html(data);
      $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
      },
      "html");
      return false;
      }
      );

  //cancel events creation/edit
  $("#involvement_events a[rel=#cancel_event]").livequery(
    'click', function(){
      $("#involvement_events").load( $(this).attr("href")); 
      return false;
      }
      );

  //new event
  $("#involvement_events a[rel=#new_event]").live(
    'click', function(){
      $("#new_event").load( $(this).attr("href")); 
      return false;
      }
      );
  //edit event
  $("#involvement_events a[rel=#edit_event]").livequery(
    'click', function(){
      $("#new_event").load( $(this).attr("href")); 
      return false;
      }
      );

  //delete event
   $('#involvement_events .delete_event').livequery(function() {
      if ($(this).attr("confirm_msg")) {
         var confirm_msg = $(this).attr("confirm_msg");
     } else {
         var confirm_msg = "Are you sure?";
     }
     //$(this).removeAttr('onclick');
     //$(this).unbind('click', false);
     $(this).click(function(e) {
     if (confirm(confirm_msg)) {
        $.post($(this).attr("action"), $(this).serialize(),
        function(data,textStatus,jqXHR) {
        $('#involvement_events').html(data);
        $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
        
        },
        'html');
         return false;
       }else{
          e.preventDefault();
         return $(this);
       }
     });
      }
    
   );


  //edit involvement
  $("#pane_actions a[rel=#edit_involvement]").livequery(
    'click', function(){
      $("#involvement_demographics").load( $(this).attr("href")); 
      return false;
      }
      );

  //view involvement details
  $("#pane a[rel=#involvement_detail]").livequery(
    'click', function(){
      $("#pane").load( $(this).attr("href")); 
      return false;
      }
      );
  //add a new subject
  $("#pane_actions a[rel=#add_subject]").livequery(
    'click', function(){
      $("#pane").load( $(this).attr("href")); 
      return false;
      }
      );
  //import subjects
  $("#pane_actions a[rel=#import_subjects]").livequery(
    'click', function(){
      $("#pane").load( $(this).attr("href")); 
      return false;
      }
      );
  //load study settings
  $("#study_information a[rel=#study_settings]").livequery(
    'click', function(){
      $("#pane").load( $(this).attr("href")); 
      return false;
      }
      );


  // -------------- Medical services --------------
  // Study service forms
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
  // Also, if checked is the saved state
  var d2 = $("#medical_service_expects_bedded_inpatients_true").attr("checked");
  if (d2 === true){
    $("#d2").fadeIn('slow');
  }
  // The service bedding description overlay
  $("#bedded_helper_link").click(function(){
    $("#bedded_description").overlay({ expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }, api: true }).load(); 
  });
  // update button activation
  $("#service_studies input[type=submit]").attr('disabled', true);
  $(".radios :input").click(function(){
    $("#service_studies input[type=submit]").attr('disabled', false);
  });
  
  // -------------- My studies --------------
  // index (my studies) datatable
  $('#my_studies .display').dataTable( { "sPaginationType": "full_numbers" });
  
  // -------------- Show study --------------
  // tabs
  $("#actions").tabs("#pane", {effect: 'ajax'});
    
  // subjects: dataTable
  $("#subject_list").livequery(function(){$(this).dataTable({
    "aoColumns": [null,null,null,null,null,{"sType":"date"},null],
    "iDisplayLength": 30,
    "sPaginationType": "full_numbers", 
    "sScrollX": "100%",
    "sScrollXInner": "110%",
    "bScrollCollapse": true,
    "bFilter": true,
    "oLanguage": {"sZeroRecords": "<p><strong>No subjects yet - click 'Add' or 'Import' to get started. Or watch our <a rel='#intro'>4 minute introduction to eNOTIS</a>.</strong></p>"}
  });});

  $('#subject_list_filter').livequery(function(){$(this).appendTo($('#search'));});

  //involvement forms list
  $("#form_list").livequery(function(){$(this).dataTable({
    "aoColumns": [{"sType":"date"},null,null,null,null],
    "bPaginate" : false,
    "oLanguage": {"sZeroRecords": "<p><strong>No forms yet - click 'Add' to get started. </strong></p>"}
  });});


  //involvement event list datatable
  $("#event_list").livequery(function(){$(this).dataTable({
    "aoColumns": [null,{"sType":"date"},null,null],
    "bPaginate" : false,
    "oLanguage": {"sZeroRecords": "<p><strong>No forms yet - click 'Add' to get started. </strong></p>"}
  });});

  //study forms datatable
  $("#study_forms .display").livequery(function(){$(this).dataTable({
    "aoColumns": [null,null,null,{"sType":"date"},{"sType":"date"}],
    "iDisplayLength": 10,
    "sPaginationType": "full_numbers"
  });});

  //study event types datatable
  $("#event_types .display").livequery(function(){$(this).dataTable({
    "aoColumns": [null,null,null],
    "iDisplayLength": 10,
    "sPaginationType": "full_numbers"
  });});

  // load some tab contents via ajax for minimal change from previous UI (overlays)
  //$('#add').load($('#add').attr('rel'), 'format=js', activateMrnLookup);
  //$('#import').load($('#import').attr('rel'), 'format=js', activateImportDataTable);
  //$('#export').load($('#export').attr('rel'), 'format=js', activateExportCheck);
  
  // import dataTable
    // console.log('activateImportDataTable');
    $("#pane .uploads .display").livequery(function(){$(this).dataTable({
      "iDisplayLength": 10,
      "sPaginationType": "full_numbers",
      "aoColumns": [{ "sType": "string", "asSorting": [ "desc", "asc" ] }, null, null, null, null]
    });});
  
  // show study: datatable paging - redraw dashes for empty cells, activate other studies and view/edit overlays
  //function activateRows(){
  //  // introduction (for empty datatable) overlay
  //   $("#subjects a[rel=#intro]").overlay({
  //    fixed: false, // allows user to scroll if overlay extends beyond viewport
  //    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 }
  //  });
  //  // dashes
  //  $("#import .display td:empty").html("--");
  //  // other studies overlay
  //  $("#subjects a[rel=#other_studies]").overlay({
  //    fixed: false, // allows user to scroll if overlay extends beyond viewport
  //    onBeforeLoad: function(){ $("#other_studies .wrap").load(this.getTrigger().attr("href"), "format=js", activateAccept); },
  //    expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
  //    onClose: function(){$("#other_studies .wrap").html("");}
  //  });
  //  // involvement overlay
  //  activateInvolvementOverlay(".display a[rel=#involvement]");
  //  // 'delete' links
  //  $('#subjects a.delete').deleteWithAjax();
 // }
 
  
  
/*
  //function activateMrnLookup(){
    // console.log('activateMrnLookup');
    // look up MRN
   $("#involvement_events a[rel=#delete_event]").livequery('click',function() {
       //if ($(this).attr("confirm_msg")) {
       //var confirm_msg = this.attr("confirm_msg");
       //} else {
       //var confirm_msg = "Are you sure?";
       //}
       //$(this).removeAttr('onclick');
       //$(this).unbind('click', false);
       $(this).click(function(e) {
       //if (confirm(confirm_msg)) {
         $.delete_($(this).attr("href"), $(this).serialize(), 
         function(data,textStatus,jqXHR) {
         $("#involvement_events").html(data);
         $("#flash").html(jqXHR.getResponseHeader('x-flash') + '<div class=close></div>');
         }, "html");
        return false;
       //}else{
       //  e.preventDefault();
       //}
       });
       //return this;
     }
   );
*/

    $("a[rel=#mrn_lookup]").livequery(function()
     {$(this).overlay(
      {
      fixed: false,
      onBeforeLoad: function(){ 
        mrns = $("#new_involvement #involvement_subject_attributes_nmff_mrn, #new_involvement #involvement_subject_attributes_nmh_mrn, #new_involvement #involvement_subject_attributes_ric_mrn");
        if(_.all(mrns, function(a){ return $(a).val() == "";})){
          alert('Please enter an MRN to look up');
          return false;
        }else{
          $("#mrn_lookup .wrap").load(this.getTrigger().attr("href"), mrns.serialize() + "&format=js");
        }
      },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onClose: function(){$("#mrn_lookup .wrap").html("");}
    });});
    
    activateInvolvementFields("#add");
    $("#add a.cancel").live("click", function(e){ e.preventDefault(); $("#add :input").val(''); $("#add :checkbox").attr('checked', '');});
    
  //}
  
  // MRN Lookup
  $('#mrn_lookup .wrap .subject a.transfer').live("click", function(e){
    e.preventDefault();
    var fields = $(this).parent('.subject').find('input');
    $.each(fields, function(i,a){
      $('#involvement_subject_attributes_'+$(a).attr('id')).val($(a).val());
      $('#involvement_'+$(a).attr('id')).val($(a).val());
    });
    $("a[rel=#mrn_lookup]").data("overlay").close();
  });
  
 /** // involvement overlay
  //function activateInvolvementOverlay(selector){
  //  $(selector).overlay({
  //    fixed: false, // allows user to scroll if overlay extends beyond viewport
  //    closeOnClick: false, // to prevent closing accidentally when dismissing datepickers
      onBeforeLoad: function(){ $("#involvement .wrap").load(this.getTrigger().attr("href"), "format=js"); },
      expose: { color: '#fff', loadSpeed: 200, opacity: 0.5 },
      onLoad: function(event){
        // console log check to see if date inputs are loaded yet. usually inconsistent results. for debugging.
        // console.log($("#involvement input.occurred_on"));
        // console.log($("#involvement input.dob"));

        // involvement cancel link
        $("#involvement a.cancel").live("click", function(e){ e.preventDefault(); event.target.close();});
        
        activateInvolvementFields("#involvement");
      }
    });
  }
*/

  // involvement form checkboxes and datepickers
  // these functions have been changed to "live", to counteract the timing problem of the objects not being loaded when onLoad is called
  function activateInvolvementFields(selector){
    
    // clear race checkboxes if unknown or not reported is checked
    $(selector + ' #involvement_unknown_or_not_reported_race:checked').parents('li.race').find(':checkbox').not('#involvement_unknown_or_not_reported_race').attr('checked', false).attr('disabled', true);
    
    // race checkboxes should disble sibling checkboxes
  	$(selector + ' #involvement_unknown_or_not_reported_race:checkbox').live("click", function(){
      var e = $(this);
      var others = e.parents('li.race').find(':checkbox').not('#involvement_unknown_or_not_reported_race');
      if(e.is(':checked')){
        others.attr('checked', false).attr('disabled', true);
      }else{
        others.attr('disabled', false);
      }
    });
    
    // datepicker for involvements
    
    // datepicker for birth date
   // $("input.dob").livequery("click", function(){
   //   if(!$(this).data("dateinput")){
   //     $(this).dateinput({format: 'yyyy-mm-dd', selectors: true, yearRange: [-120, 1],
   //       change: function(e, date){ e.target.getInput().val(e.target.getValue('yyyy-mm-dd')).data("date", date); return false; },
   //       onShow: function(e){
   //         $(selector + " #calmonth").unbind("change").change(function() { e.target.hide().setValue($(selector + " #calyear").val(), $(this).val(), e.target.getValue('d')).show(); });
   //         $(selector + " #calyear").unbind("change").change(function() { e.target.hide().setValue($(this).val(), $(selector + " #calmonth").val(), e.target.getValue('d')).show(); });
   //       }
   //     });
   //     $(this).data("dateinput").show();
   //   }
   // });
  }
  
  // export tab
  function activateExportCheck(){
    $('#report :checkbox').click(disableEmptyReports);
    disableEmptyReports();
  }
  function disableEmptyReports(){
    // disable export button if no boxes are checked
    $('#report :submit').attr('disabled', $('#report :checkbox:checked').length == 0);
  }

  
  // show study: other studies overlay - bind an event onto the accept link that loads the other studies view into the same overlay
  function activateAccept(){
    $("#other_studies .wrap a.accept").click(function(e){
      $("#other_studies .wrap").load($(e.target).attr("href"), "format=js");
      e.preventDefault();
    });
  }
    
  // -------------- Search --------------
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
  
  // -------------- session timeouts --------------
  function timeoutWarning(){ $("#session-expire").overlay({ expose: { color: '#fff', loadSpeed: 200, opacity: 0.93 }, closeOnClick: false, api: true }).load(); }
  function timeoutExpired(){ if(window.location.pathname != "/studies"){ window.location.href = '/studies'; } }
  function resetTimeouts(){
    clearTimeout(timeoutWarningTimer);
    clearTimeout(timeoutExpiredTimer);
    timeoutWarningTimer = setTimeout(timeoutWarning, 5*60*1000); // 5 minutes
    timeoutExpiredTimer = setTimeout(timeoutExpired, 30*60*1000); // 30 minutes
  }
  resetTimeouts();
  $(document).click( resetTimeouts ).keyup( resetTimeouts );
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
