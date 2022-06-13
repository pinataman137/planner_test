<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>


<!-- 지도 -->
	    	
	<div class="container2">
		<button id="likes" class="z1">좋아요</button>
	</div>
	
		<div id="map" class="z2"></div>
	

	<!-- 지도 관련 스크립트 -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a918dc059c0c7fe988d04540ed91f259"></script>
	<script>
	

	//좌표 정보 관련 코드
	
		
	
		let mapContainer = document.getElementById('map'); // 지도를 표시할 div 
				
	    mapOption = { 
					
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표	       
	        level: 3 // 지도의 확대 레벨
	        
	    };
	
	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	let map = new kakao.maps.Map(mapContainer, mapOption); 
	
	//"좋아요" 버튼을 지도 위에 배치함
	const likes = document.getElementById("likes");
	//const searchPlaces = document.getElementById("searchPlaces");
	
	map.addControl(likes, kakao.maps.ControlPosition.TOPRIGHT);
	
	 map.relayout();
	</script>
	
	
	
