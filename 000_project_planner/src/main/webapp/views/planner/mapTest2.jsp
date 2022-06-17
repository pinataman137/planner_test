<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/mapStyle.css"/>

<!-- 지도 -->
	    	
<!-- 	<div class="container2">
		<button id="searchBox" class="z1" onclick="SearchBox();" width="30">search</button>
	</div> -->
	<div class="searchContainer">		
	</div>
	
		
		
<div class="map_wrap">
    <div id="map"></div>

    <div id="menu_wrap" class="bg_white">
<!--     	<div id="searchbox"> -->
		        <div class="option">
		            <div>
		            	<h1 id="listTitle" style="text-align:left;padding:10px;margin-bottom:0px;margin-left:5px;font-family:Rubik;">SEARCH!</h1>
		                <form onsubmit="searchPlaces(); return false;" id="searchBox">
		                    	<input type="text" value="에버랜드" id="keyword" size="40" placeholder="검색어를 입력하세요"> 
		                    	<button id="searchBtn" type="submit">검색하기</button> 
		                </form>
		            </div>
		        </div>
		        <hr id="listLine">
		        <ul id="placesList"></ul>
		        <div id="pagination"></div>
<!--         </div>    -->        
    </div>
</div>
<button id="likesBtn" style="font-size:15px; width: 100px; height: 30px; position: absolute; left: 3px; top: 3px;">♥</button>


	<!-- 지도 관련 스크립트 -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a918dc059c0c7fe988d04540ed91f259&libraries=services"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a918dc059c0c7fe988d04540ed91f259&libraries=LIBRARY"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a918dc059c0c7fe988d04540ed91f259&libraries=services,clusterer,drawing"></script>
	
<script>




//마커를 담을 배열입니다
var markers = [];

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 지도 위에 컨트롤러를 올림 : "좋아요" 버튼
const likesBtn = document.getElementById("likesBtn");
map.addControl(likesBtn, kakao.maps.ControlPosition.LEFT);


 map.relayout();
 
 
//마커 추가 > 첫 번째 날! --------------------------------------------------------- 
 
const dayOnePlan2 = JSON.parse(localStorage.getItem(1)); 
console.log(dayOnePlan2);
 
/* var positions = []; 
for(let i=0;i<dayOnePlan2.length;i++){
	
	positions.push({title: dayOnePlan2[i].title,
					latlng : new kakao.maps.Latlng(dayOnePlan2[i].latitude,dayOnePlan2[i].longitude)
							//0617 에러 발생 : kakao.maps.Latlng is not a constructor
							//리액트, 등등으로 오류를 수정할 수 있나 보다
					});
	
} */ 

//----------------------------------------------------------------------------- 

// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 키워드로 장소를 검색합니다
searchPlaces();

// 키워드 검색을 요청하는 함수입니다
function searchPlaces() {

    var keyword = document.getElementById('keyword').value;

     if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!'); //키워드 없는 화면으로
        return false;
    } 

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch( keyword, placesSearchCB); 
}

// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);

        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}
//------------------------------------------------------------------------


//마커 위에 커스텀오버레이를 표시합니다
//마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다

