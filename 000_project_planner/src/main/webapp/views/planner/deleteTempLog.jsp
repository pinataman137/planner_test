<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작성 기록 삭제</title>
</head>
<style>

	div#deleteCheck{
		text-align : center;
		padding-top : 30px;
	}
	div#deleteBtn{
	
		position:absolute;
		margin-left:223px;
		margin-top:17px;
	}

</style>
<body>

	<div id="deleteCheck">
		<p>플래너 작성을 중단하시겠습니까?</p>
		<p>(편집 중이던 내용은 모두 삭제됩니다)</p>
	</div>
	<div id="deleteBtn">
		<button onclick="deleteLog();">삭제하기</button>
		<button onclick="window.close();">돌아가기</button>
	</div>
	<script>
	
		const deleteLog = ()=>{
			
			localStorage.clear(); //localStorage에 저장된 일정 전체 삭제
			opener.location.replace("<%=request.getContextPath()%>"); //사이트 메인화면으로 이동해야 함
			close(); //창 닫기
						
		}
	
	</script>

</body>
</html>