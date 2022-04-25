<!-- 이메일 인증을 하게 되면 그에 대항 정보를 처리해줌 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String code = "";
	if(request.getParameter("code") != "") {
		code = request.getParameter("code");
	}
	UserDAO userDAO = new UserDAO();
	String userID = "";
	if(session.getAttribute("userID") != "") {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null || userID.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요!');");
		script.println("location.href= 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	//현재 사용자의 이메일 주소를 받기
	String userEmail = userDAO.getUserEmail(userID);
	//사용자가 보낸 코드가 해당 사용자의 이메일 주소(해시값 적용)와 일치하는지
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false;
	if(isRight == true) {
		userDAO.setUserEmailChecked(userID);	//해당 사용자의 이메일 인증을 처리해줌
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다!');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>