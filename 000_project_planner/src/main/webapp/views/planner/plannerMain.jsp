<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%

	//쿠키 사용 後
	int days=0;
	String theme = "";
	String title = "";
	int area = 0;
	int sigungu = 0;
	
	Cookie[]cookies = request.getCookies();
	if(cookies!=null){
		
		for(Cookie c : cookies){
			
			if(c.getName().equals("forOption")){ //여행 일자
				days = Integer.parseInt(c.getValue());				
			}
			
			if(c.getName().equals("forTheme")){ //여행 테마
				theme = c.getValue();
			}
			
			if(c.getName().equals("forTitle")){ //플랜 제목
				title = c.getValue();
			}
			
			if(c.getName().equals("forArea")){ //여행 일자
				area = Integer.parseInt(c.getValue());				
			}
			
			if(c.getName().equals("forSigungu")){ //여행 일자
				sigungu = Integer.parseInt(c.getValue());			
			}
			
		}		
	}
	
	
	
	//localStorage 사용 前 -------------------------------------
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
	//0614 > "새로고침"할 경우, "localStorage"의 저장 데이터는 유지되나, 
	//화면 상에서는 1번째 날의 계획이 리셋됨... 그리고 화면상에서 데이터가 리셋된 채로 option값을 이동하게 되면 실제 localStorage값도 리셋됨! 
	
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>planner</title>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css"/>
<link href="https://fonts.googleapis.com/css2?family=Rubik:ital,wght@1,800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">
<script src="http://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>


	<div id="wrap">
    <div id="container">
	        <div id="left">
	            <div id="myBox">
	                <h1 id="yourPlanner" style="font-family:Rubik;">Your planner</h1>

			                <div>            	
			                			<!-- 0611 : select>option, change 時 데이터 제출하는 것 (0610버전 -> 0611버전 : 열람만 하기) -->
	 		                			<form action="<%=request.getContextPath()%>/temp.do" method="post" id="submitDayPlan">
				                				<input type="hidden" id="dayPlan" name="dayPlan_" value="">
			            		    			<input type="hidden" id="tempSave" name="tempSave_" value="">
			            		    			<input type="hidden" id="newDay" name="newDay_" value="">
					           			</form>   
			                	
			                	<!-- 사용자가 입력한 일수 만큼, select > option이 생성되도록 구현함 -->
				                	<select id="daysOption">
				                	</select>			                			                
			                </div>		                
			            
			            	<div id="plannerBox">
			                <div id="dayPlanner">
			                	<div id="titleBox">
			                		<h3 id="dayTitle" style=""></h3>&nbsp<h4 style="margin-top:23px;font-family:Noto Sans KR">번째 날의 계획</h4>
			                	</div>
			                	<div>
			                		<h5 id="deleteInfo">* 더블클릭 시, 카드를 삭제할 수 있습니다</h5>
			                	</div>
			                	
			                	
	
			                	
			                <!-- 드래그 앤 드롭 (시험 예시) : 장소 관련 카드가 생성될 것임. 후에 구현할 것! innerText에는 장소名, value는 장소코드 등이 저장되겠다 -->
			                
									<div id="detailPlan"></div>					
									
										    <div id="dropZone">
