<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>플래너 작성 파일</title>
</head>

<style>

	#container{
	
	display: flex;
    justify-content: center;
	
	}

	#planBox{
	
	padding: 25px;
    margin-left: 198px;
    display: inline-block;
    margin-top: 69px;
    object-position: center;
    width: 500px;
    height: 403px;
	
	}
	
	#mainTitle{
	
	margin-left: -27px;
	
	}
	
	.title{
	
	margin-bottom: 3px;
	
	}
	
	#line{
	
	width: 394px;
    margin-left: -20px;

	}
	
	#btn{
	
	margin-left: 279px;
    margin-top: 4px;
    background-color: black;
    color: white;
    border-radius: 5px;
    height: 34px;
    width: 116px;
    font-weight: 900;
	
	
	}

</style>



<body>
		<div id="container">
			<div id="planBox">
				<h2 id="mainTitle">플래너를 작성해보세요</h2>
				<hr id="line">
				<form action="<%=request.getContextPath()%>/plannermaker.do" method="post">
					<h3 class="title">플랜 제목</h3>
						<input type="text" name="plannerTitle" required>
					<h3 class="title">여행 일자</h3>
						<input type="text" name="days" placeholder="작성 예시) 2박3일 → 3" required>일
					<h3 class="title">테마</h3>
						<select name="theme" style="width:180px;">
							<option value="맛집">맛집</option>
							<option value="액티비티">액티비티</option>
							<option value="유적지">유적지</option>
							<option value="힐링">힐링</option>
							<option value="자연">자연</option>
							<option value="자유여행">자유여행</option>
						</select>
					<h3 class="title"><span style="color:red">주요</span> 방문 지역</h3>
						<select name="area" id="area_" style="width:180px;" required>
							<option value="">--선택--</option>
							<option value="1">서울</option>
							<option value="2">인천</option>
							<option value="3">대전</option>
							<option value="4">대구</option>
							<option value="5">광주</option>
							<option value="6">부산</option>
							<option value="7">울산</option>
							<option value="8">세종특별자치시</option>
							<option value="31">경기도</option>
							<option value="32">강원도</option>
							<option value="33">충청북도</option>
							<option value="34">충청남도</option>
							<option value="35">경상북도</option>
							<option value="36">경상남도</option>
							<option value="37">전라북도</option>
							<option value="38">전라남도</option>
							<option value="39">제주도</option>			
						</select>
						<select id="sigungu_" name="sigungu" style="width:180px;" required>
							<option value="">--선택--<option>
						</select>
					<br><br>
					<button id="btn">플래너 만들기</button>
				</form>
			</div>
		</div>
	
	<script>
	
		const area = document.getElementById("area_");
		const sigungu = document.getElementById("sigungu_");

		//다중select > ※ 전남, 경남... 지역코드가 순차적이지 않아 별도의 작업 수행함. 다른 지역도 그러한지 확인해야 함...
		
 		area.addEventListener("change", e=>{
			
			if(e.target.value==1){ //서울
				
				let seoul = ["강남구","강동구","강북구","강서구","관악구","광진구","구로구",
					         "금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구",
					         "서초구","성동구","성북구","송파구","양천구","영등포구","용산구",
					         "은평구","종로구","중구","중랑구"]
			
				insertInfo(seoul);

				
				 
			} else if (e.target.value==2){ //인천
				
				let incheon = ["강화군","계양구","미추홀구","남동구","동구","부평구","서구","연수구","옹진군","중구"];
				insertInfo(incheon);

			
			} else if (e.target.value==3){ //대전
				
				let daejeon = ["대덕구","동구","서구","유성구","중구"];
				insertInfo(daejeon);

			} else if (e.target.value==4){ //대구
				
				let daegu = ["남구","달서구","달성군","동구","북구","서구","수성구","중구"];
				insertInfo(daegu);

				
			} else if (e.target.value==5){ //광주
				
				let gwangju = ["광산구","남구","동구","북구","서구"];
				insertInfo(gwangju);

				
				
 			} else if (e.target.value==6){ //부산
 				
 				let busan = ["강서구","금정구","기장군","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구"]
 				insertInfo(busan);

 				
			} else if (e.target.value==7){ //울산
				
 				let ulsan = ["중구","남구","동구","북구","울주군"]
 				insertInfo(ulsan);
			
			} else if (e.target.value==8){ //세종
				
					sigungu.innerHTML = "";
			
					let option = document.createElement("option");
					option.innerText = "세종특별자치시";
					option.value = 1;
					sigungu.appendChild(option);
				
			} else if (e.target.value==31){ //경기
				
 				let gyeonggi = ["가평군","고양시","과천시","광명시","광주시","구리시","군포시","김포시","남양주시",
 								"동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시",
 								"양평군","여주시","연천군","오산시","용인시","의왕시","의정부시","이천시","파주시",
 								"평택시","포천시","하남시","화성시"];
				
				insertInfo(gyeonggi);
				
				
				
			} else if (e.target.value==32){ //강원도
				
				let gangwon = ["강릉시","고성군","동해시","삼척시","속초시","양구군","양양군","영월군","원주시","인제군",
							   "정선군","철원군","춘천시","태백시","평창군","홍천군","화천군","횡성군"]
				insertInfo(gangwon);
				
			} else if (e.target.value==33){ //충북
				
				let chungbuk = ["괴산군","단양군","보은군","영동군","옥천군","음성군","제천시","진천군","청원군","청주시","충주시","증평군"]
				insertInfo(chungbuk);
				
			} else if (e.target.value==34){ //충남
				
				let chungnam = ["공주시","금산군","논산시","당진시","보령시",
								"부여군","서산시","서천군","아산시","예산군",
								"천안시","청양군","태안군","홍성군","계룡시"]
				insertInfo(chungnam);
			
			} else if (e.target.value==35){ //경북
				
				let gyeongbuk = ["경산시","경주시","고령군","구미시","군위군","김천시","문경시","봉화군","상주시","성주군","안동시","영덕군",
								"영양군","영주시","영천시","예천군","울릉군","울진군","의성군","청도군","청송군","칠곡군","포항시"]
				insertInfo(gyeongbuk);				
				
			} else if (e.target.value==36){ //경남
				
				
				sigungu.innerHTML = "";
				let gyeongnam = ["거제시","거창군","고성군","김해시","남해군","마산시","밀양시","사천시","산청군","양산시",
								"의령군","진주시","진해시","창녕군","창원시",
								"통영시","하동군","함안군","함양군","합천군"]
			
				let code = 1;
				for(let i=0;i<10;i++){
					
					let option = document.createElement("option");
					option.innerText = gyeongnam[i];
					option.value = code++;
					sigungu.appendChild(option);					
				}
			
				//지역코드가 ~양산:10, 의령:12~임
				let codeFrom = 12;
				for(let i=10;i<gyeongnam.length;i++){
					
					let option = document.createElement("option");
					option.innerText = gyeongnam[i];
					option.value = codeFrom++;
					sigungu.appendChild(option);					
				}
				
			} else if (e.target.value==37){ //전북
				
				
				let jeonbuk = ["고창군","군산시	","김제시","남원시","무주군","부안군","순창군",
							    "완주군","익산시","임실군","장수군","전주시","정읍시","진안군"]
				insertInfo(jeonbuk);
				
				
			} else if (e.target.value==38){ //전남
				
				sigungu.innerHTML = "";
				//~여수시까지는 순차적임 (~13)
				//영광군부터 16~
				let jeonnam = ["강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군","순천시","신안군","여수시",
								"영광군","영암군","완도군","장성군","장흥군","진도군","함평군","해남군","화순군"]

				let code = 1;
				for(let i=0;i<13;i++){
					
					let option = document.createElement("option");
					option.innerText = jeonnam[i];
					option.value = code++;
					sigungu.appendChild(option);					
				}
			
				//지역코드가 영광부터 16~임
				let codeFrom = 16;
				for(let i=13;i<jeonnam.length;i++){
					
					let option = document.createElement("option");
					option.innerText = jeonnam[i];
					option.value = codeFrom++;
					sigungu.appendChild(option);					
				}
				
			} else if (e.target.value==39){ //제주
				
				let jeju = ["남제주군","북제주군","서귀포시","제주시"]
				insertInfo(jeju);

			} else sigungu.innerHTML = "";
			
	}); 
		
		console.log(sigungu);

		function insertInfo(city){ //지역 정보 대입 함수
			
			sigungu.innerHTML = "";
			let code = 1;
			
			city.forEach(e=>{
				
				let option = document.createElement("option");
				option.innerText = e;
				option.value = code++;
				sigungu.appendChild(option);
				
			});
			
		}
		
		console.log(document.querySelector("#area_ option").value);
		console.log(document.querySelector("#sigungu_ option").value);
		
		
		
		
		
		
		
/* 		function fn_ckValidate(){
			
			const ckArea = document.querySelector("#area_ option").value;
			const ckSigungu = document.querySelector("#sigungu_ option").value;
			//const ckSigungu = document.getElementById("sigungu_").value;
			
			console.log(ckArea, ckSigungu);
			
 			if(ckArea==""){

				alert("주요 방문지역을 입력해주세요!");
				return false;
			}
			if(ckSigungu==""){
				return false;
			} 
			
			return true;
		} */
		
		
	
	</script>

</body>
</html>