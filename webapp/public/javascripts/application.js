// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var contacts = {};
var mailbox  = {};
contacts.getVcard = function(id){
    $.ajax({
	    complete: function(request){
		location.hash = "#contact/"+id+"/vcard";
	    }, 
	    success: function(request){		
		$("div#contact_display").html(request);		    
	    }, 
	    type:'get', 
	    url: "/people/"+id
	});        
}

function getHeight(){
    //setting of height of windows
    var myHeight = 0;
    if( typeof( window.innerWidth ) == 'number' ) {
	myHeight = window.innerHeight;
    } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
	myHeight = document.documentElement.clientHeight;
    } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
	myHeight = document.body.clientHeight;
    }
    return myHeight;
}

mailbox.selectThis = function(id){
    $("table#message_list tr.selected").removeClass('selected');
    $("table#message_list tr#"+id).addClass('selected');
}
mailbox.selectLeftBar = function(id){
    $("ul#local_nav li.active").removeClass('active');
    $("ul#local_nav li#"+id).addClass('active');
}
mailbox.id = function(){
    return($("ul#local_nav li.active a[id]").attr("id"));
}
function getMailboxUrl(){
    return("/mailboxes/"+$("ul#local_nav li.active").attr("id").split("_")[1]);
}
function clickBackToInbox(){
    //making 'back to inbox' work
    $("div#message_nav a#back_to_inbox").click(function(){
	    fetchMails(getMailboxUrl(), $("ul#local_nav li.active").attr("id"));
	});
}
function assignMenuEvent(){
    $("#assign_menu").change(function(){
	     $.ajax({
		     dataType: "json",
		     success: function(data){			 
			 $("#status_menu").val(data["status"]);
			 setIphoneStatus(data["status"]);
		     },
			 type: 'post', 
			 url: '/tickets/assign/',
			 data: {user_id: $("#assign_menu").attr("value"), "tickets[]": $("input[name='ticket_id']").attr("value")}
		 });
	});
}
function changeStatus(tickets, status){
    $.ajax({
	    dataType: "json",
		success: function(data){
		setIphoneStatus(data["status"]);
		$("#assign_menu").val(data["user_id"]);
	    },
		type:'post', 
		url:'/tickets/changeStatus/',
		data: {"tickets[]": tickets, status: status}
	});
}

