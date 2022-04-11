<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"  %>
<%@ page import="user.UserDAO"  %>
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
      <form class="d-flex">
        <input class="form-control me-2" type="search" placeholder="검색어를 입력해 주세요." aria-label="Search">
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
				<option value="전공">전공</option>
				<option value="교양">교양</option>
				<option value="기타">기타</option>
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
		
		<!-- 카드1 -->
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">컴퓨터개론&nbsp;<small>강미주</small></div>
					<div class="col-4 text-end">
						종합<span style="color: red;"> A</span>
					</div>
				</div>
			</div>
			<div class="card-body">
			<h5 class="card-title">
				정말 좋은 강의에요.&nbsp;<small>(2021년 가을학기)</small>
			</h5>
			<p class="card-text">강의가 많이 널널해서, 솔직히 많이 배운 것 없는 것 같지만 학점도 잘 나오고 너무 좋은 것 같습니다.</p>
			<div class="row">
				<div class="col-9 text-left">
					성적<span style="color: red;"> A</span>
					널널<span style="color: red;"> A</span>
					강의<span style="color: red;"> A</span>
					<span style="color: green;"> (추천: 15)</span>
				</div>
				<div class="col-3 text-end">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=">삭제</a>
				</div>
			</div>
		</div>
		</div>
		
		
		<!-- 카드2 -->
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">컴퓨터그래픽스&nbsp;<small>홍길동</small></div>
					<div class="col-4 text-end">
						종합<span style="color: red;"> A</span>
					</div>
				</div>
			</div>
			<div class="card-body">
			<h5 class="card-title">
				강의가 재밌어요.&nbsp;<small>(2020년 1학기)</small>
			</h5>
			<p class="card-text">처음 배우는 과목이었는데, 상당히 재미있었습니다.</p>
			<div class="row">
				<div class="col-9 text-left">
					성적<span style="color: red;"> A</span>
					널널<span style="color: red;"> B</span>
					강의<span style="color: red;"> A</span>
					<span style="color: green;"> (추천: 11)</span>
				</div>
				<div class="col-3 text-end">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=">삭제</a>
				</div>
			</div>
		</div>
		</div>
		
		
		<!-- 카드3 -->
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">인터넷 마케팅&nbsp;<small>무지개</small></div>
					<div class="col-4 text-end">
						종합<span style="color: red;"> B</span>
					</div>
				</div>
			</div>
			<div class="card-body">
			<h5 class="card-title">
				흘룽한 강의입니다.&nbsp;<small>(2019년 2학기)</small>
			</h5>
			<p class="card-text">강의도 알차고 많이 배웠습니다. 다만 과제도 많고, 학점이 잘 안나와요.</p>
			<div class="row">
				<div class="col-9 text-left">
					성적<span style="color: red;"> C</span>
					널널<span style="color: red;"> B</span>
					강의<span style="color: red;"> A</span>
					<span style="color: green;">(추천: 13)</span>
				</div>
				<div class="col-3 text-end">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=">삭제</a>
				</div>
			</div>
		</div>
		</div>
		
	</section>
	
	
	
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
							<input type="text" name="lectureName" class="form-control" maxlength="20">
						</div>
						<div class="form-label col-sm-6">
							<label>교수</label>
							<input type="text" name="professorName" class="form-control" maxlength="20">
						</div>
					</div>
					<div class="row">
						<div class="form-label col-sm-4">
							<label>수강 연도</label>
							<select name="LectureYear" class="form-control">
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
							<select name="samesterDivide" class="form-control">
								<option value="1학기" selected>1학기</option>
								<option value="여름학기">여름학기</option>
								<option value="2학기">2학기</option>
								<option value="겨울학기">겨울학기</option>
							</select>
						</div>
						<div class="form-label col-sm-4">
							<label>강의 구분</label>
							<select name="LectureDivide" class="form-control">
								<option value="전공" selected>전공</option>
								<option value="교양">교양</option>
								<option value="기타">기타</option>
							</select>
						</div>
					</div>
					<!--  -->
					<div class="form-label">
						<label>제목</label>
						<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
					</div>
					<div class="form-label">
						<label>내용</label>
						<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
					</div>
					<div class="row">
						<div class="form-label col-sm-3">
							<label>종합</label>
							<select name="totalScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>성적</label>
							<select name="creditScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>널널</label>
							<select name="comfortableScore" class="form-control">
								<option value="A" selected>A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
								<option value="F">F</option>
							</select>
						</div>
						<div class="form-group col-sm-3">
							<label>강의</label>
							<select name="LectureScore" class="form-control">
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
					<!--  -->
					<div class="form-label">
						<label>신고 제목</label>
						<input type="text" name="reportTitle" class="form-control" maxlength="30">
					</div>
					<div class="form-label">
						<label>신고 내용</label>
						<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
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
					<div class="form-group">
						<label>신고 제목</label>
						<input type="text" name="reportTitle" class="form-control" maxlength="30">
					</div>
					<div class="form-group">
						<label>신고 내용</label>
						<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
					</div>
					<div class="modal-footer">
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