var customContent = '<div class="wrap">' + 
            '    	 <div class="info">' + 
            '        <div class="title">' + 
            '            여기 괜찮아요?' + 
            '            <div class="close" id="exitBtn" title="닫기"></div>' + 
            '        </div>' + 
            '        <div class="body">' + 
            '            <div class="desc">' + 
            '                <div class="ellipsis" style="font-size:50;margin-bottom:8px;">장소를 플랜에 추가할까요?</div>' +
            				 '<input type="text" id="memo" placeholder="메모를 작성해주세요">'+ //☆ 해당 장소에 대한 정보를 이미 사용자가 작성했다면, value에 값을 넣어도 되지 않을까
    '               		 <button id="addBtn" onclick="addList();" class="addToList" style="font-size:12px;margin-left:20px;width:50px;">좋아요</button>' + 
            '        	 </div>' + 
            '    </div>' +    
            '</div>'+
            '<div style="display:none", id="hiddenLat"></div>' //마커의 위도
            +'<div style="display:none", id="hiddenLng"></div>' //마커의 경도
            +'<div style="display:none", id="hiddenTitle"></div>' //마커의 장소명
            +'<div style="display:none", id="markerInfo"></div>'; //0616 마커 관련 전반적인 정보 확인
 
	function addList(){ //특정 장소를 사용자의 플랜 리스트에 추가하는 인터페이스
	clearDragEvent();
	       	
	const lat = document.getElementById("hiddenLat").innerText;
	const lng = document.getElementById("hiddenLng").innerText;
 	const placeTitle = document.getElementById("hiddenTitle").innerText;
 	const memo = document.getElementById("memo").value;
 	
	console.log("위도 : ",lat,"경도 : ",lng,"타이틀 : ",placeTitle,"메모 : ",memo);

	//장소 카드 생성해, 플랜 리스트에 추가하기 -----------------------------------
	const dropZone = document.getElementById("dropZone");
	
	const addPlan = document.createElement("div"); //div생성하기
	addPlan.classList.add("box_drag");
	addPlan.setAttribute("draggable",true);
	addPlan.innerText = placeTitle;

	//index를 식별하기 위해, 현재 dropZone에 자식 태그들이 몇 개 있는지 확인하기	
	
	const cards = document.querySelectorAll("div#dropZone div");
	console.log("현재 카드 개수 : ",cards.length);
	let tempNo = cards.length+1;
	addPlan.id="p"+tempNo;
	dropZone.insertAdjacentElement("beforeend",addPlan);
	addDragEvent();
	
	console.log(addPlan);
			
	//-------------------------------------------------------------------

	//장소 카드의 "속성"을 새로 생성해, 해당 장소의 정보를 저장하기--------------------
	addPlan.setAttribute("id",addPlan.id);
	addPlan.setAttribute("placeTitle",placeTitle);
	addPlan.setAttribute("latitude",lat);
	addPlan.setAttribute("longitude",lng);
	addPlan.setAttribute("memo",memo);
	//"속성"이 잘 저장됐는지, 확인하기-------------------------------------------
	console.log("속성 > 아이디 : ", addPlan.getAttribute("id"));
	console.log("속성 > 장소명 : ", addPlan.getAttribute("placeTitle"));
	console.log("속성 > 위도 : ", addPlan.getAttribute("latitude"));
	console.log("속성 > 경도 : ", addPlan.getAttribute("longitude"));
	console.log("속성 > 메모 : ", addPlan.getAttribute("memo"));
	//--------------------------------------------------------------------
	
	
	deletePlace(addPlan); //더블클릭 시, 삭제됨
	//deletePlaceMarker(addPlan);
	moveMap(addPlan);
} 


	//"카드" 관련 이벤트 -----------------------------------------------------
    function deletePlace(e){
		
    	let dropZone = document.getElementById("dropZone");

    	//console.log(e.target);
    	
    	e.addEventListener("dblclick",e=>{ //삭제 대상 카드 클릭 시 (카드 및 마커가 삭제됨)		
    		alert("삭제!");

    		let placeLat = e.target.getAttribute("latitude"); //카드의 위도
    		let placeLng = e.target.getAttribute("longitude"); //카드의 경도
    		
        	//console.log(placeLat,placeLng);
        	
    		//TODO 0617) 마커 삭제가 잘 안 됨... 카드 삭제할 때 실시간으로 좌표 값에 대응되는 마커도 함께 삭제되어야 하는데
    		console.log("내가 생성한 마커들 : ", myMarkers); //내가 생성한 마커들
    		
    		//myMarkers.setMap(null);
    		for(let i=0;i<myMarkers.length;i++){
    			
    			//myMarkers[i].setMap(null); //마커 전체 삭제
    			let mkLat = myMarkers[i].getPosition().getLat();
    			let mkLng = myMarkers[i].getPosition().getLng();
    			console.log(mkLat, mkLng);
    			console.log(placeLat, placeLng);
    			
				if(mkLat==placeLat&&mkLng==placeLng){
					//alert("똑같네!");
					myMarkers[i].setVisible(false);
					break;
				} //else alert("달라!");
    			
    		}
	
    		dropZone.removeChild(e.target);   
		    		
    	});
 	
    };

	

     
    
    function moveMap(e){ //0617) 카드에 마우스 오버 시, 지도가 이동하도록 구현
    
    	//let dropZones = document.querySelectorAll("div#dropZone>div");
    	
	     	e.addEventListener("mouseover",e=>{
	 		
	     			const lat = e.target.getAttribute("latitude");
	     			const lng = e.target.getAttribute("longitude");
	     			panTo(lat,lng);
		
	    	});
    	 
    } 
    
    
	function panTo(lat,lng) {
		    // 이동할 위도 경도 위치를 생성합니다 
		    var moveLatLon = new kakao.maps.LatLng(lat, lng);
		    
		    // 지도 중심을 부드럽게 이동시킵니다
		    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
		    map.panTo(moveLatLon);            
		}   
    

            