function statusMenuEvent(){
    $("#status_menu").change(function(){
	    changeStatus($("input[name='ticket_id']").attr("value"), $("#status_menu").attr("value"));
	});
}
function setIphoneStatus(status){
    if(status!="3"){
	$('.on_off :checkbox').iphoneStyle({
	     checkedLabel: 'Open',
	     uncheckedLabel: 'Closed'
	 });
    }else{
	$('.on_off :checkbox').iphoneStyle({
	     checkedLabel: 'Closed',
	     uncheckedLabel: 'Open'		
	 });
    }
}
function noteFormSubmit(){
    $("#add_note_form").submit(function(){
	    $.ajax({
		    success: function(data){		    			
			$("#thread").prepend(data);
			$("#no_of_notes").html(parseInt($("#no_of_notes").html())+1);
			$("#note_errors").css("display", "none");
			$("#add_note_form").css("display", "none");
			$("#note_body").val("");
		    },
		    error: function(data){	
			$("#note_errors").append(data.responseText).css("display", "block");
		    }, 
			type:'POST', url:'/notes/create',
			data:{"note[note]": $("#note_body").val(), "note[parent_id]": $("input[name='ticket_id']").attr("value"), "note[parent_type]": "ticket"} 
		});
	    return(false);
	});
}
function attachMailReplyEvent(replyType){
    tickets = getTickets();
    if(tickets.length>0){
	$.ajax({
		beforeSend: function(request){
		    removeContainers();
		}, 
	       complete: function(request){
		    clickBackToInbox();
		    $("div#toolbar").toggle();
		    location.hash = "#thread/"+tickets[0]+"/reply";
		}, 
		success: function(request){		
		    $("div#main_pane").append(request);		    
		}, 
		    type:'get', 
		    url: "/tickets/"+tickets[0]+"/mails/new?type="+replyType
		    });
    }else{
	alert("No conversations selected");
    }
}
function attachMailClickEvents(){
    $("table#message_list tbody tr:id").each(function(idx, tr){	
	    $(tr).find("td:gt(2)").click(function(idx){
		    url = 'mailboxes/'+mailbox.id()+'/mails/'+$(tr)[0].id
		    $.ajax({
			    beforeSend: function(){ 
				removeContainers();
			    },
			    complete: function(request){
				location.hash=url;
				mailbox.selectThis($(tr)[0].id);
				assignMenuEvent();
				statusMenuEvent();
				clickBackToInbox();
				noteFormSubmit();
				//$("table#message_list").remove();
				$("div#toolbar").toggle();
			    }, 
				success: function(request){
				//$("<div id='thread_container'>").append(request).appendTo("div#main_pane");
				$("div#main_pane").append(request);
			 $("div#thread_container").attr("style", "height: "+(getHeight()-105)+"px;");    
			 if($(tr).hasClass("unread")){
			     $(tr).removeClass("unread");
			     $(tr).find("td.indicator img:first").toggle();
			 }
			 setIphoneStatus($("#status_menu").val());
			    }, 
				type:'get', 
				url: url
				});
		});
	});
}
function dettachMailClickEvents(){
    $("table#message_list tbody tr:id").each(function(idx, tr){	
	    $.unbind('click', $(tr));
    });
}
function attachMailStatusToggleEvent(){
    $("table#message_list tbody tr").each(function(idx, tr){
	    $(tr).find("td:eq(1)").click(function(idx){	    
		    $.ajax({
			    success: function(request, response){
				if(request==="1"){
				    $(tr).addClass("unread");
				    $(tr).find("td.indicator img:first").toggle();
				}else{
				    $(tr).removeClass("unread");
				    $(tr).find("td.indicator img:first").toggle();
				}
				$("table#message_list").toggle();
			    }, 				
				type:'get', 
				url:'/mails/mark_as_read/'+$(tr)[0].id
				});
		});
	});
}
function attachMailCheckboxToggle(){
    $("table#message_list input").click(function(){
	    if($(this).attr("checked")){
		$(this).parent().parent().addClass("selected");
	    }else{
		$(this).parent().parent().removeClass("selected");
	    }	    
	    if(getTickets().length>1){
		$("div#toolbar li:lt(2)").each(function(){
			$(this).css("display", "none");
		    });
	    }else{
		$("div#toolbar li:lt(2)").each(function(){
			$(this).css("display", "inline");
		    });
	    }
	});
}
function update_unread_count(mailbox_id){
    $("span#unread_count_"+mailbox_id)[0].innerHTML-=1;
}
function fetchMails(url, barid){
    $.ajax({
	    beforeSend: function(){
		removeContainers();
	    },
	    complete: function(){
		mailbox.selectLeftBar(barid); 
		location.hash=url;
	    },
		success: function(request){
		$("div#toolbar").css("display", "block");
		if($("div#message_nav"))
		    $("div#message_nav").remove();
		$(request).appendTo($('div#list_container'));
		attachMailClickEvents(); 
		attachMailStatusToggleEvent();
		attachPaginationLinks();
		attachMailCheckboxToggle();
	    }, 
		type:'get', 
		url: url
		});
}
function removeContainers(){
    if($("#thread_container")){
	$("#thread_container").remove();
	$("#thread_meta").remove();
    }
    if($("#compose_message")){
	$("#compose_message").remove();
    }
    if($("table#message_list")){
	$("table#message_list").remove();
    }
}
function getTickets(){
    var tickets=[];
    if($("div#list_container") && $("table#message_list").length>0){
	$("table#message_list tr:id input:checked").each(function(){
		tickets.push($(this).parent().parent().attr("id"));
	    });
    }else if($("div#thread_container")){	
	tickets.push($("div#thread input:hidden").attr("value"));
    }
    return(tickets);
}
function attachPaginationLinks(){
    $("ul.pagination li a").click(function(){
	    page_id = $(this).html();
	    mailbox_id=$("ul#local_nav li.active").attr("id").split("_")[1];
	    if(mailbox_id==="all"){
		url='/mailboxes?page='+page_id;
	    }else{
		url="/mailboxes/"+mailbox_id+"/mails?page="+page_id;
	    }
	    fetchMails(url, "mailboxes_"+mailbox_id);
	});
}

