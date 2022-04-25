<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"  %>
<%@ page import="user.UserDAO"  %>
<%@ page import="evaluation.EvaluationDTO"  %>
<%@ page import="evaluation.EvaluationDAO"  %>
<%@ page import="java.util.ArrayList"  %>
<%@ page import="java.net.URLEncoder"  %>
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
	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	int pageNumber = 0;
	if(request.getParameter("lectureDivide") != null) {
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null) {
		try {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch (Exception e) {
			System.out.println("검색 페이지 번호 오류");
		}		
	}
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요!');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;		
	}
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked == false) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendConfirm.jsp';");	//이메일 인증이 안된 사람 이메일 인증 할 수 있도록 만들어주기 위한 페이지
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
	<section class="container mt-3">
		<!-- 검색 기능 -->
		<form method="get" action="./index.jsp" class="row gx-3 gy-2 align-items-center mt-2">
		  <div class="col-sm-1">
		    <label class="visually-hidden" for="specificSizeSelect">Preference</label>
		    <select name="lectureDivide" class="form-select"  id="specificSizeSelect">
				<option value="전체" selected>전체</option>
				<option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
		    </select>
		    <select name="searchType" class="form-select"  id="specificSizeSelect">
				<option value="최신순" >"최신순"</option>
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
		    </select>
		  </div>
		   <div class="col-sm-2">
		    <label class="visually-hidden" for="specificSizeInputName">Name</label>
		    <input type="text" class="form-control" id="specificSizeInputName" placeholder="검색어를 입력해 주세요.">
		  </div>
		  <div class="col-auto">
		    <button type="submit" class="btn btn-primary  mx-1">검색</button>
		    <button type="button" class="btn btn-primary  mx-1" data-bs-toggle="modal" data-bs-target="#registerModal">
					  등록하기
			</button>
			<button type="button" class="btn btn-danger  mx-1" data-bs-toggle="modal" data-bs-target="#reportModal">
					  신고
			</button>
		  </div>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null)
		for(int i = 0; i < evaluationList.size(); i++) {
			if(i == 5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
%>		
		
		<!-- 카드1 -->
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName()%>&nbsp;<small><%= evaluation.getProfessorName()%></small></div>
					<div class="col-4 text-end">
						종합<span style="color: red;"><%= evaluation.getTotalScore()%></span>
					</div>
				</div>
			</div>
			<div class="card-body">
			<h5 class="card-title">
				<%= evaluation.getEvaluationTitle()%>&nbsp;<small>(<%= evaluation.getLectureYear()%>년 <%= evaluation.getSemesterDivide()%>)</small>
			</h5>
			<p class="card-text"><%= evaluation.getEvaluationContent()%></p>
			<div class="row">
				<div class="col-9 text-left">
					성적<span style="color: red;"> <%= evaluation.getCreditScore()%></span>
					널널<span style="color: red;"> <%= evaluation.getComfortableScore()%></span>
					강의<span style="color: red;"> <%= evaluation.getLectureScore()%></span>
					<span style="color: green;"> (추천: <%= evaluation.getLikeCount()%>)</span>
				</div>
				<div class="col-3 text-end">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=">삭제</a>
				</div>
			</div>
		</div>
		</div>
<%
		}
%>		
	</section>
	<ul class="pagination jestify-content-center mt-3">
		<li class="page-item">
<%
	if(pageNumber <= 0) {
%>
	<a class="page-link disabled">이전</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber - 1 %>">이전</a>
<%
	}
%>
		</li>
		<li>
<%
	if(evaluationList.size() < 6) {
%>
	<a class="page-link disabled">다음</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber + 1 %>">다음</a>
<%
	}
%>		
		</li>
	</ul>
	
	
<!-- 등록 양식 Modal -->
<div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">평가 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="./evaluationRegisterAction.jsp" method="post">
					<div class="row">
						<div class="form-label col-sm-6">
							<label>강의명</label>
							<input type="text" name="lectureName" class="form-control mt-2" maxlength="20">
						</div>
						<div class="form-label col-sm-6">
							<label>교수</label>
							<input type="text" name="professorName" class="form-control mt-2" maxlength="20">
						</div>
					</div>
					<div class="row">
						<div class="form-label col-sm-4">
							<label>수강 연도</label>
							<select name="LectureYear" class="form-control mt-2">
								<option value="2015">2015</option>
								<option value="2016">2016</option>
								<option value="2017">2017</option>
								<option value="2018">2018</option>
								<option value="2019">2019</option>
								<option value="2020">2020</option>
								<option value="2021">2021</option>
								<option value="2022" selected>2022</option>
								<option value="2023">2023</option>
								<option value="2024">2024</option>
								<option value="2025">2025</option>
							</select>
						</div>
						<div class="form-label col-sm-4">
							<label>수강 학기</label>
							<select name="semesterDivide" class="form-control mt-2">
								<option value="1학기" selected>1학기</option>
								<option value="여름학기">여름학기</option>
								<option value="2학기">2학기</option>
								<option value="겨울학기">겨울학기</option>
							</select>
						</div>
						<div class="form-label col-sm-4">
							<label>강의 구분</label>
							<select name="LectureDivide" class="form-control mt-2">
								<option value="전공" selected>전공</option>
								<option value="교양">교양</option>
								<option value="기타">기타</option>
							</select>
						</div>
					</div>
					<!--  -->
					<div class="form-label">
						<label>제목</label>
						<input type="text" name="evaluationTitle" class="form-control mt-2" maxlength="30">
					</div>
					<div class="form-label">
						<label>내용</label>
						<textarea name="evaluationContent" class="form-control mt-2" maxlength="2048" style="height: 180px;"></textarea>
					</div>
					<div class="row">
						<div class="form-label col-sm-3">
							<label>종합</label>
							<select name="totalScore" class="form-control mt-2">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>성적</label>
							<select name="creditScore" class="form-control mt-2">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>널널</label>
							<select name="comfortableScore" class="form-control mt-2">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>강의</label>
							<select name="LectureScore" class="form-control mt-2">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
					</div>
				</form>
      </div>
      <!-- modal-footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary">등록</button>
      </div>
    </div>
  </div>
</div>


<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">신고하기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
			<form action="./reportAction.jsp" method="post">
					<!-- 신고 모달 내용 -->
					<div class="form-label mt-2">
						<label>신고 제목</label>
						<input type="text" name="reportTitle" class="form-control mt-2" maxlength="30">
					</div>
					<div class="form-label mt-2">
						<label>신고 내용</label>
						<textarea name="reportContent" class="form-control mt-2" maxlength="2048" style="height: 180px;"></textarea>
					</div>
			</form>
      </div>
      <!-- modal-footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger">신고하기</button>
      </div>
    </div>
  </div>
</div>

	<!-- 신고 모달 양식 -->
	  <div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<!-- 신고하기 모달 -->
			<div class="modal-header">
				<h5 class="modal-title" id="modal">신고하기</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form action="./reportAction.jsp" method="post">
					<!--  -->
					<div class="form-label mt-3">
						<label>신고 제목</label>
						<input type="text" name="reportTitle" class="form-control" maxlength="30">
					</div>
					<div class="form-label mt-3">
						<label>신고 내용</label>
						<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
					</div>
					<div class="modal-footer mt-3" >
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="submit" class="btn btn-danger">신고하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 푸터 -->
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2022 강미주 All Rights Reserved.
	</footer>
	
	<!-- 제이쿼리 자바스크립트 추가 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가 -->
	<!--  <script src="./js/popper.js"></script>-->
	<!-- 부트스트랩 자바스크립트 추가 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>