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
		<button>확인</button>
	</form>

</body>
</html>