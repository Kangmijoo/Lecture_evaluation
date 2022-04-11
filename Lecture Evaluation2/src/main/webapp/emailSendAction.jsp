<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.mail.Transport"  %>
<%@ page import="javax.mail.Message"  %>
<%@ page import="javax.mail.Address"  %>
<%@ page import="javax.mail.internet.InternetAddress"  %>
<%@ page import="javax.mail.internet.MimeMessage"  %>
<%@ page import="javax.mail.Session"  %>
<%@ page import="javax.mail.Authenticator"  %>
<%@ page import="java.util.Properties"  %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.Gmail" %>
<%@ page import="java.io.PrintWriter" %>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	//로그인하지 않은 상태
	if(userID == null) {	
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요!');");
		script.println("location.href = 'userLogin.jsp'");	//로그인 페이지도 이동
		script.println("</script>");
		script.close();
		return;		
	}
	//이메일 인증이 되었는지 확인
	boolean emailChecked = userDAO.getUserEmailChecked(userID);
	if (emailChecked == true) {	//인증이 된 상태
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다!');");
		script.println("location.href = 'index.jsp;");
		script.println("</script>");
		script.close();
		return;
	}
	//구글 smtp가 기본적으로 제공하는 양식 사용
	String host = "http://localhost:8080/Lecture_Evaluation/";
	String from = "dikapeulio912@gmail.com";
	String to = userDAO.getUserEmail(userID);
	String subject = "강의평가를 위한 이메일 인증 메일입니다.";
	String content = "다음 링크에 접속하여 이메일 인증을 진행하세요." +
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
	
	//smtp를 접속하기 위한 정보를 넣어주기
	Properties p = new Properties();
	//p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.gmail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.ssl.protocols", "TLSv1.2");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	//이메일 전송
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF8");		//메일 안에 담길 내용
		Transport.send(msg);		//클래스 이용해서메시지 전송
	} catch (Exception e) {	//오류 발생 시
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다!');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>
<!-- 이메일 보낸 뒤 인증 메일 보냈다는 메시지를 출력해주기 -->
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
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4" role="alert">
			이메일 주소 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가서 인증해주세요.
		</div>
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