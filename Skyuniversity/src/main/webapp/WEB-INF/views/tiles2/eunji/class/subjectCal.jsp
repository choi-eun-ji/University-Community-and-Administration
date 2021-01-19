<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8' />
  <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.5.1/main.min.css' rel='stylesheet'/>
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.5.1/main.min.js'></script>
<script>

  document.addEventListener('DOMContentLoaded', function() {
	  
	  $.ajax({
			url: "<%= request.getContextPath() %>/calendarSub.sky",
			type: "GET",
			dataType: "json",
			success: function(json) {

				 var calendarEl = document.getElementById('calendar');

				 var calendar = new FullCalendar.Calendar(calendarEl, {
				 headerToolbar: {
				     left: 'prev,next today',
				     center: 'title',
				     right: 'dayGridMonth,timeGridWeek,timeGridDay'
				 },
				 initialDate: '2021-01-01',
				 navLinks: true, // can click day/week names to navigate views
				 selectable: true,
				 selectMirror: true,
				 
				 // 일정을 등록해주는 함수
				 select: function(arg) {
					  var title = prompt('일정등록 - 일정명을 입력해주세요.');
					  if(title) {
						     calendar.addEvent({
						         title: title,		// 일정명 등록
						         start: arg.start,	// 일정 시작시간 등록
						         end: arg.end,		// 일정 마감시간 등록
						         allDay: arg.allDay
						     })
					  }
					  // 일정명 등록시, 공백 유효성 검사 
					  if(title.trim().length == 0){
						  alert("일정제목은 필수 입니다. 다시 입력해주세요.");
					  }
					  else{
						  // Ajax를 통해 일정 정보를 controller 단에 보내줌.
						  $.ajax({
							url: "<%= request.getContextPath() %>/addCalendar.sky",
							contentType: "application/x-www-form-urlencoded; charset=UTF-8",
							data: {"title":title,
								   "start":arg.start,
								   "end":arg.end},
							type: "GET",
							dataType: "json",
							success: function(json) {
								// 일정 등록을 성공하였을 때
								if(json.flag){
									alert("일정이 등록되었습니다.");
									location.reload();
								}
								// 일정 등록을 실패하였을 때
								else{
									alert("일정이 등록이 실패하였습니다.");
									location.reload();
								}
							},
							error: function(request, status, error){
					               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					        }
						  }); //------------------ end of ajax
					  }	//--------------------- end of else 
				  }, //-------------------- end of function
				  // 일정 삭제 함수
			      eventClick: function(arg) {
					 	if (confirm('해당일정을 삭제하시겠습니까?')) {
					    	// Ajax를 통해 삭제할 일정을 controller 단에 보내줌.
					 		$.ajax({
								url: "<%= request.getContextPath() %>/deleteCalendar.sky",
								contentType: "application/x-www-form-urlencoded; charset=UTF-8",
								data: {"title":arg.event.title,
									   "start":arg.event.start,
									   "end":arg.event.end},
								type: "GET",
								dataType: "json",
								success: function(json) {
									// 일정 삭제에 성공하였을 때
									if(json){
										alert("일정을 삭제하였습니다.");
										location.reload();
									}
									// 일정 삭제에 실패하였을 때
									else{
										alert("일정 삭제에 실패하였습니다.");
										location.reload();
									}
								},
								error: function(request, status, error){
						               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						        }
							});	//------------------end of ajax
					    }  //-------------------end of if()
					 },  //------------------end of function()
					 editable: false,	 // 일정 편집 가능여부
					 dayMaxEvents: true, // allow "more" link when too many events
					 events: json
				});

				calendar.render();
			},
			error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});	//------------------end of ajax
  });

</script>
<style>

  body {
    margin: 40px 10px;
    padding: 0;
    font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
    font-size: 14px;
  }

  #calendar {
    max-width: 1100px;
    margin: 0 auto;
  }

</style>
</head>
<body>

  <div id='calendar'></div>

</body>
</html>