<!--  										    <div id="p1" class="box_drag" draggable="true" >plan 1</div>
										        <div id="p2" class="box_drag" draggable="true" >plan 2</div>
										        <div id="p3" class="box_drag" draggable="true" >plan 3</div>
										        <div id="p4" class="box_drag" draggable="true" >plan 4</div>
										        <div id="p5" class="box_drag" draggable="true" >plan 5</div>
										        <div id="p6" class="box_drag" draggable="true" >plan 6</div>
										        <div id="p7" class="box_drag" draggable="true" >plan 7</div>  -->
										        <!-- <div></div> -->
										    </div>              	
					                </div>
					                
					        </div>
	            		</div>
	            		<div id="buttons">
					         <button id="save" onclick="saveSchedule();">작성 완료</button>
					         <button id="delete" onclick="deleteSchedule();">작성 취소</button>
					     </div>

					     
	         </div>
	         	 </div>
 	     	     	<%@include file="/views/planner/plannerMap.jsp" %> 
	   			 </div>


	    
	    
	    	          		
	            		<script>
	            		
	            		
	            		//새로고침 時, 편집 내용이 소멸될 수 있음을 알림
	            		window.onbeforeunload = function(e){
	            			
	            			let warning = '변경사항이 저장되지 않을 수 있습니다!';
	            			e.returnValue = warning;
	            			return warning;
	            			
	            		};
	            		

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
							document.getElementById("dayTitle").innerText= <%=fromDate!=0?fromDate:1%>
							
							
							let markersArr = [];
		            		function printMyLog(myLog, logArr){ //일자 별 마커 및 선 출력 + 옵션 전환 時 선 삭제
		            			
		            			
		            			
			            		for(let i=0;i<myLog.length;i++){	
			            			
									    //마커 출력하기 ------------------------------------------------------------------------------								    
									    // 마커 이미지의 이미지 크기 입니다
									    var imageSize = new kakao.maps.Size(36, 37); 
									    
									    // 마커 이미지를 생성합니다    
									    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
									    
									    // 마커를 생성합니다
									    var marker = new kakao.maps.Marker({
									        map: map, // 마커를 표시할 지도
									        //position: positions[i].latlng, // 마커를 표시할 위치
									        position: new kakao.maps.LatLng(myLog[i].latitude, myLog[i].longitude),
									        title : myLog[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
									        image : markerImage // 마커 이미지 
									    });
									    
									    //마커 간 선으로 연결하기 ------------------------------------------------------------------------
			
										logArr.push(new kakao.maps.LatLng(myLog[i].latitude, myLog[i].longitude));
									    markersArr.push(marker);
									    console.log(markersArr);
									
			            		}
    
									    // 지도에 표시할 선을 생성합니다
									    var polyline = new kakao.maps.Polyline({
									        path: logArr, // 선을 구성하는 좌표배열 입니다
									        strokeWeight: 5, // 선의 두께 입니다
									        strokeColor: '#FFAE00', // 선의 색깔입니다
									        strokeOpacity: 0.7, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
									        strokeStyle: 'solid', // 선의 스타일입니다
									        endArrow:'true' //화살표 표시
									    });
				
									    // 지도에 선을 표시합니다 
									    polyline.setMap(map);              						
			
										//드래그 & 드롭 이벤트 관련
										
										//clearDragEvent();
										//addDragEvent();
									
									//-----------------------------------------------------------------
 										daysOption.addEventListener("change",e=>{ //옵션 변경 시, 현재 일정에 해당하는 선과 마커를 지움!
 										
 										
		 										if(polyline!=null&&polyline.setMap()!=null){ //선 삭제
													polyline.setMap(null);
		 										}
		 										
 												//console.log("마커 확인///////////",markersArr);
 												//console.log("마커 확인2//////////", myMarkers);
		  										if(markersArr!=null&&markersArr.length!=0){ 
		  											
		 											 markersArr.forEach(e=>{
		 												 //console.log("//////////전환 확인", e);
		 												 e.setVisible(false);
		 											 });
		 										
		  										} 
										
										});
			            			
			            		}
		            		
			
								//0614-----------------------------------------------------------------
								//1. 1일차의 데이터를 localStorage에 저장했으나 "새로고침"할 경우 화면상 카드는 리셋됨을 확인함!
								//0615-----------------------------------------------------------------
								//2. 장소 정보를 객체로서 저장함! 객체의 정보를 재가공하지 않고, 적절히 꺼내 쓸 수 있도록 구현하기
								const dayOnePlan = JSON.parse(localStorage.getItem(1));
								var imageSrc = 'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-256.png'; //마커 이미지
								var linePath = [];	
								
								
								//console.log(dayOnePlan[0].id);
								
								if(dayOnePlan!=null&&thisDay==1){
									console.log("1일차 데이터 있어", dayOnePlan);
									
									//1. 리스트 > 장소 카드 관련
									//> 데이터가 있다면, 새로고침 시에도 해당 장소 데이터가 출력되도록 로직 구현하기
									//const dayOnePlanArr = dayOnePlan.split(",");
									//console.log("배열로 바꾸면? ", dayOnePlanArr);
									//printMyLog(dayOnePlan,linePath);									
            						document.getElementById("dropZone").innerHTML=""; //계속 appendChild하면 누적되므로, 먼저 비워주기
            						
									for(let i=0;i<dayOnePlan.length;i++){				
									
 										const div = document.createElement("div"); //태그 만들기
										
 										div.setAttribute("day", 1);
										div.setAttribute("id", dayOnePlan[i].id);
										div.setAttribute("placeName", dayOnePlan[i].placeName);
										div.setAttribute("latitude", dayOnePlan[i].latitude);
										div.setAttribute("longitude", dayOnePlan[i].longitude);
										div.setAttribute("memo", dayOnePlan[i].memo);
										
										div.innerText = dayOnePlan[i].placeName;
										div.classList.add("box_drag");
										div.setAttribute("draggable",true);
										document.getElementById("dropZone").appendChild(div); 
																			
										deletePlace(div);
										moveMap(div);
										 
									}
            						
									printMyLog(dayOnePlan,linePath);

									
				
								}
								
		
		            				//0613------------------------------------------------------------------
		            				//1. select 前/後 일자 정보 가져오기
		            				
		            				let preCho = "";
		            				let nowCho = "";
		            				
		            				daysOption.addEventListener("focus", e=>{
		            					daysOption.blur();
		            					preCho = daysOption.value;
		            					
		            				});
							
														
	            					daysOption.addEventListener("change",e=>{ //옵션 전환 시, 
	            					//선택 옵션 일자에 저장된 일정이 있다면 해당 일정 정보를 출력하고, 
	            					//)
	            					
	            					
 		            					console.log("마커 확인2//////////", myMarkers);
		            						myMarkers.forEach(e=>{ 
		            							//TODO 0618) 이전 option에서 생성한 마커들 삭제하고 싶었으나, (문제 : 만든 것들 일괄적으로 사라진다는 점)
		            							//mapTest2.jsp의 moveTo()메소드에서, 카드에 mouseover 시, 대응되는 좌표에 마커가 임시적으로 생성됐다 사라지는 로직 구현
		            							//그러나 지도 상에서는 마커를 확인할 수 없으니 불편하고 가독성도 좋지 않음...
		            							//(설사, 마커를 표시한다고 해도, 해당 마커에 대한 이벤트는 존재하지 않음. 만약 마커를 출력할 수 있다면 마우스 오버 시, 제공되는 서비스가 있어야 할듯. 인포윈도우를 띄우든가)
		            							e.setVisible(false);
		            							//전일자의 마커만 안 보이도록 구현할 수는 없을까?
	            							}); 

	            					
	            					nowCho = daysOption.value;
	            					console.log("이전", preCho); //select창에 출력된 "일자" 저장하기
	            					console.log("지금", nowCho); //option을 선택함으로써 "변경된 일자"저장하기
	            					//ex. 1일자->2일자 변경 시, preCho는 1, nowCho는 2가 됨
					
				            		const cards = document.querySelectorAll("div#dropZone>div"); //장소 관련 카드들 불러오기
				            		console.log("현재 dropZone에 추가된 카드 : (저장 이력이 없는 경우에는 없을 수도 있음!)",cards);
				            		
				            		//0615 > 디폴트 카드 삭제. 저장된 일정이 없다면, 카드를 출력하지 않음. 
				            		//0613---------------------------------------------------------------
				            		//임시저장 개념이므로, 저장소를 DB 대신 localStorage로 변경함
				            		
	            					const savedPlan = JSON.parse(localStorage.getItem(nowCho));
	            					let lineArr = []; //라인을 그어주기 위해서 만듦!

	            					
	            					
	            					if(savedPlan!=null&&savedPlan.length!=0){
	            									
	            								console.log("배열로 받아온",nowCho,"의 일정",savedPlan);  	
        	            						//1. 작성 기록이 있다면, 카드를 새로 생성해서 출력해주기
        	            						document.getElementById("dropZone").innerHTML=""; //계속 appendChild하면 누적되므로, 먼저 비워주기
	            						
												for(let i=0;i<savedPlan.length;i++){
																							
													const div = document.createElement("div");				
													
													div.setAttribute("day", nowCho);
													div.setAttribute("id", savedPlan[i].id);
													div.setAttribute("placeName", savedPlan[i].placeName);
													div.setAttribute("latitude", savedPlan[i].latitude);
													div.setAttribute("longitude", savedPlan[i].longitude);
													div.setAttribute("memo", savedPlan[i].memo);
													
													div.innerText = savedPlan[i].placeName;
													div.classList.add("box_drag");
													div.setAttribute("draggable",true);
													document.getElementById("dropZone").appendChild(div); 
													
													deletePlace(div); //더블클릭 시, 리스트에서 장소 삭제됨
													moveMap(div);
		
										
						            				}

														printMyLog(savedPlan,lineArr);									
														clearDragEvent();
														addDragEvent();
														
	            									} else {
	            	            						//0615) 선택한 일자로 저장된 일정이 없으면, 디폴트 : 카드 없음
	            	            						document.getElementById("dropZone").innerHTML="";
	            									}

				            		
				            						            		
				            			//플래너 내용 작성 > 장소 방문 순서 편집 관련 로직---------------------------------------------
				            		
					            		let arr=[]; //"카드"의 정보(아이디, 장소명, 위도, 경도 -> 객체化)는 arr배열에 저장하기
					            		
					            		//장소의 정보를 저장하기 위해 > "생성자 함수"만들기
					            		
					            		console.log("///////////////!!!!!!!!!?/////////", nowCho);
					            		
					            		function Places(day,id,placeName,latitude,longitude,memo){
					            			
					            			this.day = day;
					            			this.id = id;
					            			this.placeName = placeName;
					            			this.latitude = latitude;
					            			this.longitude = longitude;
					            			this.memo = memo;
					           
					            		}
					            		
					            		
					            		for(let i=0;i<cards.length;i++){	
					            			
					            			//생성자 함수로 "장소"객체 생성 후, 배열arr에 저장하기
					           				arr.push(new Places(
					           									cards[i].getAttribute("day"),
					           									cards[i].getAttribute("id"),
					           									cards[i].getAttribute("placeName"),
					           						            cards[i].getAttribute("latitude"),
					           						            cards[i].getAttribute("longitude"),
					           						            cards[i].getAttribute("memo")));
					            			
					            		}
					            		
					            		
					            		console.log(arr);
				            						            						            				           
				        
									//다음 option으로 전환되기 전, 마무리 작업 (2가지)
									//1. 타이틀 > 출력 일자 바꾸기
			            			document.getElementById("dayTitle").innerText= nowCho;
			            			
			            			//select 변경 時, 편집한 카드 배열 내용을 localStorage에 해당 일자의 일정으로 저장함
			            			
			            			localStorage.setItem(preCho,JSON.stringify(arr));
			            			
			            			//if 문으로 선택 값에 따라 getItem하면 될 거 같다... null 등이 아니면 get이후에 set하면 되지 않을까?
			            					
			            			console.log("현재 편집한 일정이 잘 저장됐는지 확인 : "
			            					    ,JSON.parse(localStorage.getItem(preCho)));
			            			
	            			});
	            			
	            			</script>
	            			
          			
	            			<script>
	            			//플래너 작성내용 저장||삭제 기능 구현--------------------------------------------------
	            			
	            			//팝업 창 위치 관련
	            			var popupX = (document.body.offsetWidth/2)-(200/2);
	            			var popupY = (window.screen.height/2)-(300/2);
	            			console.log("변수 확인",popupX, popupY);
	            			
	            			const deleteSchedule = ()=>{
	            				//alert("삭제하시겠습니까?");
	            				window.open("<%=request.getContextPath()%>/deleteTempLog.do","title","width=400,height=200 left="+popupX+",top"+popupY);
	            				
	            			}
	            			
	            			const saveSchedule = ()=> { //TODO 0619) AJAX로 객체배열 전송하기
	            				alert("저장하시겠습니까?"); 
	            			
	            				
	            				

	            				
<%-- 	            			tempArr = JSON.parse(localStorage.getItem(1));
	            				console.log(tempArr); //첫 번째 날
	            				
	            				let jsonData = JSON.stringify(tempArr[0]); //첫 번째 방문장소
	            				console.log(jsonData);
	            				
            				
 	            				$.ajax({
	            					
	            					url : "<%=request.getContextPath()%>/planner/saveLog.do",
	            					type : "get",
	            					data : {"jsonData" : jsonData}, 
	            					dataType : "json",
	            					contentType : "application/json",
	            					success : function(data){
	            						console.log("저장 완료");
	            					}, 
	            					error : function(data){
	            						console.log("저장 실패");
	            					}
	            					
	            				});  --%>
 	            				
 	            				
 	            				//localStorage 반복문!
	            				
	            				let jsonData = "";
	            				let tempArr = [];
 	            				
 	            				for(let i=0;i<localStorage.length;i++){
	            					
	            					tempArr = JSON.parse(localStorage.getItem(i+1)); //일자 별로 저장된 데이터 가져오기
	            					
	            					console.log("객체배열 확인", (i+1)+"일자의 일정 : ", tempArr);
									let cnt = 0;
	            					
	            					for(let a=0;a<tempArr.length;a++){
	            						
	            						//일자별 객체배열, Servlet에 전송하기 > Ajax 활용
	            						console.log((i+1), "일자의 일정 : ", tempArr[a]);
	            						jsonData = JSON.stringify(tempArr[a]);
	            						//여기에 ajax로 하나씩 서블릿에 보내 java객체化한 다음에, 해당 객체를 list에 차곡차곡 저장할 수 있을까?--------------------------
	            						
	     	            				$.ajax({
	    	            					
	    	            					url : "<%=request.getContextPath()%>/planner/saveLog.do",
	    	            					type : "get",
	    	            					data : {"jsonData" : jsonData}, 
	    	            					dataType : "json",
	    	            					async : false,
	    	            					contentType : "application/json",
	    	            					success : function(data){
	    	            						console.log("저장 완료");
	    	            					}, 
	    	            					error : function(data){
	    	            						console.log("저장 실패");
	    	            					}
	    	            					
	    	            				}); 		

	            					}	            						            					            					
	            				} 
	            				

            					

	            				
	            			}
	            			

		                </script>
		                
		                
		                <script>
	            		//드래그 앤 드롭 이벤트 관련
		                
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
		            	          //console.dir('///////////////dragstart_handler////////////////');
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
		            	         //console.dir('///////////////drop////////////////');
		            	         console.dir(ev);
		            	         const data = ev.dataTransfer.getData("text/plain");
		            	         
		            	         //console.log(ev.target.indexOf);
		            	         const divItems = document.querySelectorAll("div#dropZone>div");
		            	         // console.log(divItems.length);
		            	         //console.dir(ev.target.nextElementSibling);
		            	         
		            	         //태그 상 마지막 노드에 카드를 추가하고자 할 때, "insertBefore"함수 구현하기
		            	         if(ev.target.nextElementSibling!=null){
		            	         	dropZone.insertBefore(document.getElementById(data),ev.target);
		            	         } else dropZone.insertBefore(document.getElementById(data), null);
		            	         
		            	        }
	            	     	            		
	            		</script>
	            		


</body>
</html>