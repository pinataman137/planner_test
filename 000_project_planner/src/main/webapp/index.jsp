<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>플래너 작성 파일</title>
</head>
<body>

	
	<form action="<%=request.getContextPath()%>/plannermaker.do" method="post">
		<h2>여행 일자를 입력해주세요</h2>
		<input type="text" name="days">일
		<h2>여행 테마를 선택해주세요</h2>
		<select name="theme" style="width:180px;">
			<option>맛집</option>
			<option>유적지</option>
			<option>액티비티</option>
			<option>힐링</option>
			<option>풍경</option>
		</select>
		<br><br>
		<button>플래너 만들기</button>
	</form>

</body>
</html>