<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%

	//쿠키 사용 後
	int days=0;
	Cookie[]cookies = request.getCookies();
	if(cookies!=null){
		
		for(Cookie c : cookies){
			
			if(c.getName().equals("forOption")){
				days = Integer.parseInt(c.getValue());
				
			}			
		}
		//System.out.println("쿠키 가져왔어 : "+days);
	}
	
	int fromDate=0;
	String fromThisDay = (String)request.getAttribute("fromThisDay");
	if(fromThisDay!=null){
		fromDate = Integer.parseInt(fromThisDay);
		System.out.println(fromDate);
	}
	
	//---------------------------------------------------------
	//0611 > 작성 이력이 있는, 일자와 일정을 출력하기
	
 	String tempDay = (String)request.getAttribute("savedDay");
	String savedPlan = (String)request.getAttribute("savedPlan");
	
	int savedDay=0;
	if(tempDay!=null){
		savedDay = Integer.parseInt(tempDay);
		System.out.println("변환함. 직전에 저장한 일자 : "+tempDay);
		System.out.println("저장한 일자의 일정 : "+savedPlan);
	} 
	//---------------------------------------------------------
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>planner</title>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css"/>
<script src="http://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>



    <div id="container">
	        <div id="left">
	            <div id="myBox">
	                <h1 id="yourPlanner">Your planner</h1>

			                <div>            	
			                			<!-- 0611 : select>option, change 時 데이터 제출하는 것 (0610버전 -> 0611버전 : 열람만 하기) -->
	 		                			<form action="<%=request.getContextPath()%>/temp.do" method="post" id="submitDayPlan">
				                				<input type="hidden" id="dayPlan" name="dayPlan_" value="">
			            		    			<input type="hidden" id="tempSave" name="tempSave_" value="">
			            		    			<input type="hidden" id="newDay" name="newDay_" value="">
					           			</form>   
			                	
			                	<!-- 사용자가 입력한 일수 만큼, select > option이 생성되도록 구현함 -->
				                	<select id="daysOption" style="width:310px; margin-left:10px; font-size:20px;">
				                	</select>			                			                
			                </div>		                
			            
			            	<div id="plannerBox">
			                <div id="dayPlanner">
			                	<div id="titleBox">
			                		<h3 id="dayTitle"></h3>&nbsp<h4 style="margin-top:23px;">번째 날의 계획</h4>
			                	</div>
	
			                	
			                <!-- 드래그 앤 드롭 (시험 예시) : 장소 관련 카드가 생성될 것임. 후에 구현할 것! innerText에는 장소名, value는 장소코드 등이 저장되겠다 -->
			                
									<div id="detailPlan"></div>					
									
										    <div id="dropZone" >
 										    	<div id="p1" class="box_drag" draggable="true" >plan 1</div>
										        <div id="p2" class="box_drag" draggable="true" >plan 2</div>
										        <div id="p3" class="box_drag" draggable="true" >plan 3</div>
										        <div id="p4" class="box_drag" draggable="true" >plan 4</div>
										        <div id="p5" class="box_drag" draggable="true" >plan 5</div>
										        <div id="p6" class="box_drag" draggable="true" >plan 6</div>
										        <div id="p7" class="box_drag" draggable="true" >plan 7</div> 
										        <!-- <div></div> -->
										    </div>              	
					                </div>
					                
					                <div id="buttons">
					                	<button id="save">작성 완료</button>
					                	<button id="delete" onclick="deleteSchedule();">작성 취소</button>
					                </div>
					                
					        </div>
	            		</div>
	         </div>
	    </div>
	            		
	            		<script>
		                /* 여행 일수 기준 select > option생성하기 */
		                	const daysOption = document.getElementById("daysOption");
		                	const inputDay = <%=days%>;
							let day = 1;
							
							for(let i=0;i<inputDay;i++){
								const option = document.createElement("option");
								option.innerText= day++;
								option.value=option.innerText;
								console.log(option.innerText, option.value);
								daysOption.appendChild(option);
							}
							
							
		            	/* option변경할 때마다, "day n의 여행계획"으로 출력될 텍스트가 변경되도록 구현 */
		            	
	            		
							const thisDay = document.querySelector("#daysOption>option").value;
	            			
							//document.getElementById("dayTitle").innerText= "Day "+thisDay+"의 여행계획";
							//document.getElementById("dayTitle").innerText= thisDay;
							document.getElementById("dayTitle").innerText= <%=fromDate!=0?fromDate:1%>
							
							
	            				//0613------------------------------------------------------------------
	            				//1. select 前/後 일자 정보 가져오기
	            				
	            				let preCho = "";
	            				let nowCho = "";
	            				
	            				daysOption.addEventListener("focus", e=>{
	            					daysOption.blur();
	            					preCho = daysOption.value;
	            					
	            				});
							
														
	            				daysOption.addEventListener("change",e=>{
	            					
	            					nowCho = daysOption.value;
	            					console.log("이전", preCho);
	            					console.log("지금", nowCho);
	            					
	            					
	            						
				            		const cards = document.querySelectorAll("div#dropZone>div"); //장소 관련 카드들 불러오기
				            		console.log(cards);
				            		
				            		//0613---------------------------------------------------------------
				            		//임시저장 개념이므로, 저장소를 DB 대신 localStorage로 변경함
				            		
	            					//console.log("현재 저장된 일정이 있는지", localStorage.getItem(nowCho));
	            					const savedPlanTemp = localStorage.getItem(nowCho);
	            					if(savedPlanTemp!=null){
	            						const savedPlan = savedPlanTemp.split(",");
	            						console.log("배열로 받아온",nowCho,"의 일정",savedPlan);
	            						
	            						
	            						//작성 기록이 있다면, 카드를 새로 생성해서 출력해주기
	            						let cntId = 1;
	            						document.getElementById("dropZone").innerHTML=""; //계속 appendChild하면 누적되므로, 먼저 비워주기
	            						
										for(let i=0;i<savedPlan.length;i++){
											//cards.innerText = savedPlan[i];
																					
											const div = document.createElement("div");											
											const num = savedPlan[i].slice(-1);
											console.log("숫자 확인 : ",num);
											
 											div.id="p"+num;
											div.innerHTML = savedPlan[i];
											//div.className= "box_drag";
											div.classList.add("box_drag");
											div.setAttribute("draggable",true);
											document.getElementById("dropZone").appendChild(div);
										}
	            						
										clearDragEvent();
										addDragEvent();
										
	            					} else {
	            						
	            							
	            						
	            						
	            						
	            					}
				            		
				            						            		
				            		//장소 방문 순서 편집 관련 로직---------------------------------------------
				            		
					            		let arr=[]; //"카드"의 innerText정보는 배열에 저장하기
					            		console.log(arr);
					            		
					            		for(let i=0;i<cards.length;i++){					            			
					            			arr[i] = cards[i].innerText;					            			
					            		}					            		
					            		console.log(arr);
				            						            						            		
					            		let tempString = arr.join(","); //구분자(콤마)를 기준으로, 배열 內 인덱스 정보들을 하나의 문자열로 변환함
					            		console.log(tempString); //문자열로 잘 변환됐는지 확인				           
				        
									//이전 것을 저장한 이후에
									//1. 일자 바꾸기
			            			document.getElementById("dayTitle").innerText= nowCho;
			            			
			            			//select 변경 時, 편집한 카드 배열 내용을 localStorage에 해당 일자의 일정을 저장함
			            			localStorage.setItem(preCho,arr);
			            			
			            			//if 문으로 선택 값에 따라 getItem하면 될 거 같다... null 등이 아니면 get이후에 set하면 되지 않을까?
			            					
			            			console.log("확인 : ",localStorage.getItem(preCho));
			            			if(localStorage.getItem(preCho)!=null){
			            				console.log("비어있지는 않아");
			            			}
				            		
	            			});

	            				

			            			
   
		                </script>
		                
		                
		                <script>
	            		
		                
		                		function addDragEvent(){
		                			
		                			document.querySelector('#dropZone').addEventListener('dragover', dragover_handler);
		                			 
									document.querySelector('#dropZone').addEventListener('drop', drop_handler);
									
									const elements = document.querySelectorAll(".box_drag");
			            	        elements.forEach(e => e.addEventListener("dragstart", dragstart_handler));
		                		}
		                		
		                		
		                		
								function clearDragEvent(){
		                			
		                			document.querySelector('#dropZone').removeEventListener('dragover', dragover_handler);
									document.querySelector('#dropZone').removeEventListener('drop', drop_handler);
									const elements = document.querySelectorAll(".box_drag");
			            	        elements.forEach(e => e.removeEventListener("dragstart", dragstart_handler));
		                		}
		                		
		                		
		                		window.addEventListener('DOMContentLoaded', () => {
		                			addDragEvent();
			            	    });
		                		
		                		
		            			/* 드래그 앤 드롭 관련 */
		            		    
		            	        function dragstart_handler(ev) {
		            	          // 데이터 전달 객체에 대상 요소의 id를 추가합니다.
		            	          ev.dataTransfer.setData("text/plain", ev.target.id);
		            	          ev.dataTransfer.idx = 1111111111;
		            	          console.dir('///////////////dragstart_handler////////////////');
			            	         console.dir(ev);
		            	        }
		            	      
		            	      /*   window.addEventListener('DOMContentLoaded', () => {
		            	          // id를 통해 element를 가져옵니다.
		            	          const elements = document.querySelectorAll(".box_drag");
		            	          elements.forEach(e => e.addEventListener("dragstart", dragstart_handler));
		            	        }); */
		
		            	        function dragover_handler(ev) {
		            	         ev.preventDefault();
		            	         ev.dataTransfer.dropEffect = "move";
		            	        }
		
		            	        function drop_handler(ev) {
		            	         ev.preventDefault();
		            	         console.dir('///////////////drop////////////////');
		            	         console.dir(ev);
		            	         const data = ev.dataTransfer.getData("text/plain");
		            	         dropZone.insertBefore(document.getElementById(data),ev.target);
		            	        }
	            	     	            		
	            		</script>	

     		
            	
	            	


<!-- 지도 -->
<%--   <%@include file="/views/planner/map.jsp" %>  --%>
	
</body>
</html>