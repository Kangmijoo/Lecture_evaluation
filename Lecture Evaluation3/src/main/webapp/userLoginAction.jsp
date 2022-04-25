<!-- 회원가입에 성공한 사람이 로그인 할 때 로그인 요청 처리해주는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = "";
	String userPassword = "";
	if(request.getParameter("userID") != "") {
		userID = request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != "") {
		userPassword = request.getParameter("userPassword");
	}
	if(userID == null || userPassword == null || userID.equals("") || userPassword.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력하지 않은 항목이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	UserDAO userDAO = new UserDAO();
	int result = userDAO.login(userID, userPassword);
	if(result == 1) {		//로그인 성공 시
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else if (result == 0) {	//DAO에서 비밀번호 틀렸을 때 0값 반환하도록 만들었었음
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀렸습니다.');");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;		
	} else if (result == -1) {	
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;		
	} else if (result == -2) {	
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;		
	}
%>