function removeTicket(action){
    tickets=getTickets();	    
    if(tickets.length>0){
	var data = {'ticket_ids[]': tickets, 'mailbox_id': mailbox.id(), 'last_mail_id': $("table#message_list tr[id]:last").attr("id")} 
	$.ajax({
		success: function(data){		    
		    $.each(tickets, function(index, id){
			    $("table#message_list tr#"+id).remove();
			});
		    $("table#message_list tbody").append(data);
		}, 
		    type: 'POST', 
		    data: data,
		    url: "/tickets/"+action
		    });
    }else{
	alert("No conversations selected");
    }
}

$(window).ready(function(){
    fetchMails("mailboxes", "mailboxes_all");	
    $("ul#local_nav li").click(function(){
	    mailbox_id=$(this).attr("id");
	    url = $(this).attr("id").split("_").join("/");
	    fetchMails(url, mailbox_id);
	    if($(this).attr("id")==="mailboxes_trashed"){
		$(this).find("a img").attr("src", "/images/indicators/disclosure_down_active.png");
		$("#mailbox_trash_list").css("display", "block");
	    }
	});    

    $("a#delete_button").click(function(){
	    removeTicket("trash");
	});
    
    $("a#junk_button").click(function(){
	    removeTicket("junk");
	});   
    $("a#reply_all_button").click(function(){	    
	    attachMailReplyEvent("reply_all");
	});
    $("a#reply_button").click(function(){	    
	    attachMailReplyEvent("reply");
	});
    $("a#refresh_button").click(function(){	    
	    mailbox_id=$("ul#local_nav li.active").attr("id").split("_")[1];
	    url="/mailboxes/"+mailbox_id;
	    fetchMails(url, "mailbox_"+mailbox_id);
	});
    $("a#assign_button").click(function(){
	    $.ajax({
		    success: function(data){
			$("<div>").attr("id", "users_list").append(data).addClass("autocomplete").hide().appendTo("div#toolbar").fadeIn("fast");
			$(window).click(function(){$("div#users_list").hide();});
			$("div#users_list ul li").click(function(li){
				username=$(this).html();
				tickets = getTickets();
				if(tickets.length>0){
				    $.ajax({
					    success: function(data){
						$.each(tickets, function(){
							$("tr#"+this+" td:eq(6)").html("assigned");
						    });
						$("div#toolbar").before($("<p>").addClass("noticeExplanation").append("Assigned to "+username).fadeIn(200));
						setTimeout(function(){
							$("p.noticeExplanation").fadeOut(200, $.remove);
						    }, 4000);
					    },
					    type:'post', url:'/tickets/assign/',data:{user_id: this.id, "tickets[]": tickets},					    
				    });
				}else{
				    $("div#toolbar").before($("<p>").addClass("errorExplanation").append("No message selected to be assigned.").fadeIn(1000));
				    setTimeout(function(){
					    $("p.errorExplanation").fadeOut(1000, $.remove);
					}, 2000);
				}
			 });
		    }, 				
			type:'get', 
			url:'/clients/1/users/'
			});
	});
    $("a#close_button").click(function(){
	    tickets=getTickets();	    
	    if(tickets.length>0){
		var data = {'ticket_ids[]': tickets, 'mailbox_id': mailbox.id(), 'last_mail_id': $("table#message_list tr[id]:last").attr("id")} 
		$.ajax({
			success: function(data){		    
			    $.each(tickets, function(){
				    $("tr#"+this+" td:eq(6)").html("closed");
				});
			    $("div#toolbar").before($("<p>").addClass("noticeExplanation").append("Closed").fadeIn(200));
			    setTimeout(function(){
				    $("p.noticeExplanation").fadeOut(200, $.remove);
				}, 4000);
			}, 
			    type:'post', url:'/tickets/changeStatus/',data:{"tickets[]": tickets, status: 3} 
		});
	    }else{
		alert("No conversations selected");
	    }
	});
    $("div#contact_list_container p[id]").click(function(){
	    $("div#contact_list_container p.selected").each(function(){
		    $(this).removeClass("selected");
		});
	    $(this).addClass("selected");
	    contacts.getVcard($(this).attr("id"));
	});
    
    $("div#main_pane").css("height", (getHeight()-45)+"px");    
    if($("div#contact_list_container"))
	$("div#contact_list_container").css("height", (getHeight()-45)+"px;");
    if($("div#contact_display"))
	$("div#contact_display").css("height", (getHeight()-45)+"px;");
});