//------------------------------------------------------------------------

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {

    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
    //0616 > 리스트에 추가된 장소 > 마커 이미지 변경 관련
/*     const loadDay = document.getElementById("daysOption").value;
    const loadData = JSON.parse(localStorage.getItem(loadDay));
    console.log("저장내역 확인 : ", loadData); */
    
    for ( var i=0; i<places.length; i++ ) {

        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
            marker = addMarker(placePosition, i), 
            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(placePosition);

        // 마커와 검색결과 항목에 mouseover 했을때
        // 해당 장소에 인포윈도우에 장소명을 표시합니다
        // mouseout 했을 때는 인포윈도우를 닫습니다
        (function(marker, title) { //마커 관련 function
        	
        	
        	//0616 페이지 reload||select>option변경 시, 저장된 내역이 있다면 해당 지역의 마커 이미지를 변경하기------   	
/*         	for(let i=0;i<loadData.length;i++){
        		
        		//console.log(loadData[i].title);
        		
        		//console.log();
        		
        		if(loadData[i].title===title){ //☆ 문제 : 1일차만 됨. +장소 삭제 시 반영 안 됨...
        			
        			//저장된 데이터와, 출력 데이터가 동일하다면...(기준:장소명)
 					var markerImage = new kakao.maps.MarkerImage(						
						    'https://cdn-icons-png.flaticon.com/512/727/727606.png', //마커 : 이미지
						    new kakao.maps.Size(31, 35), new kakao.maps.Point(13, 34));				
							marker.setImage(markerImage);													
        		}       		
        	} */
        	//---------------------------------------------------------------------------------------
        	
        	
            kakao.maps.event.addListener(marker, 'mouseover', function() {
            	
                displayInfowindow(marker, title);
                
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
            
          	//마커 이벤트 > 마우스오버 > 장소명 출력 --------------------------------------
    	
			var overlay = new kakao.maps.CustomOverlay({
			    content: customContent,
			    map: map,
			    position: marker.getPosition()       
			});
          	
          		overlay.setMap(null);
 	
			//마커 이벤트 > 클릭 이벤트 > 커스텀 오버레이를 만듦!		

			kakao.maps.event.addListener(marker, 'click', function() {
				

				overlay.setMap(map);
				
				let lat = marker.getPosition().getLat(); //위도
				let lng = marker.getPosition().getLng(); //경도
				
				document.getElementById("hiddenLat").innerText=lat;
				document.getElementById("hiddenLng").innerText=lng;
				
				
				//해당 마커의 장소명 가져오기--------------------------------------------
				document.getElementById("hiddenTitle").innerText=title;
				

									
				//저장해둔 "메모"가 있다면, 해당 메모를 input창의 value에 출력해주기
				const savedData = JSON.parse(localStorage.getItem(document.getElementById("dayTitle").innerText));
				
				
				if(savedData!=null){
						console.log(savedData, title);
		
						const memo = document.getElementById("memo");
						
						
		 				savedData.forEach(e=>{					
							if(title===e.title&&e.memo!=''){
								memo.value = e.memo;
							}					
						});
				}
				
								
				//0616 마커의 이미지 변경을 위해----------------------------------------
				const isAdded = document.getElementById("addBtn");
				
				isAdded.addEventListener("click", e=>{ //"좋아요" 클릭 발생 시
			
/* 				var markerImage = new kakao.maps.MarkerImage( //마커 이미지 변경						
							    'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-256.png', //마커 : 이미지
							    new kakao.maps.Size(31, 35), new kakao.maps.Point(13, 34));	
				
 				marker.setImage(markerImage); */
 									
 				//0617 마커의 이미지 변경, 뿐만 아니라... 마커를 새로 생성하기 -> 생성된 마커를 기준으로 선 잇기도 가능하므로

			    			    
			    //마커 생성 메소드 호출하기
			    addMarkerFunc(lat,lng,title);
				
				
				}); 

				
				const exitBtn = document.getElementById("exitBtn"); //인포메이션 창 닫기
				exitBtn.addEventListener("click", e=>{
					overlay.setMap(null);
				})
				
			});

          	//------------------------------------------------------------------------

            itemEl.onmouseover =  function () {
                displayInfowindow(marker, title);
            };

            itemEl.onmouseout =  function () {
                infowindow.close();
            };
        })(marker, places[i].place_name);

        fragment.appendChild(itemEl);
    
    }

    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
       
}


// "좋아요" 클릭 시, 해당 좌표를 토대로 마커 생성하는 함수
// 내가 만들었던 마커들을 관리하기 위해, "배열"을 만듦
let myMarkers = [];
function addMarkerFunc(lat,lng,placeTitle){

	// 마커 이미지
	var imageSrc = 'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-256.png';
	
    // 마커 이미지의 이미지 크기 입니다
    var imageSize = new kakao.maps.Size(36, 37); 
    
    // 마커 이미지를 생성합니다    
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
    
    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({
        map: map, // 마커를 표시할 지도
        //position: positions[i].latlng, // 마커를 표시할 위치
        position: new kakao.maps.LatLng(lat,lng),
        title : placeTitle, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
        image : markerImage // 마커 이미지 
    });
    
    myMarkers.push(marker);
    //return myMarkers;
    console.log("이만큼 만들었어!", myMarkers);

}    

console.log("이만큼 만들었어! 여기서는 왜 확인이 안 될까?", myMarkers);





// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
 function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

    infowindow.setContent(content);
    infowindow.open(map, marker);

    
}

 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}


 
 
 
 //----------------------------------------------------------------------------
 //마커 클릭 관련
 // 마커에 커서가 오버됐을 때 마커 위에 표시할 인포윈도우를 생성합니다
 
 
 //console.log("마커 확인", markers);
 
 
/* var iwContent = '<div style="padding:5px;">Hello World!</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다

// 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({
    content : iwContent
});
 
 kakao.maps.event.addListener(marker, 'mouseover', function() {
  // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
    infowindow.open(map, marker);
}); */

 
 
</script>