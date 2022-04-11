<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;		
	}
	
	String lectureName = null;
	String professorName = null;
	int lectureYear = 0;
	String samesterDivide = null;
	String lectureDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String totalScore = null;
	String creditScore = null;
	String comfortableScore = null;
	String lectureScore = null;
	
	if(request.getParameter("lectureName") != "") {
		lectureName = request.getParameter("lectureName");
	}
	if(request.getParameter("professorName") != "") {
		professorName = request.getParameter("professorName");
	}
	if(request.getParameter("lectureYear") != "") {
		try {
			lectureYear = Integer.parseInt(request.getParameter("lectureYear"));
		} catch (Exception e) {
			System.out.println("강의 연도 데이터 오류");
		}
	}
	if(request.getParameter("samesterDivide") != "") {
		samesterDivide = request.getParameter("samesterDivide");
	}
	if(request.getParameter("lectureDivide") != "") {
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle") != "") {
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != "") {
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore") != "") {
		totalScore = request.getParameter("totalScore");
	}
	if(request.getParameter("creditScore") != "") {
		creditScore = request.getParameter("creditScore");
	}
	if(request.getParameter("comfortableScore") != "") {
		comfortableScore = request.getParameter("comfortableScore");
	}
	if(request.getParameter("lectureScore") != "") {
		lectureScore = request.getParameter("lectureScore");
	}
	if( lectureName == null || professorName == null || lectureYear == 0 || samesterDivide == null || lectureDivide == null || 
			evaluationTitle == null || evaluationContent == null || totalScore == null || creditScore == null || comfortableScore == null || lectureScore == null ||
			evaluationTitle.equals("") || evaluationContent.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력하지 않은 항목이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	int result = evaluationDAO.write(new EvaluationDTO(0, userID, lectureName, professorName, 
			lectureYear, samesterDivide, lectureDivide, evaluationTitle, evaluationContent,
			totalScore, creditScore, comfortableScore, lectureScore, 0));
	if(result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;		
	}
%>