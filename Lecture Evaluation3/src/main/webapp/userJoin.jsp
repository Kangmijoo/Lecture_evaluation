<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"  %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>강의평가 웹 사이트</title>
	<!-- 부트스트랩 CSS 추가 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가 -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 된 상태입니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		return;		
	}
%>
	<!-- 네비 -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="index.jsp">강의 평가 웹 사이트</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <!-- 토글 눌렀을 때 -->
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="index.jsp">메인</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            회원 관리
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
<%
	if(userID == null) {	//로그인이 안 된 상태
%>
            <li><a class="dropdown-item" href="userLogin.jsp">로그인</a></li>
            <li><a class="dropdown-item" href="userJoin.jsp">회원가입</a></li>
<%
	} else {		// 로그인 한 상태 (로그아웃 보여줌) 
%>
            <li><a class="dropdown-item" href="userLogout.jsp">로그아웃</a></li>
<%
	}
%>
          </ul>
        </li>
      </ul>
      <!-- 검색 창 -->
      <form action="./index.jsp" method="get" class="d-flex">
        <input type="text"  name="search" class="form-control me-2"  placeholder="검색어를 입력해 주세요." aria-label="Search">
        <button class="btn btn-outline-success" type="submit" style="width:80px;">검색</button>
      </form>
    </div>
  </div>
</nav>
	
	<!-- 본문 -->
	<section class="container mt-3" style="max-width: 560px;">
		<form method="post" action="./userRegisterAction.jsp">
			<div class="form-group mt-3">
				<label>아이디</label>
				<input type="text" name="userID" class="form-control mt-2">
			</div>
			<div class="form-group mt-3">
				<label>비밀번호</label>
				<input type="password" name="userPassword" class="form-control mt-2">
			</div>
			<div class="form-group mt-3">
				<label>이메일</label>
				<input type="email" name="userEmail" class="form-control mt-2">
			</div>
			<button type="submit" class="btn btn-primary mt-3">회원가입</button>
		</form>
	</section>
	
	<!-- 푸터 -->
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2022강미주All Right Reserved.
	</footer>
	
	<!-- 제이쿼리 자바스크립트 추가 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가 -->
	<script src="./js/popper.js"></script>
	<!-- 부트스트랩 자바스크립트 추가 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>